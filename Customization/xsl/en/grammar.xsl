<?xml version="1.0" encoding="utf-8"?>
<!--
	This file is part of the Spelling and Grammar Checker project.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--
		Additional English Grammar Rules.
	-->
	<xsl:template match="*[not((.//p) or (.//entry) or (.//codeph) or (.//li))]" mode="english-grammar-rules">
		<xsl:call-template name="fired-rule"/>
		<!-- Running text checks - ignore text within a codeblock or draft-comment -->
		<xsl:variable name="running-text">
			<xsl:choose>
				<xsl:when test="codeblock">
					<xsl:value-of select="text()"/>
				</xsl:when>
				<xsl:when test="draft-comment">
					<xsl:value-of select="text()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--

			 a-followed-by-vowel - In English, the indefinite article should be "an" when preceding a vowel
		-->
		<xsl:if test="matches($running-text,' a\s+[aeio]\w+') and not(matches($running-text, ' a\s+(one|user)' ,'i'))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">a-followed-by-vowel</xsl:with-param>
				<xsl:with-param name="test">matches($running-text, '(^|\b)a\s[aeiou]\w+' ,'i')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="normalize-space(replace($running-text, '\\', '\\\\'))"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			 an-followed-by-consonant - In English, the indefinite article should be "an" when preceding a consonant
		-->
		<xsl:if test="matches($running-text,' an\s+[bcdfgjklmnpqrstvwxyz]\w+')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">an-followed-by-consonant</xsl:with-param>
				<xsl:with-param name="test">matches($running-text, ,'i')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="normalize-space(replace($running-text, '\\', '\\\\'))"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			 where-not-were - In English, a comma followed by were doesn't make sense.
		-->
		<xsl:if test="matches($running-text,',\s+were','i')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">where-not-were</xsl:with-param>
				<xsl:with-param name="test">matches($running-text, ',\swere', 'i')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="normalize-space(replace($running-text, '\\', '\\\\'))"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			 split-infinitive - In English, use of split infinitives is considered poor writing style
		-->
		<xsl:if test="matches($running-text,'(T|\st)o\s+\w+ly\s','i') and not(matches($running-text,'(app|comp|Ita|on|re|supp)ly', 'i'))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">split-infinitive</xsl:with-param>
				<xsl:with-param name="test">matches($running-text, '(?![app|comp|Ita|on|re|supp)([a-z]*)ly ', 'i')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="normalize-space(replace($running-text, '\\', '\\\\'))"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="english-grammar-rules"/>
</xsl:stylesheet>