

Spelling and Grammar Checker Plug-in for DITA-OT
================================================

[![license](https://img.shields.io/github/license/jason-fox/com.here.validate.svrl.text-rules.svg)](http://www.apache.org/licenses/LICENSE-2.0)
[![DITA-OT 3.2](https://img.shields.io/badge/DITA--OT-3.2-blue.svg)](http://www.dita-ot.org/3.2)
[![DITA-OT 2.5](https://img.shields.io/badge/DITA--OT-2.5-green.svg)](http://www.dita-ot.org/2.5)
<br/>
[![Build Status](https://travis-ci.org/jason-fox/com.here.validate.svrl.text-rules.svg?branch=master)](https://travis-ci.org/jason-fox/com.here.validate.svrl.text-rules)
[![Coverage Status](https://coveralls.io/repos/github/jason-fox/com.here.validate.svrl.text-rules/badge.svg?branch=master)](https://coveralls.io/github/jason-fox/com.here.validate.svrl.text-rules?branch=master)

The Spelling and Grammar Checker plug-in for DITA OT  is an  **extension**  of the base [DITA Validator](https://github.com/jason-fox/com.here.validate.svrl) which adds simple rule-based **spelling and grammar** validation for the text elements within DITA documents.

The plug-in supports three `transtypes`:

 - `auto-correct` - remove reported spelling and grammar errors from  a DITA document
 - `text-rules`  - create an error report in **Schematron Validation Report Language** (`SVRL`) format
 - `text-rules-echo` - display the results of an `SVRL` error report in a human-readable format

More information about `SVRL` can be found at [www.schematron.com](http://www.schematron.com/validators.html)

Most of the spell-checking rules are based on a list of [known typographical errors and faults](https://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings), and the ruleset can be easily altered to include new constraints. Checking against a list of known errors means that no false positives should occur, but the existing list will never be fully comprehensive.

Table of Contents
=================

- [Install](#install)
  * [Installing DITA-OT](#installing-dita-ot)
  * [Installing the Base Validator Plug-in](#installing-the-base-validator-plug-in)
  * [Installing the Spelling and Grammar Checker Plug-in](#installing-the-spelling-and-grammar-checker-plug-in)
- [Usage](#usage)
  * [Spell-checking a document from the command line](#spell-checking-a-document-from-the-command-line)
    + [Creating an SVRL file](#creating-an-svrl-file)
    + [Echoing results to the command line](#echoing-results-to-the-command-line)
    + [Auto-correction from the command line](#auto-correction-from-the-command-line)
    + [Parameter Reference](#parameter-reference)
  * [Spell-checking a document from the using ANT](#spell-checking-a-document-from-the-using-ant)
- [Configuring the plug-in](#configuring-the-plug-in)
  * [Internationalization](#internationalization)
  * [Adding new mis-spellings to the plug-in](#adding-new-mis-spellings-to-the-plug-in)
  * [Altering the severity of a validator rule](#altering-the-severity-of-a-validator-rule)
  * [Ignoring Validator Rules](#ignoring-validator-rules)
    + [Removing a rule globally](#removing-a-rule-globally)
    + [Ignoring a rule throughout a document](#ignoring-a-rule-throughout-a-document)
    + [Ignoring a specific instance of a rule](#ignoring-a-specific-instance-of-a-rule)
    + [Ignoring all warnings/errors within a block of text](#ignoring-all-warningserrors-within-a-block-of-text)
- [Sample Document](#sample-document)
- [Spell-checker Error Messages](#spell-checker-error-messages)
- [Contribute](#contribute)
- [License](#license)


Install
=======

The validator has been tested against [DITA-OT 3.0.x](http://www.dita-ot.org/download). It is recommended that you upgrade to the latest version. Running the validator plug-in against DITA-OT 1.8.5 or earlier versions of DITA-OT will not work as it uses the newer `getVariable` template. To work with DITA-OT 1.8.5 this would need to be refactored to use `getMessage`. The validator can also be run safely against DITA-OT 2.x.

Installing DITA-OT
------------------

The spell-checker is a plug-in for the DITA open toolkit. Futhermore, it is not a stand alone plug-in as it extends the **base validator plug-in** ([`com.here.validate.svrl`](https://github.com/jason-fox/com.here.validate.svrl)).

-  install the DITA-OT distribution JAR file dependencies by running `gradle install` from your clone of the [DITA-OT repository](https://github.com/dita-ot/dita-ot).

The required dependencies are installed to a local Maven repository in your home directory under `.m2/repository/org/dita-ot/dost/`.

-  Run the Gradle distribution task to generate the plug-in distribution package:

```console
./gradlew dist
```

The distribution ZIP file is generated under `build/distributions`.

Installing the Base Validator Plug-in
-------------------------------------

-  Run the plug-in installation command:

```console
dita -install https://github.com/jason-fox/com.here.validate.svrl/archive/master.zip
```

Installing the Spelling and Grammar Checker Plug-in
---------------------------------------------------

-  Run the plug-in installation command:

```console
dita -install https://github.com/jason-fox/com.here.validate.svrl.text-rules/archive/master.zip
```

> The `dita` command line tool requires no additional configuration.

Usage
=====

Spell-checking a document from the command line
-----------------------------------------------

A test document can be found within the plug-in at: `PATH_TO_DITA_OT/plugins/com.here.validate.svrl.text-rules/sample`

### Creating an SVRL file

To create an SVRL file with the spell-checker plug-in use the `text-rules` transform  with the `--args.validate.mode=report` parameter.

-  From a terminal prompt move to the directory holding the document to validate


-  SVRL file creation can be run like any other DITA-OT transform:

```console
PATH_TO_DITA_OT/bin/dita -f text-rules -o out -i document.ditamap --args.validate.mode=report
```

Once the command has run, an `SVRL` file is created:

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<svrl:schematron-output>
	<active-pattern role="dita" name="/incorrect-spelling.dita"/>
	<fired-rule context="common" role="grammar"/>
	<fired-rule context="default-lang" role="spelling"/>
	<failed-assert role="error" location="/topic/body[1]/section[2]/p[1]">
		<diagnostic-reference diagnostic="incorrect-spelling">
			Line 17: p - [incorrect-spelling] 
			The word 'separate' is spelt incorrectly ('seperate') in the following text: 

			Seperate accommodation can be found within the main building...
		</diagnostic-reference>
	</failed-assert>
	<fired-rule context="default-lang" role="grammar"/>
	<fired-rule context="english" role="grammar"/>
</svrl:schematron-output>
```

### Echoing results to the command line

To echo results to the command line with the spell-checker plug-in use the `text-rules` transform without specifying a `report`

-  Spell-checking (`text-rules`) can be run like any other DITA-OT transform:

```console
PATH_TO_DITA_OT/bin/dita -f text-rules -i document.ditamap
```

Once the command has run, all errors and warnings are echoed to the command line:

```console
[ERROR]  [/topics/incorrect-spelling.dita]
 Line 17: p - [incorrect-spelling]
The word 'separate' is spelt incorrectly ('seperate') in the following text:
Seperate accommodation can be found within the main building.
```

Additionally, if an error occurs, the command will fail

```console
[ERROR]  [/topics/incorrect-spelling.dita]
 Line 17: p - [incorrect-spelling]
The word 'separate' is spelt incorrectly ('seperate') in the following text:
Seperate accommodation can be found within the main building.
Found 1 Errors 0 Warnings
Error: [SVRL001F][FATAL] Error: Errors detected during validation
```

### Auto-correction from the command line

To auto-correct spelling mistakes with the spell-checker plug-in use the `auto-correct` transform.

-  Auto-correction (`auto-correct`) can be run like any other DITA-OT transform:

```console
PATH_TO_DITA_OT/bin/dita -f auto-correct -i document.ditamap
```

Once the command has run spelling mistakes will have been removed from the document.

> *Note:* The auto-correct `transtype` only removes spelling, duplicate and grammar errors specified in the dictionary files

### Parameter Reference


- `args.validate.ignore.rules` - Comma separated list of rule IDs to be ignored
- `args.validate.blacklist` - Comma separated list of words that should not be present in the running text
- `args.validate.cachefile` - Specifies the location of cache file to be used. Validation will only run across altered files if this parameter is present
- `args.validate.check.case` - Comma separated list of words which have a specified capitalization
- `args.validate.color` - When set, errors and warnings are Output highlighted using ANSI color codes
- `args.validate.mode` - Validation reporting mode. The following values are supported:
	- `strict`	- Outputs both warnings and errors. Fails on errors and warnings.
	- `default` - Outputs both warnings and errors. Fails on errors only
	- `lax`		- Ignores all warnings and outputs errors only. Fails on Errors only
	- `report`  - Creates an SVRL file
- `svrl.customization.dir` - Specifies the customization directory
- `svrl.filter.file` - Specifies the location of the XSL file used to filter the echo output. If this parameter is not present, the default echo output format will be used.
- `text-rules.ruleset.file` - Specifies severity of the rules to apply. If this parameter is not present, default severity levels will be used.


Spell-checking a document from the using ANT
--------------------------------------------

An ANT build file is supplied in the same directory as the sample document. The main target can be seen below:

```xml
<dirname property="dita.dir" file="PATH_TO_DITA_OT"/>
<property name="dita.exec" value="${dita.dir}/bin/dita"/>
<property name="args.input" value="PATH_TO_DITA_DOCUMENT/document.ditamap"/>

<target name="spell-check" description="spell-check a document">
	<!-- For Unix run the DITA executable-->
	<exec executable="${dita.exec}" osfamily="unix" failonerror="true">
		<arg value="-input"/>
		<arg value="${args.input}"/>
		<arg value="-output"/>
		<arg value="${dita.dir}/out/svrl"/>
		<arg value="-format"/>
		<arg value="text-rules-echo"/>
		<!-- validation transform specific parameters -->
		<arg value="--args.validate.blacklist=(kilo)?metre|colour|teh|seperate"/>
		<arg value="--args.validate.check.case=Bluetooth|HTTP[S]? |IoT|JSON|Java|Javadoc|JavaScript|XML"/>
		<arg value="--args.validate.color=true"/>
	</exec>
	<!-- For Windows run from a DOS command -->
	<exec dir="${dita.dir}/bin" executable="cmd" osfamily="windows" failonerror="true">
		<arg value="/C"/>
		<arg value="dita -input ${args.input} -output ${dita.dir}/out/svrl -format text-rules-echo --args.validate.blacklist=&quot;(kilo)?metre|colour|teh|seperate&quot; --args.validate.check.case=&quot;Bluetooth|HTTP[S]? |IoT|JSON|Java|Javadoc|JavaScript|XML&quot;"/>
	</exec>
</target>
```


Configuring the plug-in
=======================

Internationalization
--------------------

The spelling and grammar checker currently supports three languages:

* `en` - English
* `de` - German
* `fr` - French

The language checked is based on the `default.language` setting of the DITA Open toolkit. This can be modified in the `lib/configuration.properties` file.

> Please note that error messages have **not** been internationalized into French and currently all error messages will be displayed in English.

Sample lists of duplicated and mis-spelt words are available in all three languages.
Grammar and punctuation lists have only been supplied for `en`.

Additional languages can be added by creating a new language folder and files under `cfg/dictionary`

Adding new mis-spellings to the plug-in
---------------------------------------

The list of misspelt words to check when spell-checking can be altered by amending entries in the xml files under `cfg/dictionary`. The plug-in recognizes four types of errors:

* **duplicates.xml** - Duplicated words.
* **grammar.xml** - Grammar errors (includes a ban on the use of contractions in formal text )
* **punctuation.xml** - Punctuation marks (includes a ban on smart quotes).
* **spelling.xml** - Spelling mistakes

Each entry takes the form of a pair


```xml
<entry>
	<mistake>accessable</mistake>
	<corrected>accessible</corrected>
</entry>
<entry>
	<mistake>acident</mistake>
	<corrected>accident</corrected>
</entry>
<entry>
	<mistake>accidentaly</mistake>
	<corrected>accidentally</corrected>
</entry>
```


Altering the severity of a validator rule
-----------------------------------------

The severity of a validator rule can be altered by amending entries in the `cfg/ruleset/default.xml`  file The plug-in supports four severity levels:

* **FATAL** - Fatal rules will fail validation and cannot be overridden.
* **ERROR** - Error rules will fail validation. Errors can be overridden as described above.
* **WARNING** - Warning rules will display a warning on validation, but do not fail the validation. Warnings can also be individually overridden.
* **INACTIVE** - Inactive rules are not applied.

A custom ruleset file can be passed into the plug-in using the `text-rules.ruleset.file` parameter


```console
PATH_TO_DITA_OT/bin/dita -f text-rules-echo -i document.ditamap --text-rules.ruleset.file=PATH_TO_CUSTOM/ruleset.xml
```

Ignoring Validator Rules
------------------------

### Removing a rule globally

Rules can be made inactive by altering the severity (see above).  Alternatively a rule can be commented out in the XSL configuration file.

### Ignoring a rule throughout a document

Individual rules can be ignored by passing the `args.validate.ignore.rules` parameter to the command line. The value of the parameter should be a comma-delimited list of each `rule-id` to ignore.

For example to ignore the `latin-abbreviation` validation rule within a document you would run:

```console
PATH_TO_DITA_OT/dita -f text-rules-echo -i document.ditamap -Dargs.validate.ignore.rules=latin-abbreviation
```

### Ignoring a specific instance of a rule

Specific instances of a rule can be ignored by adding a comment within the `*.dita` file. The comment should start with `ignore-rule` and needs to be added at the location where the error is flagged.

```xml
<!--
	This is an example of a spelling mistake
-->
<p>
	<!-- ignore-rule:incorrect-spelling -->
	I have deliberately misspelt the word accidentaly (sic) - it should be written with a double l.
</p>
```

### Ignoring all warnings/errors within a block of text

* A block of DITA can be excluded from firing all rules at **WARNING** level by adding the comment `ignore-all-warnings` to the block. 

* A block of DITA can be excluded from firing all rules at **ERROR** level by adding the comment `ignore-all-errors` to the block.

* Rules set at **FATAL** level cannot be ignored.


Sample Document
===============

A sample document can be found within the plug-in which can used to test plug-in rules. The document covers both positive and negative test cases. The sample document contains valid DITA which can be built as an HTML or as a PDF document - please use the `html` or `pdf` transform to read the contents or examine the `*.dita` files directly.

A complete list of rules covered by the plug-in can be found below. The final `<chapters>` of the sample document contain a set of test DITA `<topics>`, each demonstrating a broken validation rule.

The `<topic>` files are sorted as follows:

- The base validation DITA-OT plugin (`com.here.validate.svrl`) -  this  `<chapter>` contains two common textual validation rules.
- The text-rules DITA-OT plugin (`com.here.validate.svrl.text-rules`) - This  `<chapter>` contains a set of English language spelling and grammar rules.


Spell-checker Error Messages
============================

The following table list the spell-checker error messages by message ID.


|Message ID|Message|Corrective Action/Comment|
|----------|-------|-------------------------|
|a-followed-by-vowel|In the following text, change 'a' to 'an' where appropriate:|	In English, the general guideline is that the indefinite article in front of count nouns that begin with a vowel sound should be 'an'.|
|an-followed-by-consonant|In the following text, change 'an' to 'a' where appropriate:|In English, the general guideline is that the indefinite article in front of count nouns that begin with a consonant sound should be 'a'. |
|blacklisted-word|The word '\{word\}' is not allowed in the following text:|The indicated word has been banned from use. Rewrite the phrase using alternatives.|
|duplicated-punctuation|The punctuation mark '{char}' is duplicated in the following text:|The indicated punctuation mark is duplicated. Delete the duplicated punctuation mark.|
|duplicated-words|The word '\{word\}' is duplicated in the following text:|The indicated word is duplicated. Delete the duplicated word..|
|incorrect-capitalization|The word '\{word\}' is incorrectly capitalized in the following text:|The indicated word is not capitalized correctly. Fix the capitalization.|
|incorrect-grammar|The phrase '\{phrase\}' is grammatically incorrect in the following text:|The indicated phrase does not make sense. Rewrite the phrase using the correct grammar.|
|incorrect-punctuation|The punctuation mark '\{char\}' has been used incorrectly in the following text:|The indicated punctuation mark is non-standard. Replace with a corrected punctuation mark. |
|incorrect-spelling|The word '\{word\}' is a spelling mistake in the following text:|The indicated word is not spelled correctly. Fix the spelling. It is assumed that documentation follows US English spelling conventions. |
|latin-abbreviation|The accronym i.e or e.g has been used in the following text:|Latin accronyms are difficult to understand. Consider rewriting the phrase using alternatives, such as "for example"|
|sentence-capitalization|The run on sentence in the following text does not start with a capital letter|The indicated sentence is not punctuated correctly. Fix the punctuation.|
|split-inifinitive|The phrase '\{phrase\}' is written using a split-infinitive in the following text:|The indicated sentence includes a split-infinitive, which is considered poor grammatical style - consider rephrasing the sentence. |
|where-not-were|The word 'were' has been used to start a subordinate clause in the following text:|The indicated sentence does not make sense. Rewrite the phrase using the correct grammar.|

Contribute
==========

PRs accepted.

License
=======

[Apache 2.0](LICENSE) © 2018 HERE Europe B.V.

See the [LICENSE](LICENSE) file in the root of this project for license details.