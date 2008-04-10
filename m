From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/13] manpages: grammar and spelling
Date: Thu, 10 Apr 2008 09:38:15 +0200
Message-ID: <37f57a5f01350c36ccef95c2f5d01815d650767e.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50183 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbYDJHiW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:38:22 -0400
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libip6t_frag.man    |    2 +-
 extensions/libipt_SAME.man     |    2 +-
 extensions/libxt_NFQUEUE.man   |    2 +-
 extensions/libxt_connbytes.man |    4 ++--
 extensions/libxt_dscp.man      |    2 +-
 extensions/libxt_hashlimit.man |    4 ++--
 ip6tables.8.in                 |    2 +-
 ip6tables.c                    |    2 +-
 iptables.8.in                  |   10 +++++-----
 iptables.c                     |    2 +-
 10 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/extensions/libip6t_frag.man b/extensions/libip6t_frag.man
index 5ac13a4..8937b55 100644
--- a/extensions/libip6t_frag.man
+++ b/extensions/libip6t_frag.man
@@ -17,4 +17,4 @@ Matches on the first fragment.
 Matches if there are more fragments.
 .TP
 .BR "[--fraglast]"
-Matches if this is the last fragement.
+Matches if this is the last fragment.
diff --git a/extensions/libipt_SAME.man b/extensions/libipt_SAME.man
index 4e88d48..d038615 100644
--- a/extensions/libipt_SAME.man
+++ b/extensions/libipt_SAME.man
@@ -11,5 +11,5 @@ Don't use the destination-ip in the calculations when selecting the
 new source-ip
 .TP
 .B "--random"
-Port mapping will be forcely randomized to avoid attacks based on 
+Port mapping will be forcibly randomized to avoid attacks based on 
 port prediction (kernel >= 2.6.21).
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index 015effd..acd45e9 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -3,7 +3,7 @@ you to put a packet into any specific queue, identified by its 16-bit queue
 number.  
 .TP
 \fB--queue-num\fP \fIvalue\fP
-This specifies the QUEUE number to use. Valud queue numbers are 0 to 65535. The default value is 0.
+This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
 .TP
 It can only be used with Kernel versions 2.6.14 or later, since it requires
 the
diff --git a/extensions/libxt_connbytes.man b/extensions/libxt_connbytes.man
index 7b7c313..124ff6f 100644
--- a/extensions/libxt_connbytes.man
+++ b/extensions/libxt_connbytes.man
@@ -1,5 +1,5 @@
 Match by how many bytes or packets a connection (or one of the two
-flows constituting the connection) have tranferred so far, or by
+flows constituting the connection) has transferred so far, or by
 average bytes per packet.
 
 The counters are 64bit and are thus not expected to overflow ;)
@@ -7,7 +7,7 @@ The counters are 64bit and are thus not expected to overflow ;)
 The primary use is to detect long-lived downloads and mark them to be
 scheduled using a lower priority band in traffic control.
 
-The transfered bytes per connection can also be viewed through
+The transferred bytes per connection can also be viewed through
 /proc/net/ip_conntrack and accessed via ctnetlink
 .TP
 [\fB!\fP] \fB--connbytes\fP \fIfrom\fP[\fB:\fR\fIto\fP]
diff --git a/extensions/libxt_dscp.man b/extensions/libxt_dscp.man
index cb0b6f3..29ff3b2 100644
--- a/extensions/libxt_dscp.man
+++ b/extensions/libxt_dscp.man
@@ -7,4 +7,4 @@ Match against a numeric (decimal or hex) value [0-63].
 .BI "--dscp-class " "\fIDiffServ Class\fP"
 Match the DiffServ class. This value may be any of the
 BE, EF, AFxx or CSx classes.  It will then be converted
-into it's according numeric value.
+into its according numeric value.
diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index e74aedf..e449406 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -53,7 +53,7 @@ The number of buckets of the hash table
 Maximum entries in the hash.
 .TP
 \fB--hashlimit-htable-expire\fR \fImsec\fR
-After how many miliseconds do hash entries expire.
+After how many milliseconds do hash entries expire.
 .TP
 \fB--hashlimit-htable-gcinterval\fR \fImsec\fR
-How many miliseconds between garbage collection intervals.
+How many milliseconds between garbage collection intervals.
diff --git a/ip6tables.8.in b/ip6tables.8.in
index 8528b8e..f103363 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -478,7 +478,7 @@ James Morris wrote the TOS target, and tos match.
 .PP
 Jozsef Kadlecsik wrote the REJECT target.
 .PP
-Harald Welte wrote the ULOG and NFQUEUE target, the new libiptc, aswell as TTL match+target and libipulog.
+Harald Welte wrote the ULOG and NFQUEUE target, the new libiptc, as well as TTL match+target and libipulog.
 .PP
 The Netfilter Core Team is: Marc Boucher, Martin Josefsson, Yasuyuki Kozakai,
 Jozsef Kadlecsik, Patrick McHardy, James Morris, Pablo Neira Ayuso,
diff --git a/ip6tables.c b/ip6tables.c
index e5602f7..c7d4a4f 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -720,7 +720,7 @@ print_match(const struct ip6t_entry_match *m,
 	return 0;
 }
 
-/* e is called `fw' here for hysterical raisins */
+/* e is called `fw' here for historical reasons */
 static void
 print_firewall(const struct ip6t_entry *fw,
 	       const char *targname,
diff --git a/iptables.8.in b/iptables.8.in
index 9904c48..8ebedb8 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -55,7 +55,7 @@ a `target', which may be a jump to a user-defined chain in the same
 table.
 
 .SH TARGETS
-A firewall rule specifies criteria for a packet, and a target.  If the
+A firewall rule specifies criteria for a packet and a target.  If the
 packet does not match, the next rule in the chain is the examined; if
 it does match, then the next rule is specified by the value of the
 target, which can be the name of a user-defined chain or one of the
@@ -155,9 +155,9 @@ The options that are recognized by
 .B iptables
 can be divided into several different groups.
 .SS COMMANDS
-These options specify the specific action to perform.  Only one of them
-can be specified on the command line unless otherwise specified
-below.  For all the long versions of the command and option names, you
+These options specify the desired action to perform. Only one of them
+can be specified on the command line unless otherwise stated
+below. For long versions of the command and option names, you
 need to use only enough letters to ensure that
 .B iptables
 can differentiate it from all other options.
@@ -188,7 +188,7 @@ fail.  Rules are numbered starting at 1.
 .TP
 .BR "-L, --list " "[\fIchain\fP]"
 List all rules in the selected chain.  If no chain is selected, all
-chains are listed.  As every other iptables command, it applies to the
+chains are listed. Like every other iptables command, it applies to the
 specified table (filter is the default), so NAT rules get listed by
 .nf
  iptables -t nat -n -L
diff --git a/iptables.c b/iptables.c
index b2a4b53..7cc2448 100644
--- a/iptables.c
+++ b/iptables.c
@@ -720,7 +720,7 @@ print_match(const struct ipt_entry_match *m,
 	return 0;
 }
 
-/* e is called `fw' here for hysterical raisins */
+/* e is called `fw' here for historical reasons */
 static void
 print_firewall(const struct ipt_entry *fw,
 	       const char *targname,
-- 
1.5.5.rc3

