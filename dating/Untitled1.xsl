<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dating="https://github.com/dariok/dating"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:function name="dating:parseDate">
        <xsl:param name="string" />
        <xsl:choose>
            <xsl:when test="contains($string, '-')">
                <xsl:variable name="parts" as="xs:string+">
                    <xsl:analyze-string select="$string" regex="\d+">
                        <xsl:matching-substring>
                            <xsl:choose>
                                <xsl:when test="string-length() = 2 or string-length() = 4">
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="format-number(xs:int(.), '00')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($string, 'BC')">
                        <xsl:value-of select="'-'||format-number(xs:int($parts[1]), '0000')||'-'||$parts[2]||'-'||$parts[3]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$parts[1]||'-'||$parts[2]||'-'||$parts[3]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>