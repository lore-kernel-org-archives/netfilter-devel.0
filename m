From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: doc: escape minus sign in manpages
Date: Mon, 12 Jan 2009 07:07:43 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901120706460.21692@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr> <496A9E8A.10405@netfilter.org> <alpine.LSU.2.00.0901120339080.20867@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57276 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZALGHp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:07:45 -0500
In-Reply-To: <alpine.LSU.2.00.0901120339080.20867@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hm I noticed I still had something in my index that
puts back hyphens where they belong. Here goes:


parent fea74bf74ff524431ce65145f1523584edf99dc9 (v1.4.3-rc1-16-gfea74bf)
commit de2a83cb5022c429ccf1b852688481a0d8ad95e5
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jan 12 07:06:12 2009 +0100

doc: escape minus sign in manpage (2)

Addendum to previous patch.
---
 ip6tables.8.in |  125 +++++++++++++++++++++--------------------
 iptables.8.in  |  146 ++++++++++++++++++++++++------------------------
 2 files changed, 136 insertions(+), 135 deletions(-)

diff --git a/ip6tables.8.in b/ip6tables.8.in
index 3ca63d8..3d19a4c 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -28,13 +28,13 @@
 ip6tables - IPv6 packet filter administration
 .SH SYNOPSIS
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain
-rule\-specification\fP [\fIoptions...\fP]
+rule-specification\fP [\fIoptions...\fP]
 .PP
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP [\fIrulenum\fP]
-\fIrule\-specification\fP [\fIoptions...\fP]
+\fIrule-specification\fP [\fIoptions...\fP]
 .PP
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIrulenum
-rule\-specification\fP [\fIoptions...\fP]
+rule-specification\fP [\fIoptions...\fP]
 .PP
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-D\fP \fIchain rulenum\fP
 [\fIoptions...\fP]
@@ -51,7 +51,7 @@ rule\-specification\fP [\fIoptions...\fP]
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-P\fP \fIchain target\fP
 [\fIoptions...\fP]
 .PP
-\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-E\fP \fIold-chain-name new-chain-name\fP
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-E\fP \fIold-chain-name new-chain-name\fP
 .SH DESCRIPTION
 \fBIp6tables\fP is used to set up, maintain, and inspect the
 tables of IPv6 packet
@@ -91,7 +91,7 @@ There are currently three independent tables (which tables are present
 at any time depends on the kernel configuration options and which
 modules are present).
 .TP
-\fB-t\fP, \fB--table\fP \fItable\fP
+\fB\-t\fP, \fB\-\-table\fP \fItable\fP
 This option specifies the packet matching table which the command
 should operate on.  If the kernel is configured with automatic module
 loading, an attempt will be made to load the appropriate module for
@@ -101,7 +101,7 @@ The tables are as follows:
 .RS
 .TP .4i
 \fBfilter\fP:
-This is the default table (if no -t option is passed).  It contains
+This is the default table (if no \-t option is passed). It contains
 the built-in chains \fBINPUT\fP (for packets destined to local sockets),
 \fBFORWARD\fP (for packets being routed through the box), and
 \fBOUTPUT\fP (for locally-generated packets).
@@ -134,101 +134,102 @@ below.  For all the long versions of the command and option names, you
 need to use only enough letters to ensure that
 \fBip6tables\fP can differentiate it from all other options.
 .TP
-\fB-A\fP, \fB--append\fP \fIchain rule-specification\fP
+\fB\-A\fP, \fB\-\-append\fP \fIchain rule-specification\fP
 Append one or more rules to the end of the selected chain.
 When the source and/or destination names resolve to more than one
 address, a rule will be added for each possible address combination.
 .TP
-\fB-D\fP, \fB--delete\fP \fIchain rule-specification\fP
+\fB\-D\fP, \fB\-\-delete\fP \fIchain rule-specification\fP
 .ns
 .TP
-\fB-D\fP, \fB--delete\fP \fIchain rulenum\fP
+\fB\-D\fP, \fB\-\-delete\fP \fIchain rulenum\fP
 Delete one or more rules from the selected chain.  There are two
 versions of this command: the rule can be specified as a number in the
 chain (starting at 1 for the first rule) or a rule to match.
 .TP
