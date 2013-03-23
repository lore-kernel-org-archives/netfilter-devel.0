From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH 3/3 nfacct] user space executable changes and additions
Date: Sat, 23 Mar 2013 12:18:14 +0000
Message-ID: <514D9D86.9040909@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:52904 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CWMSh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:18:37 -0400
Received: by mail-la0-f48.google.com with SMTP id fq13so8700507lab.7
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2013 05:18:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the last patch of a series of 3 patches dealing with changes and
improvements to the nfacct executable as follows:

* nfacct.c almost completely rewritten

* the existing programming and parsing of command-line options has been
  scrapped in favour of a new and more efficient way of dealing with these
  (the existing implementaion contained bugs too). Command line options
  can now be partially matched. The functionality is similar to the one
  used in other netfilter tools, like 'ip'.

* the 'list' command has been enhanced to include 2 new options:
  - 'show': showing either only the bytes and name columns of each
    accounting object (when 'show bytes' is specified) or showing every
    accounting object property ('show extended');
  - 'format': to list all accounting objects in the format specified at
    the command line, regardless of what formatting option has been used to
    add each accounting object. In other words, the purpose of this option
    is to override the format of the accounting objects, if so desired.

* a new feature of the 'list' command has been added and this is the display
  of 'bytes threshold exceeded indicator'. When a bytes threshold is
  registered for accounting object and is later exceeded (in other words,
  the 'bytes' count becomes larger than the 'bytes threshold' count), then
  the 'bytes threshold exceeded indicator' is shown in the form of a
  plus sign (+) next to the bytes count, indicating this. The actual
  'bytes threshold' value for each accounting object can be modified using
  the 'add replace' command and can be seen by executing 'list' and
  specifying 'show extended' parameter as indicated above.

* the 'get' command has also been enhanced, adding the two new options
  ('show' and 'format') as indicated for the 'list' command above.

* the 'add' command functionality has also been extended. It is now possible
  to replace all accounting object properties, regardless of whether they
  are used by iptables. The following new options have been added:
  - 'replace': takes care of replacing the properties of existing accounting
    object, if it already exists even if it is in use by iptables.
  - 'threshold': get or set a 'bytes threshold' for each accounting object.
    A value of 0 disables this feature.

* a new 'save' command has been added. Its main purpose is to display to
  stdout a dump of all existing accounting objects in the accounting table
  in a format suitable for the new 'restore' command. All accounting names
  and other properties are properly encoded, if necessary, which was a major
  flaw with the current 'restore' command.

* the 'restore' command has been fixed and further enhanced. Previously, it
  was choking when there were spaces or other 'odd' characters used for the
  account object name (like " " or ";" for example). Also, it wasn't possible
  to restore accounting object if it was already in use by iptables (the byte
  and packet counters were not restored at all). The previous version also
  did not flush the accounting table and was simply 'adding' accounting
  objects, instead of doing a full restore. With this enhanced version,
  coupled with the kernel changes already done, there are two additional
  options available, which allow all accounting objects to be updated,
  regardless of whether they are in use by iptables:
  - 'flush': flushes the accounting table prior to restore, deleting all
    accounting objects. It needs to be noted that objects which are in
    use by iptables are not deleted.
  - 'replace': the purpose of this option is to replace objects (in other
    words, update all of their properties) if they already exist,
    irrespective of whether they are in use and 'locked' by iptables.
    With the combination of these two options, it is now possible to fully
    restore the entire accounting table without much difficulties.

* the functionality of the nfnetlink callback function (nfacct_cb) has been
  enhanced to determine the column width which needs to be used when listing
  accounting objects. It now merely does a brief scan of their properties and
  stores them in a linked list to be retrieved later by the calling function.
  That way, processing is much faster and the calling function can determine
  the options to use in order to add or change accounting object properties.

* the exiting 'help' command has been modified to show the full variety of
  commands and parameters available to nfacct.

* the nfacct man page has been extensively re-written to describe the entire
  functionality of the nfacct executable and its current capabilities.

* new c source file (nfacct_utils.c) and a header file (nfacct_list.h) have
  been added to facilitate the implementation of the above functionality and
  bug fixes.

* a bug fixes for the 'add', 'change' and 'delete' commands have been
  implemented. Previously, it was possible for a zero-sized account object
  name to be added to the accounting table, which was completely useless
  since the nfacct match from iptables was preventing the addition of such
  object (and rightly so). Now a porper check is in place to prevent this
  from happening and appropriate error message is given.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/linux/netfilter/nfnetlink_acct.h |    2 +
 nfacct.8                                 |  333 ++++++++++++-
 src/Makefile.am                          |    2 +-
 src/nfacct.c                             |  750 +++++++++++++++++++++---------
 src/nfacct_list.h                        |   90 ++++
 src/nfacct_utils.c                       |  305 ++++++++++++
 src/nfacct_utils.h                       |   29 ++
 7 files changed, 1278 insertions(+), 233 deletions(-)
 create mode 100644 src/nfacct_list.h
 create mode 100644 src/nfacct_utils.c
 create mode 100644 src/nfacct_utils.h

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 7c4279b..7bac4a5 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -18,6 +18,8 @@ enum nfnl_acct_type {
 	NFACCT_NAME,
 	NFACCT_PKTS,
 	NFACCT_BYTES,
+	NFACCT_BTHR,
+	NFACCT_FMT,
 	NFACCT_USE,
 	__NFACCT_MAX
 };
diff --git a/nfacct.8 b/nfacct.8
index 554bc3b..9404bc0 100644
--- a/nfacct.8
+++ b/nfacct.8
@@ -1,59 +1,350 @@
-.TH NFACCT 8 "Dec 30, 2011" "" ""
+.TH NFACCT 8 "23 Mar 2013" "" ""
 
 .\" Man page written by Pablo Neira Ayuso <pablo@netfilter.org> (Dec 2011)
 
 .SH NAME
-nfacct \- command line tool to create/retrieve/delete accounting objects
+nfacct \- command line tool to create/retrieve/delete and manipulate
+accounting objects.
 .SH SYNOPSIS
-.BR "nfacct command [name] [options]"
+.BR "nfacct list [reset] [show {bytes|extended}] [format FORMAT] [xml]"
+
+.BR "nfacct add name [replace] [format FORMAT] [threshold NUMBER]"
+
+.BR "nfacct get name [reset] [show {bytes|extended}] [format FORMAT] [xml]"
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
+this command could list up to 5 different properties for each accounting
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
+.BI "bytes threshold "
+Number of bytes which are expected to pass through this accounting object.
+If this threshold is exceeded, the \fBbytes threshold exceeded indicator\fR
+is triggered. If the value of this property is \fB0\fR, then this feature is
+disabled. The format used to display this property is the same as the
+\fBbytes\fR format.
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
+properties shown are the same as the \fBlist\fR command above.
 .TP
 .BI "flush "
-Flush the entire table.
+Flush the entire accounting table, provided the accounting objects
+are not in use by iptables (if that is so, these accounting objects
+are not flushed).
+.TP
+.BI "save "
+Dump the entire accounting object table to \fIstdout\fR using format
+appropriate for use by the \fBrestore\fR command. The output of
+packet and byte counters, as well as the threshold value, if
+enabled, is not formatted.
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
 .TP
