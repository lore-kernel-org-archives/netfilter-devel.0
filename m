Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBD9C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjKMKca (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjKMKc3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:32:29 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B409D78
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:32:23 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 7F61958725FE9; Mon, 13 Nov 2023 11:32:17 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 115E258725FEA
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:32:15 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 7/7] man: more backslash-encoding of characters
Date:   Mon, 13 Nov 2023 11:30:12 +0100
Message-ID: <20231113103156.57745-8-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113103156.57745-1-jengelh@inai.de>
References: <20231113103156.57745-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"-" is the dash, "\-" is minus as we know, but groff lists some more
characters: "^" is "modifier circumflex" and "~" is "modifier tilde",
which, too, need to be escaped for our use.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_CONNMARK.man    |   4 +-
 extensions/libxt_NFLOG.man       |   2 +-
 iptables/arptables-nft-restore.8 |   2 +-
 iptables/arptables-nft.8         | 108 +++++++++++++++----------------
 iptables/ebtables-nft.8          |   2 +-
 iptables/xtables-nft.8           |  16 ++---
 iptables/xtables-translate.8     |  32 ++++-----
 7 files changed, 83 insertions(+), 83 deletions(-)

diff --git a/extensions/libxt_CONNMARK.man b/extensions/libxt_CONNMARK.man
index 93179239..742df11d 100644
--- a/extensions/libxt_CONNMARK.man
+++ b/extensions/libxt_CONNMARK.man
@@ -8,7 +8,7 @@ Zero out the bits given by \fImask\fP and XOR \fIvalue\fP into the ctmark.
 Copy the packet mark (nfmark) to the connection mark (ctmark) using the given
 masks. The new nfmark value is determined as follows:
 .IP
-ctmark = (ctmark & ~ctmask) ^ (nfmark & nfmask)
+ctmark = (ctmark & \~ctmask) \^ (nfmark & nfmask)
 .IP
 i.e. \fIctmask\fP defines what bits to clear and \fInfmask\fP what bits of the
 nfmark to XOR into the ctmark. \fIctmask\fP and \fInfmask\fP default to
@@ -18,7 +18,7 @@ nfmark to XOR into the ctmark. \fIctmask\fP and \fInfmask\fP default to
 Copy the connection mark (ctmark) to the packet mark (nfmark) using the given
 masks. The new ctmark value is determined as follows:
 .IP
-nfmark = (nfmark & ~\fInfmask\fP) ^ (ctmark & \fIctmask\fP);
+nfmark = (nfmark & \~\fInfmask\fP) \^ (ctmark & \fIctmask\fP);
 .IP
 i.e. \fInfmask\fP defines what bits to clear and \fIctmask\fP what bits of the
 ctmark to XOR into the nfmark. \fIctmask\fP and \fInfmask\fP default to
diff --git a/extensions/libxt_NFLOG.man b/extensions/libxt_NFLOG.man
index 361311b2..43629893 100644
--- a/extensions/libxt_NFLOG.man
+++ b/extensions/libxt_NFLOG.man
@@ -9,7 +9,7 @@ may subscribe to the group to receive the packets. Like LOG, this is a
 non-terminating target, i.e. rule traversal continues at the next rule.
 .TP
 \fB\-\-nflog\-group\fP \fInlgroup\fP