-\fB-I\fP, \fB--insert\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
+\fB\-I\fP, \fB\-\-insert\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
 Insert one or more rules in the selected chain as the given rule
 number.  So, if the rule number is 1, the rule or rules are inserted
 at the head of the chain.  This is also the default if no rule number
 is specified.
 .TP
-\fB-R\fP, \fB--replace\fP \fIchain rulenum rule-specification\fP
+\fB\-R\fP, \fB\-\-replace\fP \fIchain rulenum rule-specification\fP
 Replace a rule in the selected chain.  If the source and/or
 destination names resolve to multiple addresses, the command will
 fail.  Rules are numbered starting at 1.
 .TP
-\fB-L\fP, \fB--list\fP [\fIchain\fP]
+\fB\-L\fP, \fB\-\-list\fP [\fIchain\fP]
 List all rules in the selected chain.  If no chain is selected, all
 chains are listed. Like every other ip6tables command, it applies to the
 specified table (filter is the default).
 .IP ""
-Please note that it is often used with the \fB-n\fP
+Please note that it is often used with the \fB\-n\fP
 option, in order to avoid long reverse DNS lookups.
-It is legal to specify the \fB-Z\fP
+It is legal to specify the \fB\-Z\fP
 (zero) option as well, in which case the chain(s) will be atomically
 listed and zeroed.  The exact output is affected by the other
 arguments given. The exact rules are suppressed until you use
 .nf
- ip6tables -L -v
+ ip6tables \-L \-v
 .fi
 .TP
-\fB-S\fP, \fB--list-rules\fP [\fIchain\fP]
+\fB\-S\fP, \fB\-\-list\-rules\fP [\fIchain\fP]
 Print all rules in the selected chain.  If no chain is selected, all
-chains are printed like ip6tables-save. Like every other ip6tables command,
+chains are printed like ip6tables\-save. Like every other ip6tables command,
 it applies to the specified table (filter is the default).
 .TP
-\fB-F\fP, \fB--flush\fP [\fIchain\fP]
+\fB\-F\fP, \fB\-\-flush\fP [\fIchain\fP]
 Flush the selected chain (all the chains in the table if none is given).
 This is equivalent to deleting all the rules one by one.
 .TP
-\fB-Z\fP, \fB--zero\fP [\fIchain\fP]
+\fB\-Z\fP, \fB\-\-zero\fP [\fIchain\fP]
 Zero the packet and byte counters in all chains.  It is legal to
 specify the
-\fB-L\fP, \fB--list\fP
+\fB\-L\fP, \fB\-\-list\fP
 (list) option as well, to see the counters immediately before they are
 cleared. (See above.)
 .TP
-\fB-N\fP, \fB--new-chain\fP \fIchain\fP
+\fB\-N\fP, \fB\-\-new\-chain\fP \fIchain\fP
 Create a new user-defined chain by the given name.  There must be no
 target of that name already.
 .TP
-\fB-X\fP, \fB--delete-chain\fP [\fIchain\fP]
+\fB\-X\fP, \fB\-\-delete\-chain\fP [\fIchain\fP]
 Delete the optional user-defined chain specified.  There must be no references
 to the chain.  If there are, you must delete or replace the referring rules
 before the chain can be deleted.  The chain must be empty, i.e. not contain
 any rules.  If no argument is given, it will attempt to delete every
 non-builtin chain in the table.
 .TP
-\fB-P\fP, \fB--policy\fP \fIchain target\fP
+\fB\-P\fP, \fB\-\-policy\fP \fIchain target\fP
 Set the policy for the chain to the given target.  See the section \fBTARGETS\fP
 for the legal targets.  Only built-in (non-user-defined) chains can have
 policies, and neither built-in nor user-defined chains can be policy
 targets.
 .TP
-\fB-E\fP, \fB--rename-chain\fP \fIold-chain new-chain\fP
+\fB\-E\fP, \fB\-\-rename\-chain\fP \fIold\-chain new\-chain\fP
 Rename the user specified chain to the user supplied name.  This is
 cosmetic, and has no effect on the structure of the table.
-.BI "-A, --append " "chain rule-specification"
+.TP
+\fB\-A\fP, \fB\-\-append\fP \fIchain rule-specification\fP
 Append one or more rules to the end of the selected chain.
 When the source and/or destination names resolve to more than one
 address, a rule will be added for each possible address combination.
 .TP
