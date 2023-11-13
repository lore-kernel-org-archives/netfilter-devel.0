Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46390C4167B
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjKMKoN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjKMKoM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:44:12 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ADD10CB
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:44:05 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 789B958725FE7; Mon, 13 Nov 2023 11:44:03 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 6040058725FCB
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:44:02 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 5/7] man: perform backslash-encoding
Date:   Mon, 13 Nov 2023 11:43:10 +0100
Message-ID: <20231113104357.59087-6-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113104357.59087-1-jengelh@inai.de>
References: <20231113104357.59087-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In groff, "-" specifies a hyphen, but "\-" is the minus we need.
Similarly, "^" and "~" have special meaning.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 ebtables-legacy.8.in | 394 +++++++++++++++++++++----------------------
 1 file changed, 197 insertions(+), 197 deletions(-)

diff --git a/ebtables-legacy.8.in b/ebtables-legacy.8.in
index d1a06b3..13c95fe 100644
--- a/ebtables-legacy.8.in
+++ b/ebtables-legacy.8.in
@@ -108,7 +108,7 @@ means to let the frame through.
 means the frame has to be dropped. In the
 .BR BROUTING " chain however, the " ACCEPT " and " DROP " target have different"
 meanings (see the info provided for the
-.BR -t " option)."
+.BR \-t " option)."
 .B CONTINUE
 means the next rule has to be checked. This can be handy, f.e., to know how many
 frames pass a certain point in the chain, to log those frames or to apply multiple
@@ -125,12 +125,12 @@ kernel.  The table names are
 .BR filter ", " nat " and " broute .
 Of these three tables,
 the filter table is the default table that the command operates on.
-If you are working with the filter table, then you can drop the '-t filter'
+If you are working with the filter table, then you can drop the '\-t filter'
 argument to the ebtables command.  However, you will need to provide
-the -t argument for the other two tables.  Moreover, the -t argument must be the
+the \-t argument for the other two tables.  Moreover, the \-t argument must be the
 first argument on the ebtables command line, if used. 
 .TP
-.B "-t, --table"
+.B "\-t, \-\-table"
 .br
 .B filter
 is the default table and contains three built-in chains:
@@ -154,7 +154,7 @@ of chains PREROUTING and POSTROUTING: it would be more accurate to call them
 PREFORWARDING and POSTFORWARDING, but for all those who come from the
 iptables world to ebtables it is easier to have the same names. Note that you
 can change the name
-.BR "" ( -E )
+.BR "" ( \-E )
 if you don't like the default.
 .br
 .br
@@ -176,129 +176,129 @@ would be bridged, but you can decide otherwise here. The
 .B redirect
 target is very handy here.
 .SH EBTABLES COMMAND LINE ARGUMENTS
-After the initial ebtables '-t table' command line argument, the remaining
+After the initial ebtables '\-t table' command line argument, the remaining
 arguments can be divided into several groups.  These groups
 are commands, miscellaneous commands, rule specifications, match extensions,
 watcher extensions and target extensions.
 .SS COMMANDS
 The ebtables command arguments specify the actions to perform on the table
-defined with the -t argument.  If you do not use the -t argument to name
+defined with the \-t argument.  If you do not use the \-t argument to name
 a table, the commands apply to the default filter table.
 Only one command may be used on the command line at a time, except when
 the commands
-.BR -L " and " -Z
+.BR \-L " and " \-Z
 are combined, the commands
-.BR -N " and " -P
+.BR \-N " and " \-P
 are combined, or when
-.B --atomic-file
+.B \-\-atomic\-file
 is used.
 .TP
-.B "-A, --append"
+.B "\-A, \-\-append"
 Append a rule to the end of the selected chain.
 .TP
-.B "-D, --delete"
+.B "\-D, \-\-delete"
 Delete the specified rule or rules from the selected chain. There are two ways to
 use this command. The first is by specifying an interval of rule numbers
 to delete (directly after
-.BR -D ).
+.BR \-D ).
 Syntax: \fIstart_nr\fP[\fI:end_nr\fP] (use
-.B -L --Ln
+.B \-L \-\-Ln
 to list the rules with their rule number). When \fIend_nr\fP is omitted, all rules starting
 from \fIstart_nr\fP are deleted. Using negative numbers is allowed, for more
 details about using negative numbers, see the
-.B -I
+.B \-I
 command. The second usage is by
 specifying the complete rule as it would have been specified when it was added. Only
 the first encountered rule that is the same as this specified rule, in other
 words the matching rule with the lowest (positive) rule number, is deleted.
 .TP
-.B "-C, --change-counters"
+.B "\-C, \-\-change\-counters"
 Change the counters of the specified rule or rules from the selected chain. There are two ways to
 use this command. The first is by specifying an interval of rule numbers
 to do the changes on (directly after
-.BR -C ).
+.BR \-C ).
 Syntax: \fIstart_nr\fP[\fI:end_nr\fP] (use
-.B -L --Ln
+.B \-L \-\-Ln
 to list the rules with their rule number). The details are the same as for the
-.BR -D " command. The second usage is by"
+.BR \-D " command. The second usage is by"
 specifying the complete rule as it would have been specified when it was added. Only
 the counters of the first encountered rule that is the same as this specified rule, in other
 words the matching rule with the lowest (positive) rule number, are changed.
 In the first usage, the counters are specified directly after the interval specification,
 in the second usage directly after
-.BR -C .
+.BR \-C .
 First the packet counter is specified, then the byte counter. If the specified counters start
 with a '+', the counter values are added to the respective current counter values.
-If the specified counters start with a '-', the counter values are decreased from the respective
-current counter values. No bounds checking is done. If the counters don't start with '+' or '-',
+If the specified counters start with a '\-', the counter values are decreased from the respective
+current counter values. No bounds checking is done. If the counters don't start with '+' or '\-',
 the current counters are changed to the specified counters.
 .TP