-This tool also allows a couple of options with the get and list commands that are:
+.BI "list command parameters "
+All parameters for the \fBlist\fR command shown below are optional.
+These are:
+.RS 8
 .TP
 .BI "reset "
-That atomically obtains and resets the counters.
+Resets the byte and packet counters on all accounting objects
+in the accounting table.
+.TP
+.BI "show "
+Specify what to display. Valid options are: \fIbytes\fR \- to
+display only the name and bytes counter for each accounting
+object; \fIextended\fR \- to show all properties of the
+accounting objects: name, packet and byte counters, threshold and threshold
+exceeded indicator. If this parameter is omitted, then name, packet and
+byte counters, as well as bytes threshold exceeded indicator are shown.
+.TP
+.BI "format "
+Specify the format to use to display \fIall\fR accounting objects (that
+option takes precedence over the formatting registered for each
+accounting object when it was added). For more information on format
+options see \fBFORMAT OPTIONS\fR section below.
 .TP
 .BI "xml "
-That displays the output in XML format.
+Generate all output in xml format. Special xml characters are properly
+escaped to conform to the xml specification.
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
+display the bytes counter.
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
+.TP
+.BI "reset "
+Resets the byte and packet counters on this accounting objects in the
+accounting table. The byte and packet counters shown will be
+\fIbefore\fR they were reset. Please note that this does \fInot\fR
+reset the byte threshold value of the accounting object, if enabled \-
+this needs to be done with the \fBadd\fR command
+(using \fIreplace\fR parameter).
+.TP
+.BI "show "
+Specify what properties of the accounting object to display. Valid
+options are: \fIbytes\fR \- to display only the name and bytes counter
+for this accounting object; \fIextended\fR \- to show all properties of
+the accounting object: name, packet and byte counters, threshold and bytes
+threshold exceeded indicator. If this parameter is omitted, then name,
+packet and byte counters, as well as bytes threshold exceeded
+indicator are shown.
+.TP
+.BI "format "
+Specify the format to use to display this accounting object (that option
+takes precedence over the formatting registered when the specified
+accounting object was added). For more information on format options see
+\fBFORMAT OPTIONS\fR section below.
+.TP
+.BI "xml "
+Generate all output in xml format. Special xml characters are properly
+escaped to conform to the xml specification.
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
+\fIreplace\fR and \fIflush\fR parameters need to be specified.
+.SH FORMAT OPTIONS
+This tool allows for a specific number formatting to be specified
+independently for each accounting object when it is added to the
+accounting table. These format options consist of two separate parts:
+\fIpackets\fR count number formatting and \fIbytes/threshold\fR count
+number formatting (if bytes threshold is enabled). Currently, the
+following types of number formatting is available:
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
+counter number formatting and \fImib\fR for bytes/bytes threshold counter
+number formatting).
+.TP
+.BI " "
+Similarly when '\fB3pl,\fR' is specified, this is the equivalent
+of '\fB3pl,def\fR' (use \fI3pl\fR for packets counter number
+formatting and \fIdef\fR for bytes/bytes threshold counter number
+formatting) and '\fB,\fR' is the equivalent of '\fBdef,def\fR', which is
+also the formatting used if \fIno\fR formatting options of any kind are
+specified.
+.TP
+.BI " "
+Finally, if just one formatting option is specified, then that option is
+applied to \fIboth\fR packet and byte/byte threshold numbers. In other
+words, when just '\fBraw\fR' is specified, this is the equivalent
+to '\fBraw,raw\fR' format option.
+.PP
+.SH EXAMPLES
+To \fIadd\fR accounting object called '\fBinward\fR' and use '\fB3pl\fR'
+for packet formatting and '\fBiec\fR' for bytes/threshold formatting,
+as well as set the threshold value to \fB1GiB\fR, execute
+the following command:
+.RS 8
+.TP
+.BI "nfacct add inward format 3pl,iec threshold 1073741824 "
+.RE
+.PP
+To \fIchange\fR the formatting and bytes threshold value properties of
+existing accounting object named '\fBnet 27\fR' with '\fB3pl,tib\fR' and
+\fB10TiB\fR respectively, execute the following command:
+.RS 8
+.TP
+.BI "nfacct add replace 'net 27' format 3pl,tib threshold 10995116277760 "
+.RE
+.PP
+To \fIlist\fR all accounting objects in the accounting table, display
+all their properties and generate all output in \fBxml\fR format, execute
+the following command:
+.RS 8
+.TP
+.BI "nfacct list show extended xml "
+.RE
+.PP
+To \fIsave\fR and then \fIrestore\fR all existing accounting objects in
+the accounting table, \fBreplacing\fR their properties even if used by
+iptables, and \fBflush\fR the entire accounting table prior to restore,
+execute the following command:
+.RS 8
+.TP
+.BI "nfacct save | nfacct restore flush replace "
+.RE
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
diff --git a/src/Makefile.am b/src/Makefile.am
index 28822fe..133ce61 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -2,6 +2,6 @@ include $(top_srcdir)/Make_global.am
 
 sbin_PROGRAMS = nfacct
 
-nfacct_SOURCES = nfacct.c
+nfacct_SOURCES = nfacct.c nfacct_utils.c
 
 nfacct_LDADD = ${LIBMNL_LIBS} ${LIBNETFILTER_ACCT_LIBS}
diff --git a/src/nfacct.c b/src/nfacct.c
index 2ef93c3..a01e18f 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -21,20 +21,57 @@
 #include <errno.h>
 
 #include <libmnl/libmnl.h>
