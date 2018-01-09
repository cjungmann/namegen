# Project namegen

## Introduction

This project is as much as a demonstration of techniques as it is a utility
on its own.  It shows how to scrape data from websites, and how to use
XSL to generate a names list.  XSL is not the most efficient way to do this,
but I think the strategies I employ to use XSL might inspire other projects.

It collects its own data by scraping lists of names from name surveys on the
internet and combines them into an inventory of names grouped into surnames,
girls' names and boys' names, each name element including the frequency of usage.

Using the names inventory, the **namegen** program will generate an XML
document with a list of people records, whose attributes consist of **gender**,
**fname** and **lname**.  Names will be chosen in preference according to the
frequency they occur in the surveys, and genders will be assigned 50/50.

## Outside References

This project uses another program from my repository,
[scrape](https://github.com/cjungmann/scrape), which scrapes data from
websites into XML files.  A copy or link to the **scrape** application is
needed for this application to build the names inventory.

## Files in Project

### Scripts:

- **getpage** Python program that retrieves an HTML page at a URL and cleans up
  the potentially messy HTML to valid XML.
- [scrape](https://github.com/cjungmann/scrape) Python program that uses stylesheets
  (see below) to separate the data from the rest of the cleaned-up HTML
- **builddoc** is a BASH script that uses **getpage** and **scrape** several times
  to consolidate all the data into a single document **temp_names.xml**, then uses
  **xsltproc** (a system program) to transform that document to our final
  **pop_names.xml** names inventory.
- **namegen** is a Python script that generates a list of names in a two-step
  process
  - The first step reads the **pop_names.xml" inventory to determine the population
    represented by each name group and uses that information to generate a temporary
    XML file containing a set of person elements, each consisting of a gender and two
    integer values that are indexes into first name and last name weighted inventories.
  - The second step uses a stylesheet, **ss_recon_indexes.xsl** to convert the
    name indexes into actual names.

### Stylesheets

These files convert one form of XML to another.  Preparing the **pop_names.xml**
file requires several conversion steps.

- **ss_geneanet.xsl** extracts last name data from [Geneanet](http://en.geneanet.org).
- **ss_avss.xsl** extracts first name data from [AVSS at UCSB](http://www.avss.ucsb.edu/NameGB.HTM)
- **ss_make_pop_names.xsl** pre-calculates several values to speed the selection of
  names from the inventory.
- **ss_recon_indexes.xsl** transforms person records with integer indexes into 
  completed person records with actual names.

## Follow-up

The reason this project exists is to generate an import file of names to test
a database.  My [pxml2ods](https://github.com/cjungmann/pxml2ods) will take the
output from **ss_recon_indexes.xsl** and create a spreadsheet file with the names.
If you look at **ss_recon_indexes.xsl**, you will find a simple **schema** element
that is used by **pxml2ods** to generate the spreadsheet.

## This is Only an Example

This project is an example of how to use scraped information to generate documents.

Look at **builddoc** for ideas about how to use other sources of data to generate
a different kind of document.  Each website will need its own stylesheet to extract
its unique data.

The **scrape** and **getpage** utilities called by **builddoc** can be used for many
extractions using customized stylesheets.

