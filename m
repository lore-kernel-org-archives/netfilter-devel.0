From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 29/29] change man page to describe all new features
Date: Wed, 10 Jul 2013 19:25:27 +0100
Message-ID: <1373480727-11254-30-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:62178 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3GJS1B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:27:01 -0400
Received: by mail-lb0-f175.google.com with SMTP id r10so5996827lbi.34
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:59 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* completely redesign the existing man page to describe in great details all
new features added in this patch set

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 nfacct.8 | 551 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 530 insertions(+), 21 deletions(-)

diff --git a/nfacct.8 b/nfacct.8
index 0c3249c..86b4953 100644
--- a/nfacct.8
+++ b/nfacct.8
@@ -1,59 +1,568 @@
-.TH NFACCT 8 "Dec 30, 2011" "" ""
+.TH NFACCT 8 "02 June 2013" "" ""
 
 .\" Man page written by Pablo Neira Ayuso <pablo@netfilter.org> (Dec 2011)
 
 .SH NAME
-nfacct \- command line tool to create/retrieve/delete accounting objects
+nfacct \- command line tool to create/retrieve/delete and manipulate
+accounting objects.
 .SH SYNOPSIS
-.BR "nfacct command [name] [options]"
+.BR "nfacct list [reset|setmark|clrmark] [show {bytes|marks|extended}] [format FORMAT] [sort SORT] [xml]"
+
+.BR "nfacct add name [replace] [format FORMAT] [threshold [NUMBER|'\-']]"
+
+.BR "nfacct get name [reset|setmark|clrmark] [show {bytes|marks|extended}] [format FORMAT] [xml]"
+
+.BR "nfacct flush"
+
+.BR "nfacct save"
+
+.BR "nfacct restore [flush] [replace]"
+
+.BR "nfacct version"
+
+.BR "nfacct help"
+
 .SH DESCRIPTION
 .B nfacct
-is the command line tool that allows to manipulate the Netfilter's extended
+is the command line tool that allows manipulation of Netfilter's extended
 accounting infrastructure.
 .SH COMMANDS
-These commands specify the action that nfacct performs. Only one of them can be
-specified at any given time.
+These commands specify the action that nfacct performs. Only one of them can
+be specified at any given time. The following commands can be used:
 .TP
 .BI "list "
-List the existing accounting object in table.
+List the existing accounting objects in the accounting table. Depending on
+the \fBshow\fR parameter used (see \fBlist command parameters\fR below),
+this command could list up to 8 different properties for each accounting
+object:
+.RS 8
 .TP
-.BI "restore "
-Restore accounting object table by reading from stdin. Input format is the one used
-as output by the list command.
+.BI "pkts "
+Current number of packets counted by this accounting object. This number can
+be formatted independently for each accounting object (see \fBFORMAT
+OPTIONS\fR section below).
+.TP
+.BI "mark exceeded indicator "
+This is only applicable if mark has been set against this accounting object
+(see \fBMARKING\fR section below). If any traffic has
+passed through since that mark was last set, then a plus sign (\fB+\fR) is
+shown at the end of the \fBpkts\fR column.
+.TP
+.BI "pmark "
+This shows the number of packets which passed through this accounting object
+since the last time a mark was set. The format used to display this property
+is the same as the \fBpkts\fR format. If no marking has been enabled for
+this accounting object, then a dash (\fB\-\fR) is shown.
+.TP
+.BI "bytes "
+Number of bytes counted by this accounting object. Again, this number can be
+formatted independently for each accounting object.
+.TP
+.BI "bytes threshold exceeded indicator "
+This is only applicable if the bytes threshold is enabled and set. If this
+threshold has been exceeded (in other words, the number of bytes counted is
+greater than the \fBbytes threshold\fR), then a plus sign (\fB+\fR) is shown
+at the end of the bytes column for each accounting object. If either the
+bytes threshold is disabled or the current bytes counter is less than the
+bytes threshold value, then nothing is shown.
+.TP
+.BI "bmark "
+This shows the number of bytes which passed through this accounting object
+since the last time a mark was set. The format used to display this property
+is the same as the \fBbytes\fR format. If no marking has been enabled for
+this accounting object, then a dash (\fB\-\fR) is shown.
+.TP
+.BI "bytes threshold "
+Number of bytes which are expected to pass through this accounting object.
+If this threshold is exceeded, the \fBbytes threshold exceeded indicator\fR
+is triggered. If the value of this property is shown as a dash (\fB\-\fR),
+then this feature is disabled. The format used to display this property is
+the same as the \fBbytes\fR format.
+.TP
+.BI "name "
+Name of the accounting object.
+.RE
 .TP
 .BI "add "