-#include <libnetfilter_acct/libnetfilter_acct.h>
-
-enum {
-	NFACCT_CMD_NONE = 0,
-	NFACCT_CMD_LIST,
-	NFACCT_CMD_ADD,
-	NFACCT_CMD_DELETE,
-	NFACCT_CMD_GET,
-	NFACCT_CMD_FLUSH,
-	NFACCT_CMD_VERSION,
-	NFACCT_CMD_HELP,
-	NFACCT_CMD_RESTORE,
+
+#include "nfacct_list.h"
+#include "nfacct_utils.h"
+
+struct nfa {
+	struct nfacct *nfacct;
+	struct nfacct_list_head head;
 };
 
+/* store nfacct objects information */
+static NFACCT_LIST_HEAD(nfa_list);
+
+static struct nfa *nfa_alloc(void)
+{
+	return calloc(1, sizeof(struct nfa));
+}
+
+static void nfa_free(struct nfa *nfa)
+{
+	if (nfa)
+		free(nfa);
+}
+
+static void free_nfa_list(void) {
+	struct nfa *nfa, *nnfa;
+	nfacct_list_for_each_entry_safe(nfa, nnfa, &nfa_list, head) {
+		if (nfa->nfacct)
+			nfacct_free(nfa->nfacct);
+
+		nfa_free(nfa);
+	}
+}
+
+/* xml header & footer strings */
+#define XML_HEADER 	"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" \
+			"<nfacct>\n"
+#define XML_FOOTER	"</nfacct>\n"
+
+/*
+ * maximum total of columns to be shown, except the
+ * "name" column as that is not width-dependent
+ *
+ */
+#define MAX_COLUMNS 3
+
+/* maximum restore tokens: "name fmt pkts bytes bthr" */
+#define MAX_RESTORE_TOKENS 5
+
+/* stores nfacct options for snprintf_* and nfacct_cb functions */
+static struct nfacct_options *options;
+
 static int nfacct_cmd_list(int argc, char *argv[]);
 static int nfacct_cmd_add(int argc, char *argv[]);
 static int nfacct_cmd_delete(int argc, char *argv[]);
@@ -43,10 +80,45 @@ static int nfacct_cmd_flush(int argc, char *argv[]);
 static int nfacct_cmd_version(int argc, char *argv[]);
 static int nfacct_cmd_help(int argc, char *argv[]);
 static int nfacct_cmd_restore(int argc, char *argv[]);
+static int nfacct_cmd_save(int argc, char *argv[]);
+
+/* main command 'menu' */
+static const struct cmd {
+	const char *cmd;
+	int (*func)(int argc, char **argv);
+} cmds[] = {
+	{ "list", 	nfacct_cmd_list },
+	{ "add",	nfacct_cmd_add },
+	{ "delete",	nfacct_cmd_delete },
+	{ "get",	nfacct_cmd_get },
+	{ "flush",	nfacct_cmd_flush },
+	{ "save",	nfacct_cmd_save },
+	{ "restore",	nfacct_cmd_restore },
+	{ "version",	nfacct_cmd_version },
+	{ "help",	nfacct_cmd_help },
+	{ 0, 0 }
+};
+
+static int nfacct_do_cmd(const char *argv0, int argc, char **argv)
+{
+	const struct cmd *c;
+
+	for (c = cmds; c->cmd; ++c) {
+		if (nfacct_matches(argv0, c->cmd) == 0) {
+			return (c->func(argc-1, argv+1));
+		}
+	}
+	fprintf(stderr, "nfacct v%s: Unknown command: %s\n",
+		VERSION, argv0);
+	return EXIT_FAILURE;
+}
+
 
+static void usage(char *argv[]) __attribute__((noreturn));
 static void usage(char *argv[])
 {
 	fprintf(stderr, "Usage: %s command [parameters]...\n", argv[0]);
+	exit(EXIT_FAILURE);
 }
 
 static void nfacct_perror(const char *msg)
@@ -59,100 +131,97 @@ static void nfacct_perror(const char *msg)
 	}
 }
 
+#define RET_ERR(x)	nfacct_perror(x); \
+			goto err;
+#define RET_ARG_ERR()	RET_ERR("unknown argument")
+
+#define GET_NEXT_ARG() 	do {				\
+				argv++;			\
+				if (--argc <= 0) {	\
+					RET_ARG_ERR();	\
+				}			\
+			} while(0)
+#define NEXT_ARG_OK() 	(argc - 1 > 0)
+#define NEXT_ARG() 	do {		\
+				argv++;	\
+				argc--;	\
+			} while(0)
+#define PREV_ARG() 	do {		\
+				argv--;	\
+				argc++;	\
+			} while(0)
+
 int main(int argc, char *argv[])
 {
-	int cmd = NFACCT_CMD_NONE, ret = 0;
+	int ret = 0;
 
-	if (argc < 2) {
-		usage(argv);
-		exit(EXIT_FAILURE);
-	}
-
-	if (strncmp(argv[1], "list", strlen(argv[1])) == 0)
-		cmd = NFACCT_CMD_LIST;
-	else if (strncmp(argv[1], "add", strlen(argv[1])) == 0)
-		cmd = NFACCT_CMD_ADD;
-	else if (strncmp(argv[1], "delete", strlen(argv[1])) == 0)
-		cmd = NFACCT_CMD_DELETE;
-	else if (strncmp(argv[1], "get", strlen(argv[1])) == 0)
-		cmd = NFACCT_CMD_GET;
-	else if (strncmp(argv[1], "flush", strlen(argv[1])) == 0)
-		cmd = NFACCT_CMD_FLUSH;
-	else if (strncmp(argv[1], "version", strlen(argv[1])) == 0)
-		cmd = NFACCT_CMD_VERSION;
-	else if (strncmp(argv[1], "help", strlen(argv[1])) == 0)
-		cmd = NFACCT_CMD_HELP;
-	else if (strncmp(argv[1], "restore", strlen(argv[1])) == 0)
-		cmd = NFACCT_CMD_RESTORE;
-	else {
-		fprintf(stderr, "nfacct v%s: Unknown command: %s\n",
-			VERSION, argv[1]);
+	if (argc >= 2) {
+		ret = nfacct_do_cmd(argv[1], argc-1, argv+1);
+		if (ret != EXIT_FAILURE)
+			return ret < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
+	}
 		usage(argv);
-		exit(EXIT_FAILURE);
-	}
-
-	switch(cmd) {
-	case NFACCT_CMD_LIST:
-		ret = nfacct_cmd_list(argc, argv);
-		break;
-	case NFACCT_CMD_ADD:
-		ret = nfacct_cmd_add(argc, argv);
-		break;
-	case NFACCT_CMD_DELETE:
-		ret = nfacct_cmd_delete(argc, argv);
-		break;
-	case NFACCT_CMD_GET:
-		ret = nfacct_cmd_get(argc, argv);
-		break;
-	case NFACCT_CMD_FLUSH:
-		ret = nfacct_cmd_flush(argc, argv);
-		break;
-	case NFACCT_CMD_VERSION:
-		ret = nfacct_cmd_version(argc, argv);
-		break;
-	case NFACCT_CMD_HELP:
-		ret = nfacct_cmd_help(argc, argv);
-		break;
-	case NFACCT_CMD_RESTORE:
-		ret = nfacct_cmd_restore(argc, argv);
-		break;
-	}
-	return ret < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
 }
 
-static bool xml_header = false;
+#define SET_MAX_WIDTH(x) if (bl[(x)] > nfacct_option_get_tsize(options,     \
+							       o_num[(x)])) \
+				nfacct_option_set_tsize(options,	    \
+							o_num[(x)], bl[x]);
 
 static int nfacct_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nfacct *nfacct;
-	char buf[4096];
-	bool *xml = (bool *)data;
+	struct nfa *nfa = NULL;
+	size_t bl[MAX_COLUMNS];
+	char buf[MAX_TOKEN_SIZE];
+	int i;
+	bool *ignore_col_width = (bool *)data;
+	static const enum nfacct_option_type o_num[MAX_COLUMNS] =
+				{ NFACCT_OPT_PCW,
+				  NFACCT_OPT_BCW,
+				  NFACCT_OPT_BTCW,
+				};
 