-.B "-I, --insert"
+.B "\-I, \-\-insert"
 Insert the specified rule into the selected chain at the specified rule number. If the
 rule number is not specified, the rule is added at the head of the chain.
 If the current number of rules equals
 .IR N ,
 then the specified number can be
 between
-.IR -N " and " N+1 .
+.IR \-N " and " N+1 .
 For a positive number
 .IR i ,
 it holds that
-.IR i " and " i-N-1
+.IR i " and " i\-N\-1
 specify the same place in the chain where the rule should be inserted. The rule number
 0 specifies the place past the last rule in the chain and using this number is therefore
 equivalent to using the
-.BR -A " command."
+.BR \-A " command."
 Rule numbers structly smaller than 0 can be useful when more than one rule needs to be inserted
 in a chain.
 .TP
-.B "-P, --policy"
+.B "\-P, \-\-policy"
 Set the policy for the chain to the given target. The policy can be
 .BR ACCEPT ", " DROP " or " RETURN .
 .TP
-.B "-F, --flush"
+.B "\-F, \-\-flush"
 Flush the selected chain. If no chain is selected, then every chain will be
 flushed. Flushing a chain does not change the policy of the
 chain, however.
 .TP
-.B "-Z, --zero"
+.B "\-Z, \-\-zero"
 Set the counters of the selected chain to zero. If no chain is selected, all the counters
 are set to zero. The
-.B "-Z"
+.B "\-Z"
 command can be used in conjunction with the 
-.B "-L"
+.B "\-L"
 command.
 When both the
-.B "-Z"
+.B "\-Z"
 and
-.B "-L"
+.B "\-L"
 commands are used together in this way, the rule counters are printed on the screen
 before they are set to zero.
 .TP
-.B "-L, --list"
+.B "\-L, \-\-list"
 List all rules in the selected chain. If no chain is selected, all chains
 are listed.
 .br
 The following options change the output of the
-.B "-L"
+.B "\-L"
 command.
 .br
-.B "--Ln"
+.B "\-\-Ln"
 .br
 Places the rule number in front of every rule. This option is incompatible with the
-.BR --Lx " option."
+.BR \-\-Lx " option."
 .br
-.B "--Lc"
+.B "\-\-Lc"
 .br
 Shows the counters at the end of each rule displayed by the
-.B "-L"
+.B "\-L"
 command. Both a frame counter (pcnt) and a byte counter (bcnt) are displayed.
 The frame counter shows how many frames have matched the specific rule, the byte
 counter shows the sum of the frame sizes of these matching frames. Using this option
-.BR "" "in combination with the " --Lx " option causes the counters to be written out"
-.BR "" "in the '" -c " <pcnt> <bcnt>' option format."
+.BR "" "in combination with the " \-\-Lx " option causes the counters to be written out"
+.BR "" "in the '" \-c " <pcnt> <bcnt>' option format."
 .br
-.B "--Lx"
+.B "\-\-Lx"
 .br
 Changes the output so that it produces a set of ebtables commands that construct
 the contents of the chain, when specified.
