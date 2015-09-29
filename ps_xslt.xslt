<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!--skips new lines and indents in-->    
    <xsl:output method="xml" indent="yes"/>
    <!--if,error-->
    <xsl:strip-space elements="*"/>
    <!--delete up to here-->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    

    <!--skips completely-->
    <xsl:template match="channel/title"/>
    <xsl:template match="channel/description"/>
    <xsl:template match="channel/link"/>
    <xsl:template match="channel/language"/>
    <xsl:template match="channel/lastBuildDate"/>
    <xsl:template match="image"/>
    <xsl:template match="item/link"/>
    
    <!--skips node if empty-->
    <xsl:template match="item/title[not(child::node())]"/>
    <xsl:template match="item/link[not(child::node())]"/>
    <xsl:template match="item/guid[not(child::node())]"/>
    <xsl:template match="item/comments[not(child::node())]"/>

    <!--delimits values if seperated by comma-->
    <xsl:template match="item/category[contains(.,',')]">  
        <xsl:variable name="elementName" select="name(..)"/>
        
        <xsl:call-template name="splitIntoElements">
            <xsl:with-param name="baseName" select="name(..)" />
            <xsl:with-param name="txt" select="." />    
        </xsl:call-template>
        
    </xsl:template>
    
    <xsl:template name="splitIntoElements">
        <xsl:param name="baseName" />
        <xsl:param name="txt" />
        <xsl:param name="delimiter" select="','" />
        <xsl:param name="index" select="1" />
        
        <xsl:variable name="first" select="substring-before($txt, $delimiter)" />
        <xsl:variable name="remaining" select="substring-after($txt, $delimiter)" />
        
        <xsl:element name="{$baseName}-{$index}">
            <xsl:choose>
                <xsl:when test="$first">
                    <xsl:value-of select="$first" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$txt" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>     
        <xsl:if test="$remaining">
            <xsl:call-template name="splitIntoElements">
                <xsl:with-param name="baseName" select="$baseName" />
                <xsl:with-param name="txt" select="$remaining" />
                <xsl:with-param name="index" select="$index+1" />
                <xsl:with-param name="delimiter" select="$delimiter" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

<!-- 
    This XSLT is created to transform incoming rss feed from PacketStorm.
    When applied, it will skip nodes with empty values 
    and delimit categories into <item-1> tags.
    
Author: Ugur
--> 