-	nfacct = nfacct_alloc();
-	if (nfacct == NULL) {
-		nfacct_perror("OOM");
-		goto err;
+	if (ignore_col_width == NULL || options == NULL) {
+		RET_ERR("nfacct_cb_data_and_options");
 	}
 
-	if (nfacct_nlmsg_parse_payload(nlh, nfacct) < 0) {
-		nfacct_perror("nfacct_parse_nl_msg");
-		goto err_free;
+	nfa = nfa_alloc();
+	if (nfa == NULL) {
+		RET_ERR("OOM");
 	}
 
-	if (*xml && !xml_header) {
-		printf("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
-			"<nfacct>\n");
-		xml_header = true;
+	nfa->nfacct = nfacct_alloc();
+	if (nfa->nfacct == NULL) {
+		nfacct_perror("OOM");
+		goto err_nfa_free;
 	}
 
-	nfacct_snprintf(buf, sizeof(buf), nfacct,
-			*xml ? NFACCT_SNPRINTF_T_XML :
+	if (nfacct_nlmsg_parse_payload(nlh, nfa->nfacct) < 0) {
+		nfacct_perror("nfacct_parse_nl_msg");
+		goto err_nfacct_free;
+	}
+	if (!*ignore_col_width) {
+		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
+				nfa->nfacct,
 			       NFACCT_SNPRINTF_T_PLAIN,
-			NFACCT_SNPRINTF_F_FULL);
-	printf("%s\n", buf);
+				NFACCT_SNPRINTF_F_NUMONLY, options);
+		i = nfacct_parse_tokens_length(buf, " ",
+						ARRAY_SIZE(bl), bl);
+		if (i < MAX_COLUMNS) {
+			nfacct_perror("nfacct_parse_tokens_length");
+			goto err_nfacct_free;
+		}
+		for (i = 0; i < MAX_COLUMNS; i++) {
+			SET_MAX_WIDTH(i);
+		}
+	}
+	nfacct_list_add_tail(&nfa->head, &nfa_list);
+	return MNL_CB_OK;
 
-err_free:
-	nfacct_free(nfacct);
+err_nfacct_free:
+	nfacct_free(nfa->nfacct);
+err_nfa_free:
+	nfa_free(nfa);
 err:
 	return MNL_CB_OK;
 }
@@ -160,21 +229,43 @@ err:
 static int nfacct_cmd_list(int argc, char *argv[])
 {
 	bool zeroctr = false, xml = false;
+	bool b_fmt = false, b_sh = false;
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	unsigned int seq, portid;
-	int ret, i;
+	int ret = -1, i;
+	struct nfa *nfa = NULL;
+	uint32_t fmt = FMT_MAX;
+	uint16_t flags = NFACCT_SNPRINTF_F_FULL;
 
-	for (i=2; i<argc; i++) {
-		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
+	while (argc > 0) {
+		if (nfacct_matches(argv[0],"reset") == 0 && !zeroctr) {
 			zeroctr = true;
-		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
+		} else if (nfacct_matches(argv[0],"xml") == 0 && !xml) {
 			xml = true;
+		} else if (nfacct_matches(argv[0],"show") == 0 && !b_sh) {
+			GET_NEXT_ARG();
+			if (nfacct_matches(argv[0],"bytes") == 0) {
+				flags = NFACCT_SNPRINTF_F_BONLY;
+			} else if (nfacct_matches(argv[0],"extended") == 0) {
+				flags = NFACCT_SNPRINTF_F_EXTENDED;
 		} else {
-			nfacct_perror("unknown argument");
-			return -1;
+				RET_ARG_ERR();
 		}
+			b_sh = true;
+		} else if ((nfacct_matches(argv[0],"format") == 0 ||
+			   nfacct_matches(argv[0],"fmt") == 0) && !b_fmt) {
+			GET_NEXT_ARG();
+			fmt = nfacct_parse_format_options(argv[0]);
+			if (fmt == FMT_MAX) {
+				RET_ARG_ERR();
+			}
+			b_fmt = true;
+		} else {
+			RET_ARG_ERR();
+		}
+		argc--; argv++;
 	}
 
 	seq = time(NULL);
@@ -185,41 +276,64 @@ static int nfacct_cmd_list(int argc, char *argv[])
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
-		nfacct_perror("mnl_socket_open");
-		return -1;
+		RET_ERR("mnl_socket_open");
 	}
 
 	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		nfacct_perror("mnl_socket_bind");
-		return -1;
+		RET_ERR("mnl_socket_bind");
 	}
 	portid = mnl_socket_get_portid(nl);
 
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		nfacct_perror("mnl_socket_send");
-		return -1;
+		RET_ERR("mnl_socket_send");
 	}
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, nfacct_cb, &xml);
-		if (ret <= 0)
+	options = nfacct_options_alloc();
+	if (options == NULL) {
+		RET_ERR("OOM");
+	}
+	nfacct_option_set_u32(options, NFACCT_OPT_FMT, fmt);
+
+	i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
+	while (i > 0) {
+		i = mnl_cb_run(buf, i, seq, portid, nfacct_cb, &xml);
+		if (i <= 0)
 			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
 	}
-	if (ret == -1) {
+	if (i == -1) {
 		nfacct_perror("error");
-		return -1;
+		goto err_free_nfa;
 	}
 	mnl_socket_close(nl);
 
-	if (xml_header)
-		printf("</nfacct>\n");
+	if (xml)
+		printf(XML_HEADER);
 
-	return 0;
+	nfacct_list_for_each_entry(nfa, &nfa_list, head) {
+		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
+				nfa->nfacct,
+				xml ? NFACCT_SNPRINTF_T_XML :
+				      NFACCT_SNPRINTF_T_PLAIN,
+				flags, options);
+		printf("%s\n",buf);
+	}
+
+	if (xml)
+		printf(XML_FOOTER);
+
+	ret = 0;
+
+err_free_nfa:
+	free_nfa_list();
+	nfacct_options_free(options);
+
+err:
+	return ret;
 }
 
-static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
+static int _nfacct_cmd_add(char *name, uint32_t *fmt, uint64_t *pkts,
+			   uint64_t *bytes, uint64_t *bthr, bool replace)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -236,31 +350,38 @@ static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
 
 	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, name);
 
-	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_PKTS, pkts);
-	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES, bytes);
+	if (pkts)
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_PKTS, *pkts);
+
+	if (bytes)
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES, *bytes);
+
+	if (bthr)
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BTHR, *bthr);
+
+	if (fmt)
+		nfacct_attr_set_u32(nfacct, NFACCT_ATTR_FMT, *fmt);
 
 	seq = time(NULL);
 	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_NEW,
-				     NLM_F_CREATE | NLM_F_ACK, seq);
+				     NLM_F_CREATE | NLM_F_ACK |
+				     (replace ? NLM_F_REPLACE : 0), seq);
 	nfacct_nlmsg_build_payload(nlh, nfacct);
 
 	nfacct_free(nfacct);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
-		nfacct_perror("mnl_socket_open");
-		return -1;
+		RET_ERR("mnl_socket_open");
 	}
 
 	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		nfacct_perror("mnl_socket_bind");
-		return -1;
+		RET_ERR("mnl_socket_bind");
 	}
 	portid = mnl_socket_get_portid(nl);
 
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		nfacct_perror("mnl_socket_send");
-		return -1;
+		RET_ERR("mnl_socket_send");
 	}
 
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
@@ -271,27 +392,62 @@ static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
 		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	}
 	if (ret == -1) {
-		nfacct_perror("error");
-		return -1;
+		RET_ERR("error");
 	}
 	mnl_socket_close(nl);
 
 	return 0;
+err:
+	return -1;
 }
 