@@ -307,78 +307,78 @@ table are given, including commands for creating the user-defined chains (if any
 You can use this set of commands in an ebtables boot or reload
 script.  For example the output could be used at system startup.
 The 
-.B "--Lx"
+.B "\-\-Lx"
 option is incompatible with the
-.B "--Ln"
+.B "\-\-Ln"
 listing option. Using the
-.BR --Lx " option together with the " --Lc " option will cause the counters to be written out"
-.BR "" "in the '" -c " <pcnt> <bcnt>' option format."
+.BR \-\-Lx " option together with the " \-\-Lc " option will cause the counters to be written out"
+.BR "" "in the '" \-c " <pcnt> <bcnt>' option format."
 .br
-.B "--Lmac2"
+.B "\-\-Lmac2"
 .br
 Shows all MAC addresses with the same length, adding leading zeroes
 if necessary. The default representation omits leading zeroes in the addresses.
 .TP
-.B "-N, --new-chain"
+.B "\-N, \-\-new\-chain"
 Create a new user-defined chain with the given name. The number of
 user-defined chains is limited only by the number of possible chain names.
 A user-defined chain name has a maximum
 length of 31 characters. The standard policy of the user-defined chain is
 ACCEPT. The policy of the new chain can be initialized to a different standard
 target by using the
-.B -P
+.B \-P
 command together with the
-.B -N
+.B \-N
 command. In this case, the chain name does not have to be specified for the
-.B -P
+.B \-P
 command.
 .TP
-.B "-X, --delete-chain"
+.B "\-X, \-\-delete\-chain"
 Delete the specified user-defined chain. There must be no remaining references (jumps)
 to the specified chain, otherwise ebtables will refuse to delete it. If no chain is
 specified, all user-defined chains that aren't referenced will be removed.
 .TP
-.B "-E, --rename-chain"
+.B "\-E, \-\-rename\-chain"
 Rename the specified chain to a new name.  Besides renaming a user-defined
 chain, you can rename a standard chain to a name that suits your
 taste. For example, if you like PREFORWARDING more than PREROUTING,
-then you can use the -E command to rename the PREROUTING chain. If you do
+then you can use the \-E command to rename the PREROUTING chain. If you do
 rename one of the standard ebtables chain names, please be sure to mention
 this fact should you post a question on the ebtables mailing lists.
 It would be wise to use the standard name in your post. Renaming a standard
 ebtables chain in this fashion has no effect on the structure or functioning
 of the ebtables kernel table.
 .TP
-.B "--init-table"
+.B "\-\-init\-table"
 Replace the current table data by the initial table data.
 .TP
-.B "--atomic-init"
+.B "\-\-atomic\-init"
 Copy the kernel's initial data of the table to the specified
 file. This can be used as the first action, after which rules are added
 to the file. The file can be specified using the
-.B --atomic-file
+.B \-\-atomic\-file
 command or through the
 .IR EBTABLES_ATOMIC_FILE " environment variable."
 .TP
-.B "--atomic-save"
+.B "\-\-atomic\-save"
 Copy the kernel's current data of the table to the specified
 file. This can be used as the first action, after which rules are added
 to the file. The file can be specified using the
-.B --atomic-file
+.B \-\-atomic\-file
 command or through the
 .IR EBTABLES_ATOMIC_FILE " environment variable."
 .TP
-.B "--atomic-commit"
+.B "\-\-atomic\-commit"
 Replace the kernel table data with the data contained in the specified
 file. This is a useful command that allows you to load all your rules of a
 certain table into the kernel at once, saving the kernel a lot of precious
 time and allowing atomic updates of the tables. The file which contains
 the table data is constructed by using either the
-.B "--atomic-init"
+.B "\-\-atomic\-init"
 or the
-.B "--atomic-save"
+.B "\-\-atomic\-save"
 command to generate a starting file. After that, using the
-.B "--atomic-file"
+.B "\-\-atomic\-file"
 command when constructing rules or setting the
 .IR EBTABLES_ATOMIC_FILE " environment variable"
 allows you to extend the file and build the complete table before
@@ -386,20 +386,20 @@ committing it to the kernel. This command can be very useful in boot scripts
 to populate the ebtables tables in a fast way.
 .SS MISCELLANOUS COMMANDS
 .TP
-.B "-V, --version"
+.B "\-V, \-\-version"
 Show the version of the ebtables userspace program.
 .TP
-.BR "-h, --help " "[\fIlist of module names\fP]"
+.BR "\-h, \-\-help " "[\fIlist of module names\fP]"
 Give a brief description of the command syntax. Here you can also specify
 names of extensions and ebtables will try to write help about those
 extensions. E.g.
-.IR "ebtables -h snat log ip arp" .
+.IR "ebtables \-h snat log ip arp" .
 Specify
 .I list_extensions
 to list all extensions supported by the userspace
 utility.
 .TP
-.BR "-j, --jump " "\fItarget\fP"
+.BR "\-j, \-\-jump " "\fItarget\fP"
 The target of the rule. This is one of the following values:
 .BR ACCEPT ,
 .BR DROP ,
@@ -409,7 +409,7 @@ a target extension (see
 .BR "TARGET EXTENSIONS" ")"
 or a user-defined chain name.
 .TP
-.B --atomic-file "\fIfile\fP"
+.B \-\-atomic\-file "\fIfile\fP"
 Let the command operate on the specified
 .IR file .
 The data of the table to
@@ -419,12 +419,12 @@ before the command specification. An alternative that should be preferred,
 is setting the
 .IR EBTABLES_ATOMIC_FILE " environment variable."
 .TP
-.B -M, --modprobe "\fIprogram\fP"
+.B \-M, \-\-modprobe "\fIprogram\fP"
 When talking to the kernel, use this
 .I program
 to try to automatically load missing kernel modules.
 .TP
-.B --concurrent
+.B \-\-concurrent
 Use a file lock to support concurrent scripts updating the ebtables kernel tables.
 
 .SS
@@ -439,7 +439,7 @@ and the
 .BR "WATCHER EXTENSIONS" 
 below.
 .TP
-.BR "-p, --protocol " "[!] \fIprotocol\fP"
+.BR "\-p, \-\-protocol " "[!] \fIprotocol\fP"
 The protocol that was responsible for creating the frame. This can be a
 hexadecimal number, above 
 .IR 0x0600 ,
@@ -466,10 +466,10 @@ will be represented by
 .IR IPV4 .
 The use of this file is not case sensitive. 
 See that file for more information. The flag 
-.B --proto
+.B \-\-proto
 is an alias for this option.
 .TP 
-.BR "-i, --in-interface " "[!] \fIname\fP"
+.BR "\-i, \-\-in\-interface " "[!] \fIname\fP"
 The interface (bridge port) via which a frame is received (this option is useful in the
 .BR INPUT ,
 .BR FORWARD ,
@@ -477,10 +477,10 @@ The interface (bridge port) via which a frame is received (this option is useful
 chains). If the interface name ends with '+', then
 any interface name that begins with this name (disregarding '+') will match.
 The flag
-.B --in-if
+.B \-\-in\-if
 is an alias for this option.
 .TP
-.BR "--logical-in " "[!] \fIname\fP"
+.BR "\-\-logical\-in " "[!] \fIname\fP"
 The (logical) bridge interface via which a frame is received (this option is useful in the
 .BR INPUT ,
 .BR FORWARD ,
@@ -489,7 +489,7 @@ chains).
 If the interface name ends with '+', then
 any interface name that begins with this name (disregarding '+') will match.
 .TP
-.BR "-o, --out-interface " "[!] \fIname\fP"
+.BR "\-o, \-\-out\-interface " "[!] \fIname\fP"
 The interface (bridge port) via which a frame is going to be sent (this option is useful in the
 .BR OUTPUT ,
 .B FORWARD
@@ -498,10 +498,10 @@ and
 chains). If the interface name ends with '+', then
 any interface name that begins with this name (disregarding '+') will match.
 The flag
-.B --out-if
+.B \-\-out\-if
 is an alias for this option.
 .TP
-.BR "--logical-out " "[!] \fIname\fP"
+.BR "\-\-logical\-out " "[!] \fIname\fP"
 The (logical) bridge interface via which a frame is going to be sent (this option
 is useful in the
 .BR OUTPUT ,
@@ -512,7 +512,7 @@ chains).
 If the interface name ends with '+', then
 any interface name that begins with this name (disregarding '+') will match.
 .TP
-.BR "-s, --source " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-s, \-\-source " "[!] \fIaddress\fP[/\fImask\fP]"
 The source MAC address. Both mask and address are written as 6 hexadecimal
 numbers separated by colons. Alternatively one can specify Unicast,
 Multicast, Broadcast or BGA (Bridge Group Address):
@@ -523,39 +523,39 @@ Multicast, Broadcast or BGA (Bridge Group Address):
 .IR "BGA" "=01:80:c2:00:00:00/ff:ff:ff:ff:ff:ff."
 Note that a broadcast
 address will also match the multicast specification. The flag
-.B --src
+.B \-\-src
 is an alias for this option.
 .TP
-.BR "-d, --destination " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-d, \-\-destination " "[!] \fIaddress\fP[/\fImask\fP]"
 The destination MAC address. See
-.B -s
+.B \-s
 (above) for more details on MAC addresses. The flag
-.B --dst
+.B \-\-dst
 is an alias for this option.
 .TP
-.BR "-c, --set-counter " "\fIpcnt bcnt\fP"
+.BR "\-c, \-\-set\-counter " "\fIpcnt bcnt\fP"
 If used with
-.BR -A " or " -I ", then the packet and byte counters of the new rule will be set to
+.BR \-A " or " \-I ", then the packet and byte counters of the new rule will be set to
 .IR pcnt ", resp. " bcnt ".
 If used with the
-.BR -C " or " -D " commands, only rules with a packet and byte count equal to"
+.BR \-C " or " \-D " commands, only rules with a packet and byte count equal to"
 .IR pcnt ", resp. " bcnt " will match."
 
 .SS MATCH EXTENSIONS
 Ebtables extensions are dynamically loaded into the userspace tool,
 there is therefore no need to explicitly load them with a
--m option like is done in iptables.
+\-m option like is done in iptables.
 These extensions deal with functionality supported by kernel modules supplemental to
 the core ebtables code.
 .SS 802_3
 Specify 802.3 DSAP/SSAP fields or SNAP type.  The protocol must be specified as
-.IR "LENGTH " "(see the option " " -p " above).
+.IR "LENGTH " "(see the option " " \-p " above).
 .TP
-.BR "--802_3-sap " "[!] \fIsap\fP"
+.BR "\-\-802_3\-sap " "[!] \fIsap\fP"
 DSAP and SSAP are two one byte 802.3 fields.  The bytes are always
 equal, so only one byte (hexadecimal) is needed as an argument.
 .TP
-.BR "--802_3-type " "[!] \fItype\fP"
+.BR "\-\-802_3\-type " "[!] \fItype\fP"
 If the 802.3 DSAP and SSAP values are 0xaa then the SNAP type field must
 be consulted to determine the payload protocol.  This is a two byte
 (hexadecimal) argument.  Only 802.3 frames with DSAP/SSAP 0xaa are
@@ -570,160 +570,160 @@ the MAC address is optional. Multiple MAC/IP address pairs with the same MAC add
 but different IP address (and vice versa) can be specified. If the MAC address doesn't
 match any entry from the list, the frame doesn't match the rule (unless "!" was used).
 .TP
-.BR "--among-dst " "[!] \fIlist\fP"
+.BR "\-\-among\-dst " "[!] \fIlist\fP"
 Compare the MAC destination to the given list. If the Ethernet frame has type
 .IR IPv4 " or " ARP ,
 then comparison with MAC/IP destination address pairs from the
 list is possible.
 .TP
-.BR "--among-src " "[!] \fIlist\fP"
+.BR "\-\-among\-src " "[!] \fIlist\fP"
 Compare the MAC source to the given list. If the Ethernet frame has type
 .IR IPv4 " or " ARP ,
 then comparison with MAC/IP source address pairs from the list
 is possible.
 .TP
-.BR "--among-dst-file " "[!] \fIfile\fP"
+.BR "\-\-among\-dst\-file " "[!] \fIfile\fP"
 Same as
-.BR --among-dst " but the list is read in from the specified file."
+.BR \-\-among\-dst " but the list is read in from the specified file."
 .TP
-.BR "--among-src-file " "[!] \fIfile\fP"
+.BR "\-\-among\-src\-file " "[!] \fIfile\fP"
 Same as
-.BR --among-src " but the list is read in from the specified file."
+.BR \-\-among\-src " but the list is read in from the specified file."
 .SS arp
 Specify (R)ARP fields. The protocol must be specified as
 .IR ARP " or " RARP .
 .TP
-.BR "--arp-opcode " "[!] \fIopcode\fP"
+.BR "\-\-arp\-opcode " "[!] \fIopcode\fP"
 The (R)ARP opcode (decimal or a string, for more details see
-.BR "ebtables -h arp" ).
+.BR "ebtables \-h arp" ).
 .TP
