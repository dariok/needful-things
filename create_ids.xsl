<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:template match="tei:*">
        <xsl:variable name="num">
            <xsl:choose>
                <xsl:when test="self::tei:div">
                    <xsl:value-of select="'d' || (count(preceding::tei:div | ancestor::tei:div) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:p">
                    <xsl:value-of select="'p' || (count(preceding::tei:p) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:cell">
                    <xsl:value-of select="'cell' || (count(preceding::tei:cell) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:item">
                    <xsl:value-of select="'i' || (count(preceding::tei:item) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:titlePart or self::tei:imprimatur">
                    <xsl:value-of select="'tit' || (count(preceding::tei:titlePart | preceding::tei:imprimatur) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:opener or self::tei:closer or self::tei:postscript">
                    <xsl:value-of select="'opc' || (count(preceding::tei:opener | preceding::tei:closer | preceding::tei:postscript) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:epigraph or self::tei:salute">
                    <xsl:value-of select="'eps' || (count(preceding::tei:epigraph | preceding::tei:salute) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:l">
                    <xsl:value-of select="'l' || (count(preceding::tei:l) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:note[@type='footnote']">
                    <xsl:value-of select="'nn' || (count(preceding::tei:note[@type='footnote']) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:pb">
                    <xsl:value-of select="'pag' || (count(preceding::tei:pb) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:lb">
                    <xsl:value-of select="'z' || (count(preceding::tei:lb) + 1)"/>
                </xsl:when>
                <xsl:when test="self::tei:cit">
                    <xsl:value-of select="'cit' || (count(preceding::tei:cit) + 1)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{local-name()}">
            <xsl:if test="not(@xml:id) and string-length($num) &gt; 0">
                <xsl:attribute name="xml:id" select="$num" />
            </xsl:if>
            <xsl:apply-templates select="@* | node()" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>