-
-
 static int nfacct_cmd_add(int argc, char *argv[])
 {
-	if (argc < 3) {
+	int ret = -1;
+	bool replace = false, bthr_set = false;
+	bool b_fmt = false;
+	char *name;
+	uint32_t fmt = FMT_MAX;
+	uint64_t bthr;
+
+	if (argc < 1 || strlen(argv[0]) == 0) {
 		nfacct_perror("missing object name");
 		return -1;
-	} else if (argc > 3) {
-		nfacct_perror("too many arguments");
+	}
+	name = strdup(argv[0]);
+	if (!name) {
+		nfacct_perror("OOM");
 		return -1;
 	}
-
-	return _nfacct_cmd_add(argv[2], 0, 0);
+	NEXT_ARG();
+	while (argc > 0) {
+		if (nfacct_matches(argv[0],"replace") == 0 && !replace) {
+			replace = true;
+		} else if ((nfacct_matches(argv[0],"format") == 0 ||
+			   nfacct_matches(argv[0],"fmt") == 0) && !b_fmt) {
+			GET_NEXT_ARG();
+			fmt = nfacct_parse_format_options(argv[0]);
+			if (fmt == FMT_MAX) {
+				RET_ARG_ERR();
+			}
+			b_fmt = true;
+		} else if (nfacct_matches(argv[0],"threshold") == 0 &&
+			   !bthr_set) {
+			GET_NEXT_ARG();
+			if (get_uint64_t(&bthr, argv[0]) != 0) {
+				RET_ARG_ERR();
+			}
+			bthr_set = true;
+		} else {
+			RET_ARG_ERR();
+		}
+		argc--; argv++;
+	}
+	ret = _nfacct_cmd_add(name, (fmt == FMT_MAX ? NULL : &fmt), NULL,
+			      NULL, (bthr_set ? &bthr : NULL), replace);
+err:
+	free(name);
+	return ret;
 }
 
 static int nfacct_cmd_delete(int argc, char *argv[])
@@ -303,21 +459,18 @@ static int nfacct_cmd_delete(int argc, char *argv[])
 	struct nfacct *nfacct;
 	int ret;
 
-	if (argc < 3) {
-		nfacct_perror("missing object name");
-		return -1;
-	} else if (argc > 3) {
-		nfacct_perror("too many arguments");
-		return -1;
+	if (argc < 1 || strlen(argv[0]) == 0) {
+		RET_ERR("missing object name");
+	} else if (argc > 1) {
+		RET_ERR("too many arguments");
 	}
 
 	nfacct = nfacct_alloc();
 	if (nfacct == NULL) {
-		nfacct_perror("OOM");
-		return -1;
+		RET_ERR("OOM");
 	}
 
-	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, argv[2]);
+	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, argv[0]);
 
 	seq = time(NULL);
 	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_DEL,
@@ -328,19 +481,16 @@ static int nfacct_cmd_delete(int argc, char *argv[])
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
-		nfacct_perror("mnl_socket_open");
-		return -1;
+		RET_ERR("mnl_socket_open");
 	}
 
 	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		nfacct_perror("mnl_socket_bind");
-		return -1;
+		RET_ERR("mnl_socket_bind");
 	}
 	portid = mnl_socket_get_portid(nl);
 
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		nfacct_perror("mnl_socket_send");
-		return -1;
+		RET_ERR("mnl_socket_send");
 	}
 
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
@@ -351,46 +501,75 @@ static int nfacct_cmd_delete(int argc, char *argv[])
 		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	}
 	if (ret == -1) {
-		nfacct_perror("error");
-		return -1;
+		RET_ERR("error");
 	}
 
 	mnl_socket_close(nl);
 
 	return 0;
+
+err:
+	return -1;
 }
 
 static int nfacct_cmd_get(int argc, char *argv[])
 {
 	bool zeroctr = false, xml = false;
+	bool b_sh = false, b_fmt = false;
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq;
 	struct nfacct *nfacct;
-	int ret, i;
+	int ret = -1, i;
+	char *name;
+	struct nfa *nfa = NULL;
+	uint32_t fmt = FMT_MAX;
+	uint16_t flags = NFACCT_SNPRINTF_F_FULL;
 
-	if (argc < 3) {
+	if (argc < 1 || strlen(argv[0]) == 0) {
 		nfacct_perror("missing object name");
 		return -1;
 	}
-	for (i=3; i<argc; i++) {
-		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
+	name = strdup(argv[0]);
+	if (!name) {
+		nfacct_perror("OOM");
+		return -1;
+	}
+	NEXT_ARG();
+	while (argc > 0) {
+		if (nfacct_matches(argv[0],"reset") == 0 && !zeroctr) {
 			zeroctr = true;
-		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
+		} else if (nfacct_matches(argv[0],"xml") == 0 && !xml) {
 			xml = true;
+		} else if (nfacct_matches(argv[0],"show") == 0 && !b_sh) {
+			GET_NEXT_ARG();
+			if (nfacct_matches(argv[0],"bytes") == 0) {
+				flags = NFACCT_SNPRINTF_F_BONLY;
+			} else if (nfacct_matches(argv[0],"extended") == 0) {
+				flags = NFACCT_SNPRINTF_F_EXTENDED;
+		} else {
+				RET_ARG_ERR();
+		}
+			b_sh = true;
+		} else if ((nfacct_matches(argv[0],"format") == 0 ||
+			   nfacct_matches(argv[0],"fmt") == 0) && !b_fmt) {
+			GET_NEXT_ARG();
+			fmt = nfacct_parse_format_options(argv[0]);
+			if (fmt == FMT_MAX) {
+				RET_ARG_ERR();
+			}
+			b_fmt = true;
 		} else {
-			nfacct_perror("unknown argument");
-			return -1;
+			RET_ARG_ERR();
 		}
+		argc--; argv++;
 	}
-
 	nfacct = nfacct_alloc();
 	if (nfacct == NULL) {
-		nfacct_perror("OOM");
-		return -1;
+		RET_ERR("OOM");
 	}
-	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, argv[2]);
+	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, name);
 
 	seq = time(NULL);
 	nlh = nfacct_nlmsg_build_hdr(buf, zeroctr ?
@@ -404,38 +583,61 @@ static int nfacct_cmd_get(int argc, char *argv[])
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
-		nfacct_perror("mnl_socket_open");
-		return -1;
+		RET_ERR("mnl_socket_open");
 	}
 
 	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		nfacct_perror("mnl_socket_bind");
-		return -1;
+		RET_ERR("mnl_socket_bind");
 	}
 	portid = mnl_socket_get_portid(nl);
 
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		nfacct_perror("mnl_socket_send");
-		return -1;
+		RET_ERR("mnl_socket_send");
 	}
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, nfacct_cb, &xml);
-		if (ret <= 0)
+	options = nfacct_options_alloc();
+	if (options == NULL) {
+		RET_ERR("OOM");
+	}
+	nfacct_option_set_u32(options, NFACCT_OPT_FMT, fmt);
+
+	i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
+	while (i > 0) {
+		i = mnl_cb_run(buf, i, seq, portid, nfacct_cb, &xml);
+		if (i <= 0)
 			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
 	}
-	if (ret == -1) {
+	if (i == -1) {
 		nfacct_perror("error");
-		return -1;
+		goto err_free_nfa;
 	}
 	mnl_socket_close(nl);
 
-	if (xml_header)
-		printf("</nfacct>\n");
+	if (xml)
+		printf(XML_HEADER);
 
-	return 0;
+	nfacct_list_for_each_entry(nfa, &nfa_list, head) {
+		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
+				nfa->nfacct,
+				xml ? NFACCT_SNPRINTF_T_XML :
+				      NFACCT_SNPRINTF_T_PLAIN,
+				flags, options);
+		printf("%s\n",buf);
+	}
+
+	if (xml)
+		printf(XML_FOOTER);
+
+	ret = 0;
+
+err_free_nfa:
+	free_nfa_list();
+	nfacct_options_free(options);
+
+err:
+	free(name);
+	return ret;
 }
 
 static int nfacct_cmd_flush(int argc, char *argv[])