-.B -h
+\fB\-h\fP
 Help.
 Give a (currently very brief) description of the command syntax.
 .SS PARAMETERS
 The following parameters make up a rule specification (as used in the
 add, delete, insert, replace and append commands).
 .TP
-[\fB!\fP] \fB-p\fP, \fB--protocol\fP \fIprotocol\fP
+[\fB!\fP] \fB\-p\fP, \fB\-\-protocol\fP \fIprotocol\fP
 The protocol of the rule or of the packet to check.
 The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
 \fBicmpv6\fP, \fBesp\fP, \fBmh\fP or \fBall\fP,
 or it can be a numeric value, representing one of these protocols or a
 different one. A protocol name from /etc/protocols is also allowed.
 But IPv6 extension headers except \fBesp\fP are not allowed.
-\fBesp\fP and \fBipv6-nonext\fP
+\fBesp\fP and \fBipv6\-nonext\fP
 can be used with Kernel version 2.6.11 or later.
 A "!" argument before the protocol inverts the
 test.  The number zero is equivalent to \fBall\fP.
@@ -236,7 +237,7 @@ Protocol \fBall\fP
 will match with all protocols and is taken as default when this
 option is omitted.
 .TP
-[\fB!\fP] \fB-s\fP, \fB--source\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-s\fP, \fB\-\-source\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Source specification.
 \fIAddress\fP can be either a hostname (please note that specifying
 any name to be resolved with a remote query such as DNS is a really bad idea),
@@ -245,33 +246,33 @@ a network IPv6 address (with \fB/\fP\fImask\fP), or a plain IPv6 address.
 The \fImask\fP is a plain number,
 specifying the number of 1's at the left side of the network mask.
 A "!" argument before the address specification inverts the sense of
-the address. The flag \fB--src\fP
+the address. The flag \fB\-\-src\fP
 is an alias for this option.
 .TP
-[\fB!\fP] \fB-d\fP, \fB--destination\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-d\fP, \fB\-\-destination\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Destination specification. 
-See the description of the \fB-s\fP
+See the description of the \fB\-s\fP
 (source) flag for a detailed description of the syntax.  The flag
-\fB--dst\fP is an alias for this option.
+\fB\-\-dst\fP is an alias for this option.
 .TP
-\fB-j\fP, \fB--jump\fP \fItarget\fP
+\fB\-j\fP, \fB\-\-jump\fP \fItarget\fP
 This specifies the target of the rule; i.e., what to do if the packet
 matches it.  The target can be a user-defined chain (other than the
 one this rule is in), one of the special builtin targets which decide
 the fate of the packet immediately, or an extension (see \fBEXTENSIONS\fP
 below).  If this
-option is omitted in a rule (and \fB-g\fP
+option is omitted in a rule (and \fB\-g\fP
 is not used), then matching the rule will have no
 effect on the packet's fate, but the counters on the rule will be
 incremented.
 .TP
-\fB-g\fP, \fB--goto\fP \fIchain\fP
+\fB\-g\fP, \fB\-\-goto\fP \fIchain\fP
 This specifies that the processing should continue in a user
-specified chain. Unlike the --jump option return will not continue
+specified chain. Unlike the \-\-jump option return will not continue
 processing in this chain but instead in the chain that called us via
---jump.
+\-\-jump.
 .TP
-[\fB!\fP] \fB-i\fP, \fB--in-interface\fP \fIname\fP
+[\fB!\fP] \fB\-i\fP, \fB\-\-in\-interface\fP \fIname\fP
 Name of an interface via which a packet was received (only for
 packets entering the \fBINPUT\fP, \fBFORWARD\fP and \fBPREROUTING\fP
 chains).  When the "!" argument is used before the interface name, the
@@ -279,7 +280,7 @@ sense is inverted.  If the interface name ends in a "+", then any
 interface which begins with this name will match.  If this option is
 omitted, any interface name will match.
 .TP
-[\fB!\fP] \fB-o\fP, \fB--out-interface\fP \fIname\fP
+[\fB!\fP] \fB\-o\fP, \fB\-\-out\-interface\fP \fIname\fP
 Name of an interface via which a packet is going to be sent (for packets
 entering the \fBFORWARD\fP, \fBOUTPUT\fP and \fBPOSTROUTING\fP
 chains).  When the "!" argument is used before the interface name, the
@@ -288,58 +289,58 @@ interface which begins with this name will match.  If this option is
 omitted, any interface name will match.
 .\" Currently not supported (header-based)
 .\" .TP
-.\" [\fB!\fP] \fB-f\fP, \fB--fragment\fP
+.\" [\fB!\fP] \fB\-f\fP, \fB\-\-fragment\fP
 .\" This means that the rule only refers to second and further fragments
 .\" of fragmented packets.  Since there is no way to tell the source or
 .\" destination ports of such a packet (or ICMP type), such a packet will
 .\" not match any rules which specify them.  When the "!" argument
-.\" precedes the "-f" flag, the rule will only match head fragments, or
+.\" precedes the "\-f" flag, the rule will only match head fragments, or
 .\" unfragmented packets.
 .TP
-\fB-c\fP, \fB--set-counters\fP \fIpackets bytes\fP
+\fB\-c\fP, \fB\-\-set\-counters\fP \fIpackets bytes\fP
 This enables the administrator to initialize the packet and byte
 counters of a rule (during \fBINSERT\fP, \fBAPPEND\fP, \fBREPLACE\fP
 operations).
 .SS "OTHER OPTIONS"
 The following additional options can be specified:
 .TP
-\fB-v\fP, \fB--verbose\fP
+\fB\-v\fP, \fB\-\-verbose\fP
 Verbose output.  This option makes the list command show the interface
 name, the rule options (if any), and the TOS masks.  The packet and
 byte counters are also listed, with the suffix 'K', 'M' or 'G' for
 1000, 1,000,000 and 1,000,000,000 multipliers respectively (but see
-the \fB-x\fP flag to change this).
+the \fB\-x\fP flag to change this).
 For appending, insertion, deletion and replacement, this causes
 detailed information on the rule or rules to be printed.
 .TP