-.BR "--arp-htype " "[!] \fIhardware type\fP"
+.BR "\-\-arp\-htype " "[!] \fIhardware type\fP"
 The hardware type, this can be a decimal or the string
 .I Ethernet
 (which sets
 .I type
 to 1). Most (R)ARP packets have Eternet as hardware type.
 .TP
-.BR "--arp-ptype " "[!] \fIprotocol type\fP"
+.BR "\-\-arp\-ptype " "[!] \fIprotocol type\fP"
 The protocol type for which the (r)arp is used (hexadecimal or the string
 .IR IPv4 ,
 denoting 0x0800).
 Most (R)ARP packets have protocol type IPv4.
 .TP
-.BR "--arp-ip-src " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-arp\-ip\-src " "[!] \fIaddress\fP[/\fImask\fP]"
 The (R)ARP IP source address specification.
 .TP
-.BR "--arp-ip-dst " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-arp\-ip\-dst " "[!] \fIaddress\fP[/\fImask\fP]"
 The (R)ARP IP destination address specification.
 .TP
-.BR "--arp-mac-src " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-arp\-mac\-src " "[!] \fIaddress\fP[/\fImask\fP]"
 The (R)ARP MAC source address specification.
 .TP
-.BR "--arp-mac-dst " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-arp\-mac\-dst " "[!] \fIaddress\fP[/\fImask\fP]"
 The (R)ARP MAC destination address specification.
 .TP
