<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all" version="2.0">

   <xsl:template match="tei:lb">
      <lb>
         <xsl:apply-templates select="@*"/>
         <xsl:attribute name="xml:id">
            <xsl:text>z</xsl:text>
            <xsl:number count="tei:lb" level="any"/>
         </xsl:attribute>
      </lb>
   </xsl:template>

   <xsl:template match="tei:w">
      <w>
         <xsl:attribute name="xml:id">
            <xsl:text>w</xsl:text>
            <xsl:number count="tei:w | tei:num" level="any"/>
         </xsl:attribute>
         <xsl:apply-templates/>
      </w>
   </xsl:template>
   <xsl:template match="tei:num">
      <num>
         <xsl:attribute name="xml:id">
            <xsl:text>w</xsl:text>
            <xsl:number count="tei:w | tei:num" level="any"/>
         </xsl:attribute>
         <xsl:apply-templates/>
      </num>
   </xsl:template>
   <xsl:template match="tei:pc">
      <pc>
         <xsl:attribute name="xml:id">
            <xsl:text>pc</xsl:text>
            <xsl:number count="tei:pc" level="any"/>
         </xsl:attribute>
         <xsl:apply-templates/>
      </pc>
   </xsl:template>

   <xsl:template match="tei:div">
      <div>
         <xsl:attribute name="xml:id">
            <xsl:choose>
               <xsl:when test="@xml:id">
                  <xsl:sequence select="@xml:id"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>d</xsl:text>
                  <xsl:number count="tei:div" level="any"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="tei:p">
      <p>
         <xsl:apply-templates select="@*"/>
         <xsl:if test="ancestor::tei:text">
            <xsl:attribute name="xml:id">
               <xsl:text>p</xsl:text>
               <xsl:number count="tei:p" level="any"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>

   <xsl:template match="tei:titlePart | tei:imprimatur">
      <xsl:element name="{local-name()}">
         <xsl:apply-templates select="@*"/>
         <xsl:attribute name="xml:id">
            <xsl:text>tit</xsl:text>
            <xsl:number count="tei:titlePart | tei:imprimatur" level="any"/>
         </xsl:attribute>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="tei:item">
      <item>
         <xsl:apply-templates select="@*"/>
         <xsl:attribute name="xml:id">
            <xsl:text>i</xsl:text>
            <xsl:number count="tei:item" level="any"/>
         </xsl:attribute>
         <xsl:apply-templates select="node()"/>
      </item>
   </xsl:template>

   <xsl:template match="tei:head | tei:label">
      <xsl:element name="{local-name()}">
         <xsl:apply-templates select="@*"/>
         <xsl:attribute name="xml:id">
            <xsl:text>hl</xsl:text>
            <xsl:number count="tei:label | tei:head" level="any"/>
         </xsl:attribute>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="tei:list">
      <list>
         <xsl:apply-templates select="@*"/>
         <xsl:attribute name="xml:id">
            <xsl:text>li</xsl:text>
            <xsl:number level="any"/>
         </xsl:attribute>
         <xsl:apply-templates select="node()"/>
      </list>
   </xsl:template>
   
   <xsl:template match="tei:cell">
      <cell>
         <xsl:apply-templates select="@*"/>
         <xsl:attribute name="xml:id">
            <xsl:text>ce</xsl:text>
            <xsl:number level="any"/>
         </xsl:attribute>
         <xsl:apply-templates select="node()"/>
      </cell>
   </xsl:template>
   
   <xsl:template match="tei:note">
      <note>
         <xsl:apply-templates select="@*" />
         <xsl:choose>
            <xsl:when test="@xml:id"/>
            <xsl:when test="@n">
               <xsl:attribute name="xml:id" select="'n' || @n" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="xml:id">
                  <xsl:text>n</xsl:text>
                  <xsl:number level="any"/>
               </xsl:attribute>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:apply-templates select="node()" />
      </note>
   </xsl:template>
   
   <xsl:template match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="node() | @*"/>
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>
