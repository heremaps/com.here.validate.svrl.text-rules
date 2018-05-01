<?xml version="1.0" ?>
<!--
	This file is part of the Spelling and Grammar Checker project.
	See the accompanying LICENSE file for applicable licenses.
-->
<!--
	Stylesheet that creates an ANT build script based on the spell-check errors.
-->
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" method="xml" omit-xml-declaration="no"/>
	<xsl:template match="/">
		<project default="auto-correct" name="validator.auto-correct">
			<target name="auto-correct">
				<xsl:apply-templates mode="stuff" select="//meta"/>
			</target>
		</project>
	</xsl:template>
	<!--
		Template to add each error found as a replaceregex entry.
	-->
	<xsl:template match="*" mode="stuff">
		<xsl:element name="replaceregexp">
			<xsl:attribute name="file">${dir}
				<xsl:value-of select="@file"/></xsl:attribute>
			<xsl:attribute name="match">\b
				<xsl:value-of select="@mistake"/>
				\b</xsl:attribute>
			<xsl:attribute name="replace">
				<xsl:value-of select="@correction"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>