-\fB-n\fP, \fB--numeric\fP
+\fB\-n\fP, \fB\-\-numeric\fP
 Numeric output.
 IP addresses and port numbers will be printed in numeric format.
 By default, the program will try to display them as host names,
 network names, or services (whenever applicable).
 .TP
-\fB-x\fP, \fB--exact\fP
+\fB\-x\fP, \fB\-\-exact\fP
 Expand numbers.
 Display the exact value of the packet and byte counters,
 instead of only the rounded number in K's (multiples of 1000)
 M's (multiples of 1000K) or G's (multiples of 1000M).  This option is
-only relevant for the \fB-L\fP command.
+only relevant for the \fB\-L\fP command.
 .TP
-.B "--line-numbers"
+\fB\-\-line\-numbers\fP
 When listing rules, add line numbers to the beginning of each rule,
 corresponding to that rule's position in the chain.
 .TP
-\fB--modprobe=\fP\fIcommand\fP
+\fB\-\-modprobe=\fP\fIcommand\fP
 When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
 .SH MATCH EXTENSIONS
 ip6tables can use extended packet matching modules.  These are loaded
-in two ways: implicitly, when \fB-p\fP or \fB--protocol\fP
-is specified, or with the \fB-m\fP or \fB--match\fP
+in two ways: implicitly, when \fB\-p\fP or \fB\-\-protocol\fP
+is specified, or with the \fB\-m\fP or \fB\-\-match\fP
 options, followed by the matching module name; after these, various
 extra command line options become available, depending on the specific
 module.  You can specify multiple extended match modules in one line,
-and you can use the \fB-h\fP or \fB--help\fP
+and you can use the \fB\-h\fP or \fB\-\-help\fP
 options after the module has been specified to receive help specific
 to that module.
 .PP
@@ -368,18 +369,18 @@ passes through one of the three chains (except loopback traffic, which
 involves both INPUT and OUTPUT chains); previously a forwarded packet
 would pass through all three.
 .PP
-The other main difference is that \fB-i\fP refers to the input interface;
-\fB-o\fP refers to the output interface, and both are available for packets
+The other main difference is that \fB\-i\fP refers to the input interface;
+\fB\-o\fP refers to the output interface, and both are available for packets
 entering the \fBFORWARD\fP chain.
 There are several other changes in ip6tables.
 .SH SEE ALSO
-.BR ip6tables-save (8),
-.BR ip6tables-restore(8),
-.BR iptables (8),
-.BR iptables-save (8),
-.BR iptables-restore (8),
-.BR libipq (3).
-.P
+\fBip6tables\-save\fP(8),
+\fBip6tables\-restore\fP(8),
+\fBiptables\fP(8),
+\fBiptables\-save\fP(8),
+\fBiptables\-restore\fP(8),
+\fBlibipq\fP(3).
+.PP
 The packet-filtering-HOWTO details iptables usage for
 packet filtering,
 the netfilter-extensions-HOWTO details the extensions that are
