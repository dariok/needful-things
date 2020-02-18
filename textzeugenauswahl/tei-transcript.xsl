<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:param name="dev" static="1" select="0"/>
  <xsl:param name="view" static="1" select="false()"/>
  <xsl:import href="../../wdbplus-dev/wdbplus-dev.xsl" use-when="$dev"/>
  
  <xsl:output method="html" />
  <!-- TODO Parameter, wenn der Text einer bestimmten Ausgabe ausgegeben werden soll -->
  
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$dev">
        <xsl:variable name="content" use-when="$dev">
          <xsl:apply-templates select="//tei:text" />
        </xsl:variable>
        <xsl:call-template name="surround" use-when="$dev">
          <xsl:with-param name="content" select="$content" />
          <xsl:with-param name="file" select="doc('../../wdbplus-dev/arndt.html')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="//tei:text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:body">
    <div class="content">
      <xsl:choose>
        <xsl:when test="$view">
          <xsl:attribute name="data-wit" select="$view" />
          <div class="info">
            <xsl:text>Textzeuge </xsl:text>
            <xsl:value-of select="$view" />
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="info">
            <xsl:text>Gesamtansicht</xsl:text>
          </div>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates />
      <xsl:if test="not($view)">
        <div class="footnotes">
          <xsl:apply-templates select="descendant::tei:app | descendant::tei:note[@type = 'column-title']" mode="foot" />
        </div>
        <div class="footnotes">
          <xsl:apply-templates select="descendant::tei:note[@type = 'footnote']" mode="foot" />
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:div">
    <div class="text">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  
  <xsl:template match="tei:head">
    <h2>
      <xsl:apply-templates />
    </h2>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="tei:pb">
    <xsl:if test="not($view) or ($view and contains(@ed, $view))">
      <span class="pagebreak">
        <xsl:text> |</xsl:text>
        <xsl:variable name="id" select="substring-after(@facs, '#')" />
        <xsl:variable name="url" select="id($id)/tei:graphic/@url" />
        <xsl:choose>
          <xsl:when test="string-length($url) gt 0">
            <a data-wit="{substring($id, 1, 1)}">
              <xsl:attribute name="href">
                <xsl:value-of select="$url" />
              </xsl:attribute>
              <xsl:value-of select="translate(@ed, '#', '')" />
              <xsl:text>: </xsl:text>
              <xsl:value-of select="@n"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(@ed, '#', '')" />
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@n"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>| </xsl:text>
      </span>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:note[@type = 'column-title']">
    <xsl:call-template name="makeLinkToFootnote" />
  </xsl:template>
  <xsl:template match="tei:note[@type = 'column-title']" mode="foot">
    <xsl:variable name="nr">
      <xsl:call-template name="fn_number_crit" />
    </xsl:variable>
    <div class="footnote" id="cfn{$nr}">
      <span class="fn_number">
        <xsl:call-template name="makeLinkFromFootnote" />
      </span>
      <span class="fn-text">
        <xsl:apply-templates />
      </span>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:note[@type = 'footnote']">
    <xsl:variable name="n">
      <xsl:number level="any" count="tei:note[@type = 'footnote']"/>
    </xsl:variable>
    <a href="#fn{$n}" id="tfn{$n}" class="fn_number">
      <xsl:value-of select="$n" />
    </a>
  </xsl:template>
  
  <xsl:template match="tei:note[@type = 'footnote']" mode="foot">
    <xsl:variable name="n">
      <xsl:number level="any" count="tei:note[@type = 'footnote']"/>
    </xsl:variable>
    <div class="footnote" id="fn{$n}">
      <span class="fn_number">
        <a href="#tfn{$n}">
          <xsl:value-of select="$n"/>
        </a>
      </span>
      <span class="fn-text">
        <xsl:apply-templates />
      </span>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:quote">
    <xsl:text>»</xsl:text>
    <xsl:apply-templates />
    <xsl:text>«</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:foreign">
    <span class="greek">
      <xsl:apply-templates />
    </span>
  </xsl:template>
  
  <xsl:template match="tei:app">
    <xsl:choose>
      <xsl:when test="$view">
        <xsl:apply-templates select="tei:*[contains(@wit, $view)]/node()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="tei:lem" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="makeLinkToFootnote" />
  </xsl:template>
  
  <xsl:template match="tei:app" mode="foot">
    <xsl:variable name="nr">
      <xsl:call-template name="fn_number_crit" />
    </xsl:variable>
    <div class="footnote" id="cfn{$nr}">
      <span class="fn_number">
        <xsl:call-template name="makeLinkFromFootnote" />
      </span>
      <span class="fn-text">
        <xsl:apply-templates select="tei:lem/@wit" />
        <xsl:apply-templates select="tei:rdg" />
      </span>
    </div>
  </xsl:template>
  
  <!-- add @place="margin": „{$wit} marginal zusätzlich:“ -->
  <!-- note @place="margin": „{$wit} marginal:“ -->
  
  <xsl:template match="tei:rdg">
    <xsl:choose>
      <xsl:when test="tei:note[@place]">
        <xsl:apply-templates select="@wit" />
        <i> marginal zusätzlich: </i>
      </xsl:when>
      <xsl:when test="not(text())">
        <i>fehlt </i>
        <xsl:apply-templates select="@wit" />
      </xsl:when>
      <xsl:when test="normalize-space() != normalize-space(preceding-sibling::tei:lem)">
        <xsl:apply-templates select="@wit" />
        <i> statt dessen </i>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@wit" />
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates />
    <xsl:if test="following-sibling::tei:rdg">
      <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:hi">
    <xsl:choose>
      <xsl:when test="contains(@rend, 'italic')">
        <i>
          <xsl:apply-templates />
        </i>
      </xsl:when>
      <xsl:when test="contains(@rend, 'antiqua')">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:when test="contains(@rend, 'smallcaps')">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:when test="contains(@rend, 'font-size')">
        <xsl:apply-templates />
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="@wit">
    <i>
      <xsl:value-of select="translate(., '#', '')" />
    </i>
  </xsl:template>
  
  <xsl:template name="makeLinkToFootnote">
    <xsl:variable name="nr">
      <xsl:call-template name="fn_number_crit" />
    </xsl:variable>
    <a href="#cfn{$nr}" id="tcfn{$nr}" class="fn_number">
      <xsl:value-of select="$nr" />
    </a>
  </xsl:template>
  
  <xsl:template name="makeLinkFromFootnote">
    <xsl:variable name="nr">
      <xsl:call-template name="fn_number_crit" />
    </xsl:variable>
    <a href="#tcfn{$nr}">
      <xsl:value-of select="$nr" />
    </a>
  </xsl:template>
  
  <xsl:template name="fn_number_crit">
    <xsl:number level="any" count="tei:app | tei:note[@type = 'column-title']" format="a" />
  </xsl:template>
</xsl:stylesheet>