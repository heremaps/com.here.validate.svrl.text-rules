

Spelling and Grammar Checker Plug-in for DITA-OT
================================================

Copyright (c) 2016 HERE Europe B.V.

See the [LICENSE](LICENSE) file in the root of this project for license details.

Introduction
------------

The Spelling and Grammar Checker plug-in for DITA OT  is an  **extension**  of the base [DITA Validator](https://github.com/heremaps/com.here.validate.svrl) which adds simple rule-based **spelling and grammar** validation for the text elements within DITA documents.

The plug-in supports three `transtypes`:

 - `auto-correct` - remove reported spelling and grammar errors from  a DITA document
 - `text-rules`  - create an error report in **Schematron Validation Report Language** (`SVRL`) format
 - `text-rules-echo` - display the results of an `SVRL` error report in a human-readable format

More information about `SVRL` can be found at [www.schematron.com](http://www.schematron.com/validators.html)

Most of the spell-checking rules are based on a list of [known typographical errors and faults](https://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings), and the ruleset can be easily altered to include new constraints. Checking against a list of known errors means that no false positives should occur, but the existing list will never be fully comprehensive.



Prerequisites
-------------

### Requirements

The  DITA spell-checker has been tested against [DITA-OT 2.2.x](http://www.dita-ot.org/download). It is recommended that you upgrade to the latest version. Running the `spell-checker` plug-in against earlier versions of DITA-OT will not work as it uses the newer `getVariable` template. To work with DITA-OT 1.8.5 this would need to be refactored to use `getMessage`.

### Installing DITA-OT

The spell-checker is a plug-in for the DITA open toolkit. Futhermore, it is not a stand alone plug-in as it extends the **base validator plug-in** ([`com.here.validate.svrl`](https://github.com/heremaps/com.here.validate.svrl)).

-  install the DITA-OT distribution JAR file dependencies by running `gradle install` from your clone of the [DITA-OT repository](https://github.com/dita-ot/dita-ot).

The required dependencies are installed to a local Maven repository in your home directory under `.m2/repository/org/dita-ot/dost/`.

-  Run the Gradle distribution task to generate the plug-in distribution package:

  ```bash
./gradlew dist
  ```

The distribution ZIP file is generated under `build/distributions`.

### Installing the Base Plug-in

-  Run the plug-in installation command:

  ```bash
dita -install https://github.com/heremaps/com.here.validate.svrl/archive/v1.0.0.zip
  ```

### Installing the Spelling and Grammar Checker Plug-in

-  Run the plug-in installation command:

  ```bash
dita -install https://github.com/heremaps/com.here.validate.svrl.text-rules/archive/v1.0.0.zip
  ```

> The `dita` command line tool requires no additional configuration.

Usage
-----


### Spell-checking a document from the command line

A test document can be found within the plug-in at: `PATH_TO_DITA_OT/plugins/com.here.validate.svrl.text-rules/sample`

#### Creating an SVRL file

To create an SVRL file with the spell-checker plug-in use the `text-rules` transform.

-  From a terminal prompt move to the directory holding the document to validate

-  Clean the output directory (named "`out`" in the examples below), to ensure that the result from an old validation run is not present.

  ```bash
rm -rf ./out
  ```

-  SVRL file creation can be run like any other DITA-OT transform:

  ```bash
PATH_TO_DITA_OT/bin/dita -f text-rules -o out -i document.ditamap
  ```

Once the command has run, an `SVRL` file is created:

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<svrl:schematron-output>
<active-pattern xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                   name="grammar-and-spelling"
                   role="content">
      <fired-rule context="p"/>
      <fired-rule context="p"/>
      <fired-rule context="p"/>
      <failed-assert location="/incorrect-spelling.dita" role="error">
         <diagnostic-reference diagnostic="incorrect-spelling">Line 17: p - [incorrect-grammar]
The phrase 'separate' is written incorrectly ('seperate') in the following text:
Seperate accommodation can be found within the main building..</diagnostic-reference>
      </failed-assert>
		</active-pattern>
</svrl:schematron-output>
```

#### Echoing results to the command line

To echo results to the command line with the spell-checker plug-in use the `text-rules-echo` transform.

-  Clean the output directory (named "`out`" in the examples below), to ensure that the result from an old text-rules run is not present.

  ```bash
rm -rf ./out
  ```

-  Spell-checking (`text-rules-echo`) can be run like any other DITA-OT transform:

  ```bash
PATH_TO_DITA_OT/bin/dita -f text-rules-echo -i document.ditamap
  ```

Once the command has run, all errors and warnings are echoed to the command line:

```bash
[echo] [ERROR]  [/topics/incorrect-spelling.dita]
[echo]   Line 17: p - [incorrect-spelling]
[echo] The word 'separate' is spelt incorrectly ('seperate') in the following text:
[echo]
[echo] Seperate accommodation can be found within the main building.
```
Additionally, if an error occurs, the command will fail

```bash
[echo] [ERROR]  [/topics/incorrect-spelling.dita]
[echo]   Line 17: p - [incorrect-spelling]
[echo] The word 'separate' is spelt incorrectly ('seperate') in the following text:
[echo]
[echo] Seperate accommodation can be found within the main building.
[echo] Found 1 Errors 0 Warnings
Error: Errors detected during validation
```

### Auto-correction from the command line

To auto-correct spelling mistakes with the spell-checker plug-in use the `auto-correct` transform.

-  Clean the output directory (named "`out`" in the examples below), to ensure that the result from an old run is not present.

  ```bash
rm -rf ./out
  ```

-  Auto-correction (`auto-correct`) can be run like any other DITA-OT transform:

  ```bash
PATH_TO_DITA_OT/bin/dita -f auto-correct -i document.ditamap
  ```

Once the command has run spelling mistakes will have been removed from the document.

> *Note:* The auto-correct `transtype` only removes spelling, duplicate and grammar errors specified in the dictionary files


###	Spell-checking a document from the using `ant`


An ant build file is supplied in the same directory as the sample document. The main target can be seen below:

```xml
<!-- The path to dita-ot, correct as necesary  -->
<dirname property="dita.dir" file="path-to-dita-ot"/>
<!--the path to the DITA document to build, change as necessary -->
<property name="args.input" value="path-to-doc/document.ditamap"/>
<!-- Minimal classpath to invoke DITA OT via ANT. -->
<path id="dita.ot.classpath">
	... etc..
</path>
<target name="validate">
	<java classname="org.apache.tools.ant.launch.Launcher" fork="true" failonerror="true" classpathref="dita.ot.classpath">
		<arg value="-Dargs.input=${args.input}"/>
		<arg value="-Ddita.dir=${dita.dir}"/>
		<arg value="-buildfile"/>
		<arg value="${dita.dir}/build.xml"/>
		<arg value="-Dgenerate-debug-attributes=false"/>
		<arg value="-Doutput.dir=out/svrl"/>
		<arg value="-Dtranstype=text-rules-echo"/>
		<!-- validation transform specific parameters -->
		<arg value="-Dargs.validate.blacklist=(kilo)?metre|colour|teh|seperate"/>
		<arg value="-Dargs.validate.check.case=Bluetooth|HTTP[S]? |ID|IoT|JSON|Java|Javadoc|JavaScript|XML"/>
		<arg value="-Dargs.validate.mode=default" />
		<!-- Run the transform quietly to avoid verbose output. -->
		<arg value="-S"/>
		<arg value="-q"/>
	</java>
</target>
```


### Parameter Reference


- `args.validate.ignore.rules` - Comma separated list of rule IDs to be ignored
- `args.validate.blacklist` - Comma separated list of words that should not be present in the running text
- `args.validate.check.case` - Comma separated list of words which have a specified capitalization
- `args.validate.mode` - Validation reporting mode. The following values are supported:
	- `strict`	- Outputs both warnings and errors. Fails on errors and warnings.
	- `default` - Outputs both warnings and errors. Fails on errors only
	- `lax`		- Ignores all warnings and outputs errors only. Fails on Errors only
- `svrl.customization.dir` - Specifies the customization directory
- `svrl.filter.file` - Specifies the location of the XSL file used to filter the echo output


Configuring the plug-in
-----------------------

### Internationalization

The spelling and grammar checker currently supports three languages:

* `en` - English
* `de` - German
* `fr` - French

The language checked is based on the `default.language` setting of the DITA Open toolkit. This can be modified in the `lib/configuration.properties` file.

> Please note that error messages have **not** been internationalized into French and currently all error messages will be displayed in English.

Sample lists of duplicated and mis-spelt words are available in all three languages.
Grammar and punctuation lists have only been supplied for `en`.

Additional languages can be added by creating a new language folder and files under `cfg/dictionary`


### Adding new mis-spellings to the plug-in

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


### Altering the severity of a validator rule

The severity of a validator rule can be altered by amending entries in the `cfg/ruleset/default.xml`  file The plug-in supports four severity levels:

* **FATAL** - Fatal rules will fail validation and cannot be overridden.
* **ERROR** - Error rules will fail validation. Errors can be overridden as described above.
* **WARNING** - Warning rules will display a warning on validation, but do not fail the validation. Warnings can also be individually overridden.
* **INACTIVE** - Inactive rules are not applied.


### Ignoring validator Rules

#### Removing a rule globally

Rules can be made inactive by altering the severity (see above).  Alternatively a rule can be commented out in the XSL configuration file.

#### Ignoring a rule throughout a document

Individual rules can be ignored by passing the `args.validate.ignore.rules` parameter to the command line. The value of the parameter should be a comma-delimited list of each `rule-id` to ignore.

For example to ignore the `latin-abbreviation` validation rule within a document you would run:

```bash
PATH_TO_DITA_OT/dita -f text-rules-echo -i document.ditamap -Dargs.validate.ignore.rules=latin-abbreviation
```


#### Ignoring a specific instance of a rule

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


Sample Document
---------------

A sample document can be found within the plug-in which can used to test plug-in rules. The document covers both positive and negative test cases. The sample document contains valid DITA which can be built as an HTML or as a PDF document - please use the `html` or `pdf` transform to read the contents or examine the `*.dita` files directly.

A complete list of rules covered by the plug-in can be found below. The final `<chapters>` of the sample document contain a set of test DITA `<topics>`, each demonstrating a broken validation rule.

The `<topic>` files are sorted as follows:

- The base validation DITA-OT plugin (`com.here.validate.svrl`) -  this  `<chapter>` contains two common textual validation rules.
- The text-rules DITA-OT plugin (`com.here.validate.svrl.text-rules`) - This  `<chapter>` contains a set of English language spelling and grammar rules.


Spell-checker Error Messages
----------------------------

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