-Add new accounting object.
+Adds new or changes the properties of existing accounting object in the
+accounting table.
 .TP
 .BI "delete "
-Delete accounting object.
+Delete existing accounting object from the accounting table.
 .TP
 .BI "get "
-Get existing accounting object.
+Get and display information about existing accounting object. The
+properties shown are the same as the \fBlist\fR command above. This command
+allows for some of the account object properties to be changed (see
+\fBget command parameters\fR below).
 .TP
 .BI "flush "
-Delete all unused accounting objects.
+Flush the entire accounting table, provided the accounting objects
+are not in use by iptables (if that is so, these accounting objects
+are not deleted).
+.TP
+.BI "save "
+Dump the entire accounting object table to \fIstdout\fR using format
+appropriate for use by the \fBrestore\fR command. The output of
+packet, byte and all other counters, if applicable, is not formatted. For
+more information on the format used, see \fBRESTORE FORMAT\fR
+section below.
+.TP
+.BI "restore "
+Restore accounting object table by reading from \fIstdin\fR. Input
+format is the one used as output by the \fBsave\fR command.
 .TP
 .BI "version "
-Displays the version information.
+Displays version information.
 .TP
 .BI "help "
-Displays the help message.
-.SH OPTIONS
+Displays help message.
+.SH PARAMETERS
+This tool also allows for a set of parameters to be specified,
+depending on the command used. They are as follows:
+.TP
+.BI "list command parameters "
+All parameters for the \fBlist\fR command shown below are optional.
+These are:
+.RS 8
+.TP
+.BI "reset "
+Resets the byte and packet counters on all accounting objects
+in the accounting table. Please note that this also resets the marks of the
+accounting objects, when applicable.
 .TP
-This tool also allows a couple of options with the get and list commands that are:
+.BI "setmark "
+Sets new or updates existing marks on all registered accounting objects in
+the accounting table. For more information on marking, see
+\fBMARKING\fR section below.
+.TP
+.BI "clrmark "
+Clears existing marks and disables marking on all registered accounting
+objects in the accounting table.
+.TP
+.BI "show "
+Specify what to display. Valid options are: \fIbytes\fR \- to display only
+the name and bytes counter for each accounting object; \fImarks\fR \- to
+display only the name, packet and byte counters since the last mark was set
+for each accounting object; \fIextended\fR \- to show all properties of the
+accounting objects: name, packet, byte and threshold counters, packet and
+byte counters since the last mark was set, if applicable, mark exceeded
+and threshold exceeded indicators. If this parameter is omitted, then name,
+packet and byte counters, as well as mark exceeded and bytes threshold
+exceeded indicators are shown.
+.TP
+.BI "format "
+Specify the format to use to display \fIall\fR accounting objects (that
+option takes precedence over the formatting registered for each
+accounting object when it was added). For more information on format
+options see \fBFORMAT OPTIONS\fR section below.
+.TP
+.BI "sort "
+Specify how to sort the accounting objects. Valid options are:
+\fIname\fR (default) \- to sort by nfacct name; \fIpackets\fR \- to sort by
+number of packets received; \fIpmark\fR \- to sort by number of packets
+received since last mark was set; \fIbytes\fR \- to sort by number of bytes
+received; \fIbmark\fR \- to sort by number of bytes received since last mark
+was set; \fIthreshold\fR \- to sort by bytes threshold value; or specify
+\fInone\fR for not sorting any accounting objects. Please note that all
+sorting is done in ascending order (low-high).
+.TP
+.BI "xml "
+Generate all output in xml format. Special xml characters are properly
+escaped to conform to the xml specification. Please note that \fBNO\fR
+number formatting of any kind is applied to the values of the various
+counters for each accounting object - they are shown "as\-is", while the
+formatting properties are shown as xml element attributes, allowing external
+aplication to format these numbers accordningly. All other indicators, like
+\fBmark exceeded indicator\fR, as well as
+\fBbytes threshold exceeded indicator\fR are also shown as xml element
+attributes.
+.RE
+.TP
+.BI "add command parameters "
+All parameters for the \fBadd\fR command shown below with the exception of
+\fIname\fR are optional. These are:
+.RS 8
+.TP
+.BI "name "
+Name of the accounting object to add or replace in the accounting table.
+This should be between 1 and 31 characters long (if it is longer than 31
+characters, it is automatically truncated). This parameter is mandatory.
+.TP
+.BI "replace "
+If specified, it replaces the accounting object if it already exists. If
+this parametter is omitted and the accounting object already exists in
+the accounting table, then an error is returned.
+.TP
+.BI "format "
+Set the format to use to display packets, bytes and bytes threshold
+numbers for this accounting object with the \fBget\fR and \fBlist\fR
+commands. For more information on format options see
+\fBFORMAT OPTIONS\fR section below.
+.TP
+.BI "threshold "
+Set the bytes threshold for this accounting object. If this threshold is
+exceeded, then the bytes threshold exceeded indicator is triggered.
+The number specified must be in bytes, regardless of the format used to
+display the bytes counter. If dash (\fB\-\fR) is specified (the default),
+then the bytes threshold feature is disabled (this could later be enabled
+with \fBadd replace\fR).
+.RE
+.TP
+.BI "get command parameters "
+All parameters for the \fBget\fR command shown below with the exception of
+\fIname\fR are optional. These are:
+.RS 8
+.TP
+.BI "name "
+Name of the accounting object to get and display information of.
+This paramenter is mandatory.
 .TP
 .BI "reset "
