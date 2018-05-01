<?xml version="1.0" encoding="utf-8"?>
<!--
	This file is part of the Spelling and Grammar Checker project.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet version="2.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="LANGUAGE_CODE" select="substring($DEFAULTLANG, 1, 2)"/>
	<xsl:variable as="xs:boolean" name="INCLUDE_META" select="$AUTO_CORRECT='true'"/>
	<!-- Apply Rules which apply to all nodes  -->
	<xsl:template match="*" mode="common-pattern">
		<active-pattern name="common-rules" role="grammar">
			<!--
				The following rules apply to all text regardless of language.
			-->
			<xsl:apply-templates mode="common-grammar-rules" select="//*[self::p or self::li or self::entry][text()]"/>
			<xsl:apply-templates mode="common-textual-rules" select="//*[self::p or self::li or self::entry][text()]"/>
			<!--
				The following rules apply to the default language only.
			-->
			<xsl:if test="(not(@xml:lang or ancestor::*[@xml:lang]/@xml:lang) or ((starts-with(@xml:lang,'$LANGUAGE_CODE'))  or (starts-with(ancestor::*[@xml:lang]/@xml:lang,'$LANGUAGE_CODE'))) )">
				<xsl:apply-templates mode="default-lang-spelling-rules" select="//*[self::p or self::li or self::entry][text()]"/>
				<xsl:apply-templates mode="default-lang-grammar-rules" select="//*[self::p or self::li or self::entry][text()]"/>
			</xsl:if>
		</active-pattern>
		<!-- The following additional rules apply to the English language only -->
		<xsl:if test="$LANGUAGE_CODE='en'">
			<xsl:if test="(not(@xml:lang or ancestor::*[@xml:lang]/@xml:lang) or ((starts-with(@xml:lang,'en'))  or (starts-with(ancestor::*[@xml:lang]/@xml:lang,'en'))) )">
				<active-pattern name="english-grammar" role="grammar">
					<xsl:apply-templates mode="english-grammar-rules" select="//*[self::p or self::li or self::entry][text()]"/>
				</active-pattern>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--
		Common DITA Grammar Rules - Typographic errors within the running text
	-->
	<xsl:template match="*[not((.//p) or (.//entry) or (.//codeph) or (.//li))]" mode="common-grammar-rules">
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

			 sentence-capitalization - Sentences must start with a capital letter
		-->
		<xsl:if test="not(./keyword) and matches($running-text,'\w\w\.\s+[a-z]') and not(matches($running-text,'((i\.e)|(e\.g))\.|etc\.'))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">sentence-capitalization</xsl:with-param>
				<xsl:with-param name="test">matches($running-text, ,'i') </xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="normalize-space(replace($running-text, '\\', '\\\\'))"/>
			</xsl:call-template>
		</xsl:if>
		<!--

			 latin-abbreviation - Latin abbreviations should be avoided.
		-->
		<xsl:if test="matches($running-text,'((i\.e)|(e\.g))\.')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">latin-abbreviation</xsl:with-param>
				<xsl:with-param name="test">matches($running-text,'(i.\e\.|e\.g\.)')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="normalize-space(replace($running-text, '\\', '\\\\'))"/>
			</xsl:call-template>
		</xsl:if>
		<!--

			 duplicated-punctuation - Duplicated punctionation marks should be removed
		-->
		<xsl:if test="matches($running-text,'(,,|\.\.|\?\?|!!|::|;;|--)') and not(matches($running-text, '\.\.\.'))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">duplicated-punctuation</xsl:with-param>
				<xsl:with-param name="test">matches($running-text,'(,,|\.\.|\?\?|!!|::|;;|--)</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="normalize-space(replace($running-text, '\\', '\\\\'))"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="common-grammar-rules"/>
	<!--
		Default language Spelling Rules - Typographic errors within the running text, not codeph or codeblock. Looks for regex matches from the words in the dictionary files
	-->
	<xsl:variable name="spelling-file">
		<xsl:value-of select="$DICTIONARY_DIR"/>
		<xsl:value-of select="concat('/', 'spelling.xml')"/>
	</xsl:variable>
	<xsl:variable name="duplicates-file">
		<xsl:value-of select="$DICTIONARY_DIR"/>
		<xsl:value-of select="concat('/', 'duplicates.xml')"/>
	</xsl:variable>
	<xsl:template match="*[not(self::codeblock or ancestor::codeblock)]" mode="default-lang-spelling-rules">
		<xsl:call-template name="fired-rule"/>
		<!-- Running text checks-->
		<xsl:variable name="running-text">
			<xsl:value-of select="text()"/>
		</xsl:variable>
		<!--
			 incorrect-spelling - The words in the spellings file should not be found within the running text.
		-->
		<xsl:if test="matches($running-text,$SPELLING_REGEX,'i')">
			<xsl:call-template name="fail-file-based-rule">
				<xsl:with-param name="file" select="$spelling-file"/>
				<xsl:with-param name="rule-id">incorrect-spelling</xsl:with-param>
				<xsl:with-param name="test">matches($running-text,$SPELLING_REGEX,'i')</xsl:with-param>
				<xsl:with-param name="running-text" select="$running-text"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			 duplicated-words - The words in the duplicates file should not be found within the running text.
		-->
		<xsl:if test="matches($running-text,$DUPLICATES_REGEX,'i')">
			<xsl:call-template name="fail-file-based-rule">
				<xsl:with-param name="file" select="$duplicates-file"/>
				<xsl:with-param name="rule-id">duplicated-words</xsl:with-param>
				<xsl:with-param name="test">matches($running-text,$DUPLICATES_REGEX,'i')</xsl:with-param>
				<xsl:with-param name="running-text" select="$running-text"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="default-lang-spelling-rules"/>
	<!--
		Default language grammar Rules - Typographic errors within the running text
		Looks for regex matches from the words in the dictionary files
	-->
	<xsl:variable name="grammar-file">
		<xsl:value-of select="$DICTIONARY_DIR"/>
		<xsl:value-of select="concat('/', 'grammar.xml')"/>
	</xsl:variable>
	<xsl:variable name="punctuation-file">
		<xsl:value-of select="$DICTIONARY_DIR"/>
		<xsl:value-of select="concat('/', 'punctuation.xml')"/>
	</xsl:variable>
	<xsl:template match="*[not((.//p) or (.//entry) or (.//codeph) or (.//li))]" mode="default-lang-grammar-rules">
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
			 incorrect-grammar - The words in the grammar file should not be found within the running text.
		-->
		<xsl:if test="matches($running-text,$GRAMMAR_REGEX,'i')">
			<xsl:call-template name="fail-file-based-rule">
				<xsl:with-param name="file" select="$grammar-file"/>
				<xsl:with-param name="rule-id">incorrect-grammar</xsl:with-param>
				<xsl:with-param name="test">matches($running-text,$GRAMMAR_REGEX,'i')</xsl:with-param>
				<xsl:with-param name="running-text" select="$running-text"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			 incorrect-punctuation -  The characters in the punctuation file should not be found within the running text.
		-->
		<xsl:if test="matches($running-text,$PUNCTUATION_REGEX)">
			<xsl:variable name="node" select="."/>
			<xsl:variable name="rule-id">incorrect-punctuation</xsl:variable>
			<xsl:for-each select="document($punctuation-file)//entry">
				<xsl:variable name="mistake">
					<xsl:value-of select="normalize-space(./mistake)"/>
				</xsl:variable>
				<xsl:variable name="corrected">
					<xsl:value-of select="normalize-space(./corrected)"/>
				</xsl:variable>
				<xsl:variable name="mistake-whole-word-regex">
					<xsl:text>(</xsl:text>
					<xsl:value-of select="$mistake"/>
					<xsl:text>)</xsl:text>
				</xsl:variable>
				<xsl:if test="matches($running-text,$mistake-whole-word-regex)">
					<xsl:apply-templates mode="failed-assert-with-node" select="$node">
						<xsl:with-param name="rule-id" select="$rule-id"/>
						<xsl:with-param name="test" select="matches($running-text,$PUNCTUATION_REGEX)"/>
						<!--  Placeholders -->
						<xsl:with-param name="param1" select="$corrected"/>
						<xsl:with-param name="param2" select="$mistake"/>
						<xsl:with-param name="param3" select="normalize-space(replace($running-text, '\\', '\\\\'))"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="default-lang-grammar-rules"/>
	<!--
		Function to trawl through the list of mistakes and find the one that
		fired the rule.
	-->
	<xsl:template name="fail-file-based-rule">
		<xsl:param name="file"/>
		<xsl:param name="rule-id"/>
		<xsl:param name="test"/>
		<xsl:param name="running-text"/>
		<xsl:variable name="node" select="."/>
		<xsl:for-each select="document($file)//entry">
			<xsl:variable name="mistake">
				<xsl:value-of select="normalize-space(./mistake)"/>
			</xsl:variable>
			<xsl:variable name="corrected">
				<xsl:value-of select="normalize-space(./corrected)"/>
			</xsl:variable>
			<xsl:variable name="mistake-whole-word-regex">
				<xsl:text>(^|\W)(</xsl:text>
				<xsl:value-of select="$mistake"/>
				<xsl:text>)($|\W)</xsl:text>
			</xsl:variable>
			<xsl:if test="matches($running-text,$mistake-whole-word-regex,'i')">
				<xsl:apply-templates mode="failed-assert-with-node" select="$node">
					<xsl:with-param name="rule-id" select="$rule-id"/>
					<xsl:with-param name="test" select="$test"/>
					<!--  Placeholders -->
					<xsl:with-param name="param1" select="$corrected"/>
					<xsl:with-param name="param2" select="$mistake"/>
					<xsl:with-param name="param3" select="normalize-space(replace($running-text, '\\', '\\\\'))"/>
				</xsl:apply-templates>
				<xsl:if test="$INCLUDE_META">
					<xsl:variable name="correction" select="tokenize(tokenize($corrected, ',')[1], '\[')[1]"/>
					<xsl:element name="meta">
						<xsl:attribute name="mistake">
							<xsl:value-of select="$mistake"/>
						</xsl:attribute>
						<xsl:attribute name="correction">
							<xsl:value-of select="$correction"/>
						</xsl:attribute>
						<xsl:attribute name="file">
							<xsl:value-of select="$document-uri"/>
						</xsl:attribute>
					</xsl:element>
					<xsl:element name="meta">
						<xsl:attribute name="mistake">
							<xsl:value-of select="upper-case(substring($mistake,1,1))"/>
							<xsl:value-of select="substring($mistake,2)"/>
						</xsl:attribute>
						<xsl:attribute name="correction">
							<xsl:value-of select="upper-case(substring($correction,1,1))"/>
							<xsl:value-of select="substring($correction,2)"/>
						</xsl:attribute>
						<xsl:attribute name="file">
							<xsl:value-of select="$document-uri"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>