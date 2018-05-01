<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the Spelling and Grammar Checker project.
  See the accompanying LICENSE file for applicable licenses.
-->
<!--
	Stylesheet that is used to process each *.dita file in turn and transform it into
	Schematron Validation Report Language (SVRL) files

	see http://www.schematron.com/validators.html

	Schematron is an ISO/IEC Standard. ISO/IEC 19757-3:2006 Information technology
		Document Schema Definition Language (DSDL) - Part 3: Rule-based validation - Schematron
	The standard is available Royalty-free at the ISO website

	http://standards.iso.org/ittf/PubliclyAvailableStandards/index.html
-->
<xsl:stylesheet exclude-result-prefixes="dita-ot" version="2.0" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="plugin:com.here.validate.svrl:xsl/schematron.xsl"/>
	<xsl:import href="plugin:com.here.validate.svrl:Customization/xsl/textual-rules.xsl"/>
	<!--PROLOG-->
	<xsl:param as="xs:string" name="SOURCE"/>
	<xsl:param as="xs:string" name="DICTIONARY_DIR"/>
	<!-- Parameters to hold spelling mistakes etc. -->
	<xsl:param name="DUPLICATES_REGEX">a^</xsl:param>
	<xsl:param name="SPELLING_REGEX">a^</xsl:param>
	<xsl:param name="GRAMMAR_REGEX">a^</xsl:param>
	<xsl:param name="PUNCTUATION_REGEX">a^</xsl:param>
	<!-- Parameters to re-check blacklisted and case sensitive words-->
	<xsl:param as="xs:string" name="BLACKLIST"/>
	<xsl:param as="xs:string" name="CHECK_CASE"/>
	<xsl:param as="xs:string" name="AUTO_CORRECT" select="'false'"/>
	<xsl:include href="../Customization/xsl/common-rules.xsl"/>
	<xsl:include href="../Customization/xsl/en/grammar.xsl"/>
	<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
	<xsl:template match="/">
		<!--SCHEMA SETUP-->
		<schematron-output schemaVersion="1.5" title="DITA text-rules Validation" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
			<xsl:apply-templates mode="common-pattern"/>
		</schematron-output>
	</xsl:template>
</xsl:stylesheet>