-.BR "" "[!]" " --arp-gratuitous"
+.BR "" "[!]" " \-\-arp\-gratuitous"
 Checks for ARP gratuitous packets: checks equality of IPv4 source
 address and IPv4 destination address inside the ARP header.
 .SS ip
 Specify IPv4 fields. The protocol must be specified as
 .IR IPv4 .
 .TP
-.BR "--ip-source " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-ip\-source " "[!] \fIaddress\fP[/\fImask\fP]"
 The source IP address.
 The flag
-.B --ip-src
+.B \-\-ip\-src
 is an alias for this option.
 .TP
-.BR "--ip-destination " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-ip\-destination " "[!] \fIaddress\fP[/\fImask\fP]"
 The destination IP address.
 The flag
-.B --ip-dst
+.B \-\-ip\-dst
 is an alias for this option.
 .TP
-.BR "--ip-tos " "[!] \fItos\fP"
+.BR "\-\-ip\-tos " "[!] \fItos\fP"
 The IP type of service, in hexadecimal numbers.
 .BR IPv4 .
 .TP
-.BR "--ip-protocol " "[!] \fIprotocol\fP"
+.BR "\-\-ip\-protocol " "[!] \fIprotocol\fP"
 The IP protocol.
 The flag
-.B --ip-proto
+.B \-\-ip\-proto
 is an alias for this option.
 .TP
-.BR "--ip-source-port " "[!] \fIport1\fP[:\fIport2\fP]"
+.BR "\-\-ip\-source\-port " "[!] \fIport1\fP[:\fIport2\fP]"
 The source port or port range for the IP protocols 6 (TCP), 17
 (UDP), 33 (DCCP) or 132 (SCTP). The
-.B --ip-protocol
+.B \-\-ip\-protocol
 option must be specified as
 .IR TCP ", " UDP ", " DCCP " or " SCTP .
 If
 .IR port1 " is omitted, " 0:port2 " is used; if " port2 " is omitted but a colon is specified, " port1:65535 " is used."
 The flag
-.B --ip-sport
+.B \-\-ip\-sport
 is an alias for this option.
 .TP
-.BR "--ip-destination-port " "[!] \fIport1\fP[:\fIport2\fP]"
+.BR "\-\-ip\-destination\-port " "[!] \fIport1\fP[:\fIport2\fP]"
 The destination port or port range for ip protocols 6 (TCP), 17
 (UDP), 33 (DCCP) or 132 (SCTP). The
-.B --ip-protocol
+.B \-\-ip\-protocol
 option must be specified as
 .IR TCP ", " UDP ", " DCCP " or " SCTP .
 If
 .IR port1 " is omitted, " 0:port2 " is used; if " port2 " is omitted but a colon is specified, " port1:65535 " is used."
 The flag
-.B --ip-dport
+.B \-\-ip\-dport
 is an alias for this option.
 .SS ip6
 Specify IPv6 fields. The protocol must be specified as
 .IR IPv6 .
 .TP
-.BR "--ip6-source " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-ip6\-source " "[!] \fIaddress\fP[/\fImask\fP]"
 The source IPv6 address.
 The flag
-.B --ip6-src
+.B \-\-ip6\-src
 is an alias for this option.
 .TP
-.BR "--ip6-destination " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-ip6\-destination " "[!] \fIaddress\fP[/\fImask\fP]"
 The destination IPv6 address.
 The flag
-.B --ip6-dst
+.B \-\-ip6\-dst
 is an alias for this option.
 .TP
-.BR "--ip6-tclass " "[!] \fItclass\fP"
+.BR "\-\-ip6\-tclass " "[!] \fItclass\fP"
 The IPv6 traffic class, in hexadecimal numbers.
 .TP
-.BR "--ip6-protocol " "[!] \fIprotocol\fP"
+.BR "\-\-ip6\-protocol " "[!] \fIprotocol\fP"
 The IP protocol.
 The flag
-.B --ip6-proto
+.B \-\-ip6\-proto
 is an alias for this option.
 .TP
-.BR "--ip6-source-port " "[!] \fIport1\fP[:\fIport2\fP]"
+.BR "\-\-ip6\-source\-port " "[!] \fIport1\fP[:\fIport2\fP]"
 The source port or port range for the IPv6 protocols 6 (TCP), 17
 (UDP), 33 (DCCP) or 132 (SCTP). The
-.B --ip6-protocol
+.B \-\-ip6\-protocol
 option must be specified as
 .IR TCP ", " UDP ", " DCCP " or " SCTP .
 If
 .IR port1 " is omitted, " 0:port2 " is used; if " port2 " is omitted but a colon is specified, " port1:65535 " is used."
 The flag
-.B --ip6-sport
+.B \-\-ip6\-sport
 is an alias for this option.
 .TP
-.BR "--ip6-destination-port " "[!] \fIport1\fP[:\fIport2\fP]"
+.BR "\-\-ip6\-destination\-port " "[!] \fIport1\fP[:\fIport2\fP]"
 The destination port or port range for IPv6 protocols 6 (TCP), 17
 (UDP), 33 (DCCP) or 132 (SCTP). The
-.B --ip6-protocol
+.B \-\-ip6\-protocol
 option must be specified as
 .IR TCP ", " UDP ", " DCCP " or " SCTP .
 If
 .IR port1 " is omitted, " 0:port2 " is used; if " port2 " is omitted but a colon is specified, " port1:65535 " is used."
 The flag
-.B --ip6-dport
+.B \-\-ip6\-dport
 is an alias for this option.
 .TP
