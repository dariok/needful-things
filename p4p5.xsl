<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://w3.org/2005/xpath-functions"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="tei date"
	>
	
	<!-- **
				* Conversion from TEI P4 to P5
				* Herzog August Bibliothek Wolfenbüttel - - Wolfenbüttler Digitale Bibliothek
				* Contact:	kampkaspar@hab.de
				* This script may be used, distributed and changed freely as long as the author and the library are
				* properly credited and further usage of this and any derived scripts is granted free of charge. 
				**-->

	<!-- 	Handling of indent and strip-space is slightly different between parsers. Different setting may improve
				human readability. Adjust as needed. -->
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<!--<xsl:output method="xml" encoding="UTF-8" indent="no"/>-->
	<xsl:strip-space elements="*"/>
	
	<!-- get the current date -->
	<xsl:variable name="today">
		<!--XSLT 1.0: <xsl:value-of select="date:date()"/>-->
		<xsl:value-of select="current-date()"/>
	</xsl:variable>
	
	<!-- Variables for lowercase-conversion and replacement for certain characters (needed in XSLT 1.0) -->
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz_'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ ,.'" />		 <!-- replace space by _ and remove ,. -->
	
	<!-- **
				* Project-specific instructions
				* Adjust these according to your local requirements.
				** -->
	
	<!-- ** teiHeader ** -->
	<!-- 	If in an edition only <author> is given and it refers to the editor, <editor> is the better choice.
				Will only insert a comment marked as TODO. Comment out if you don't want to change this. -->
	<!--<xsl:template match="fileDesc/titleStmt/author">
		<xsl:if test="not(../editor)">
			<xsl:element name="author"><xsl:apply-templates select="@*|text()"/></xsl:element>
			<xsl:comment> #TODO: is this rather &lt;editor&gt;<xsl:value-of select="."/>&lt;/editor&gt; ? </xsl:comment>
		</xsl:if>
	</xsl:template>-->
	
	<!-- add mandatory <resp> if not yet present in <respStmt>. Add the statement according to your local needs. -->
	<xsl:template match="fileDesc/titleStmt/respStmt">
		<xsl:element name="respStmt">
			<xsl:if test="not(./resp)">
				<xsl:element name="resp">Ediert durch die</xsl:element>
				<xsl:comment> TODO change this to a more appropriate wording! </xsl:comment>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<!-- ** END teiHeader ** -->
	
	<!-- ** body ** -->
	<!-- A list of the @reason available in an unclear. Separate multiple values by | -->
	<xsl:variable name="reasons">
		'illegible'	
	</xsl:variable>
	
	<!-- 	ref/@targType removed; convert [p4]@targType→[p5]@type, [p4]@type→[p5]@subType. 
				Adjust this to your local use of @targType/@type and @type/@subtype. -->
	<xsl:template name="t_ref">
		<xsl:element name="ref">
			<xsl:copy-of select="@target"/>
			<xsl:choose>
				<xsl:when test="@targType">
					<xsl:if test="@type">
						<xsl:attribute name="subtype">
							<xsl:value-of select="@type"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="type">
						<xsl:value-of select="@targType"/>
					</xsl:attribute>
					<xsl:comment> TODO: check whether @type and @subtype are correct! </xsl:comment>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="@type"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="text()"/>
		</xsl:element>
	</xsl:template>
	
	<!-- 	If a personal name within a text is marked up to refer to an index, <rs> is the preferred option.
				Comment out if you need a different solution; adjust the replacement values for the types according to
				your needs; the usage of English values is strongly recommended. -->
	<xsl:template match="//text//div//name[@type]">
		<xsl:element name="rs">
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="@type = 'Person'">										 <!-- adjust localized value names for english values -->
						<xsl:text>person</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'Körperschaft'">
						<xsl:text>corporate</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'Ort'">
						<xsl:text>place</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>TODO:enter_a_valid_type_here</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates select="@*|text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="//div//name/@type"/>
	
	<!-- 	mdDescription has been changed to msDesc, as have its constituents. Do you want to copy former msHeading to
				a new <head> (allowed but in case of structured data not the preferred solution), 'yes', or copy its children to 
				msContents/msItem (author, title, respStmt, textLang, note) and history/origin (origPlace, origDate), 'no'?
				PLEASE NOTE that if <author> or <respStmt> are present in the msHeading, the result would be invalid P5. Hence,
				the value will be reset to its default 'no' if any of these are encountered in msHeading. -->
	<xsl:variable name="copyHeadingToHead">yes</xsl:variable>
	<!-- ** END of body ** -->
	
	<!-- ** attributes ** -->
	<!-- 	name/@reg is not valid anymore in P5; convert it to a ref and provide any other information separately.
				Adjust to your local ref-system. -->
	<xsl:template match="name/@reg">
		<xsl:attribute name="ref">#<xsl:value-of select="translate(., $uppercase, $lowercase)"/></xsl:attribute>
	</xsl:template>
	<!-- ** END of attributes ** -->
	<!-- ** END of project-specific instructions ** -->
	
	<!-- **
				* Common instructions
				* These transformations should be the same for every conversion P4→P5; no changes should be necessary.
				** -->
		
	<!-- Adjust the root element -->	
	<xsl:template match="TEI.2">
		<TEI xmlns="http://www.tei-c.org/ns/1.0">
			<xsl:apply-templates select="*|@*"/>
		</TEI>
	</xsl:template>
	<xsl:template match="teiCorpus">
		<teiCorpus xmlns="http://www.tei-c.org/ns/1.0">
			<xsl:apply-templates select="*|@*"/>
		</teiCorpus>
	</xsl:template>
	
	<!-- ** teiHeader ** -->	
	<!-- add a change entry for what we do here -->
	<xsl:template match="revisionDesc">
		<revisionDesc>
			<xsl:element name="change">
				<xsl:attribute name="when"><xsl:value-of select="$today"/></xsl:attribute>
				<xsl:attribute name="who">p4p5.xsl</xsl:attribute>
				<xsl:variable name="max_n">
					<xsl:for-each select="//change/@n">
						<xsl:sort select="." data-type="number" order="descending"/>
						<xsl:if test="position()=1">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:attribute name="n"><xsl:value-of select="$max_n+1"/></xsl:attribute>
				Automatic transcoding TEI P4 → P5 by p4p5.xsl.
			</xsl:element>
			<xsl:apply-templates/>
		</revisionDesc>
	</xsl:template>
	
	<!-- <change> has changed its attributes and cannot contain <respStmt> -->
	<xsl:template match="revisionDesc/change">
		<xsl:element name="change">
			<xsl:attribute name="n">
				<xsl:value-of select="@n"/>
			</xsl:attribute>
			<xsl:attribute name="when">																							<!-- former tespStmt/date is now @when. -->
				<xsl:value-of select="./date/@value"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="./respStmt/name/@ref">																	<!-- former respStmt/@ref is now @who -->
					<xsl:attribute name="who">
						<xsl:value-of select="./respStmt/name/@ref"/>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="./respStmt/name">											<!-- former respStmt/name now has to be a child of <change> -->
				<xsl:element name="name">
					<xsl:value-of select="./respStmt/name/text()"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="item">									<!-- <item> not allowed as child of <change>, has to be child of a <list> -->
				<list>
					<xsl:apply-templates/>
				</list>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template match="change/date"/>
	<xsl:template match="change/respStmt"/>
	
	<!-- to describe languages, only langUsage/languae is available -->
	<xsl:template match="langUsage/p">
		<xsl:element name="language">
			<xsl:attribute name="ident">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:value-of select="text()"/>
		</xsl:element>
	</xsl:template>
	
	<!-- handList has been removed; there is now handNotes consisting of handNote -->
	<xsl:template match="handList">
		<xsl:element name="handNotes">
			<xsl:apply-templates select="*"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="handList/hand">
		<xsl:element name="handNote">
			<xsl:apply-templates select="text()|@*"/>
		</xsl:element>
	</xsl:template>
	
	<!-- msDescription (from MASTER) has been integrated to P5 as msDesc -->
	<xsl:template match="msDescription">
		<xsl:apply-templates select="@status"/>
		<xsl:element name="msDesc">
			<xsl:apply-templates select="msIdentifier"/>
			<xsl:if test="($copyHeadingToHead='yes' and msHeading and not(msHeading[author|respStmt|textLang])) or head">
				<xsl:element name="head">
					<xsl:if test="msHeading">
						<xsl:comment>Copied from msHeading</xsl:comment>
						<xsl:apply-templates select="msHeading/*"/>
					</xsl:if>
					<xsl:apply-templates select="head/*"/>
				</xsl:element>
			</xsl:if>
			<xsl:element name="msContents">
				<xsl:if test="$copyHeadingToHead='no' or msHeading[author|respStmt|textLang]">
					<xsl:element name="msItem">
						<xsl:comment>Copied from msHeading</xsl:comment>
						<xsl:apply-templates 
							select="msHeading/*[self::author or self::title or self::respStmt or self::textLang or self::note]"/>
					</xsl:element>
				</xsl:if>
				<xsl:apply-templates select="msContents/*"/>
			</xsl:element>
			<xsl:element name="physDesc">
				<xsl:if test="physDesc/p">
					<xsl:element name="p"><xsl:apply-templates select="physDesc/p"/></xsl:element>
				</xsl:if>
				<xsl:element name="objectDesc">
					<xsl:apply-templates select="physDesc/objectDesc/@*"/>
					<xsl:apply-templates select="physDesc/objectDesc/*"/>
					<xsl:if test="physDesc/form">
						<xsl:attribute name="form">
							<xsl:value-of select="physDesc/form"/>
						</xsl:attribute>
						<xsl:element name="supportDesc">
							<xsl:apply-templates select="physDesc/support"/>
							<xsl:apply-templates select="physDesc/extent"/>
							<xsl:apply-templates select="physDesc/foliation"/>
							<xsl:apply-templates select="physDesc/collation"/>
							<xsl:apply-templates select="physDesc/condition"/>
						</xsl:element>
						<xsl:element name="layoutDesc">
							<xsl:apply-templates select="physDesc/*[self::layout]"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
				<xsl:element name="handDesc">
					<!--	some people seem to have changed to handDesc but kept the rest; we assume that only one of these is used
								and not both within the same document (if so, there's nothing we want to do about it...) -->
					<xsl:apply-templates select="physDesc/handDesc/*"/>
					<xsl:if test="physDesc/handDesc/@hands">
						<xsl:attribute name="hands"><xsl:value-of select="physDesc/handDesc/@hands"/></xsl:attribute>
					</xsl:if>
					
					<xsl:if test="physDesc/msWriting/@hands">
						<xsl:attribute name="hands"><xsl:value-of select="physDesc/msWriting/@hands"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="physDesc/msWriting/*"/>
				</xsl:element>
				<xsl:if test="physDesc/decoration">
					<xsl:element name="decoDesc">
						<xsl:apply-templates select="physDesc/decoration/*"/>
					</xsl:element>
				</xsl:if>
				<xsl:apply-templates select="physDesc/musicNotation"/>
				<xsl:apply-templates select="physDesc/additions"/>
				<xsl:apply-templates select="physDesc/bindingDesc"/>
				<xsl:apply-templates select="physDesc/sealDesc"/>
				<xsl:apply-templates select="physDesc/accMat"/>
			</xsl:element>
			<xsl:element name="history">
				<xsl:element name="origin">
					<xsl:apply-templates select="history/origin/@*[local-name() != 'certainty']"/>
					<xsl:if test="history/origin/@certainty">
						<xsl:element name="certainty">
							<xsl:attribute name="cert"><xsl:value-of select="history/origin/@certainty"/></xsl:attribute>
							<xsl:attribute name="locus">.</xsl:attribute>						<!-- @locus is required but not meaningful here -->
						</xsl:element>
					</xsl:if>
					<xsl:if test="$copyHeadingToHead='no' or msHeading[author|respStmt|textLang]">
						<xsl:comment>Copied from msHeading</xsl:comment>
						<xsl:apply-templates select="msHeading/*[self::origPlace or self::origDate]"/>
					</xsl:if>
					<xsl:apply-templates select="history/origin/*"/>
				</xsl:element>
				<xsl:apply-templates select="history/provenance"/>
				<xsl:apply-templates select="history/acquisition"/>
			</xsl:element>
			<xsl:apply-templates select="additional"/>
			<xsl:apply-templates select="msPart"/>
		</xsl:element>
	</xsl:template>
	<!-- msDescription/@status has been dropped; writing it into @type as we boldly assume that no-one has @type here -->
	<xsl:template match="msDescription/@status">
		<xsl:comment>msDescription/@status: <xsl:value-of select="."/></xsl:comment>
	</xsl:template>
	<!-- overview has been removed; giving it as <p>. -->
	<xsl:template match="msDescription//overview">
		<xsl:element name="p"><xsl:copy-of select="text()"/></xsl:element>
	</xsl:template>
	<!-- msIdentifier/altName was changed to altIdentifier -->
	<xsl:template match="msIdentifier/altName">
		<xsl:element name="altIdentifier">
			<xsl:apply-templates select="@*"/>
			<xsl:element name="idno"><xsl:apply-templates select="text()"/></xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- @attested has been removed, if @attested='no', we introduce @role='unattested' -->
	<xsl:template match="msHeading/author[@attested]">
		<xsl:element name="author">
			<xsl:apply-templates select="@*[local-name() != 'attested']"/>
			<xsl:element name="note">attested: <xsl:value-of select="@attested"/></xsl:element>
			<xsl:apply-templates select="text()"/>
		</xsl:element>
	</xsl:template>
	<!-- The values of msItem/@defective have changed. -->
	<xsl:template match="msItem/@defective">
		<xsl:choose>
			<xsl:when test="not('true') and not('false') and not('unknown')">
				<xsl:choose>
					<xsl:when test=".='yes'">
						<xsl:attribute name="defective">true</xsl:attribute>
					</xsl:when>
					<xsl:when test=".='no'">
						<xsl:attribute name="defective">false</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="defective">unknown</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:copy/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- msItem/q is not allowed; putting it inside <cit>. -->
	<xsl:template match="msItem/q">
		<xsl:element name="cit">
			<xsl:element name="q">
				<xsl:apply-templates select="node()|@*"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!--	<summary> cannot exist within msItem nor can there be more than one which has to be the first child;we can only 
				comment it out and have the user deal with it. -->
	<xsl:template match="msItem/summary">
		<xsl:comment>TODO: msItem/summary is not allowed; there can only be one msContents/summary. was:
			&lt;summary&gt;<xsl:copy-of select="node()"/>&lt;/summary&gt;</xsl:comment>
	</xsl:template>
	<!-- support/watermarks is now support/watermark -->
	<xsl:template match="support/watermarks">
		<xsl:element name="watermark"><xsl:copy-of select="text()"/></xsl:element>
	</xsl:template>
	<!-- msWriting/handDesc is now a handNote -->
	<xsl:template match="msWriting/handDesc">
		<xsl:element name="handNote">
			<xsl:apply-templates select="*|@*"/>
		</xsl:element>
	</xsl:template>
	<!-- @figurative, @illustrative and @technique have been dropped; return them as <p> -->
	<xsl:template match="decoration/decoNote">
		<xsl:element name="decoNote">
			<xsl:apply-templates select="*|@*[local-name() != 'figurative' and local-name() !='technique' and local-name() != 'illustrative']"/>
			<xsl:comment>TODO: former attributes @figurative: <xsl:value-of select="@figurative"/>; @technique: <xsl:value-of select="@technique"/>; @illustrative: <xsl:value-of select="@illustrative"/></xsl:comment>
		</xsl:element>
	</xsl:template>
	<!-- text within a <binding> has to be within a <p> -->
	<xsl:template match="binding/text()">
		<xsl:element name="p"><xsl:value-of select="."/></xsl:element>
	</xsl:template>
	<!-- <material> is not allowed within <binding>; put it inside <p> -->
	<xsl:template match="binding/material">
		<xsl:element name="p"><xsl:element name="material"><xsl:copy-of select="text()"/></xsl:element></xsl:element>
	</xsl:template>
	<!-- origPlace/@reg has been removed; as with name/@reg, convert to @ref and provide longer info elsewhere -->
	<xsl:template match="origPlace/@reg">
		<xsl:attribute name="ref">#<xsl:value-of select="translate(., $uppercase, $lowercase)"/></xsl:attribute>
	</xsl:template>
	<!-- origin/@certainty has been removed. -->
	<xsl:template match="origin/@certainty"/>
	<!-- additional/adminInfo/remarks now has to be model.noteLike -->
	<xsl:template match="adminInfo/remarks">
		<xsl:element name="note"><xsl:apply-templates select="./*|@*"/></xsl:element>
	</xsl:template>
	<xsl:template match="msDescription/msPart">
		<xsl:element name="msPart">
			<xsl:apply-templates select="@*"/>
			<xsl:element name="msIdentifier">
				<xsl:apply-templates select="msIdentifier"/>
				<xsl:apply-templates select="idno"/>
			</xsl:element>
			<xsl:apply-templates select="./*[not(self::idno)]"/>
		</xsl:element>
	</xsl:template>
	
	<!-- There is a mandatory order in publicationStmt: publisher, distributor or authority must be first-->
	<xsl:template match="publicationStmt">
		<xsl:element name="publicationStmt">
			<xsl:apply-templates select="./*[self::publisher or self::distributor or self::authority]"/>
			<xsl:apply-templates select="./*[not(self::publisher or self::distributor or self::authority)]"></xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<!-- ** END of teiHeader ** -->
	
	<!-- ** body elements ** -->
	<!-- xref and xptr are obsolete in P5; convert to simple ref or ptr, resp. -->
	<xsl:template match="xref">
		<xsl:element name="ref">
			<xsl:apply-templates select="@*|text()"/>
		</xsl:element> 
	</xsl:template>
	<xsl:template match="xptr">
		<xsl:element name="ptr">
			<xsl:apply-templates select="@*|text()"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="ref[@targType='bibl']">
		<bibl>
			<xsl:call-template name="t_ref"/>
		</bibl>
	</xsl:template>
	
	<xsl:template match="ref">
		<xsl:call-template name="t_ref"/>
	</xsl:template>
	
	<!-- @reason to hold reason of uncertainty; more info is better put into a note -->
	<xsl:template match="unclear[@reason]">
		<xsl:choose>
			<xsl:when test="not(@reason=$reasons)">
				<xsl:element name="unclear">
					<xsl:attribute name="reason">#TODO: change to an appropriate and valid value</xsl:attribute>
					<xsl:apply-templates select="text()|@*"/>
				</xsl:element>
				<xsl:element name="note">
					<xsl:attribute name="type">editorial</xsl:attribute>
					<xsl:value-of select="@reason"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="unclear">
					<xsl:apply-templates select="*|@*"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="unclear/@reason"/>
	
	<!-- in P5, expan[@abbr] and abbr[@expan] must each be a child of a <choice> -->
	<xsl:template match="expan[@abbr]">
		<choice>
			<abbr>
				<xsl:value-of select="@abbr"/>
			</abbr>
			<expan>
				<xsl:value-of select="text()"/>
			</expan>
		</choice>
	</xsl:template>
	<xsl:template match="abbr[@expan]">
		<choice>
			<abbr>
				<xsl:value-of select="text()"/>
			</abbr>
			<expan>
				<xsl:value-of select="@expan"/>
			</expan>
		</choice>
	</xsl:template>
	
	<!-- in P5, corr[@sic] and sic[@corr] must each be a child of a <choice> -->
	<xsl:template match="corr[@sic]">
		<choice>
			<sic>
				<xsl:value-of select="@sic"/>
			</sic>
			<corr>
				<xsl:value-of select="text()"/>
			</corr>
		</choice>
	</xsl:template>
	<xsl:template match="sic[@corr]">
		<choice>
			<sic>
				<xsl:value-of select="text()"/>
			</sic>
			<corr>
				<xsl:value-of select="@corr"/>
			</corr>
		</choice>
	</xsl:template>
	
	<!-- in P5, orig[@reg] and reg[@oirg] must each be a child of a <choice> -->
	<xsl:template match="orig[@reg]">
		<choice>
			<sic>
				<xsl:value-of select="@reg"/>
			</sic>
			<corr>
				<xsl:value-of select="text()"/>
			</corr>
		</choice>
	</xsl:template>
	<xsl:template match="reg[@orig]">
		<choice>
			<sic>
				<xsl:value-of select="text()"/>
			</sic>
			<corr>
				<xsl:value-of select="@orig"/>
			</corr>
		</choice>
	</xsl:template>

	<!-- nested indexes are really nested now -->
	<xsl:template match="index[@level1]">
		<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:attribute name="indexName"><xsl:value-of select="@index"/></xsl:attribute>
			<xsl:element name="term">
				<xsl:value-of select="@level1"/>
			</xsl:element>
			<xsl:if test="@level2">
				<xsl:element name="index">
					<xsl:element name="term">
						<xsl:value-of select="@level2"/>
					</xsl:element>
					<xsl:if test="@level3">
						<xsl:element name="index">
							<xsl:element name="term">
								<xsl:value-of select="@level3"/>
							</xsl:element>
							<xsl:if test="@level4">
								<xsl:element name="index">
									<xsl:element name="term">
										<xsl:value-of select="@level4"/>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<!-- <monogr> only allowed as child of a <biblStruct> -->
	<xsl:template match="bibl[monogr]">
		<biblStruct>
			<analytic>
				<xsl:apply-templates/>
			</analytic>
			<monogr>
				<xsl:apply-templates select="./monogr/*"/>
			</monogr>
		</biblStruct>
	</xsl:template>
	<xsl:template match="bibl/monogr"/>
	
	<!-- <imprint> not allowed in <bibl>; {imprint/*} → {bibl/*} -->
	<xsl:template match="bibl/imprint">
		<xsl:apply-templates select="./*"/>
	</xsl:template>
	<!-- ** END of body ** -->
	
	<!-- ** attributes ** -->
	<!-- handShift/@old removed without substitute. -->
	<xsl:template match="handShift/@old"/>
	
	<!-- textLang/@langKey has been renamed to @mainLang -->
	<xsl:template match="textLang/@langKey">
		<xsl:attribute name="mainLang">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>
	
	<!-- should only appear as an attribute of <xref> or <xptr> -->
	<xsl:template match="@doc">
		<xsl:attribute name="target">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<!-- @tei:id was dropped; replacement is @xml:id -->
	<xsl:template match="@id">
		<xsl:attribute name="xml:id">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>
	
	<!-- @tei:lang was dropped; replacement is @xml:lang -->
	<xsl:template match="@lang">
		<xsl:attribute name="xml:lang">
			<xsl:value-of select="."/>
		</xsl:attribute>
		<xsl:comment> TODO: Make sure this is a valid language code! </xsl:comment>
	</xsl:template>
	
	<!-- @cert may only contain high, medium, low or unknown -->
	<xsl:template match="@cert">
		<xsl:choose>
			<xsl:when test=".='high|medium|low|unknown'">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="num"><xsl:value-of select="number(translate(., '%', ''))"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$num > 67">
						<xsl:attribute name="cert">
							<xsl:text>high</xsl:text>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$num > 34">
						<xsl:attribute name="cert">
							<xsl:text>medium</xsl:text>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$num > 0">
						<xsl:attribute name="cert">
							<xsl:text>low</xsl:text>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="cert">
							<xsl:text>unknown</xsl:text>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- sic/@resp was (erroneously?) declared in P4 but has been removed-->
	<xsl:template match="sic/@resp"/>	
	
	<!-- date/@value is now @when -->
	<xsl:template match="date/@value">
		<xsl:choose>
			<xsl:when test=". castable as xs:date">
				<xsl:attribute name="when">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment> TODO: when='<xsl:value-of select="."/>' is not a valid ISO date! </xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- locus/@targets is now @target -->
	<xsl:template match="locus/@targets">
		<xsl:attribute name="target"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	
	<!-- get rid of some unwanted attributes -->	
	<xsl:template match="@TEIform" />
	
	<xsl:template match="teiHeader/@status">
		<xsl:if test="not(. = 'new')">
			<xsl:attribute name="status">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="teiCorpus/TEI/@xmlns"/>
	
	<xsl:template match="@xmlns"/>
	
	<!-- ** Defaults ** -->
	<!-- make sure every element is in the right namespace -->	
	<xsl:template match="*">
		<xsl:choose>
			<xsl:when test="namespace-uri()=''">
				<xsl:element namespace="http://www.tei-c.org/ns/1.0" name="{local-name(.)}">
					<xsl:apply-templates select="node()|@*"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="node()|@*"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@*|processing-instruction()|comment()|text()">
		<xsl:copy/>
	</xsl:template>
	<!-- ** END of Defaults ** -->
</xsl:transform>