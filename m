From: Jan Engelhardt <jengelh@medozas.de>
Subject: manpages: various updates
Date: Thu, 3 Jul 2008 20:16:29 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807032016150.23294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58258 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbYGCSQb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:16:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

#patch 3/3

commit feff2b3b0bb0de9b9d8b410713d24365e79cca03
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jul 3 20:11:47 2008 +0200

    manpages: various updates
    
    - synchronized iptables--ip6tbales manpages
    - -S option, list of chain names, protocol names
    - markup updates
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.8.in |  319 ++++++++++++++++++------------------------------
 iptables.8.in  |  296 ++++++++++++++++----------------------------
 2 files changed, 225 insertions(+), 390 deletions(-)

diff --git a/ip6tables.8.in b/ip6tables.8.in
index f5d33db..666616d 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -1,4 +1,4 @@
-.TH IP6TABLES 8 "Jan 22, 2006" "" ""
+.TH IP6TABLES 8 "Jul 03, 2008" "" ""
 .\"
 .\" Man page written by Andras Kis-Szabo <kisza@sch.bme.hu>
 .\" It is based on iptables man page.
@@ -27,26 +27,28 @@
 .SH NAME
 ip6tables \- IPv6 packet filter administration
 .SH SYNOPSIS
-.BR "ip6tables [-t table] -[AD] " "chain rule-specification [options]"
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB]\fP {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
 .br
-.BR "ip6tables [-t table] -I " "chain [rulenum] rule-specification [options]"
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
 .br
-.BR "ip6tables [-t table] -R " "chain rulenum rule-specification [options]"
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
 .br
-.BR "ip6tables [-t table] -D " "chain rulenum [options]"
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -D\fP \fIchain rulenum\fP [\fIoptions...\fP]
 .br
-.BR "ip6tables [-t table] -[LFZ] " "[chain] [options]"
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -S\fP [\fIchain\fP]
 .br
-.BR "ip6tables [-t table] -N " "chain"
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB]\fP {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
 .br
-.BR "ip6tables [-t table] -X " "[chain]"
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -N\fP \fIchain\fP
 .br
-.BR "ip6tables [-t table] -P " "chain target [options]"
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -X\fP [\fIchain\fP]
 .br
-.BR "ip6tables [-t table] -E " "old-chain-name new-chain-name"
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -P\fP \fIchain target\fP [\fIoptions...\fP]
+.br
+\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -E\fP \fIold-chain-name new-chain-name\fP
 .SH DESCRIPTION
-.B Ip6tables
-is used to set up, maintain, and inspect the tables of IPv6 packet
+\fBIp6tables\fP is used to set up, maintain, and inspect the
+tables of IPv6 packet
 filter rules in the Linux kernel.  Several different tables
 may be defined.  Each table contains a number of built-in
 chains and may also contain user-defined chains.
@@ -57,48 +59,34 @@ a `target', which may be a jump to a user-defined chain in the same
 table.
 
 .SH TARGETS
-A firewall rule specifies criteria for a packet, and a target.  If the
+A firewall rule specifies criteria for a packet and a target.  If the
 packet does not match, the next rule in the chain is the examined; if
 it does match, then the next rule is specified by the value of the
 target, which can be the name of a user-defined chain or one of the
-special values 
-.IR ACCEPT ,
-.IR DROP ,
-.IR QUEUE ,
-or
-.IR RETURN .
+special values \fBACCEPT\fP, \fBDROP\fP, \fBQUEUE\fP or \fBRETURN\fP.
 .PP
-.I ACCEPT 
-means to let the packet through.
-.I DROP
-means to drop the packet on the floor.
-.I QUEUE
-means to pass the packet to userspace.  (How the packet can be received
+\fBACCEPT\fP means to let the packet through.
+\fBDROP\fP means to drop the packet on the floor.
+\fBQUEUE\fP means to pass the packet to userspace.
+(How the packet can be received
 by a userspace process differs by the particular queue handler.  2.4.x
-and 2.6.x kernels up to 2.6.13 include the 
-.B
-ip_queue
-queue handler.  Kernels 2.6.14 and later additionally include the 
-.B
-nfnetlink_queue
-queue handler.  Packets with a target of QUEUE will be sent to queue number '0'
-in this case. Please also see the
-.B
-NFQUEUE
+and 2.6.x kernels up to 2.6.13 include the \fBip_queue\fP
+queue handler.  Kernels 2.6.14 and later additionally include the
+\fBnfnetlink_queue\fP queue handler.  Packets with a target of QUEUE will be
+sent to queue number '0' in this case. Please also see the \fBNFQUEUE\fP
 target as described later in this man page.)
-.I RETURN
-means stop traversing this chain and resume at the next rule in the
+\fBRETURN\fP means stop traversing this chain and resume at the next
+rule in the
 previous (calling) chain.  If the end of a built-in chain is reached
-or a rule in a built-in chain with target
-.I RETURN
+or a rule in a built-in chain with target \fBRETURN\fP
 is matched, the target specified by the chain policy determines the
 fate of the packet.
 .SH TABLES
-There are currently two independent tables (which tables are present
+There are currently three independent tables (which tables are present
 at any time depends on the kernel configuration options and which
-modules are present), as nat table has not been implemented yet.
+modules are present).
 .TP
-.BI "-t, --table " "table"
+\fB-t\fP, \fB--table\fP \fItable\fP
 This option specifies the packet matching table which the command
 should operate on.  If the kernel is configured with automatic module
 loading, an attempt will be made to load the appropriate module for
@@ -107,132 +95,121 @@ that table if it is not already there.
 The tables are as follows:
 .RS
 .TP .4i
-.BR "filter" :
+\fBfilter\fP:
 This is the default table (if no -t option is passed).  It contains
-the built-in chains
-.B INPUT
-(for packets coming into the box itself),
-.B FORWARD
-(for packets being routed through the box), and
-.B OUTPUT
-(for locally-generated packets).
+the built-in chains \fBINPUT\fP (for packets destined to local sockets),
+\fBFORWARD\fP (for packets being routed through the box), and
+\fBOUTPUT\fP (for locally-generated packets).
 .TP
-.BR "mangle" :
+\fBmangle\fP:
 This table is used for specialized packet alteration.  Until kernel
-2.4.17 it had two built-in chains:
-.B PREROUTING
-(for altering incoming packets before routing) and
-.B OUTPUT
+2.4.17 it had two built-in chains: \fBPREROUTING\fP
+(for altering incoming packets before routing) and \fBOUTPUT\fP
 (for altering locally-generated packets before routing).
 Since kernel 2.4.18, three other built-in chains are also supported:
-.B INPUT
-(for packets coming into the box itself),
-.B FORWARD
-(for altering packets being routed through the box), and
-.B POSTROUTING
+\fBINPUT\fP (for packets coming into the box itself), \fBFORWARD\fP
+(for altering packets being routed through the box), and \fBPOSTROUTING\fP
 (for altering packets as they are about to go out).
 .TP
-.BR "raw" :
+\fBraw\fP:
 This table is used mainly for configuring exemptions from connection
 tracking in combination with the NOTRACK target.  It registers at the netfilter
-hooks with higher priority and is thus called before nf_conntrack, or any other
-IP6 tables.  It provides the following built-in chains:
-.B PREROUTING
-(for packets arriving via any network interface)
-.B OUTPUT
+hooks with higher priority and is thus called before ip_conntrack, or any other
+IP tables.  It provides the following built-in chains: \fBPREROUTING\fP
+(for packets arriving via any network interface) \fBOUTPUT\fP
 (for packets generated by local processes)
 .RE
 .SH OPTIONS
 The options that are recognized by
-.B ip6tables
-can be divided into several different groups.
+\fBip6tables\fP can be divided into several different groups.
 .SS COMMANDS
 These options specify the specific action to perform.  Only one of them
 can be specified on the command line unless otherwise specified
 below.  For all the long versions of the command and option names, you
 need to use only enough letters to ensure that
-.B ip6tables
-can differentiate it from all other options.
+\fBip6tables\fP can differentiate it from all other options.
 .TP
-.BI "-A, --append " "chain rule-specification"
+\fB-A\fP, \fB--append\fP \fIchain rule-specification\fP
 Append one or more rules to the end of the selected chain.
 When the source and/or destination names resolve to more than one
 address, a rule will be added for each possible address combination.
 .TP
-.BI "-D, --delete " "chain rule-specification"
+\fB-D\fP, \fB--delete\fP \fIchain rule-specification\fP
 .ns
 .TP
-.BI "-D, --delete " "chain rulenum"
+\fB-D\fP, \fB--delete\fP \fIchain rulenum\fP
 Delete one or more rules from the selected chain.  There are two
 versions of this command: the rule can be specified as a number in the
 chain (starting at 1 for the first rule) or a rule to match.
 .TP
-.B "-I, --insert"
+\fB-I\fP, \fB--insert\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
 Insert one or more rules in the selected chain as the given rule
 number.  So, if the rule number is 1, the rule or rules are inserted
 at the head of the chain.  This is also the default if no rule number
 is specified.
 .TP
-.BI "-R, --replace " "chain rulenum rule-specification"
+\fB-R\fP, \fB--replace\fP \fIchain rulenum rule-specification\fP
 Replace a rule in the selected chain.  If the source and/or
 destination names resolve to multiple addresses, the command will
 fail.  Rules are numbered starting at 1.
 .TP
-.BR "-L, --list " "[\fIchain\fP]"
+\fB-L\fP, \fB--list\fP [\fIchain\fP]
 List all rules in the selected chain.  If no chain is selected, all
-chains are listed.  As every other iptables command, it applies to the
-specified table (filter is the default), so mangle rules get listed by
+chains are listed. Like every other iptables command, it applies to the
+specified table (filter is the default), so NAT rules get listed by
 .nf
- ip6tables -t mangle -n -L
+ iptables -t nat -n -L
 .fi
-Please note that it is often used with the
-.B -n
+Please note that it is often used with the \fB-n\fP
 option, in order to avoid long reverse DNS lookups.
-It is legal to specify the
-.B -Z
+It is legal to specify the \fB-Z\fP
 (zero) option as well, in which case the chain(s) will be atomically
 listed and zeroed.  The exact output is affected by the other
 arguments given. The exact rules are suppressed until you use
 .nf
- ip6tables -L -v
+ iptables -L -v
 .fi
 .TP
-.BR "-S, --list-rules " "[\fIchain\fP]"
+\fB-S\fP, \fB--list-rules\fP [\fIchain\fP]
 Print all rules in the selected chain.  If no chain is selected, all
 chains are printed like iptables-save. Like every other iptables command,
 it applies to the specified table (filter is the default).
 .TP
-.BR "-F, --flush " "[\fIchain\fP]"
+\fB-F\fP, \fB--flush\fP [\fIchain\fP]
 Flush the selected chain (all the chains in the table if none is given).
 This is equivalent to deleting all the rules one by one.
 .TP
-.BR "-Z, --zero " "[\fIchain\fP]"
+\fB-Z\fP, \fB--zero\fP [\fIchain\fP]
 Zero the packet and byte counters in all chains.  It is legal to
 specify the
-.B "-L, --list"
+\fB-L\fP, \fB--list\fP
 (list) option as well, to see the counters immediately before they are
 cleared. (See above.)
 .TP
-.BI "-N, --new-chain " "chain"
+\fB-N\fP, \fB--new-chain\fP \fIchain\fP
 Create a new user-defined chain by the given name.  There must be no
 target of that name already.
 .TP
-.BR "-X, --delete-chain " "[\fIchain\fP]"
+\fB-X\fP, \fB--delete-chain\fP [\fIchain\fP]
 Delete the optional user-defined chain specified.  There must be no references
-to the chain.  If there are, you must delete or replace the referring
-rules before the chain can be deleted.  If no argument is given, it
-will attempt to delete every non-builtin chain in the table.
+to the chain.  If there are, you must delete or replace the referring rules
+before the chain can be deleted.  The chain must be empty, i.e. not contain
+any rules.  If no argument is given, it will attempt to delete every
+non-builtin chain in the table.
 .TP
-.BI "-P, --policy " "chain target"
-Set the policy for the chain to the given target.  See the section
-.B TARGETS
+\fB-P\fP, \fB--policy\fP \fIchain target\fP
+Set the policy for the chain to the given target.  See the section \fBTARGETS\fP
 for the legal targets.  Only built-in (non-user-defined) chains can have
 policies, and neither built-in nor user-defined chains can be policy
 targets.
 .TP
-.BI "-E, --rename-chain " "old-chain new-chain"
+\fB-E\fP, \fB--rename-chain\fP \fIold-chain new-chain\fP
 Rename the user specified chain to the user supplied name.  This is
 cosmetic, and has no effect on the structure of the table.
+.BI "-A, --append " "chain rule-specification"
+Append one or more rules to the end of the selected chain.
+When the source and/or destination names resolve to more than one
+address, a rule will be added for each possible address combination.
 .TP
 .B -h
 Help.
@@ -241,179 +218,130 @@ Give a (currently very brief) description of the command syntax.
 The following parameters make up a rule specification (as used in the
 add, delete, insert, replace and append commands).
 .TP
-.BR "-p, --protocol " "[!] \fIprotocol\fP"
+[\fB!\fP] \fB-p\fP, \fB--protocol\fP \fIprotocol\fP
 The protocol of the rule or of the packet to check.
-The specified protocol can be one of
-.IR tcp ,
-.IR udp ,
-.IR icmpv6 ,
-.IR esp ,
-.IR all ,
+The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
+\fBicmpv6\fP, \fBesp\fP, \fBmh\fP or \fBall\fP,
 or it can be a numeric value, representing one of these protocols or a
 different one. A protocol name from /etc/protocols is also allowed.
-But IPv6 extension headers except
-.IR esp
-are not allowed.
-.IR esp ,
-and
-.IR ipv6-nonext
+But IPv6 extension headers except \fBesp\fP are not allowed.
+\fBesp\fP and \fBipv6-nonext\fP
 can be used with Kernel version 2.6.11 or later.
 A "!" argument before the protocol inverts the
-test.  The number zero is equivalent to
-.IR all .
-Protocol
-.I all
+test.  The number zero is equivalent to \fBall\fP.
+Protocol \fBall\fP
 will match with all protocols and is taken as default when this
 option is omitted.
 .TP
-.BR "-s, --source " "[!] \fIaddress\fP[/\fImask\fP]"
+[\fB!\fP] \fB-s\fP, \fB--source\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Source specification.
-.I Address
-can be either a hostname (please note that specifying
+\fIAddress\fP can be either a hostname (please note that specifying
 any name to be resolved with a remote query such as DNS is a really bad idea),
-a network IPv6 address (with /mask), or a plain IPv6 address.
+a network IPv6 address (with \fB/\fP\fImask\fP), or a plain IPv6 address.
 (the network name isn't supported now).
-The
-.I mask
-can be either a network mask or a plain number,
+The \fImask\fP is a plain number,
 specifying the number of 1's at the left side of the network mask.
-Thus, a mask of
-.I 64
-is equivalent to
-.IR ffff:ffff:ffff:ffff:0000:0000:0000:0000 .
 A "!" argument before the address specification inverts the sense of
-the address. The flag
-.B --src
+the address. The flag \fB--src\fP
 is an alias for this option.
 .TP
-.BR "-d, --destination " "[!] \fIaddress\fP[/\fImask\fP]"
+[\fB!\fP] \fB-d\fP, \fB--destination\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Destination specification. 
-See the description of the
-.B -s
+See the description of the \fB-s\fP
 (source) flag for a detailed description of the syntax.  The flag
-.B --dst
-is an alias for this option.
+\fB--dst\fP is an alias for this option.
 .TP
-.BI "-j, --jump " "target"
+\fB-j\fP, \fB--jump\fP \fItarget\fP
 This specifies the target of the rule; i.e., what to do if the packet
 matches it.  The target can be a user-defined chain (other than the
 one this rule is in), one of the special builtin targets which decide
-the fate of the packet immediately, or an extension (see
-.B EXTENSIONS
+the fate of the packet immediately, or an extension (see \fBEXTENSIONS\fP
 below).  If this
-option is omitted in a rule (and
-.B -g
+option is omitted in a rule (and \fB-g\fP
 is not used), then matching the rule will have no
 effect on the packet's fate, but the counters on the rule will be
 incremented.
 .TP
-.BI "-g, --goto " "chain"
+\fB-g\fP, \fB--goto\fP \fIchain\fP
 This specifies that the processing should continue in a user
 specified chain. Unlike the --jump option return will not continue
 processing in this chain but instead in the chain that called us via
 --jump.
 .TP
-.BR "-i, --in-interface " "[!] \fIname\fP"
-Name of an interface via which a packet is going to be received (only for
-packets entering the 
-.BR INPUT ,
-.B FORWARD
-and
-.B PREROUTING
+[\fB!\fP] \fB-i\fP, \fB--in-interface\fP \fIname\fP
+Name of an interface via which a packet was received (only for
+packets entering the \fBINPUT\fP, \fBFORWARD\fP and \fBPREROUTING\fP
 chains).  When the "!" argument is used before the interface name, the
 sense is inverted.  If the interface name ends in a "+", then any
 interface which begins with this name will match.  If this option is
 omitted, any interface name will match.
 .TP
-.BR "-o, --out-interface " "[!] \fIname\fP"
+[\fB!\fP] \fB-o\fP, \fB--out-interface\fP \fIname\fP
 Name of an interface via which a packet is going to be sent (for packets
-entering the
-.BR FORWARD 
-and
-.B OUTPUT
+entering the \fBFORWARD\fP, \fBOUTPUT\fP and \fBPOSTROUTING\fP
 chains).  When the "!" argument is used before the interface name, the
 sense is inverted.  If the interface name ends in a "+", then any
 interface which begins with this name will match.  If this option is
 omitted, any interface name will match.
-.TP
 .\" Currently not supported (header-based)
-.\" 
-.\" .B "[!] " "-f, --fragment"
+.\" .TP
+.\" [\fB!\fP] \fB-f\fP, \fB--fragment\fP
 .\" This means that the rule only refers to second and further fragments
 .\" of fragmented packets.  Since there is no way to tell the source or
 .\" destination ports of such a packet (or ICMP type), such a packet will
 .\" not match any rules which specify them.  When the "!" argument
 .\" precedes the "-f" flag, the rule will only match head fragments, or
 .\" unfragmented packets.
-.\" .TP
-.B "-c, --set-counters " "PKTS BYTES"
+.TP
+\fB-c\fP, \fB--set-counters\fP \fIpackets bytes\fP
 This enables the administrator to initialize the packet and byte
-counters of a rule (during
-.B INSERT,
-.B APPEND,
-.B REPLACE
+counters of a rule (during \fBINSERT\fP, \fBAPPEND\fP, \fBREPLACE\fP
 operations).
 .SS "OTHER OPTIONS"
 The following additional options can be specified:
 .TP
-.B "-v, --verbose"
+\fB-v\fP, \fB--verbose\fP
 Verbose output.  This option makes the list command show the interface
 name, the rule options (if any), and the TOS masks.  The packet and
 byte counters are also listed, with the suffix 'K', 'M' or 'G' for
 1000, 1,000,000 and 1,000,000,000 multipliers respectively (but see
-the
-.B -x
-flag to change this).
+the \fB-x\fP flag to change this).
 For appending, insertion, deletion and replacement, this causes
 detailed information on the rule or rules to be printed.
 .TP
-.B "-n, --numeric"
+\fB-n\fP, \fB--numeric\fP
 Numeric output.
 IP addresses and port numbers will be printed in numeric format.
 By default, the program will try to display them as host names,
 network names, or services (whenever applicable).
 .TP
-.B "-x, --exact"
+\fB-x\fP, \fB--exact\fP
 Expand numbers.
 Display the exact value of the packet and byte counters,
 instead of only the rounded number in K's (multiples of 1000)
 M's (multiples of 1000K) or G's (multiples of 1000M).  This option is
-only relevant for the 
-.B -L
-command.
+only relevant for the \fB-L\fP command.
 .TP
 .B "--line-numbers"
 When listing rules, add line numbers to the beginning of each rule,
 corresponding to that rule's position in the chain.
 .TP
-.B "--modprobe=command"
-When adding or inserting rules into a chain, use
-.B command
+\fB--modprobe=\fP\fIcommand\fP
+When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
 .SH MATCH EXTENSIONS
 ip6tables can use extended packet matching modules.  These are loaded
-in two ways: implicitly, when
-.B -p
-or
-.B --protocol
-is specified, or with the
-.B -m
-or
-.B --match
+in two ways: implicitly, when \fB-p\fP or \fB--protocol\fP
+is specified, or with the \fB-m\fP or \fB--match\fP
 options, followed by the matching module name; after these, various
 extra command line options become available, depending on the specific
 module.  You can specify multiple extended match modules in one line,
-and you can use the
-.B -h
-or
-.B --help
+and you can use the \fB-h\fP or \fB--help\fP
 options after the module has been specified to receive help specific
 to that module.
 
 The following are included in the base package, and most of these can
-be preceded by a
-.B !
-to invert the sense of the match.
+be preceded by a "\fB!\fP" to invert the sense of the match.
 .\" @MATCH@
 .SH TARGET EXTENSIONS
 ip6tables can use extended target modules: the following are included
@@ -428,27 +356,18 @@ other errors cause an exit code of 1.
 Bugs?  What's this? ;-)
 Well... the counters are not reliable on sparc64.
 .SH COMPATIBILITY WITH IPCHAINS
-This 
-.B ip6tables
+This \fBip6tables\fP
 is very similar to ipchains by Rusty Russell.  The main difference is
-that the chains 
-.B INPUT
-and
-.B OUTPUT
+that the chains \fBINPUT\fP and \fBOUTPUT\fP
 are only traversed for packets coming into the local host and
 originating from the local host respectively.  Hence every packet only
 passes through one of the three chains (except loopback traffic, which
 involves both INPUT and OUTPUT chains); previously a forwarded packet
 would pass through all three.
 .PP
-The other main difference is that 
-.B -i
-refers to the input interface;
-.B -o
-refers to the output interface, and both are available for packets
-entering the
-.B FORWARD
-chain.
+The other main difference is that \fB-i\fP refers to the input interface;
+\fB-o\fP refers to the output interface, and both are available for packets
+entering the \fBFORWARD\fP chain.
 .\" .PP The various forms of NAT have been separated out; 
 .\" .B iptables 
 .\" is a pure packet filter when using the default `filter' table, with
diff --git a/iptables.8.in b/iptables.8.in
index 0b945cb..c08d27d 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -1,4 +1,4 @@
-.TH IPTABLES 8 "Mar 09, 2002" "" ""
+.TH IPTABLES 8 "Jul 03, 2008" "" ""
 .\"
 .\" Man page written by Herve Eychenne <rv@wallfire.org> (May 1999)
 .\" It is based on ipchains page.
@@ -25,26 +25,28 @@
 .SH NAME
 iptables \- administration tool for IPv4 packet filtering and NAT
 .SH SYNOPSIS
-.BR "iptables [-t table] -[AD] " "chain rule-specification [options]"
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB]\fP {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
 .br
-.BR "iptables [-t table] -I " "chain [rulenum] rule-specification [options]"
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
 .br
-.BR "iptables [-t table] -R " "chain rulenum rule-specification [options]"
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
 .br
-.BR "iptables [-t table] -D " "chain rulenum [options]"
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -D\fP \fIchain rulenum\fP [\fIoptions...\fP]
 .br
-.BR "iptables [-t table] -[LFZ] " "[chain] [options]"
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -S\fP [\fIchain\fP]
 .br
-.BR "iptables [-t table] -N " "chain"
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB]\fP {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
 .br
-.BR "iptables [-t table] -X " "[chain]"
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -N\fP \fIchain\fP
 .br
-.BR "iptables [-t table] -P " "chain target [options]"
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -X\fP [\fIchain\fP]
 .br
-.BR "iptables [-t table] -E " "old-chain-name new-chain-name"
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -P\fP \fIchain target\fP [\fIoptions...\fP]
+.br
+\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -E\fP \fIold-chain-name new-chain-name\fP
 .SH DESCRIPTION
-.B Iptables
-is used to set up, maintain, and inspect the tables of IP packet
+\fBIptables\fP is used to set up, maintain, and inspect the
+tables of IPv4 packet
 filter rules in the Linux kernel.  Several different tables
 may be defined.  Each table contains a number of built-in
 chains and may also contain user-defined chains.
@@ -59,36 +61,22 @@ A firewall rule specifies criteria for a packet and a target.  If the
 packet does not match, the next rule in the chain is the examined; if
 it does match, then the next rule is specified by the value of the
 target, which can be the name of a user-defined chain or one of the
-special values 
-.IR ACCEPT ,
-.IR DROP ,
-.IR QUEUE ,
-or
-.IR RETURN .
+special values \fBACCEPT\fP, \fBDROP\fP, \fBQUEUE\fP or \fBRETURN\fP.
 .PP
-.I ACCEPT 
-means to let the packet through.
-.I DROP
-means to drop the packet on the floor.
-.I QUEUE
-means to pass the packet to userspace.  (How the packet can be received
+\fBACCEPT\fP means to let the packet through.
+\fBDROP\fP means to drop the packet on the floor.
+\fBQUEUE\fP means to pass the packet to userspace.
+(How the packet can be received
 by a userspace process differs by the particular queue handler.  2.4.x
-and 2.6.x kernels up to 2.6.13 include the 
-.B
-ip_queue
-queue handler.  Kernels 2.6.14 and later additionally include the 
-.B
-nfnetlink_queue
-queue handler.  Packets with a target of QUEUE will be sent to queue number '0'
-in this case. Please also see the
-.B
-NFQUEUE
+and 2.6.x kernels up to 2.6.13 include the \fBip_queue\fP
+queue handler.  Kernels 2.6.14 and later additionally include the
+\fBnfnetlink_queue\fP queue handler.  Packets with a target of QUEUE will be
+sent to queue number '0' in this case. Please also see the \fBNFQUEUE\fP
 target as described later in this man page.)
-.I RETURN
-means stop traversing this chain and resume at the next rule in the
+\fBRETURN\fP means stop traversing this chain and resume at the next
+rule in the
 previous (calling) chain.  If the end of a built-in chain is reached
-or a rule in a built-in chain with target
-.I RETURN
+or a rule in a built-in chain with target \fBRETURN\fP
 is matched, the target specified by the chain policy determines the
 fate of the packet.
 .SH TABLES
@@ -96,7 +84,7 @@ There are currently three independent tables (which tables are present
 at any time depends on the kernel configuration options and which
 modules are present).
 .TP
-.BI "-t, --table " "table"
+\fB-t\fP, \fB--table\fP \fItable\fP
 This option specifies the packet matching table which the command
 should operate on.  If the kernel is configured with automatic module
 loading, an attempt will be made to load the appropriate module for
@@ -105,99 +93,81 @@ that table if it is not already there.
 The tables are as follows:
 .RS
 .TP .4i
-.BR "filter" :
+\fBfilter\fP:
 This is the default table (if no -t option is passed).  It contains
-the built-in chains
-.B INPUT
-(for packets destined to local sockets),
-.B FORWARD
-(for packets being routed through the box), and
-.B OUTPUT
-(for locally-generated packets).
-.TP
-.BR "nat" :
+the built-in chains \fBINPUT\fP (for packets destined to local sockets),
+\fBFORWARD\fP (for packets being routed through the box), and
+\fBOUTPUT\fP (for locally-generated packets).
+.TP
+\fBnat\fP:
 This table is consulted when a packet that creates a new
-connection is encountered.  It consists of three built-ins:
-.B PREROUTING
-(for altering packets as soon as they come in),
-.B OUTPUT
-(for altering locally-generated packets before routing), and
-.B POSTROUTING
+connection is encountered.  It consists of three built-ins: \fBPREROUTING\fP
+(for altering packets as soon as they come in), \fBOUTPUT\fP
+(for altering locally-generated packets before routing), and \fBPOSTROUTING\fP
 (for altering packets as they are about to go out).
 .TP
-.BR "mangle" :
+\fBmangle\fP:
 This table is used for specialized packet alteration.  Until kernel
-2.4.17 it had two built-in chains:
-.B PREROUTING
-(for altering incoming packets before routing) and
-.B OUTPUT
+2.4.17 it had two built-in chains: \fBPREROUTING\fP
+(for altering incoming packets before routing) and \fBOUTPUT\fP
 (for altering locally-generated packets before routing).
 Since kernel 2.4.18, three other built-in chains are also supported:
-.B INPUT
-(for packets coming into the box itself),
-.B FORWARD
-(for altering packets being routed through the box), and
-.B POSTROUTING
+\fBINPUT\fP (for packets coming into the box itself), \fBFORWARD\fP
+(for altering packets being routed through the box), and \fBPOSTROUTING\fP
 (for altering packets as they are about to go out).
 .TP
-.BR "raw" :
+\fBraw\fP:
 This table is used mainly for configuring exemptions from connection
 tracking in combination with the NOTRACK target.  It registers at the netfilter
 hooks with higher priority and is thus called before ip_conntrack, or any other
-IP tables.  It provides the following built-in chains:
-.B PREROUTING
-(for packets arriving via any network interface)
-.B OUTPUT
+IP tables.  It provides the following built-in chains: \fBPREROUTING\fP
+(for packets arriving via any network interface) \fBOUTPUT\fP
 (for packets generated by local processes)
 .RE
 .SH OPTIONS
 The options that are recognized by
-.B iptables
-can be divided into several different groups.
+\fBiptables\fP can be divided into several different groups.
 .SS COMMANDS
 These options specify the desired action to perform. Only one of them
 can be specified on the command line unless otherwise stated
 below. For long versions of the command and option names, you
 need to use only enough letters to ensure that
-.B iptables
-can differentiate it from all other options.
+\fBiptables\fP can differentiate it from all other options.
 .TP
-.BI "-A, --append " "chain rule-specification"
+\fB-A\fP, \fB--append\fP \fIchain rule-specification\fP
 Append one or more rules to the end of the selected chain.
 When the source and/or destination names resolve to more than one
 address, a rule will be added for each possible address combination.
 .TP
-.BI "-D, --delete " "chain rule-specification"
+\fB-D\fP, \fB--delete\fP \fIchain rule-specification\fP
 .ns
 .TP
-.BI "-D, --delete " "chain rulenum"
+\fB-D\fP, \fB--delete\fP \fIchain rulenum\fP
 Delete one or more rules from the selected chain.  There are two
 versions of this command: the rule can be specified as a number in the
 chain (starting at 1 for the first rule) or a rule to match.
 .TP
-.BR "-I, --insert " "\fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP"
+\fB-I\fP, \fB--insert\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
 Insert one or more rules in the selected chain as the given rule
 number.  So, if the rule number is 1, the rule or rules are inserted
 at the head of the chain.  This is also the default if no rule number
 is specified.
 .TP
-.BI "-R, --replace " "chain rulenum rule-specification"
+\fB-R\fP, \fB--replace\fP \fIchain rulenum rule-specification\fP
 Replace a rule in the selected chain.  If the source and/or
 destination names resolve to multiple addresses, the command will
 fail.  Rules are numbered starting at 1.
 .TP
-.BR "-L, --list " "[\fIchain\fP]"
+\fB-L\fP, \fB--list\fP [\fIchain\fP]
 List all rules in the selected chain.  If no chain is selected, all
 chains are listed. Like every other iptables command, it applies to the
 specified table (filter is the default), so NAT rules get listed by
 .nf
  iptables -t nat -n -L
 .fi
-Please note that it is often used with the
-.B -n
+Please note that it is often used with the \fB-n\fP
 option, in order to avoid long reverse DNS lookups.
-It is legal to specify the
-.B -Z
+It is legal to specify the \fB-Z\fP
 (zero) option as well, in which case the chain(s) will be atomically
 listed and zeroed.  The exact output is affected by the other
 arguments given. The exact rules are suppressed until you use
@@ -205,41 +175,40 @@ arguments given. The exact rules are suppressed until you use
  iptables -L -v
 .fi
 .TP
-.BR "-S, --list-rules " "[\fIchain\fP]"
+\fB-S\fP, \fB--list-rules\fP [\fIchain\fP]
 Print all rules in the selected chain.  If no chain is selected, all
 chains are printed like iptables-save. Like every other iptables command,
 it applies to the specified table (filter is the default).
 .TP
-.BR "-F, --flush " "[\fIchain\fP]"
+\fB-F\fP, \fB--flush\fP [\fIchain\fP]
 Flush the selected chain (all the chains in the table if none is given).
 This is equivalent to deleting all the rules one by one.
 .TP
-.BR "-Z, --zero " "[\fIchain\fP]"
+\fB-Z\fP, \fB--zero\fP [\fIchain\fP]
 Zero the packet and byte counters in all chains.  It is legal to
 specify the
-.B "-L, --list"
+\fB-L\fP, \fB--list\fP
 (list) option as well, to see the counters immediately before they are
 cleared. (See above.)
 .TP
-.BI "-N, --new-chain " "chain"
+\fB-N\fP, \fB--new-chain\fP \fIchain\fP
 Create a new user-defined chain by the given name.  There must be no
 target of that name already.
 .TP
-.BR "-X, --delete-chain " "[\fIchain\fP]"
+\fB-X\fP, \fB--delete-chain\fP [\fIchain\fP]
 Delete the optional user-defined chain specified.  There must be no references
 to the chain.  If there are, you must delete or replace the referring rules
 before the chain can be deleted.  The chain must be empty, i.e. not contain
 any rules.  If no argument is given, it will attempt to delete every
 non-builtin chain in the table.
 .TP
-.BI "-P, --policy " "chain target"
-Set the policy for the chain to the given target.  See the section
-.B TARGETS
+\fB-P\fP, \fB--policy\fP \fIchain target\fP
+Set the policy for the chain to the given target.  See the section \fBTARGETS\fP
 for the legal targets.  Only built-in (non-user-defined) chains can have
 policies, and neither built-in nor user-defined chains can be policy
 targets.
 .TP
-.BI "-E, --rename-chain " "old-chain new-chain"
+\fB-E\fP, \fB--rename-chain\fP \fIold-chain new-chain\fP
 Rename the user specified chain to the user supplied name.  This is
 cosmetic, and has no effect on the structure of the table.
 .TP
@@ -250,95 +219,70 @@ Give a (currently very brief) description of the command syntax.
 The following parameters make up a rule specification (as used in the
 add, delete, insert, replace and append commands).
 .TP
-.BR "-p, --protocol " "[!] \fIprotocol\fP"
+[\fB!\fP] \fB-p\fP, \fB--protocol\fP \fIprotocol\fP
 The protocol of the rule or of the packet to check.
-The specified protocol can be one of
-.IR tcp ,
-.IR udp ,
-.IR icmp ,
-or
-.IR all ,
+The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
+\fBicmp\fP, \fBesp\fP, \fBah\fP, \fBsctp\fP or \fBall\fP,
 or it can be a numeric value, representing one of these protocols or a
 different one.  A protocol name from /etc/protocols is also allowed.
 A "!" argument before the protocol inverts the
-test.  The number zero is equivalent to
-.IR all .
-Protocol
-.I all
+test.  The number zero is equivalent to \fBall\fP.
+Protocol \fBall\fP
 will match with all protocols and is taken as default when this
 option is omitted.
 .TP
-.BR "-s, --source " "[!] \fIaddress\fP[/\fImask\fP]"
-Source specification.
-.I Address
+[\fB!\fP] \fB-s\fP, \fB--source\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+Source specification. \fIAddress\fP
 can be either a network name, a hostname (please note that specifying
 any name to be resolved with a remote query such as DNS is a really bad idea),
-a network IP address (with /mask), or a plain IP address.
-The
-.I mask
+a network IP address (with \fB/\fP\fImask\fP), or a plain IP address.
+The \fImask\fP
 can be either a network mask or a plain number,
 specifying the number of 1's at the left side of the network mask.
-Thus, a mask of
-.I 24
-is equivalent to
-.IR 255.255.255.0 .
+Thus, a mask of \fI24\fP is equivalent to \fI255.255.255.0\fP.
 A "!" argument before the address specification inverts the sense of
-the address. The flag
-.B --src
-is an alias for this option.
+the address. The flag \fB--src\fP is an alias for this option.
 .TP
-.BR "-d, --destination " "[!] \fIaddress\fP[/\fImask\fP]"
+[\fB!\fP] \fB-d\fP, \fB--destination\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Destination specification. 
-See the description of the
-.B -s
+See the description of the \fB-s\fP
 (source) flag for a detailed description of the syntax.  The flag
-.B --dst
-is an alias for this option.
+\fB--dst\fP is an alias for this option.
 .TP
-.BI "-j, --jump " "target"
+\fB-j\fP, \fB--jump\fP \fItarget\fP
 This specifies the target of the rule; i.e., what to do if the packet
 matches it.  The target can be a user-defined chain (other than the
 one this rule is in), one of the special builtin targets which decide
-the fate of the packet immediately, or an extension (see
-.B EXTENSIONS
+the fate of the packet immediately, or an extension (see \fBEXTENSIONS\fP
 below).  If this
-option is omitted in a rule (and
-.B -g
+option is omitted in a rule (and \fB-g\fP
 is not used), then matching the rule will have no
 effect on the packet's fate, but the counters on the rule will be
 incremented.
 .TP
-.BI "-g, --goto " "chain"
+\fB-g\fP, \fB--goto\fP \fIchain\fP
 This specifies that the processing should continue in a user
 specified chain. Unlike the --jump option return will not continue
 processing in this chain but instead in the chain that called us via
 --jump.
 .TP
-.BR "-i, --in-interface " "[!] \fIname\fP"
+[\fB!\fP] \fB-i\fP, \fB--in-interface\fP \fIname\fP
 Name of an interface via which a packet was received (only for
-packets entering the 
-.BR INPUT ,
-.B FORWARD
-and
-.B PREROUTING
+packets entering the \fBINPUT\fP, \fBFORWARD\fP and \fBPREROUTING\fP
 chains).  When the "!" argument is used before the interface name, the
 sense is inverted.  If the interface name ends in a "+", then any
 interface which begins with this name will match.  If this option is
 omitted, any interface name will match.
 .TP
-.BR "-o, --out-interface " "[!] \fIname\fP"
+[\fB!\fP] \fB-o\fP, \fB--out-interface\fP \fIname\fP
 Name of an interface via which a packet is going to be sent (for packets
-entering the
-.BR FORWARD ,
-.B OUTPUT
-and
-.B POSTROUTING
+entering the \fBFORWARD\fP, \fBOUTPUT\fP and \fBPOSTROUTING\fP
 chains).  When the "!" argument is used before the interface name, the
 sense is inverted.  If the interface name ends in a "+", then any
 interface which begins with this name will match.  If this option is
 omitted, any interface name will match.
 .TP
-.B "[!] " "-f, --fragment"
+[\fB!\fP] \fB-f\fP, \fB--fragment\fP
 This means that the rule only refers to second and further fragments
 of fragmented packets.  Since there is no way to tell the source or
 destination ports of such a packet (or ICMP type), such a packet will
@@ -346,74 +290,55 @@ not match any rules which specify them.  When the "!" argument
 precedes the "-f" flag, the rule will only match head fragments, or
 unfragmented packets.
 .TP
-.BI "-c, --set-counters " "PKTS BYTES"
+\fB-c\fP, \fB--set-counters\fP \fIpackets bytes\fP
 This enables the administrator to initialize the packet and byte
-counters of a rule (during
-.B INSERT,
-.B APPEND,
-.B REPLACE
+counters of a rule (during \fBINSERT\fP, \fBAPPEND\fP, \fBREPLACE\fP
 operations).
 .SS "OTHER OPTIONS"
 The following additional options can be specified:
 .TP
-.B "-v, --verbose"
+\fB-v\fP, \fB--verbose\fP
 Verbose output.  This option makes the list command show the interface
 name, the rule options (if any), and the TOS masks.  The packet and
 byte counters are also listed, with the suffix 'K', 'M' or 'G' for
 1000, 1,000,000 and 1,000,000,000 multipliers respectively (but see
-the
-.B -x
-flag to change this).
+the \fB-x\fP flag to change this).
 For appending, insertion, deletion and replacement, this causes
 detailed information on the rule or rules to be printed.
 .TP
-.B "-n, --numeric"
+\fB-n\fP, \fB--numeric\fP
 Numeric output.
 IP addresses and port numbers will be printed in numeric format.
 By default, the program will try to display them as host names,
 network names, or services (whenever applicable).
 .TP
-.B "-x, --exact"
+\fB-x\fP, \fB--exact\fP
 Expand numbers.
 Display the exact value of the packet and byte counters,
 instead of only the rounded number in K's (multiples of 1000)
 M's (multiples of 1000K) or G's (multiples of 1000M).  This option is
-only relevant for the 
-.B -L
-command.
+only relevant for the \fB-L\fP command.
 .TP
 .B "--line-numbers"
 When listing rules, add line numbers to the beginning of each rule,
 corresponding to that rule's position in the chain.
 .TP
-.B "--modprobe=command"
-When adding or inserting rules into a chain, use
-.B command
+\fB--modprobe=\fP\fIcommand\fP
+When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
 .SH MATCH EXTENSIONS
 iptables can use extended packet matching modules.  These are loaded
-in two ways: implicitly, when
-.B -p
-or
-.B --protocol
-is specified, or with the
-.B -m
-or
-.B --match
+in two ways: implicitly, when \fB-p\fP or \fB--protocol\fP
+is specified, or with the \fB-m\fP or \fB--match\fP
 options, followed by the matching module name; after these, various
 extra command line options become available, depending on the specific
 module.  You can specify multiple extended match modules in one line,
-and you can use the
-.B -h
-or
-.B --help
+and you can use the \fB-h\fP or \fB--help\fP
 options after the module has been specified to receive help specific
 to that module.
 
 The following are included in the base package, and most of these can
-be preceded by a
-.B !
-to invert the sense of the match.
+be preceded by a "\fB!\fP" to invert the sense of the match.
 .\" @MATCH@
 .SH TARGET EXTENSIONS
 iptables can use extended target modules: the following are included
@@ -428,29 +353,20 @@ other errors cause an exit code of 1.
 Bugs?  What's this? ;-)
 Well, you might want to have a look at http://bugzilla.netfilter.org/
 .SH COMPATIBILITY WITH IPCHAINS
-This
-.B iptables
+This \fBiptables\fP
 is very similar to ipchains by Rusty Russell.  The main difference is
-that the chains
-.B INPUT
-and
-.B OUTPUT
+that the chains \fBINPUT\fP and \fBOUTPUT\fP
 are only traversed for packets coming into the local host and
 originating from the local host respectively.  Hence every packet only
 passes through one of the three chains (except loopback traffic, which
 involves both INPUT and OUTPUT chains); previously a forwarded packet
 would pass through all three.
 .PP
-The other main difference is that
-.B -i
-refers to the input interface;
-.B -o
-refers to the output interface, and both are available for packets
-entering the
-.B FORWARD
-chain.
-.PP The various forms of NAT have been separated out; 
-.B iptables 
+The other main difference is that \fB-i\fP refers to the input interface;
+\fB-o\fP refers to the output interface, and both are available for packets
+entering the \fBFORWARD\fP chain.
+.PP
+The various forms of NAT have been separated out; \fBiptables\fP
 is a pure packet filter when using the default `filter' table, with
 optional extension modules.  This should simplify much of the previous
 confusion over the combination of IP masquerading and packet filtering