-.BR "--ip6-icmp-type " "[!] {\fItype\fP[:\fItype\fP]/\fIcode\fP[:\fIcode\fP]|\fItypename\fP}"
+.BR "\-\-ip6\-icmp\-type " "[!] {\fItype\fP[:\fItype\fP]/\fIcode\fP[:\fIcode\fP]|\fItypename\fP}"
 Specify ipv6\-icmp type and code to match.
 Ranges for both type and code are supported. Type and code are
 separated by a slash. Valid numbers for type and range are 0 to 255.
@@ -732,27 +732,27 @@ be used instead of numbers. The list of known type names is shown by the command
 .nf
   ebtables \-\-help ip6
 .fi
-This option is only valid for \-\-ip6-prococol ipv6-icmp.
+This option is only valid for \-\-ip6\-prococol ipv6\-icmp.
 .SS limit
 This module matches at a limited rate using a token bucket filter.
 A rule using this extension will match until this limit is reached.
 It can be used with the
-.B --log
+.B \-\-log
 watcher to give limited logging, for example. Its use is the same
 as the limit match of iptables.
 .TP
-.BR "--limit " "[\fIvalue\fP]"
+.BR "\-\-limit " "[\fIvalue\fP]"
 Maximum average matching rate: specified as a number, with an optional
 .IR /second ", " /minute ", " /hour ", or " /day " suffix; the default is " 3/hour .
 .TP
-.BR "--limit-burst " "[\fInumber\fP]"
+.BR "\-\-limit\-burst " "[\fInumber\fP]"
 Maximum initial number of packets to match: this number gets recharged by
 one every time the limit specified above is not reached, up to this
 number; the default is
 .IR 5 .
 .SS mark_m
 .TP
-.BR "--mark " "[!] [\fIvalue\fP][/\fImask\fP]"
+.BR "\-\-mark " "[!] [\fIvalue\fP][/\fImask\fP]"
 Matches frames with the given unsigned mark value. If a
 .IR value " and " mask " are specified, the logical AND of the mark value of the frame and"
 the user-specified
@@ -771,7 +771,7 @@ non-zero. Only specifying a
 .IR mask " is useful to match multiple mark values."
 .SS pkttype
 .TP
-.BR "--pkttype-type " "[!] \fItype\fP"
+.BR "\-\-pkttype\-type " "[!] \fItype\fP"
 Matches on the Ethernet "class" of the frame, which is determined by the
 generic networking code. Possible values:
 .IR broadcast " (MAC destination is the broadcast address),"
@@ -781,88 +781,88 @@ generic networking code. Possible values:
 .SS stp
 Specify stp BPDU (bridge protocol data unit) fields. The destination
 address