-That atomically obtains and resets the counters.
+Resets the byte and packet counters on this accounting objects in the
+accounting table. The byte and packet counters shown will be
+\fIbefore\fR they were reset. Please note that this does \fInot\fR
+reset the byte threshold value of the accounting object, if enabled \-
+this needs to be done with the \fBadd\fR command (using \fIreplace\fR
+parameter). Mark counters, if enabled for this accounting object are
+also reset.
+.TP
+.BI "setmark "
+Sets new or updates existing mark on this accounting object. For more
+information on marking, see \fBMARKING\fR section
+below.
+.TP
+.BI "clrmark "
+Clears any existing mark and disables marking on this accounting object.
+.TP
+.BI "show "
+Specify what properties of the accounting object to display. Valid
+options are: \fIbytes\fR \- to display only the name and bytes counter
+for this accounting object; \fImarks\fR \- to display only the name, packet
+and byte counters since the last mark was set for this accounting object;
+\fIextended\fR \- to show all properties of this accounting object: name,
+packet, byte and threshold counters, packet and byte counters since the
+last mark was set, if applicable, mark exceeded and threshold exceeded
+indicators. If this parameter is omitted, then name, packet and byte counters,
+as well as mark exceeded and bytes threshold exceeded indicators are shown.
+.TP
+.BI "format "
+Specify the format to use to display this accounting object (that option
+takes precedence over the formatting registered when the specified
+accounting object was added). For more information on format options see
+\fBFORMAT OPTIONS\fR section below.
 .TP
 .BI "xml "