@@ -446,9 +648,8 @@ static int nfacct_cmd_flush(int argc, char *argv[])
 	uint32_t portid, seq;
 	int ret;
 
-	if (argc > 2) {
-		nfacct_perror("too many arguments");
-		return -1;
+	if (argc > 0) {
+		RET_ERR("too many arguments");
 	}
 
 	seq = time(NULL);
@@ -456,36 +657,35 @@ static int nfacct_cmd_flush(int argc, char *argv[])
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
-		nfacct_perror("mnl_socket_open");
-		return -1;
+		RET_ERR("mnl_socket_open");
 	}
 
 	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		nfacct_perror("mnl_socket_bind");
-		return -1;
+		RET_ERR("mnl_socket_bind");
 	}
 	portid = mnl_socket_get_portid(nl);
 
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		nfacct_perror("mnl_socket_send");
-		return -1;
+		RET_ERR("mnl_socket_send");
 	}
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	ret = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
 	while (ret > 0) {
 		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
 		if (ret <= 0)
 			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		ret = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
 	}
 	if (ret == -1) {
-		nfacct_perror("error");
-		return -1;
+		RET_ERR("error");
 	}
 
 	mnl_socket_close(nl);
 
 	return 0;
+
+err:
+	return -1;
 }
 
 static const char version_msg[] =
@@ -507,47 +707,175 @@ static int nfacct_cmd_version(int argc, char *argv[])
 static const char help_msg[] =
 	"nfacct v%s: utility for the Netfilter extended accounting "
 	"infrastructure\n"
-	"Usage: %s command [parameters]...\n\n"
+	"Usage: nfacct command [parameters]...\n\n"
 	"Commands:\n"
-	"  list [reset]\t\tList the accounting object table (and reset)\n"
-	"  add object-name\tAdd new accounting object to table\n"
-	"  delete object-name\tDelete existing accounting object\n"
-	"  get object-name\tGet existing accounting object\n"
+	"  list LST_PARAMS\tList the accounting object table\n"
+	"  add NAME ADD_PARAMS\tAdd new accounting object NAME to table\n"
+	"  delete NAME\t\tDelete existing accounting object NAME\n"
+	"  get NAME GET_PARAMS\tGet and list existing accounting object NAME\n"
 	"  flush\t\t\tFlush accounting object table\n"
-	"  restore\t\tRestore accounting object table reading 'list' output from stdin\n"
+	"  save\t\t\tDump current accounting object table to stdout\n"
+	"  restore RST_PARAMS\tRestore accounting object table from stdin\n"
 	"  version\t\tDisplay version and disclaimer\n"
-	"  help\t\t\tDisplay this help message\n";
+	"  help\t\t\tDisplay this help message\n\n"
+	"Parameters:\n"
+	"  LST_PARAMS := [ reset ] [ show SHOW_SPEC ] [ format FMT_SPEC ] [ xml ]\n"
+	"  ADD_PARAMS := [ replace ] [ format FMT_SPEC ] [ threshold NUMBER ]\n"
+	"  GET_PARAMS := [ reset ] [ show SHOW_SPEC ] [ format FMT_SPEC ] [ xml ]\n"
+	"  RST_PARAMS := [ flush ] [ replace ]\n"
+	"  SHOW_SPEC := { bytes | extended }\n"
+	"  FMT_SPEC := { [FMT] | [,] | [FMT] ... }\n"
+	"  FMT := { def | raw | 3pl | iec | kib | mib | gib | tib | pib | eib |\n"
+	"  \t   si | kb | mb | gb | tb | pb | eb }\n";
+
 
 static int nfacct_cmd_help(int argc, char *argv[])
 {
-	printf(help_msg, VERSION, argv[0]);
+	printf(help_msg, VERSION);
 	return 0;
 }
 