diff --git a/iptables.8.in b/iptables.8.in
index 7754c8c..2bbd9a7 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -23,33 +23,33 @@
 .\"
 .\"
 .SH NAME
-iptables \- administration tool for IPv4 packet filtering and NAT
+iptables - administration tool for IPv4 packet filtering and NAT
 .SH SYNOPSIS
-\fBiptables\fP [\fB-t\fP \fItable\fP] {\fB-A\fP|\fB-D\fP} \fIchain\fP \fIrule-specification\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain\fP \fIrule-specification\fP
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-I\fP [\fIrulenum\fP] \fIrule-specification\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP [\fIrulenum\fP] \fIrule-specification\fP
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-R\fP \fIrulenum rule-specification\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIrulenum rule-specification\fP
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-D\fP \fIchain rulenum\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-D\fP \fIchain rulenum\fP
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-S\fP [\fIchain\fP]
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP]
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
+\fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-F\fP|\fB\-L\fP|\fB\-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-N\fP \fIchain\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-N\fP \fIchain\fP
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-X\fP [\fIchain\fP]
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-X\fP [\fIchain\fP]
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-P\fP \fIchain target\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-P\fP \fIchain target\fP
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-E\fP \fIold-chain-name new-chain-name\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-E\fP \fIold-chain-name new-chain-name\fP
 .PP
 rule-specification = [\fImatches...\fP] [\fItarget\fP]
 .PP
-match = \fB-m\fP \fImatchname\fP [\fIper-match-options\fP]
+match = \fB\-m\fP \fImatchname\fP [\fIper-match-options\fP]
 .PP
-target = \fB-j\fP \fItargetname\fP [\fIper-target-options\fP]
+target = \fB\-j\fP \fItargetname\fP [\fIper\-target\-options\fP]
 .SH DESCRIPTION
 \fBIptables\fP is used to set up, maintain, and inspect the
 tables of IPv4 packet
@@ -89,7 +89,7 @@ There are currently three independent tables (which tables are present
 at any time depends on the kernel configuration options and which
 modules are present).
 .TP
-\fB-t\fP, \fB--table\fP \fItable\fP
+\fB\-t\fP, \fB\-\-table\fP \fItable\fP
 This option specifies the packet matching table which the command
 should operate on.  If the kernel is configured with automatic module
 loading, an attempt will be made to load the appropriate module for
@@ -99,7 +99,7 @@ The tables are as follows:
 .RS
 .TP .4i
 \fBfilter\fP:
-This is the default table (if no -t option is passed).  It contains
+This is the default table (if no \-t option is passed). It contains
 the built-in chains \fBINPUT\fP (for packets destined to local sockets),
 \fBFORWARD\fP (for packets being routed through the box), and
 \fBOUTPUT\fP (for locally-generated packets).
@@ -139,92 +139,92 @@ below. For long versions of the command and option names, you
 need to use only enough letters to ensure that
 \fBiptables\fP can differentiate it from all other options.
 .TP
-\fB-A\fP, \fB--append\fP \fIchain rule-specification\fP
+\fB\-A\fP, \fB\-\-append\fP \fIchain rule-specification\fP
 Append one or more rules to the end of the selected chain.
 When the source and/or destination names resolve to more than one
 address, a rule will be added for each possible address combination.
 .TP
-\fB-D\fP, \fB--delete\fP \fIchain rule-specification\fP
+\fB\-D\fP, \fB\-\-delete\fP \fIchain rule-specification\fP
 .ns
 .TP
-\fB-D\fP, \fB--delete\fP \fIchain rulenum\fP
+\fB\-D\fP, \fB\-\-delete\fP \fIchain rulenum\fP
 Delete one or more rules from the selected chain.  There are two
 versions of this command: the rule can be specified as a number in the
 chain (starting at 1 for the first rule) or a rule to match.
 .TP
-\fB-I\fP, \fB--insert\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
+\fB\-I\fP, \fB\-\-insert\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
 Insert one or more rules in the selected chain as the given rule
 number.  So, if the rule number is 1, the rule or rules are inserted
 at the head of the chain.  This is also the default if no rule number
 is specified.
 .TP