-That displays the output in XML format.
+Generate all output in xml format. Special xml characters are properly
+escaped to conform to the xml specification.  Please note that \fBNO\fR
+number formatting of any kind is applied to the values of the various
+counters for each accounting object - they are shown "as\-is", while
+the formatting properties are shown as xml element attributes, allowing
+external aplication to format these numbers accordningly. All other
+indicators, like \fBmark exceeded indicator\fR, as well as
+\fBbytes threshold exceeded indicator\fR are also shown as xml element
+attributes.
+.RE
+.TP
+.BI "restore command parameters "
+All parameters for the \fBrestore\fR command are optional. These are:
+.RS 8
+.TP
+.BI "flush "
+If specified, it flushes the entire accounting table prior to restoring
+the accounting objects. If this option is omitted, then no flush is
+performed and the accounting objects are simply added to the accounting
+table if they don't already exist.
+.TP
+.BI "replace "
+If specified, it replaces the properties of existing accounting objects
+even if they are used in iptables. If this option is \fInot\fR specified
+and that accounting object is used in iptables, then the properties of
+that object are \fInot\fR updated!
+.RE
+.TP
+.BI " "
+\fBPLEASE NOTE:\fR  In order to restore the \fBentire\fR accounting table
+to the state it was in when the save command was executed, even if the
+accounting objects are currently \fBin use by iptables\fR, both
+\fIreplace\fR and \fIflush\fR parameters need to be specified. For more
+information on the restore format, see \fBRESTORE FORMAT\fR section below.
+.SH FORMAT OPTIONS
+This tool allows for a specific number formatting to be specified
+independently for each accounting object when it is added to the
+accounting table. These format options consist of two separate parts:
+\fIpackets\fR count number formatting, which also includes the packets
+count since mark was last applied, if applicable, and \fIbytes\fR count
+number formatting, which includes bytes count since mark was last applied,
+as well as bytes threshold, if applicable.
+.TP
+Currently, the following types of number formatting are available:
+.TP
+.BI "def "
+Default: default formatting to use. This is the format applied if no
+formatting option is specified. Numbers are formatted so that they
+always occupy 20 characters and have leading zeroes, e.g.
+123 is shown as 00000000000000000123.
+.TP
+.BI "raw "
+Raw: no formatting of any kind is applied. The number is shown 'as-is',
+without any leading or trailing zeroes or with any format applied to it,
+e.g. 123 is shown as 123.
+.TP
+.BI "3pl "
+Triplets: number is formatted in \fItriplets\fR so that each 3 digits are
+separated with the \fIthousand separator\fR registered with the current
+locale in the system, e.g. 1234567 is shown as 1,234,567 (assuming that ','
+is the current locale thousand separator symbol \- see notes below).
+.TP
+.BI "iec "
+IEC: apply the \fBIEC standard\fR for number formatting, depending on the
+current value, with 3 decimal places. e.g 8305798 is shown as 7.921MiB,
+while 2106468480 is shown as 1.962GiB (again, assuming the ',' and '.' are
+the current locale thousand separator and decimal symbols \- see notes
+below).
+.TP
+.BI "kib, mib, gib, tib, pib and eib "
+IEC KiB, MiB, GiB, TiB, PiB and EiB number format specifications: apply the
+specific IEC number formatting (kibibyte, mibibyte and so on) regardless of
+the current value, with 3 decimal places, e.g. assuming we would like to
+use the \fImib\fR format (in other words, lock the number output to appear
+in IEC mibibytes), then 8305798 is shown as 7.921MiB, while 2106468480 is
+shown as 2,008.885MiB.
+.TP
+.BI "si "
+SI: apply the (old) SI standard for number formatting, depending on the
+current value, with 3 decimal places, e.g. 8305798 is shown as 8.306MB,
+while 2106468480 is shown as 2.106GB.
+.TP
+.BI "kb, mb, gb, tb, pb and eb "
+SI KB, MB, GB, TB, PB and EB number format specifications: apply the
+specific SI number formatting (kilobyte, megabyte and so on) regardless
+of the current value, with 3 decimal places, e.g. assuming we would like
+to use the \fImb\fR format (in other words, lock the number output to
+appear in SI megabytes), then 8305798 is shown as 8.306MB, while
+2106468480 is shown as 2,106.469MB.
+.RE
+.TP
+.BI "PLEASE NOTE: "
+With the exception of the default (\fIdef\fR) and raw (\fIraw\fR)
+formatting options, all other formatting options are \fBlocale-specific\fR
+as they are dependent on the \fIdecimal sign\fR and
+\fIthousand separator\fR symbols set by the operating system. If the current
+locale on the machine where nfacct is executed cannot be determined,
+then \fBen_GB\fR locale is used.
+.TP
+.BI " "
+Also, if a particular formatting option is not specified, then the default
+(\fIdef\fR) format is applied as described above.
+.TP
+.BI " "
+For example: when '\fB,mib\fR' formatting option is specified, this is the
+equivalent of '\fBdef,mib\fR' (in other words, use \fIdef\fR for packets
+counter number formatting and \fImib\fR for bytes counter number
+formatting).
+.TP
+.BI " "
+Similarly when '\fB3pl,\fR' is specified, this is the equivalent
+of '\fB3pl,def\fR' (use \fI3pl\fR for packets counter number
+formatting and \fIdef\fR for bytes counter number formatting) and '\fB,\fR'
+is the equivalent of '\fBdef,def\fR', which is also the formatting used
+if \fIno\fR formatting options of any kind are specified.
+.TP
+.BI " "
+Finally, if just one formatting option is specified, then that option is
+applied to \fIboth\fR packet and byte numbers. In other words, when
+just '\fBraw\fR' is specified, this is the equivalent to '\fBraw,raw\fR'
+format option.
+.TP
+Examples:
+.TP
+.BI " "
+To \fIadd\fR accounting object called '\fBinward\fR' and use '\fB3pl\fR'
+for packet formatting and '\fBiec\fR' for bytes formatting, as well as set
+the threshold value to \fB1GiB\fR, execute the following command:
+.RS 8
+.TP
+.BI " "
+.BI "nfacct add inward format 3pl,iec threshold 1073741824 "
+.RE
+.TP
+.BI " "
+To \fIchange\fR the formatting properties of
+existing accounting object named '\fBnet 27\fR' with '\fB3pl,tib\fR' and
+disable the bytes threshold, execute the following command:
+.RS 8
+.TP
+.BI " "
+.BI "nfacct add replace 'net 27' format 3pl,tib threshold - "
+.RE
+.TP
+.BI " "
+To \fIlist\fR all accounting objects in the accounting table, display
+all their properties and generate all output in \fBxml\fR format, execute
+the following command:
+.RS 8
+.TP
+.BI " "
+.BI "nfacct list show extended xml "
+.RE
+.TP
+.BI " "
+To \fIsave\fR and then \fIrestore\fR all existing accounting objects in
+the accounting table, \fBreplacing\fR their properties even if used by
+iptables, and \fBflush\fR the entire accounting table prior to restore,
+execute the following command:
+.RS 8
+.TP
+.BI " "
+.BI "nfacct save | nfacct restore flush replace "
+.RE
+.SH RESTORE FORMAT
+The entire restore format consists of \fBname=value\fR pairs, describing
+accounting object properties to be restored. With the exception of
+\fBname\fR, all properties are optional, however, most depend on either
+the value of mark or byte threshold indicators. Comments are allowed \- each
+line needs to start with the hash symbol (\fB#\fR) in first position. Blank
+lines are also ignored. Although the position in which each property is
+specified is not important, it could only be specified once - multiple
+definitions of the same accounting object properties are not allowed.
+.TP
+.BI " "
+.RE
+The execution of the restore file is atomic - each line is read,
+various accounting properties are verified, and then the accounting
+object is added or replaced immediately (the entire accounting table is
+flushed prior to that operation if \fIflush\fR command parameter is used).
+In the event of an error midway through the contents of the restore file,
+the executuion stops and all accounting objects restored up to that point are
+\fBnot\fR deleted.
+.TP
+.BI " "
+.RE
+The following properties are allowed in the restore file: 
+.TP
+.BI "name "
+Name of the accounting object. The value may be quoted, if space (' ') or
+other "special" characters appear in the account object name. This property
+is \fImandatory\fR.
+.TP
+.BI "fmt "
+Format of the accounting object as described in the \fBFORMAT OPTIONS\fR
+section above.
+.TP
+.BI "pkts "
+Packets received counter. If this property is specified, then \fBbytes\fR
+(see below) also needs to be included. This property is also mandatory in
+case marking is used (see \fBMARKING\fR section below).
+.TP
+.BI "bytes "
+Bytes received counter. If this property is specified, then \fBpkts\fR
+(see above) also needs to be included. This property is also mandatory in
+case marking is used (see \fBMARKING\fR section below) or if byte threshold
+is also enabled (see \fBthr\fR below).
+.TP
+.BI "pmark "
+Packets received counter since the last time a mark was set/enabled for this
+accounting object. If this property is specified, then \fBbmark\fR
+(see below), as well as \fBpkts\fR and \fBbytes\fR properties must also be
+included. The value of this property should not exceed the value of
+\fBpkts\fR.
+.TP
+.BI "bmark "
+Bytes received counter since the last time a mark was set/enabled for this
+accounting object. Mandatory if \fBpmark\fR is also specified. The value of
+this property should not exceed the value of \fBbytes\fR.
+.TP
+.BI "thr "
+Bytes threshold limit. If set, \fBbytes\fR also needs to specified.
+.TP
+Examples:
+.TP
+.BI " "
+The following line restores an accounting object 
+named '\fBALL dns\-internal\fR' using \fB3pl\fR format for packet counters and
+\fBiec\fR for byte counters, setting their values to \fB1451\fR and
+\fB249437\fR respectively and also enabling the byte threshold feature,
+setting it at \fB1MiB\fR:
+.RS 8
+.TP
+.BI " "
+.BI "name='ALL dns\-internal' fmt=3pl,iec pkts=1451 bytes=249437 thr=1048576"
+.RE
+.TP
+.BI " "
+The following line restores an accounting object named \fBweb\fR using
+\fB3pl\fR format for packet counters and \fBsi\fR for byte counters, setting
+their values to \fB1058481\fR and \fB1432810595\fR respectively and also
+enabling the byte threshold and marking features, setting byte threshold to
+\fB1.5GiB\fR, while enabling the packet and byte marks to start from
+\fB148965\fR and \fB136198528\fR respectively:
+.RS 8
+.TP
+.BI " "
+.BI "name=web fmt=3pl,si pkts=1058481 bytes=1432810595 pmark=148965 bmark=136198528 thr=1572864000"
+.RE
+.SH MARKING
+This tool has one additional feature for short-term traffic accounting,
+which allows a "mark" to be placed against an accounting object, enabling
+it to count traffic (both bytes and packets) since that mark has been
+enabled/set. This is in addition to the main packet and byte counters and
+enables for a short-term traffic to be analysed. Such marks could be placed
+as soon as accounting object is created and can be set, reset or deleted for
+each object independently.
+.TP
+.BI " "
+.RE
+The \fBlist\fR command allows for marks to be set/cleared for all registered
+accounting objects, while the \fBget\fR command allows this to be done for a
+specific accounting object. These two commands also allow for only the
+mark-related properties of a given accounting object (or objects) to be
+shown, using the \fBshow marks\fR parameter.
+.TP
+.BI " "
+.RE
+Once a mark has been set, traffic is counted as normal, though 3 additional
+properties are made available, in addition to the main packet and byte
+counters:
+.TP
+.BI "mark exceeded indicator "
+This property gives an indication whether \fIany\fR traffic has passed
+through the accounting object since a mark was last set. This is shown in
+the form of a plus sign (\fB+\fR) displayed next to the \fBpkts\fR counters.
+.TP
+.BI "packet mark count "
+This shows how many packets have passed through this accounting object since
+the mark was last set. The format of this property is the same as \fBpkts\fR.
+.TP
+.BI "bytes mark count "
+This shows how many bytes have passed through this accounting object since
+the mark was last set. The format of this property is the same as
+\fBbytes\fR.
+.TP
+.BI " "
+.RE
+Once placed, if a mark is then replaced, then the above properties start
+counting traffic from the last mark being set - that is, the "old" mark
+is deleted (and with it the mark packet and byte counters) and the new
+one is set, starting to count traffic from zero.
+.TP
+.BI " "
+.RE
+It is also worth noting that although mark packet and byte counters can
+be set or reset independently of the main counters, their value is dependent
+on them. In other words, if the main packet and byte counters are reset
+via the \fBlist reset\fR or \fBget reset\fR commands, or the account
+object is deleted, the mark associated with it is also reset or deleted.
 .PP
 .SH SEE ALSO
 .BR iptables (8)
 .SH BUGS
+.BI " "
+.PP
 Please, report them to netfilter-devel@vger.kernel.org or file a bug in
 Netfilter's bugzilla (https://bugzilla.netfilter.org).
 .SH AUTHORS
 Pablo Neira Ayuso wrote and maintains the nfacct tool.
 .PP
-Man page written by Pablo Neira Ayuso <pablo@netfilter.org>.
+Man page written by Pablo Neira Ayuso <pablo@netfilter.org> and later
+ammended by Michael Zintakis <michael.zintakis@googlemail.com>.
-- 
1.8.3.1

