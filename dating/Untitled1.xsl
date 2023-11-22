<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:dating="https://github.com/dariok/dating"
   exclude-result-prefixes="xs"
   version="2.0">
   
   <xsl:function name="dating:parseDate">
      <xsl:param name="string" />
      <xsl:message select="matches($string, '\d+\.? [A-Z][a-z]+\.? \d+')"></xsl:message>
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
         <xsl:when test="matches($string, '\d+\.? [A-Z][a-z]+\.? \d+')">
            <xsl:variable name="parts" select="$string => translate('[', '') => translate(']', '') => tokenize(' ')" />
            <xsl:choose>
               <xsl:when test="not(matches($parts[3], '\d{4}'))">
                  <xsl:message>Cannot parse date <xsl:value-of select="$string"/>.</xsl:message>
                  <xsl:text>not a date</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="day" select="$parts[1] => translate('.', '')"/>
                  
                  <xsl:value-of select="$parts[3]" />
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="dating:parseMonth($parts[2])"/>
                  <xsl:text>-</xsl:text>
                  <xsl:choose>
                     <xsl:when test="contains($day, '–')">
                        <xsl:value-of select="substring-before($day, '–') => number() => format-number('00')"/>
                     </xsl:when>
                     <xsl:when test="contains($day, '—')">
                        <xsl:value-of select="substring-before($day, '—') => number() => format-number('00')"/>
                     </xsl:when>
                     <xsl:when test="contains($day, '-')">
                        <xsl:value-of select="substring-before($day, '-') => number() => format-number('00')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$day => number() => format-number('00')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   
   <xsl:function name="dating:parseMonth">
      <xsl:param name="value" />
      
      <xsl:choose>
         <xsl:when test="matches($value, 'Jan(uar)?|Ianuar(ius)*|Janvier')">01</xsl:when>
         <xsl:when test="matches($value, 'Fe[bv][ruaie\.]+')">02</xsl:when>
         <xsl:when test="matches($value, 'M[aäe]r[s|z|ti]')">03</xsl:when>
         <xsl:when test="matches($value, 'Apr[il\.]+')">04</xsl:when>
         <xsl:when test="matches($value, 'Ma[iy]')">05</xsl:when>
         <xsl:when test="matches($value, 'Jun[\.iy]|Iunius|Jui?n')">06</xsl:when>
         <xsl:when test="matches($value, 'Jui?l[\.letyius]+')">07</xsl:when>
         <xsl:when test="matches($value, 'Aug[ust\.]+|Aout')">08</xsl:when>
         <xsl:when test="matches($value, 'Sept[embr\.]+')">09</xsl:when>
         <xsl:when test="matches($value, 'O[ck]+[tober\.]+')">10</xsl:when>
         <xsl:when test="matches($value, 'Nov[ebmr\.]+')">11</xsl:when>
         <xsl:when test="matches($value, 'De[cz][embr\.]+')">12</xsl:when>
         <xsl:otherwise>
            <xsl:text>notAMonth</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
</xsl:stylesheet>