-\fB-R\fP, \fB--replace\fP \fIchain rulenum rule-specification\fP
+\fB\-R\fP, \fB\-\-replace\fP \fIchain rulenum rule-specification\fP
 Replace a rule in the selected chain.  If the source and/or
 destination names resolve to multiple addresses, the command will
 fail.  Rules are numbered starting at 1.
 .TP
-\fB-L\fP, \fB--list\fP [\fIchain\fP]
+\fB\-L\fP, \fB\-\-list\fP [\fIchain\fP]
 List all rules in the selected chain.  If no chain is selected, all
 chains are listed. Like every other iptables command, it applies to the
 specified table (filter is the default), so NAT rules get listed by
 .nf
- iptables -t nat -n -L
+ iptables \-t nat \-n \-L
 .fi
-Please note that it is often used with the \fB-n\fP
+Please note that it is often used with the \fB\-n\fP
 option, in order to avoid long reverse DNS lookups.
-It is legal to specify the \fB-Z\fP
+It is legal to specify the \fB\-Z\fP
 (zero) option as well, in which case the chain(s) will be atomically
 listed and zeroed.  The exact output is affected by the other
 arguments given. The exact rules are suppressed until you use
 .nf
- iptables -L -v
+ iptables \-L \-v
 .fi
 .TP
-\fB-S\fP, \fB--list-rules\fP [\fIchain\fP]
+\fB\-S\fP, \fB\-\-list\-rules\fP [\fIchain\fP]
 Print all rules in the selected chain.  If no chain is selected, all
-chains are printed like iptables-save. Like every other iptables command,
+chains are printed like iptables\-save. Like every other iptables command,
 it applies to the specified table (filter is the default).
 .TP
-\fB-F\fP, \fB--flush\fP [\fIchain\fP]
+\fB\-F\fP, \fB\-\-flush\fP [\fIchain\fP]
 Flush the selected chain (all the chains in the table if none is given).
 This is equivalent to deleting all the rules one by one.
 .TP
-\fB-Z\fP, \fB--zero\fP [\fIchain\fP]
+\fB\-Z\fP, \fB\-\-zero\fP [\fIchain\fP]
 Zero the packet and byte counters in all chains.  It is legal to
 specify the
-\fB-L\fP, \fB--list\fP
+\fB\-L\fP, \fB\-\-list\fP
 (list) option as well, to see the counters immediately before they are
 cleared. (See above.)
 .TP
-\fB-N\fP, \fB--new-chain\fP \fIchain\fP
+\fB\-N\fP, \fB\-\-new\-chain\fP \fIchain\fP
 Create a new user-defined chain by the given name.  There must be no
 target of that name already.
 .TP
-\fB-X\fP, \fB--delete-chain\fP [\fIchain\fP]
+\fB\-X\fP, \fB\-\-delete\-chain\fP [\fIchain\fP]
 Delete the optional user-defined chain specified.  There must be no references
 to the chain.  If there are, you must delete or replace the referring rules
 before the chain can be deleted.  The chain must be empty, i.e. not contain
 any rules.  If no argument is given, it will attempt to delete every
 non-builtin chain in the table.
 .TP
-\fB-P\fP, \fB--policy\fP \fIchain target\fP
+\fB\-P\fP, \fB\-\-policy\fP \fIchain target\fP
 Set the policy for the chain to the given target.  See the section \fBTARGETS\fP
 for the legal targets.  Only built-in (non-user-defined) chains can have
 policies, and neither built-in nor user-defined chains can be policy
 targets.
 .TP
-\fB-E\fP, \fB--rename-chain\fP \fIold-chain new-chain\fP
+\fB\-E\fP, \fB\-\-rename\-chain\fP \fIold\-chain new\-chain\fP
 Rename the user specified chain to the user supplied name.  This is
 cosmetic, and has no effect on the structure of the table.
 .TP
-.B -h
+\fB\-\h\fP
 Help.
 Give a (currently very brief) description of the command syntax.
 .SS PARAMETERS
 The following parameters make up a rule specification (as used in the
 add, delete, insert, replace and append commands).
 .TP
