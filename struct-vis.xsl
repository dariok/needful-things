<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	<!-- created 2017-07-12 editor:DK = Dario Kampkaspar, dario.kampkaspar@oeaw.ac.at -->
	
	<xsl:output method="html" indent="yes" />
	<xsl:param name="id" as="xs:string" select="''"/>
	<xsl:param name="render" select="false()" as="xs:boolean" />
	
	<xsl:template match="/">
		<html>
			<head>
				<xsl:if test="$render">
					<link rel="stylesheet" href="style.css" />
				</xsl:if>
			</head>
			<body>
			   <xsl:choose>
			      <xsl:when test="exists($id)">
			         <xsl:apply-templates select="//*[contains(@xml:id, $id) or contains(@id, $id)]" mode="start"/>
			      </xsl:when>
			      <xsl:otherwise>
			         <xsl:apply-templates mode="start" />
			      </xsl:otherwise>
			   </xsl:choose>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="*" mode="start">
		<pre><xsl:value-of select="name()" /></pre>
		<ol>
			<xsl:apply-templates select="node()|@*" />
		</ol>
	</xsl:template>
	
	<xsl:template match="node()[node() or @*]">
		<li><pre><xsl:value-of select="local-name()"/></pre>
			<ol>
				<xsl:apply-templates select="node()|@*" />
			</ol>
		</li>
	</xsl:template>
	
	<xsl:template match="text()[normalize-space()='']"/>
	
	<xsl:template match="node()[not(node() or @*) and string-length(normalize-space()) > 0]">
		<li>
			<xsl:choose>
				<xsl:when test="self::text()"><pre>text()</pre><xsl:value-of select="."/></xsl:when>
				<xsl:otherwise><pre><xsl:value-of select="name()"/></pre></xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>
	
	<xsl:template match="@*">
		<li><pre>@<xsl:value-of select="name()"/></pre><xsl:value-of select="." /></li>
	</xsl:template>
</xsl:stylesheet>