-.BR "" ( -d ") must be specified as the bridge group address"
+.BR "" ( \-d ") must be specified as the bridge group address"
 .IR "" ( BGA ).
 For all options for which a range of values can be specified, it holds that
 if the lower bound is omitted (but the colon is not), then the lowest possible lower bound
 for that option is used, while if the upper bound is omitted (but the colon again is not), the
 highest possible upper bound for that option is used.
 .TP
-.BR "--stp-type " "[!] \fItype\fP"
+.BR "\-\-stp\-type " "[!] \fItype\fP"
 The BPDU type (0\(en255), recognized non-numerical types are
 .IR config ", denoting a configuration BPDU (=0), and"
 .IR tcn ", denothing a topology change notification BPDU (=128)."
 .TP
-.BR "--stp-flags " "[!] \fIflag\fP"
+.BR "\-\-stp\-flags " "[!] \fIflag\fP"
 The BPDU flag (0\(en255), recognized non-numerical flags are
-.IR topology-change ", denoting the topology change flag (=1), and"
-.IR topology-change-ack ", denoting the topology change acknowledgement flag (=128)."
+.IR topology\-change ", denoting the topology change flag (=1), and"
+.IR topology\-change\-ack ", denoting the topology change acknowledgement flag (=128)."
 .TP
-.BR "--stp-root-prio " "[!] [\fIprio\fP][:\fIprio\fP]"
+.BR "\-\-stp\-root\-prio " "[!] [\fIprio\fP][:\fIprio\fP]"
 The root priority (0\(en65535) range.
 .TP
-.BR "--stp-root-addr " "[!] [\fIaddress\fP][/\fImask\fP]"
+.BR "\-\-stp\-root\-addr " "[!] [\fIaddress\fP][/\fImask\fP]"
 The root mac address, see the option
-.BR -s " for more details."
+.BR \-s " for more details."
 .TP
-.BR "--stp-root-cost " "[!] [\fIcost\fP][:\fIcost\fP]"
+.BR "\-\-stp\-root\-cost " "[!] [\fIcost\fP][:\fIcost\fP]"
 The root path cost (0\(en4294967295) range.
 .TP
-.BR "--stp-sender-prio " "[!] [\fIprio\fP][:\fIprio\fP]"
+.BR "\-\-stp\-sender\-prio " "[!] [\fIprio\fP][:\fIprio\fP]"
 The BPDU's sender priority (0\(en65535) range.
 .TP
-.BR "--stp-sender-addr " "[!] [\fIaddress\fP][/\fImask\fP]"
+.BR "\-\-stp\-sender\-addr " "[!] [\fIaddress\fP][/\fImask\fP]"
 The BPDU's sender mac address, see the option
-.BR -s " for more details."
+.BR \-s " for more details."
 .TP
-.BR "--stp-port " "[!] [\fIport\fP][:\fIport\fP]"
+.BR "\-\-stp\-port " "[!] [\fIport\fP][:\fIport\fP]"
 The port identifier (0\(en65535) range.
 .TP
-.BR "--stp-msg-age " "[!] [\fIage\fP][:\fIage\fP]"
+.BR "\-\-stp\-msg\-age " "[!] [\fIage\fP][:\fIage\fP]"
 The message age timer (0\(en65535) range.
 .TP
-.BR "--stp-max-age " "[!] [\fIage\fP][:\fIage\fP]"
+.BR "\-\-stp\-max\-age " "[!] [\fIage\fP][:\fIage\fP]"
 The max age timer (0\(en65535) range.
 .TP
-.BR "--stp-hello-time " "[!] [\fItime\fP][:\fItime\fP]"
+.BR "\-\-stp\-hello\-time " "[!] [\fItime\fP][:\fItime\fP]"
 The hello time timer (0\(en65535) range.
 .TP
-.BR "--stp-forward-delay " "[!] [\fIdelay\fP][:\fIdelay\fP]"
+.BR "\-\-stp\-forward\-delay " "[!] [\fIdelay\fP][:\fIdelay\fP]"
 The forward delay timer (0\(en65535) range.
 .SS string
 This module matches on a given string using some pattern matching strategy.
 .TP
-.BR "--string-algo " "\fIalgorithm\fP"
+.BR "\-\-string\-algo " "\fIalgorithm\fP"
 The pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morris)
 .TP
-.BR "--string-from " "\fIoffset\fP"
+.BR "\-\-string\-from " "\fIoffset\fP"
 The lowest offset from which a match can start. (default: 0)
 .TP
-.BR "--string-to " "\fIoffset\fP"
+.BR "\-\-string\-to " "\fIoffset\fP"
 The highest offset from which a match can start. (default: size of frame)
 .TP
-.BR "--string " "[!] \fIpattern\fP"
+.BR "\-\-string " "[!] \fIpattern\fP"
 Matches the given pattern.
 .TP
-.BR "--string-hex " "[!] \fIpattern\fP"
+.BR "\-\-string\-hex " "[!] \fIpattern\fP"
 Matches the given pattern in hex notation, e.g. '|0D 0A|', '|0D0A|', 'www|09|netfilter|03|org|00|'
 .TP
-.BR "--string-icase"
+.BR "\-\-string\-icase"
 Ignore case when searching.
 .SS vlan
 Specify 802.1Q Tag Control Information fields.
 The protocol must be specified as
 .IR 802_1Q " (0x8100)."
 .TP
-.BR "--vlan-id " "[!] \fIid\fP"
+.BR "\-\-vlan\-id " "[!] \fIid\fP"
 The VLAN identifier field (VID). Decimal number from 0 to 4095.
 .TP
-.BR "--vlan-prio " "[!] \fIprio\fP"
+.BR "\-\-vlan\-prio " "[!] \fIprio\fP"
 The user priority field, a decimal number from 0 to 7.
 The VID should be set to 0 ("null VID") or unspecified
 (in the latter case the VID is deliberately set to 0).
 .TP
-.BR "--vlan-encap " "[!] \fItype\fP"
+.BR "\-\-vlan\-encap " "[!] \fItype\fP"
 The encapsulated Ethernet frame type/length.
 Specified as a hexadecimal
 number from 0x0000 to 0xFFFF or as a symbolic name
@@ -877,36 +877,36 @@ target is executed.
 .SS log
 The log watcher writes descriptive data about a frame to the syslog.
 .TP
-.B "--log"
+.B "\-\-log"
 .br
 Log with the default loggin options: log-level=
 .IR info ,
 log-prefix="", no ip logging, no arp logging.
 .TP
-.B --log-level "\fIlevel\fP"
+.B \-\-log\-level "\fIlevel\fP"
 .br
 Defines the logging level. For the possible values, see
-.BR "ebtables -h log" .
+.BR "ebtables \-h log" .
 The default level is 
 .IR info .
 .TP
-.BR --log-prefix " \fItext\fP"
+.BR \-\-log\-prefix " \fItext\fP"
 .br
 Defines the prefix
 .I text
 to be printed at the beginning of the line with the logging information.
 .TP
-.B --log-ip 
+.B \-\-log\-ip 
 .br
 Will log the ip information when a frame made by the ip protocol matches 
 the rule. The default is no ip information logging.
 .TP
-.B --log-ip6 
+.B \-\-log\-ip6 
 .br
 Will log the ipv6 information when a frame made by the ipv6 protocol matches 
 the rule. The default is no ipv6 information logging.
 .TP
-.B --log-arp
+.B \-\-log\-arp
 .br
 Will log the (r)arp information when a frame made by the (r)arp protocols
 matches the rule. The default is no (r)arp information logging.
@@ -919,27 +919,27 @@ through a
 socket to the specified multicast group. One or more userspace processes
 may subscribe to the group to receive the packets.
 .TP
-.B "--nflog"
+.B "\-\-nflog"
 .br
 Log with the default logging options
 .TP
-.B --nflog-group "\fInlgroup\fP"
+.B \-\-nflog\-group "\fInlgroup\fP"
 .br
-The netlink group (1\(en2^32-1) to which packets are (only applicable for
+The netlink group (1\(en2\^32\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 1.
 .TP
-.B --nflog-prefix "\fIprefix\fP"
+.B \-\-nflog\-prefix "\fIprefix\fP"
 .br
 A prefix string to include in the log message, up to 30 characters
 long, useful for distinguishing messages in the logs.
 .TP
-.B --nflog-range "\fIsize\fP"
+.B \-\-nflog\-range "\fIsize\fP"
 .br
 The number of bytes to be copied to userspace (only applicable for
 nfnetlink_log). nfnetlink_log instances may specify their own
 range, this option overrides it.
 .TP
-.B --nflog-threshold "\fIsize\fP"
+.B \-\-nflog\-threshold "\fIsize\fP"
 .br
 Number of packets to queue inside the kernel before sending them
 to userspace (only applicable for nfnetlink_log). Higher values
@@ -969,23 +969,23 @@ specifies after how many hundredths of a second the queue should be
 flushed, even if it is not full yet. The default is 10 (one tenth of
 a second).
 .TP
-.B "--ulog"
+.B "\-\-ulog"
 .br
 Use the default settings: ulog-prefix="", ulog-nlgroup=1,
 ulog-cprange=4096, ulog-qthreshold=1.
 .TP
-.B --ulog-prefix "\fItext\fP"
+.B \-\-ulog\-prefix "\fItext\fP"
 .br
 Defines the prefix included with the packets sent to userspace.
 .TP
-.BR --ulog-nlgroup " \fIgroup\fP"
+.BR \-\-ulog\-nlgroup " \fIgroup\fP"
 .br
 Defines which netlink group number to use (a number from 1 to 32).
 Make sure the netlink group numbers used for the iptables ULOG
 target differ from those used for the ebtables ulog watcher.
 The default group number is 1.
 .TP
-.BR --ulog-cprange " \fIrange\fP"
+.BR \-\-ulog\-cprange " \fIrange\fP"
 .br
 Defines the maximum copy range to userspace, for packets matching the
 rule. The default range is 0, which means the maximum copy range is
@@ -995,7 +995,7 @@ A maximum copy range larger than
 128*1024 is meaningless as the packets sent to userspace have an upper
 size limit of 128*1024.
 .TP
-.BR --ulog-qthreshold " \fIthreshold\fP"
+.BR \-\-ulog\-qthreshold " \fIthreshold\fP"
 .br
 Queue at most
 .I threshold
@@ -1020,11 +1020,11 @@ for an IP address on an Ethernet network, it is ignored by this target
 When the ARP request is malformed, it is dropped
 .BR "" ( DROP ).
 .TP
-.BR "--arpreply-mac " "\fIaddress\fP"
+.BR "\-\-arpreply\-mac " "\fIaddress\fP"
 Specifies the MAC address to reply with: the Ethernet source MAC and the
 ARP payload source MAC will be filled in with this address.
 .TP
-.BR "--arpreply-target " "\fItarget\fP"
+.BR "\-\-arpreply\-target " "\fItarget\fP"
 Specifies the standard target. After sending the ARP reply, the rule still
 has to give a standard target so ebtables knows what to do with the ARP request.
 The default target
@@ -1037,15 +1037,15 @@ target can only be used in the
 .BR PREROUTING " and " OUTPUT " chains of the " nat " table."
 It specifies that the destination MAC address has to be changed.
 .TP
-.BR "--to-destination " "\fIaddress\fP"
+.BR "\-\-to\-destination " "\fIaddress\fP"
 .br
 Change the destination MAC address to the specified
 .IR address .
 The flag
-.B --to-dst
+.B \-\-to\-dst
 is an alias for this option.
 .TP
-.BR "--dnat-target " "\fItarget\fP"
+.BR "\-\-dnat\-target " "\fItarget\fP"
 .br
 Specifies the standard target. After doing the dnat, the rule still has to
 give a standard target so ebtables knows what to do with the dnated frame.
@@ -1064,27 +1064,27 @@ to use the marking of a frame/packet in both ebtables and iptables,
 if the bridge-nf code is compiled into the kernel. Both put the marking at the
 same place. This allows for a form of communication between ebtables and iptables.
 .TP
-.BR "--mark-set " "\fIvalue\fP"
+.BR "\-\-mark\-set " "\fIvalue\fP"
 .br
 Mark the frame with the specified non-negative
 .IR value .
 .TP
-.BR "--mark-or " "\fIvalue\fP"
+.BR "\-\-mark\-or " "\fIvalue\fP"
 .br
 Or the frame with the specified non-negative
 .IR value .
 .TP
-.BR "--mark-and " "\fIvalue\fP"
+.BR "\-\-mark\-and " "\fIvalue\fP"
 .br
 And the frame with the specified non-negative
 .IR value .
 .TP
-.BR "--mark-xor " "\fIvalue\fP"
+.BR "\-\-mark\-xor " "\fIvalue\fP"
 .br
 Xor the frame with the specified non-negative
 .IR value .
 .TP
-.BR "--mark-target " "\fItarget\fP"
+.BR "\-\-mark\-target " "\fItarget\fP"
 .br
 Specifies the standard target. After marking the frame, the rule
 still has to give a standard target so ebtables knows what to do.
@@ -1102,7 +1102,7 @@ In the
 .BR BROUTING " chain, the MAC address of the bridge port is used as destination address,"
 .BR "" "in the " PREROUTING " chain, the MAC address of the bridge is used."
 .TP
-.BR "--redirect-target " "\fItarget\fP"
+.BR "\-\-redirect\-target " "\fItarget\fP"
 .br
 Specifies the standard target. After doing the MAC redirect, the rule
 still has to give a standard target so ebtables knows what to do.
@@ -1118,14 +1118,14 @@ target can only be used in the
 .BR POSTROUTING " chain of the " nat " table."
 It specifies that the source MAC address has to be changed.
 .TP
-.BR "--to-source " "\fIaddress\fP"
+.BR "\-\-to\-source " "\fIaddress\fP"
 .br
 Changes the source MAC address to the specified
 .IR address ". The flag"
-.B --to-src
+.B \-\-to\-src
 is an alias for this option.
 .TP
-.BR "--snat-target " "\fItarget\fP"
+.BR "\-\-snat\-target " "\fItarget\fP"
 .br
 Specifies the standard target. After doing the snat, the rule still has 
 to give a standard target so ebtables knows what to do.
@@ -1135,7 +1135,7 @@ to give a standard target so ebtables knows what to do.
 .BR "" "that using " RETURN " in a base chain is not allowed."
 .br
 .TP
-.BR "--snat-arp "
+.BR "\-\-snat\-arp "
 .br
 Also change the hardware source address inside the arp header if the packet is an
 arp message and the hardware address length in the arp header is 6 bytes.
-- 
2.42.1