-The netlink group (0\(en2^16\-1) to which packets are (only applicable for
+The netlink group (0\(en2\^16\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 0.
 .TP
 \fB\-\-nflog\-prefix\fP \fIprefix\fP
diff --git a/iptables/arptables-nft-restore.8 b/iptables/arptables-nft-restore.8
index 0e525fe3..596ca1c9 100644
--- a/iptables/arptables-nft-restore.8
+++ b/iptables/arptables-nft-restore.8
@@ -22,7 +22,7 @@
 .SH NAME
 arptables-restore \(em Restore ARP Tables (nft-based)
 .SH SYNOPSIS
-\fBarptables\-restore
+\fBarptables\-restore\fP
 .SH DESCRIPTION
 .PP
 .B arptables-restore
diff --git a/iptables/arptables-nft.8 b/iptables/arptables-nft.8
index 444b0015..2bee9f2b 100644
--- a/iptables/arptables-nft.8
+++ b/iptables/arptables-nft.8
@@ -102,11 +102,11 @@ section of this man page.
 There is only one ARP table in the Linux
 kernel.  The table is
 .BR filter.
-You can drop the '-t filter' argument to the arptables command.
-The -t argument must be the
+You can drop the '\-t filter' argument to the arptables command.
+The \-t argument must be the
 first argument on the arptables command line, if used.
 .TP
-.B "-t, --table"
+.B "\-t, \-\-table"
 .br
 .BR filter ,
 is the only table and contains two built-in chains:
@@ -123,79 +123,79 @@ are commands, miscellaneous commands, rule-specifications, match-extensions,
 and watcher-extensions.
 .SS COMMANDS
 The arptables command arguments specify the actions to perform on the table
-defined with the -t argument.  If you do not use the -t argument to name
+defined with the \-t argument. If you do not use the \-t argument to name
 a table, the commands apply to the default filter table.
 With the exception of the
-.B "-Z"
+.B "\-Z"
 command, only one command may be used on the command line at a time.
 .TP
-.B "-A, --append"
+.B "\-A, \-\-append"
 Append a rule to the end of the selected chain.
 .TP
-.B "-D, --delete"
+.B "\-D, \-\-delete"
 Delete the specified rule from the selected chain. There are two ways to
 use this command. The first is by specifying an interval of rule numbers
 to delete, syntax: start_nr[:end_nr]. Using negative numbers is allowed, for more
-details about using negative numbers, see the -I command. The second usage is by
+details about using negative numbers, see the \-I command. The second usage is by
 specifying the complete rule as it would have been specified when it was added.
 .TP
-.B "-I, --insert"
+.B "\-I, \-\-insert"
 Insert the specified rule into the selected chain at the specified rule number.
 If the current number of rules equals N, then the specified number can be
-between -N and N+1. For a positive number i, it holds that i and i-N-1 specify the
+between \-N and N+1. For a positive number i, it holds that i and i\-N\-1 specify the
 same place in the chain where the rule should be inserted. The number 0 specifies
 the place past the last rule in the chain and using this number is therefore
-equivalent with using the -A command.
+equivalent with using the \-A command.
 .TP
-.B "-R, --replace"
+.B "\-R, \-\-replace"
 Replaces the specified rule into the selected chain at the specified rule number.
 If the current number of rules equals N, then the specified number can be
 between 1 and N. i specifies the place in the chain where the rule should be replaced.
 .TP
-.B "-P, --policy"
+.B "\-P, \-\-policy"
 Set the policy for the chain to the given target. The policy can be
 .BR ACCEPT ", " DROP " or " RETURN .
 .TP
-.B "-F, --flush"
+.B "\-F, \-\-flush"
 Flush the selected chain. If no chain is selected, then every chain will be
 flushed. Flushing the chain does not change the policy of the
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
 .TP
-.B "-N, --new-chain"
+.B "\-N, \-\-new-chain"
 Create a new user-defined chain with the given name. The number of
 user-defined chains is unlimited. A user-defined chain name has maximum
 length of 31 characters.
 .TP
-.B "-X, --delete-chain"
+.B "\-X, \-\-delete-chain"
 Delete the specified user-defined chain. There must be no remaining references
 to the specified chain, otherwise
 .B arptables
 will refuse to delete it. If no chain is specified, all user-defined
 chains that aren't referenced will be removed.
 .TP
-.B "-E, --rename-chain"
+.B "\-E, \-\-rename\-chain"
 Rename the specified chain to a new name.  Besides renaming a user-defined
 chain, you may rename a standard chain name to a name that suits your
 taste. For example, if you like PREBRIDGING more than PREROUTING,
-then you can use the -E command to rename the PREROUTING chain. If you do
+then you can use the \-E command to rename the PREROUTING chain. If you do
 rename one of the standard
 .B arptables
 chain names, please be sure to mention
@@ -211,13 +211,13 @@ kernel table.
 
 .SS MISCELLANOUS COMMANDS
 .TP
-.B "-V, --version"
+.B "\-V, \-\-version"
 Show the version of the arptables userspace program.
 .TP
-.B "-h, --help"
+.B "\-h, \-\-help"
 Give a brief description of the command syntax.
 .TP
-.BR "-j, --jump " "\fItarget\fP"
+.BR "\-j, \-\-jump " "\fItarget\fP"
 The target of the rule. This is one of the following values:
 .BR ACCEPT ,
 .BR DROP ,
@@ -227,7 +227,7 @@ a target extension (see
 .BR "TARGET EXTENSIONS" ")"
 or a user-defined chain name.
 .TP
-.BI "-c, --set-counters " "PKTS BYTES"
+.BI "\-c, \-\-set-counters " "PKTS BYTES"
 This enables the administrator to initialize the packet and byte
 counters of a rule (during
 .B INSERT,
@@ -241,38 +241,38 @@ in the add and delete commands). A "!" option before the specification
 inverts the test for that specification. Apart from these standard rule 
 specifications there are some other command line arguments of interest.
 .TP
-.BR "-s, --source-ip " "[!] \fIaddress\fP[/\fImask]\fP"
+.BR "\-s, \-\-source\-ip " "[!] \fIaddress\fP[/\fImask]\fP"
 The Source IP specification.
 .TP 
-.BR "-d, --destination-ip " "[!] \fIaddress\fP[/\fImask]\fP"
+.BR "\-d, \-\-destination\-ip " "[!] \fIaddress\fP[/\fImask]\fP"
 The Destination IP specification.
 .TP 
-.BR "--source-mac " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-source\-mac " "[!] \fIaddress\fP[/\fImask\fP]"
 The source mac address. Both mask and address are written as 6 hexadecimal
 numbers separated by colons.
 .TP
-.BR "--destination-mac " "[!] \fIaddress\fP[/\fImask\fP]"
+.BR "\-\-destination\-mac " "[!] \fIaddress\fP[/\fImask\fP]"
 The destination mac address. Both mask and address are written as 6 hexadecimal
 numbers separated by colons.
 .TP 
-.BR "-i, --in-interface " "[!] \fIname\fP"
+.BR "\-i, \-\-in\-interface " "[!] \fIname\fP"
 The interface via which a frame is received (for the
 .B INPUT
 chain). The flag
-.B --in-if
+.B \-\-in\-if
 is an alias for this option.
 .TP
-.BR "-o, --out-interface " "[!] \fIname\fP"
+.BR "\-o, \-\-out-interface " "[!] \fIname\fP"
 The interface via which a frame is going to be sent (for the
 .B OUTPUT
 chain). The flag
-.B --out-if
+.B \-\-out\-if
 is an alias for this option.
 .TP
-.BR "-l, --h-length " "\fIlength\fP[/\fImask\fP]"
+.BR "\-l, \-\-h\-length " "\fIlength\fP[/\fImask\fP]"
 The hardware length (nr of bytes)
 .TP
-.BR "--opcode " "\fIcode\fP[/\fImask\fP]
+.BR "\-\-opcode " "\fIcode\fP[/\fImask\fP]
 The operation code (2 bytes). Available values are:
 .BR 1 = Request
 .BR 2 = Reply
@@ -284,63 +284,63 @@ The operation code (2 bytes). Available values are:
 .BR 8 = InARP_Request
 .BR 9 = ARP_NAK .
 .TP
-.BR "--h-type " "\fItype\fP[/\fImask\fP]"
+.BR "\-\-h\-type " "\fItype\fP[/\fImask\fP]"
 The hardware type (2 bytes, hexadecimal). Available values are:
 .BR 1 = Ethernet .
 .TP
-.BR "--proto-type " "\fItype\fP[/\fImask\fP]"
+.BR "\-\-proto\-type " "\fItype\fP[/\fImask\fP]"
 The protocol type (2 bytes). Available values are:
 .BR 0x800 = IPv4 .
 
 .SS TARGET-EXTENSIONS
 .B arptables
 extensions are precompiled into the userspace tool. So there is no need
-to explicitly load them with a -m option like in
+to explicitly load them with a \-m option like in
 .BR iptables .
 However, these
 extensions deal with functionality supported by supplemental kernel modules.
 .SS mangle
 .TP
-.BR "--mangle-ip-s IP address"
+.BR "\-\-mangle\-ip\-s IP address"
 Mangles Source IP Address to given value.
 .TP
-.BR "--mangle-ip-d IP address"
+.BR "\-\-mangle\-ip\-d IP address"
 Mangles Destination IP Address to given value.
 .TP
-.BR "--mangle-mac-s MAC address"
+.BR "\-\-mangle\-mac\-s MAC address"
 Mangles Source MAC Address to given value.
 .TP
-.BR "--mangle-mac-d MAC address"
+.BR "\-\-mangle\-mac\-d MAC address"
 Mangles Destination MAC Address to given value.
 .TP
-.BR "--mangle-target target "
+.BR "\-\-mangle\-target target "
 Target of ARP mangle operation
-.BR "" ( DROP ", " CONTINUE " or " ACCEPT " -- default is " ACCEPT ).
+.BR "" ( DROP ", " CONTINUE " or " ACCEPT " \(em default is " ACCEPT ).
 .SS CLASSIFY
-This module allows you to set the skb->priority value (and thus
+This module allows you to set the skb\->priority value (and thus
 classify the packet into a specific CBQ class).
 
 .TP
-.BR "--set-class major:minor"
+.BR "\-\-set\-class major:minor"
 
 Set the major and minor  class  value.  The  values  are  always
 interpreted as hexadecimal even if no 0x prefix is given.
 
 .SS MARK
-This  module  allows you to set the skb->mark value (and thus classify
+This  module  allows you to set the skb\->mark value (and thus classify
 the packet by the mark in u32)
 
 .TP
-.BR "--set-mark mark"
+.BR "\-\-set\-mark mark"
 Set the mark value. The  values  are  always
 interpreted as hexadecimal even if no 0x prefix is given
 
 .TP
-.BR "--and-mark mark"
+.BR "\-\-and\-mark mark"
 Binary AND the mark with bits.
 
 .TP
-.BR "--or-mark mark"
+.BR "\-\-or\-mark mark"
 Binary OR the mark with bits.
 
 .SH NOTES
@@ -357,6 +357,6 @@ chain in
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
 .SH SEE ALSO
-.BR xtables-nft "(8), " iptables "(8), " ebtables "(8), " ip (8)
+.BR xtables\-nft "(8), " iptables "(8), " ebtables "(8), " ip (8)
 .PP
 .BR "" "See " https://wiki.nftables.org
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 9fc845a1..641008cf 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -858,7 +858,7 @@ Log with the default logging options
 .TP
 .B --nflog-group "\fInlgroup\fP"
 .br
-The netlink group (1\(en2^32\-1) to which packets are (only applicable for
+The netlink group (1\(en2\^32\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 1.
 .TP
 .B --nflog-prefix "\fIprefix\fP"
diff --git a/iptables/xtables-nft.8 b/iptables/xtables-nft.8
index 702bf954..3ced29ca 100644
--- a/iptables/xtables-nft.8
+++ b/iptables/xtables-nft.8
@@ -105,15 +105,15 @@ One basic example is creating the skeleton ruleset in nf_tables from the
 xtables-nft tools, in a fresh machine:
 
 .nf
-	root@machine:~# iptables\-nft \-L
+	root@machine:\~# iptables\-nft \-L
 	[...]
-	root@machine:~# ip6tables\-nft \-L
+	root@machine:\~# ip6tables\-nft \-L
 	[...]
-	root@machine:~# arptables\-nft \-L
+	root@machine:\~# arptables\-nft \-L
 	[...]
-	root@machine:~# ebtables\-nft \-L
+	root@machine:\~# ebtables\-nft \-L
 	[...]
-	root@machine:~# nft list ruleset
+	root@machine:\~# nft list ruleset
 	table ip filter {
 		chain INPUT {
 			type filter hook input priority 0; policy accept;
@@ -175,12 +175,12 @@ To migrate your complete filter ruleset, in the case of \fBiptables(8)\fP,
 you would use:
 
 .nf
-	root@machine:~# iptables\-legacy\-save > myruleset # reads from x_tables
-	root@machine:~# iptables\-nft\-restore myruleset   # writes to nf_tables
+	root@machine:\~# iptables\-legacy\-save > myruleset # reads from x_tables
+	root@machine:\~# iptables\-nft\-restore myruleset   # writes to nf_tables
 .fi
 or
 .nf
-	root@machine:~# iptables\-legacy\-save | iptables-translate-restore | less
+	root@machine:\~# iptables\-legacy\-save | iptables\-translate\-restore | less
 .fi
 
 to see how rules would look like in the nft
diff --git a/iptables/xtables-translate.8 b/iptables/xtables-translate.8
index a048e8c9..ba16c525 100644
--- a/iptables/xtables-translate.8
+++ b/iptables/xtables-translate.8
@@ -38,15 +38,15 @@ ruleset from \fBiptables(8)\fP, \fBip6tables(8)\fP and \fBebtables(8)\fP to
 The available commands are:
 
 .IP \[bu] 2
-iptables-translate
+iptables\-translate
 .IP \[bu]
-iptables-restore-translate
+iptables\-restore\-translate
 .IP \[bu] 2
-ip6tables-translate
+ip6tables\-translate
 .IP \[bu]
-ip6tables-restore-translate
+ip6tables\-restore\-translate
 .IP \[bu] 2
-ebtables-translate
+ebtables\-translate
 
 .SH USAGE
 They take as input the original
@@ -69,38 +69,38 @@ Basic operation examples.
 Single command translation:
 
 .nf
-root@machine:~# iptables-translate -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
+root@machine:\~# iptables\-translate \-A INPUT \-p tcp \-\-dport 22 \-m conntrack \-\-ctstate NEW \-j ACCEPT
 nft add rule ip filter INPUT tcp dport 22 ct state new counter accept
 
-root@machine:~# ip6tables-translate -A FORWARD -i eth0 -o eth3 -p udp -m multiport --dports 111,222 -j ACCEPT
+root@machine:\~# ip6tables\-translate \-A FORWARD \-i eth0 \-o eth3 \-p udp \-m multiport \-\-dports 111,222 \-j ACCEPT
 nft add rule ip6 filter FORWARD iifname eth0 oifname eth3 meta l4proto udp udp dport { 111,222} counter accept
 .fi
 
 Whole ruleset translation:
 
 .nf
-root@machine:~# iptables-save > save.txt
-root@machine:~# cat save.txt
-# Generated by iptables-save v1.6.0 on Sat Dec 24 14:26:40 2016
+root@machine:\~# iptables\-save > save.txt
+root@machine:\~# cat save.txt
+# Generated by iptables\-save v1.6.0 on Sat Dec 24 14:26:40 2016
 *filter
 :INPUT ACCEPT [5166:1752111]
 :FORWARD ACCEPT [0:0]
 :OUTPUT ACCEPT [5058:628693]
--A FORWARD -p tcp -m tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
+\-A FORWARD \-p tcp \-m tcp \-\-dport 22 \-m conntrack \-\-ctstate NEW \-j ACCEPT
 COMMIT
 # Completed on Sat Dec 24 14:26:40 2016
 
-root@machine:~# iptables-restore-translate -f save.txt
-# Translated by iptables-restore-translate v1.6.0 on Sat Dec 24 14:26:59 2016
+root@machine:\~# iptables\-restore\-translate \-f save.txt
+# Translated by iptables\-restore\-translate v1.6.0 on Sat Dec 24 14:26:59 2016
 add table ip filter
 add chain ip filter INPUT { type filter hook input priority 0; }
 add chain ip filter FORWARD { type filter hook forward priority 0; }
 add chain ip filter OUTPUT { type filter hook output priority 0; }
 add rule ip filter FORWARD tcp dport 22 ct state new counter accept
 
-root@machine:~# iptables-restore-translate -f save.txt > ruleset.nft
-root@machine:~# nft -f ruleset.nft
-root@machine:~# nft list ruleset
+root@machine:\~# iptables\-restore\-translate \-f save.txt > ruleset.nft
+root@machine:\~# nft \-f ruleset.nft
+root@machine:\~# nft list ruleset
 table ip filter {
 	chain INPUT {
 		type filter hook input priority 0; policy accept;
-- 
2.42.1

