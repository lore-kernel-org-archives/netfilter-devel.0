Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NORMAL_HTTP_TO_IP,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A456DC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AD6D213A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfCMTqe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:46:34 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48582 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfCMTqe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 15:46:34 -0400
Received: from localhost ([::1]:33440 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h49pg-0001AR-17; Wed, 13 Mar 2019 20:46:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/6] doc: Adjust ebtables man page
Date:   Wed, 13 Mar 2019 20:46:15 +0100
Message-Id: <20190313194617.31071-5-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313194617.31071-1-phil@nwl.cc>
References: <20190313194617.31071-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Change content to match nft-variant, most notably:

* There is no broute table, drop all references to it
* Comment out description of among and string matches, we don't support
  them (yet)

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ebtables-nft.8 | 164 ++++++++++++++++------------------------
 1 file changed, 67 insertions(+), 97 deletions(-)

diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 55204ab91e8a4..db8b2ab28cca5 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -24,7 +24,7 @@
 .\"     
 .\"
 .SH NAME
-ebtables-legacy (2.0.10.4@) \- Ethernet bridge frame table administration (legacy)
+ebtables \- Ethernet bridge frame table administration (nft-based)
 .SH SYNOPSIS
 .BR "ebtables " [ -t " table ] " - [ ACDI "] chain rule specification [match extensions] [watcher extensions] target"
 .br
@@ -51,17 +51,6 @@ ebtables-legacy (2.0.10.4@) \- Ethernet bridge frame table administration (legac
 .BR "ebtables " [ -t " table ] [" --atomic-file " file] " --atomic-save
 .br
 
-.SH LEGACY
-This tool uses the old xtables/setsockopt framework, and is a legacy version
-of ebtables. That means that a new, more modern tool exists with the same
-functionality using the nf_tables framework and you are encouraged to migrate now.
-The new binaries (known as ebtables-nft and formerly known as ebtables-compat)
-uses the same syntax and semantics than this legacy one.
-
-You can still use this legacy tool. You should probably get some specific
-information from your Linux distribution or vendor.
-More docs are available at https://wiki.nftables.org
-
 .SH DESCRIPTION
 .B ebtables
 is an application program used to set up and maintain the
@@ -72,7 +61,7 @@ It is analogous to the
 application, but less complicated, due to the fact that the Ethernet protocol
 is much simpler than the IP protocol.
 .SS CHAINS
-There are three ebtables tables with built-in chains in the
+There are two ebtables tables with built-in chains in the
 Linux kernel. These tables are used to divide functionality into
 different sets of rules. Each set of rules is called a chain.
 Each chain is an ordered list of rules that can match Ethernet frames. If a
@@ -98,10 +87,7 @@ an 'extension' (see below) or a jump to a user-defined chain.
 .B ACCEPT
 means to let the frame through.
 .B DROP
-means the frame has to be dropped. In the
-.BR BROUTING " chain however, the " ACCEPT " and " DROP " target have different"
-meanings (see the info provided for the
-.BR -t " option)."
+means the frame has to be dropped.
 .B CONTINUE
 means the next rule has to be checked. This can be handy, f.e., to know how many
 frames pass a certain point in the chain, to log those frames or to apply multiple
@@ -113,14 +99,16 @@ For the extension targets please refer to the
 .B "TARGET EXTENSIONS"
 section of this man page.
 .SS TABLES
-As stated earlier, there are three ebtables tables in the Linux
+As stated earlier, there are two ebtables tables in the Linux
 kernel.  The table names are
-.BR filter ", " nat " and " broute .
-Of these three tables,
+.BR filter " and " nat .
+Of these two tables,
 the filter table is the default table that the command operates on.
 If you are working with the filter table, then you can drop the '-t filter'
 argument to the ebtables command.  However, you will need to provide
-the -t argument for the other two tables.  Moreover, the -t argument must be the
+the -t argument for
+.B nat
+table.  Moreover, the -t argument must be the
 first argument on the ebtables command line, if used. 
 .TP
 .B "-t, --table"
@@ -149,25 +137,6 @@ iptables world to ebtables it is easier to have the same names. Note that you
 can change the name
 .BR "" ( -E )
 if you don't like the default.
-.br
-.br
-.B broute
-is used to make a brouter, it has one built-in chain:
-.BR BROUTING .
-The targets
-.BR DROP " and " ACCEPT
-have a special meaning in the broute table (these names are used instead of
-more descriptive names to keep the implementation generic).
-.B DROP
-actually means the frame has to be routed, while
-.B ACCEPT
-means the frame has to be bridged. The
-.B BROUTING
-chain is traversed very early. However, it is only traversed by frames entering on
-a bridge port that is in forwarding state. Normally those frames
-would be bridged, but you can decide otherwise here. The
-.B redirect
-target is very handy here.
 .SH EBTABLES COMMAND LINE ARGUMENTS
 After the initial ebtables '-t table' command line argument, the remaining
 arguments can be divided into several groups.  These groups
@@ -553,35 +522,35 @@ If the 802.3 DSAP and SSAP values are 0xaa then the SNAP type field must
 be consulted to determine the payload protocol.  This is a two byte
 (hexadecimal) argument.  Only 802.3 frames with DSAP/SSAP 0xaa are
 checked for type.
-.SS among
-Match a MAC address or MAC/IP address pair versus a list of MAC addresses
-and MAC/IP address pairs.
-A list entry has the following format:
-.IR xx:xx:xx:xx:xx:xx[=ip.ip.ip.ip][,] ". Multiple"
-list entries are separated by a comma, specifying an IP address corresponding to
-the MAC address is optional. Multiple MAC/IP address pairs with the same MAC address
-but different IP address (and vice versa) can be specified. If the MAC address doesn't
-match any entry from the list, the frame doesn't match the rule (unless "!" was used).
-.TP
-.BR "--among-dst " "[!] \fIlist\fP"
-Compare the MAC destination to the given list. If the Ethernet frame has type
-.IR IPv4 " or " ARP ,
-then comparison with MAC/IP destination address pairs from the
-list is possible.
-.TP
-.BR "--among-src " "[!] \fIlist\fP"
-Compare the MAC source to the given list. If the Ethernet frame has type
-.IR IPv4 " or " ARP ,
-then comparison with MAC/IP source address pairs from the list
-is possible.
-.TP
-.BR "--among-dst-file " "[!] \fIfile\fP"
-Same as
-.BR --among-dst " but the list is read in from the specified file."
-.TP
-.BR "--among-src-file " "[!] \fIfile\fP"
-Same as
-.BR --among-src " but the list is read in from the specified file."
+.\" .SS among
+.\" Match a MAC address or MAC/IP address pair versus a list of MAC addresses
+.\" and MAC/IP address pairs.
+.\" A list entry has the following format:
+.\" .IR xx:xx:xx:xx:xx:xx[=ip.ip.ip.ip][,] ". Multiple"
+.\" list entries are separated by a comma, specifying an IP address corresponding to
+.\" the MAC address is optional. Multiple MAC/IP address pairs with the same MAC address
+.\" but different IP address (and vice versa) can be specified. If the MAC address doesn't
+.\" match any entry from the list, the frame doesn't match the rule (unless "!" was used).
+.\" .TP
+.\" .BR "--among-dst " "[!] \fIlist\fP"
+.\" Compare the MAC destination to the given list. If the Ethernet frame has type
+.\" .IR IPv4 " or " ARP ,
+.\" then comparison with MAC/IP destination address pairs from the
+.\" list is possible.
+.\" .TP
+.\" .BR "--among-src " "[!] \fIlist\fP"
+.\" Compare the MAC source to the given list. If the Ethernet frame has type
+.\" .IR IPv4 " or " ARP ,
+.\" then comparison with MAC/IP source address pairs from the list
+.\" is possible.
+.\" .TP
+.\" .BR "--among-dst-file " "[!] \fIfile\fP"
+.\" Same as
+.\" .BR --among-dst " but the list is read in from the specified file."
+.\" .TP
+.\" .BR "--among-src-file " "[!] \fIfile\fP"
+.\" Same as
+.\" .BR --among-src " but the list is read in from the specified file."
 .SS arp
 Specify (R)ARP fields. The protocol must be specified as
 .IR ARP " or " RARP .
@@ -822,26 +791,26 @@ The hello time timer (0-65535) range.
 .TP
 .BR "--stp-forward-delay " "[!] [\fIdelay\fP][:\fIdelay\fP]"
 The forward delay timer (0-65535) range.
-.SS string
-This module matches on a given string using some pattern matching strategy.
-.TP
-.BR "--string-algo " "\fIalgorithm\fP"
-The pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morris)
-.TP
-.BR "--string-from " "\fIoffset\fP"
-The lowest offset from which a match can start. (default: 0)
-.TP
-.BR "--string-to " "\fIoffset\fP"
-The highest offset from which a match can start. (default: size of frame)
-.TP
-.BR "--string " "[!] \fIpattern\fP"
-Matches the given pattern.
-.TP
-.BR "--string-hex " "[!] \fIpattern\fP"
-Matches the given pattern in hex notation, e.g. '|0D 0A|', '|0D0A|', 'www|09|netfilter|03|org|00|'
-.TP
-.BR "--string-icase"
-Ignore case when searching.
+.\" .SS string
+.\" This module matches on a given string using some pattern matching strategy.
+.\" .TP
+.\" .BR "--string-algo " "\fIalgorithm\fP"
+.\" The pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morris)
+.\" .TP
+.\" .BR "--string-from " "\fIoffset\fP"
+.\" The lowest offset from which a match can start. (default: 0)
+.\" .TP
+.\" .BR "--string-to " "\fIoffset\fP"
+.\" The highest offset from which a match can start. (default: size of frame)
+.\" .TP
+.\" .BR "--string " "[!] \fIpattern\fP"
+.\" Matches the given pattern.
+.\" .TP
+.\" .BR "--string-hex " "[!] \fIpattern\fP"
+.\" Matches the given pattern in hex notation, e.g. '|0D 0A|', '|0D0A|', 'www|09|netfilter|03|org|00|'
+.\" .TP
+.\" .BR "--string-icase"
+.\" Ignore case when searching.
 .SS vlan
 Specify 802.1Q Tag Control Information fields.
 The protocol must be specified as
@@ -1026,7 +995,6 @@ The default target
 The
 .B dnat
 target can only be used in the
-.BR BROUTING " chain of the " broute " table and the "
 .BR PREROUTING " and " OUTPUT " chains of the " nat " table."
 It specifies that the destination MAC address has to be changed.
 .TP
@@ -1089,11 +1057,8 @@ The
 .B redirect
 target will change the MAC target address to that of the bridge device the
 frame arrived on. This target can only be used in the
-.BR BROUTING " chain of the " broute " table and the "
 .BR PREROUTING " chain of the " nat " table."
-In the
-.BR BROUTING " chain, the MAC address of the bridge port is used as destination address,"
-.BR "" "in the " PREROUTING " chain, the MAC address of the bridge is used."
+The MAC address of the bridge is used as destination address."
 .TP
 .BR "--redirect-target " "\fItarget\fP"
 .br
@@ -1135,12 +1100,17 @@ arp message and the hardware address length in the arp header is 6 bytes.
 .br
 .SH FILES
 .I /etc/ethertypes
-.I /var/lib/ebtables/lock
 .SH ENVIRONMENT VARIABLES
 .I EBTABLES_ATOMIC_FILE
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
+.SH BUGS
+The version of ebtables this man page ships with does not support the
+.B broute
+table. Also there is no support for
+.BR among " and " string
+matches. And finally, this list is probably not complete.
 .SH SEE ALSO
-.BR iptables "(8), " brctl "(8), " ifconfig "(8), " route (8)
+.BR xtables-nft "(8), " iptables "(8), " ip (8)
 .PP
-.BR "" "See " http://ebtables.sf.net
+.BR "" "See " https://wiki.nftables.org
-- 
2.21.0