-[\fB!\fP] \fB-p\fP, \fB--protocol\fP \fIprotocol\fP
+[\fB!\fP] \fB\-p\fP, \fB\-\-protocol\fP \fIprotocol\fP
 The protocol of the rule or of the packet to check.
 The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
 \fBicmp\fP, \fBesp\fP, \fBah\fP, \fBsctp\fP or \fBall\fP,
@@ -236,7 +236,7 @@ Protocol \fBall\fP
 will match with all protocols and is taken as default when this
 option is omitted.
 .TP
-[\fB!\fP] \fB-s\fP, \fB--source\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-s\fP, \fB\-\-source\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Source specification. \fIAddress\fP
 can be either a network name, a hostname (please note that specifying
 any name to be resolved with a remote query such as DNS is a really bad idea),
@@ -246,32 +246,32 @@ can be either a network mask or a plain number,
 specifying the number of 1's at the left side of the network mask.
 Thus, a mask of \fI24\fP is equivalent to \fI255.255.255.0\fP.
 A "!" argument before the address specification inverts the sense of
-the address. The flag \fB--src\fP is an alias for this option.
+the address. The flag \fB\-\-src\fP is an alias for this option.
 .TP
-[\fB!\fP] \fB-d\fP, \fB--destination\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-d\fP, \fB\-\-destination\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Destination specification. 
-See the description of the \fB-s\fP
+See the description of the \fB\-s\fP
 (source) flag for a detailed description of the syntax.  The flag
-\fB--dst\fP is an alias for this option.
+\fB\-\-dst\fP is an alias for this option.
 .TP
-\fB-j\fP, \fB--jump\fP \fItarget\fP
+\fB\-j\fP, \fB\-\-jump\fP \fItarget\fP
 This specifies the target of the rule; i.e., what to do if the packet
 matches it.  The target can be a user-defined chain (other than the
 one this rule is in), one of the special builtin targets which decide
 the fate of the packet immediately, or an extension (see \fBEXTENSIONS\fP
 below).  If this
-option is omitted in a rule (and \fB-g\fP
+option is omitted in a rule (and \fB\-g\fP
 is not used), then matching the rule will have no
 effect on the packet's fate, but the counters on the rule will be
 incremented.
 .TP
-\fB-g\fP, \fB--goto\fP \fIchain\fP
+\fB\-g\fP, \fB\-\-goto\fP \fIchain\fP
 This specifies that the processing should continue in a user
-specified chain. Unlike the --jump option return will not continue
+specified chain. Unlike the \-\-jump option return will not continue
 processing in this chain but instead in the chain that called us via
---jump.
+\-\-jump.
 .TP
-[\fB!\fP] \fB-i\fP, \fB--in-interface\fP \fIname\fP
+[\fB!\fP] \fB\-i\fP, \fB\-\-in\-interface\fP \fIname\fP
 Name of an interface via which a packet was received (only for
 packets entering the \fBINPUT\fP, \fBFORWARD\fP and \fBPREROUTING\fP
 chains).  When the "!" argument is used before the interface name, the
@@ -279,7 +279,7 @@ sense is inverted.  If the interface name ends in a "+", then any
 interface which begins with this name will match.  If this option is
 omitted, any interface name will match.
 .TP
-[\fB!\fP] \fB-o\fP, \fB--out-interface\fP \fIname\fP
+[\fB!\fP] \fB\-o\fP, \fB\-\-out\-interface\fP \fIname\fP
 Name of an interface via which a packet is going to be sent (for packets
 entering the \fBFORWARD\fP, \fBOUTPUT\fP and \fBPOSTROUTING\fP
 chains).  When the "!" argument is used before the interface name, the
@@ -287,58 +287,58 @@ sense is inverted.  If the interface name ends in a "+", then any
 interface which begins with this name will match.  If this option is
 omitted, any interface name will match.
 .TP
-[\fB!\fP] \fB-f\fP, \fB--fragment\fP
+[\fB!\fP] \fB\-f\fP, \fB\-\-fragment\fP
 This means that the rule only refers to second and further fragments
 of fragmented packets.  Since there is no way to tell the source or
 destination ports of such a packet (or ICMP type), such a packet will
 not match any rules which specify them.  When the "!" argument
-precedes the "-f" flag, the rule will only match head fragments, or
+precedes the "\-f" flag, the rule will only match head fragments, or
 unfragmented packets.
 .TP
-\fB-c\fP, \fB--set-counters\fP \fIpackets bytes\fP
+\fB\-c\fP, \fB\-\-set\-counters\fP \fIpackets bytes\fP
 This enables the administrator to initialize the packet and byte
 counters of a rule (during \fBINSERT\fP, \fBAPPEND\fP, \fBREPLACE\fP
 operations).
 .SS "OTHER OPTIONS"
 The following additional options can be specified:
 .TP
-\fB-v\fP, \fB--verbose\fP
+\fB\-v\fP, \fB\-\-verbose\fP
 Verbose output.  This option makes the list command show the interface
 name, the rule options (if any), and the TOS masks.  The packet and
 byte counters are also listed, with the suffix 'K', 'M' or 'G' for
 1000, 1,000,000 and 1,000,000,000 multipliers respectively (but see
-the \fB-x\fP flag to change this).
+the \fB\-x\fP flag to change this).
 For appending, insertion, deletion and replacement, this causes
 detailed information on the rule or rules to be printed.
 .TP