+static int nfacct_cmd_save(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	unsigned int seq, portid;
+	int ret = -1, i;
+	bool ignore_width = true;
+	struct nfa *nfa = NULL;
+
+	if (argc > 0) {
+		RET_ERR("too many arguments");
+	}
+	seq = time(NULL);
+	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_GET,
+				     NLM_F_DUMP, seq);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		RET_ERR("mnl_socket_open");
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		RET_ERR("mnl_socket_bind");
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		RET_ERR("mnl_socket_send");
+	}
+
+	options = nfacct_options_alloc();
+	if (options == NULL) {
+		RET_ERR("OOM");
+	}
+	nfacct_option_set_u32(options, NFACCT_OPT_FMT, FMT_MAX);
+
+	i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
+	while (i > 0) {
+		i = mnl_cb_run(buf, i, seq, portid, nfacct_cb, &ignore_width);
+		if (i <= 0)
+			break;
+		i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
+	}
+	if (i == -1) {
+		nfacct_perror("error");
+		goto err_free_nfa;
+	}
+	mnl_socket_close(nl);
+
+	nfacct_list_for_each_entry(nfa, &nfa_list, head) {
+		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
+				nfa->nfacct,
+				NFACCT_SNPRINTF_T_PLAIN,
+				NFACCT_SNPRINTF_F_SAVE, options);
+		printf("%s\n",buf);
+	}
+
+	ret = 0;
+
+err_free_nfa:
+	free_nfa_list();
+	nfacct_options_free(options);
+
+err:
+	return ret;
+}
+
+#define FREE_TOKENS for (i = 0; i < ret; i++) \
+			free(tokens[i]);
+
+#define PRINT_ERR(x,y)	snprintf(err_str,ARRAY_SIZE(err_str),	\
+				 x,cnt,y);			\
+			FREE_TOKENS;				\
+			RET_ERR(err_str);
+
 static int nfacct_cmd_restore(int argc, char *argv[])
 {
-	uint64_t pkts, bytes;
-	char name[512];
-	char buffer[512];
+	bool replace = false, flush = false;
+	uint32_t fmt = FMT_MAX;
+	uint64_t numbers[3];
+	char *tokens[MAX_RESTORE_TOKENS + 1];
+	char buf[MAX_TOKEN_SIZE];
+	char err_str[80];
+	int cnt = 0;
+	int i;
 	int ret;
 
-	while (fgets(buffer, sizeof(buffer), stdin)) {
-		char *semicolon = strchr(buffer, ';');
-		if (semicolon == NULL) {
-			nfacct_perror("invalid line");
-			return -1;
+	if (argc > 2) {
+		RET_ERR("too many arguments");
+		}
+	while (argc > 0) {
+		if (nfacct_matches(argv[0],"replace") == 0 && !replace) {
+			replace = true;
+		} else if (nfacct_matches(argv[0],"flush") == 0 && !flush) {
+			flush = true;
+		} else {
+			RET_ARG_ERR();
 		}
-		*semicolon = 0;
-		ret = sscanf(buffer,
-			     "{ pkts = %"PRIu64", bytes = %"PRIu64" } = %s",
-		       &pkts, &bytes, name);
-		if (ret != 3) {
-			nfacct_perror("error reading input");
-			return -1;
+		argc--; argv++;
 		}
-		if ((ret = _nfacct_cmd_add(name, pkts, bytes)) != 0)
-			return ret;
 
+	if (flush) {
+		ret = nfacct_cmd_flush(0, NULL);
+		if (ret == -1) {
+			RET_ERR("flush not successful");
+		}
+	}
+	while (fgets(buf, ARRAY_SIZE(buf), stdin)) {
+		ret = nfacct_parse_tokens(buf, " \n", MAX_RESTORE_TOKENS+1,
+					  tokens);
+		cnt++;
+		if (ret != MAX_RESTORE_TOKENS) {
+			PRINT_ERR("error on line %d: %d tokens retrieved",
+				  ret);
+		} else {
+			fmt = nfacct_parse_format_options(tokens[1]);
+			if (fmt == FMT_MAX) {
+				PRINT_ERR("error on line %d: "
+					  "invalid format token '%s'",
+					  tokens[1]);
+			}
+			for (i = 2; i < MAX_RESTORE_TOKENS; i++) {
+				if (get_uint64_t(&numbers[i-2],
+						 tokens[i]) != 0) {
+					PRINT_ERR("error on line %d: "
+						  "invalid number token '%s'",
+						  tokens[i]);
+				}
+			}
+		}
+		ret = _nfacct_cmd_add(tokens[0], &fmt,
+				      &numbers[0], &numbers[1], &numbers[2],
+				      replace);
+		FREE_TOKENS;
+		if (ret != 0)
+			goto err;
 	}
 	return 0;
+
+err:
+	return -1;
 }
+
diff --git a/src/nfacct_list.h b/src/nfacct_list.h
new file mode 100644
index 0000000..d023e12
--- /dev/null
+++ b/src/nfacct_list.h
@@ -0,0 +1,90 @@
+/*
+ * 	Based on netlink/list.h
+ *	by Thomas Graf <tgraf@suug.ch>
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ */
+
+#ifndef _NFACCT_LIST_H_
+#define _NFACCT_LIST_H_
+
+struct nfacct_list_head
+{
+	struct nfacct_list_head *	next;
+	struct nfacct_list_head *	prev;
+};
+
+
+static inline void __nfacct_list_add(struct nfacct_list_head *obj,
+				 struct nfacct_list_head *prev,
+				 struct nfacct_list_head *next)
+{
+	prev->next = obj;
+	obj->prev = prev;
+	next->prev = obj;
+	obj->next = next;
+}
+
+static inline void nfacct_list_add_tail(struct nfacct_list_head *obj,
+					struct nfacct_list_head *head)
+{
+	__nfacct_list_add(obj, head->prev, head);
+}
+
+static inline void nfacct_list_add_head(struct nfacct_list_head *obj,
+					struct nfacct_list_head *head)
+{
+	__nfacct_list_add(obj, head, head->next);
+}
+
+static inline void nfacct_list_del(struct nfacct_list_head *obj)
+{
+	obj->next->prev = obj->prev;
+	obj->prev->next = obj->next;
+}
+
+static inline int nfacct_list_empty(struct nfacct_list_head *head)
+{
+	return head->next == head;
+}
+
+#define nfacct_container_of(ptr, type, member) ({			\
+        typeof( ((type *)0)->member ) *__mptr = (ptr);			\
+        (type *)( (char *)__mptr - ((size_t) &((type *)0)->member));})
+
+#define nfacct_list_entry(ptr, type, member) \
+	nfacct_container_of(ptr, type, member)
+
+#define nfacct_list_at_tail(pos, head, member) \
+	((pos)->member.next == (head))
+
+#define nfacct_list_at_head(pos, head, member) \
+	((pos)->member.prev == (head))
+
+#define NFACCT_LIST_HEAD(name) \
+	struct nfacct_list_head name = { &(name), &(name) }
+
+#define nfacct_list_for_each_entry(pos, head, member)			\
+	for (pos = nfacct_list_entry((head)->next,			\
+				     typeof(*pos), member);		\
+	     &(pos)->member != (head); 					\
+	     (pos) = nfacct_list_entry((pos)->member.next,		\
+				    typeof(*(pos)), member))
+
+#define nfacct_list_for_each_entry_safe(pos, n, head, member)		\
+	for (pos = nfacct_list_entry((head)->next,			\
+				  typeof(*pos), member),		\
+		n = nfacct_list_entry(pos->member.next,			\
+				   typeof(*pos), member);		\
+	     &(pos)->member != (head); 					\
+	     pos = n, n = nfacct_list_entry(n->member.next,		\
+					 typeof(*n), member))
+
+#define nfacct_init_list_head(head) \
+	do { (head)->next = (head); (head)->prev = (head); } while (0)
+
+#endif
diff --git a/src/nfacct_utils.c b/src/nfacct_utils.c
new file mode 100644
index 0000000..bed558c
--- /dev/null
+++ b/src/nfacct_utils.c
@@ -0,0 +1,305 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <limits.h>
+
+#include "nfacct_utils.h"
+
+/* Matches two strings, including partial matches */
+int nfacct_matches(const char *cmd, const char *pattern)
+{
+	if (cmd == NULL || pattern == NULL)
+		return -1;
+	size_t len = strlen(cmd);
+	if (len > strlen(pattern))
+		return -1;
+	return memcmp(pattern, cmd, len);
+}
+
+/*
+ * Takes 'str' and breaks it in maximum of 'len' tokens, using 'sep'
+ * as separators, taking into account character escaping (\) and
+ * string quotation (e.g. "abc de"). Each token is stored in 'tokens'.
+ * The function returns the number of tokens actually processed and stored.
+ *
+ * N.B.:
+ *	1. Character escaping is NOT translated/taken into account. In
+ *	   other words, "\t" translates to "t".
+ *	2. It is assumed that each resulting token is no more than
+ *	   MAX_TOKEN_SIZE characters.
+ *
+ */
+int nfacct_parse_tokens(const char *str, const char *sep,
+			const size_t len, char *tokens[])
+{
+	bool quote_open = false, escaped = false;
+	size_t param_len = 0, i = 0;
+	char buf[MAX_TOKEN_SIZE], *ptr, *tmp;
+
+	if (str == NULL || tokens == NULL || sep == NULL)
+		goto err;
+
+	tmp = strdup(str);
+	for (ptr = tmp; *ptr; ptr++) {
+		if (quote_open) {
+			if (escaped) {
+				if (param_len >= ARRAY_SIZE(buf))
+					goto err_free;
+				buf[param_len++] = *ptr;
+				escaped = false;
+				continue;
+			} else if (*ptr == '\\') {
+				escaped = true;
+				continue;
+			} else if (*ptr == '"') {
+				quote_open = false;
+				*ptr = *sep;
+			} else {
+				if (param_len >= ARRAY_SIZE(buf))
+					goto err_free;
+				buf[param_len++] = *ptr;
+				continue;
+			}
+		} else {
+			if (*ptr == '"') {
+				quote_open = true;
+				continue;
+			}
+		}
+		if (strchr(sep, *ptr)) {
+			if (!param_len)
+				continue;
+
+			if (!param_len || i >= len ||
+			    param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+
+			buf[param_len] = '\0';
+			tokens[i] = strdup(buf);
+			i++;
+			param_len = 0;
+		} else {
+			/* regular character, copy to buffer */
+			if (param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+			buf[param_len++] = *ptr;
+		}
+	}
+
+	if (escaped || quote_open || !param_len || i >= len)
+		goto err_free;
+
+	if (param_len && param_len < ARRAY_SIZE(buf)) {
+		buf[param_len] = '\0';
+		tokens[i] = strdup(buf);
+		i++;
+	}
+
+err_free:
+	free(tmp);
+err:
+	return i;
+}
+
+/*
+ * Takes 'str' and breaks it in maximum of 'len' tokens, using 'sep'
+ * as separators, taking into account character escaping (\) and
+ * string quotation (e.g. "abc de"). Each token length is stored in 't_len'.
+ * The function returns the number of tokens actually processed.
+ *
+ * N.B.:
+ *	1. Character escaping is NOT translated/taken into account. In
+ *	   other words, "\t" translates to "t".
+ *	2. It is assumed that each resulting token is no more than
+ *	   MAX_TOKEN_SIZE characters.
+ *
+ */
+int nfacct_parse_tokens_length(const char *str, const char *sep,
+				const size_t len, size_t t_len[])
+{
+	bool quote_open = false, escaped = false;
+	size_t param_len = 0, i = 0;
+	char buf[MAX_TOKEN_SIZE], *ptr, *tmp;
+
+	if (str == NULL || t_len == NULL || sep == NULL)
+		goto err;
+
+	tmp = strdup(str);
+	for (ptr = tmp; *ptr; ptr++) {
+		if (quote_open) {
+			if (escaped) {
+				if (param_len >= ARRAY_SIZE(buf))
+					goto err_free;
+				buf[param_len++] = *ptr;
+				escaped = false;
+				continue;
+			} else if (*ptr == '\\') {
+				escaped = true;
+				continue;
+			} else if (*ptr == '"') {
+				quote_open = false;
+				*ptr = *sep;
+			} else {
+				if (param_len >= ARRAY_SIZE(buf))
+					goto err_free;
+				buf[param_len++] = *ptr;
+				continue;
+			}
+		} else {
+			if (*ptr == '"') {
+				quote_open = true;
+				continue;
+			}
+		}
+		if (strchr(sep, *ptr)) {
+			if (!param_len)
+				continue;
+
+			if (!param_len || i >= len ||
+			    param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+
+			buf[param_len] = '\0';
+			t_len[i] = strlen(buf);
+			i++;
+			param_len = 0;
+		} else {
+			/* regular character, copy to buffer */
+			if (param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+			buf[param_len++] = *ptr;
+		}
+	}
+
+	if (escaped || quote_open || !param_len || i >= len)
+		goto err_free;
+
+	if (param_len && param_len < ARRAY_SIZE(buf)) {
+		buf[param_len] = '\0';
+		t_len[i] = strlen(buf);
+		i++;
+	}
+
+err_free:
+	free(tmp);
+err:
+	return i;
+}
+
+/* maximum length of any format options */
+#define MAX_FMT_LEN 3
+static const char *fmt_options[FMT_MAX + 1] =	{
+						"def","raw","3pl","iec","kib",
+						"mib","gib","tib","pib","eib",
+						"si","kb","mb","gb","tb","pb",
+						"eb",""
+						};
+
+
+/*
+ *
+ * Parses 'str' into a pair of nfacct_format values
+ * as defined in fmt_options and returns either
+ * 8bits:packet_fmt, 8bits:bytes_fmt or FMT_MAX if incorrect
+ * format was specified.
+ *
+ * N.B.:
+ *	1. "3pl" is the equivalent of "3pl,3pl";
+ *	2. ",3pl" is the equivalent of "def,3pl";
+ *	3. "3pl," is the equivalent of "3pl,def";
+ *	4. "," is the equivalent of "def,def";
+ *
+ */
+uint32_t nfacct_parse_format_options(const char *str)
+{
+	uint32_t ret = FMT_MAX;
+	size_t i = 0, j = 0, param_len = 0;
+	char buf[(MAX_FMT_LEN + 1) * 2], *ptr, *tmp;
+	enum nfacct_format fmt[2] = { FMT_MAX, FMT_MAX };
+
+	if (str == NULL || strlen(str) > ARRAY_SIZE(buf))
+		goto err;
+
+	tmp = strdup(str);
+	for (ptr = tmp; *ptr && i < ARRAY_SIZE(fmt); ptr++) {
+		if (strchr(",", *ptr)) {
+			if (!param_len) {
+				fmt[i] = FMT_DEFAULT;
+				i++;
+				continue;
+			}
+			if (param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+
+			buf[param_len] = '\0';
+			for (j = 0; j <= FMT_MAX &&
+				strncmp(buf,fmt_options[j],3) != 0; j++) { ; }
+			if (j >= FMT_MAX) {
+				/* syntax error, exit */
+				goto err_free;
+			}
+
+			fmt[i] = j;
+			i++;
+			param_len = 0;
+		} else {
+			/* regular character, copy to buffer */
+			if (param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+			buf[param_len++] = *ptr;
+		}
+	}
+	if (!param_len) {
+		fmt[i] = FMT_DEFAULT;
+	} else if (param_len < ARRAY_SIZE(buf)) {
+		buf[param_len] = '\0';
+		for (j = 0; j <= FMT_MAX &&
+			strncmp(buf, fmt_options[j], 3) != 0; j++) { ; }
+
+		if (j >= FMT_MAX) {
+			/* syntax error, exit */
+			goto err_free;
+		}
+		fmt[i] = j;
+	}
+
+	if (fmt[0] == FMT_MAX)
+		fmt[0] = fmt[1];
+
+	if (fmt[1] == FMT_MAX)
+		fmt[1] = fmt[0];
+
+	ret = (fmt[0] << 8) | fmt[1];
+
+err_free:
+	free(tmp);
+	if (i > 2 || j >= FMT_MAX)
+		ret = FMT_MAX;
+err:
+	return ret;
+}
+
+/* converts 'arg' to 64-bit unsigned long long */
+int get_uint64_t(uint64_t *val, const char *arg)
+{
+	uint64_t res;
+	char *ptr;
+
+	if (!arg || !*arg)
+		return -1;
+	errno = 0;
+	res = strtoull(arg, &ptr, 10);
+	if (!ptr || ptr == arg || *ptr || (res == ULLONG_MAX && errno))
+ 		return -1;
+ 	*val = res;
+ 	return 0;
+}
+
diff --git a/src/nfacct_utils.h b/src/nfacct_utils.h
new file mode 100644
index 0000000..1fb9648
--- /dev/null
+++ b/src/nfacct_utils.h
@@ -0,0 +1,29 @@
+/*
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ */
+
+#ifndef _NFACCT_UTILS_H_
+#define _NFACCT_UTILS_H_
+
+#include <libnetfilter_acct/libnetfilter_acct.h>
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
+#endif
+
+/* maximum length of a token */
+#define MAX_TOKEN_SIZE 256
+
+extern int nfacct_matches(const char *cmd, const char *pattern);
+extern int nfacct_parse_tokens(const char *str, const char *sep,
+				const size_t len, char *tokens[]);
+extern int nfacct_parse_tokens_length(const char *str, const char *sep,
+				const size_t len, size_t t_len[]);
+extern uint32_t nfacct_parse_format_options(const char *str);
+extern int get_uint64_t(uint64_t *val, const char *arg);
+
+#endif