-\fB-n\fP, \fB--numeric\fP
+\fB\-n\fP, \fB\-\-numeric\fP
 Numeric output.
 IP addresses and port numbers will be printed in numeric format.
 By default, the program will try to display them as host names,
 network names, or services (whenever applicable).
 .TP
-\fB-x\fP, \fB--exact\fP
+\fB\-x\fP, \fB\-\-exact\fP
 Expand numbers.
 Display the exact value of the packet and byte counters,
 instead of only the rounded number in K's (multiples of 1000)
 M's (multiples of 1000K) or G's (multiples of 1000M).  This option is
-only relevant for the \fB-L\fP command.
+only relevant for the \fB\-L\fP command.
 .TP
-.B "--line-numbers"
+\fB\-\-line\-numbers\fP
 When listing rules, add line numbers to the beginning of each rule,
 corresponding to that rule's position in the chain.
 .TP
-\fB--modprobe=\fP\fIcommand\fP
+\fB\-\-modprobe=\fP\fIcommand\fP
 When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
 .SH MATCH EXTENSIONS
 iptables can use extended packet matching modules.  These are loaded
-in two ways: implicitly, when \fB-p\fP or \fB--protocol\fP
-is specified, or with the \fB-m\fP or \fB--match\fP
+in two ways: implicitly, when \fB\-p\fP or \fB\-\-protocol\fP
+is specified, or with the \fB\-m\fP or \fB\-\-match\fP
 options, followed by the matching module name; after these, various
 extra command line options become available, depending on the specific
 module.  You can specify multiple extended match modules in one line,
-and you can use the \fB-h\fP or \fB--help\fP
+and you can use the \fB\-h\fP or \fB\-\-help\fP
 options after the module has been specified to receive help specific
 to that module.
 .PP
@@ -367,8 +367,8 @@ passes through one of the three chains (except loopback traffic, which
 involves both INPUT and OUTPUT chains); previously a forwarded packet
 would pass through all three.
 .PP
-The other main difference is that \fB-i\fP refers to the input interface;
-\fB-o\fP refers to the output interface, and both are available for packets
+The other main difference is that \fB\-i\fP refers to the input interface;
+\fB\-o\fP refers to the output interface, and both are available for packets
 entering the \fBFORWARD\fP chain.
 .PP
 The various forms of NAT have been separated out; \fBiptables\fP
@@ -377,19 +377,19 @@ optional extension modules.  This should simplify much of the previous
 confusion over the combination of IP masquerading and packet filtering
 seen previously.  So the following options are handled differently:
 .nf
- -j MASQ
- -M -S
- -M -L
+ \-j MASQ
+ \-M \-S
+ \-M \-L
 .fi
 There are several other changes in iptables.
 .SH SEE ALSO
-.BR iptables-save (8),
-.BR iptables-restore (8),
-.BR ip6tables (8),
-.BR ip6tables-save (8),
-.BR ip6tables-restore (8),
-.BR libipq (3).
-.P
+\fBiptables\-save\fP(8),
+\fBiptables\-restore\fP(8),
+\fBip6tables\fP(8),
+\fBip6tables\-save\fP(8),
+\fBip6tables\-restore\fP(8),
+\fBlibipq\fP(3).
+.PP
 The packet-filtering-HOWTO details iptables usage for
 packet filtering, the NAT-HOWTO details NAT,
 the netfilter-extensions-HOWTO details the extensions that are
-- 
# Created with git-export-patch
