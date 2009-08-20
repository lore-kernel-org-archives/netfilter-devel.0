From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] manpages: more fixes to minuses, hyphens, dashes
Date: Thu, 20 Aug 2009 17:09:38 +0200
Message-ID: <1250780978-14013-5-git-send-email-jengelh@medozas.de>
References: <1250780978-14013-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40290 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbZHTPJq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:09:46 -0400
In-Reply-To: <1250780978-14013-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Debian still carries patches patches to the iptables nroff code touching
ASCII minuses, so I thought, what's it this time.

Eventually, this patch tries to straighten things once more, per
http://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style#Hyphens and
http://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style#Dashes .

Titles will get the em dash; all typed commands or parameters with a
hyphen get a minus (so that man(1) hyperlinking and copy-pasting does
work), but other mentions get the hyphen.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_NFLOG.man     |    2 +-
 extensions/libxt_connbytes.man |    2 +-
 ip6tables-restore.8            |    7 +++----
 ip6tables-save.8               |    4 ++--
 ip6tables.8.in                 |    6 +++---
 iptables-restore.8             |    7 +++----
 iptables-save.8                |    4 ++--
 iptables-xml.8                 |   10 ++++------
 iptables.8.in                  |    4 ++--
 libipq/ipq_create_handle.3     |    4 ++--
 libipq/ipq_errstr.3            |    2 +-
 libipq/ipq_message_type.3      |    2 +-
 libipq/ipq_read.3              |    4 ++--
 libipq/ipq_set_mode.3          |    4 ++--
 libipq/ipq_set_verdict.3       |    4 ++--
 libipq/libipq.3                |    4 ++--
 16 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/extensions/libxt_NFLOG.man b/extensions/libxt_NFLOG.man
index 861501b..66f0b97 100644
--- a/extensions/libxt_NFLOG.man
+++ b/extensions/libxt_NFLOG.man
@@ -9,7 +9,7 @@ may subscribe to the group to receive the packets. Like LOG, this is a
 non-terminating target, i.e. rule traversal continues at the next rule.
 .TP
 \fB\-\-nflog\-group\fP \fInlgroup\fP
-The netlink group (1 - 2^32\-1) to which packets are (only applicable for
+The netlink group (1 \- 2^32\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 0.
 .TP
 \fB\-\-nflog\-prefix\fP \fIprefix\fP
diff --git a/extensions/libxt_connbytes.man b/extensions/libxt_connbytes.man
index e475cae..0504a55 100644
--- a/extensions/libxt_connbytes.man
+++ b/extensions/libxt_connbytes.man
@@ -8,7 +8,7 @@ The primary use is to detect long-lived downloads and mark them to be
 scheduled using a lower priority band in traffic control.
 .PP
 The transferred bytes per connection can also be viewed through
-`conntrack -L` and accessed via ctnetlink.
+`conntrack \-L` and accessed via ctnetlink.
 .PP
 NOTE that for connections which have no accounting information, the match will
 always return false. The "net.netfilter.nf_conntrack_acct" sysctl flag controls
diff --git a/ip6tables-restore.8 b/ip6tables-restore.8
index 43c1268..0264807 100644
--- a/ip6tables-restore.8
+++ b/ip6tables-restore.8
@@ -19,10 +19,9 @@
 .\"
 .\"
 .SH NAME
-ip6tables-restore \- Restore IPv6 Tables
+ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-.BR "ip6tables-restore " "[-c] [-n]"
-.br
+\fBip6tables\-restore\fP [\fB\-c\fP] [\fB\-n\fP]
 .SH DESCRIPTION
 .PP
 .B ip6tables-restore
@@ -44,7 +43,7 @@ Harald Welte <laforge@gnumonks.org>
 .br
 Andras Kis-Szabo <kisza@sch.bme.hu>
 .SH SEE ALSO
-.BR ip6tables-save "(8), " ip6tables "(8) "
+\fBip6tables\-save\fP(8), \fBip6tables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the
diff --git a/ip6tables-save.8 b/ip6tables-save.8
index c760b32..457be82 100644
--- a/ip6tables-save.8
+++ b/ip6tables-save.8
@@ -19,7 +19,7 @@
 .\"
 .\"
 .SH NAME
-ip6tables-save - dump iptables rules to stdout
+ip6tables-save \(em dump iptables rules to stdout
 .SH SYNOPSIS
 \fBip6tables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
 [\fB\-t\fP \fItable\fP
@@ -46,7 +46,7 @@ Harald Welte <laforge@gnumonks.org>
 .br
 Andras Kis-Szabo <kisza@sch.bme.hu>
 .SH SEE ALSO
-.BR ip6tables-restore "(8), " ip6tables "(8) "
+\fBip6tables\-restore\fP(8), \fBip6tables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the
diff --git a/ip6tables.8.in b/ip6tables.8.in
index 8037dc7..7d9a617 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -1,4 +1,4 @@
-.TH IP6TABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH IP6TABLES 8 "" "iptables 1.4.4" "iptables 1.4.4"
 .\"
 .\" Man page written by Andras Kis-Szabo <kisza@sch.bme.hu>
 .\" It is based on iptables man page.
@@ -25,7 +25,7 @@
 .\"
 .\"
 .SH NAME
-ip6tables - IPv6 packet filter administration
+ip6tables \(em IPv6 packet filter administration
 .SH SYNOPSIS
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain
 rule-specification\fP [\fIoptions...\fP]
@@ -175,7 +175,7 @@ arguments given. The exact rules are suppressed until you use
 .TP
 \fB\-S\fP, \fB\-\-list\-rules\fP [\fIchain\fP]
 Print all rules in the selected chain.  If no chain is selected, all
-chains are printed like ip6tables\-save. Like every other ip6tables command,
+chains are printed like ip6tables-save. Like every other ip6tables command,
 it applies to the specified table (filter is the default).
 .TP
 \fB\-F\fP, \fB\-\-flush\fP [\fIchain\fP]
diff --git a/iptables-restore.8 b/iptables-restore.8
index e80d943..a52bceb 100644
--- a/iptables-restore.8
+++ b/iptables-restore.8
@@ -19,10 +19,9 @@
 .\"
 .\"
 .SH NAME
-iptables-restore \- Restore IP Tables
+iptables-restore \(em Restore IP Tables
 .SH SYNOPSIS
-.BR "iptables-restore " "[-c] [-n]"
-.br
+\fBiptables\-restore\fP [\fB\-c\fP] [\fB\-n\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-restore
@@ -41,7 +40,7 @@ None known as of iptables-1.2.1 release
 .SH AUTHOR
 Harald Welte <laforge@gnumonks.org>
 .SH SEE ALSO
-.BR iptables-save "(8), " iptables "(8) "
+\fBiptables\-save\fP(8), \fBiptables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the
diff --git a/iptables-save.8 b/iptables-save.8
index c1729fe..c2e0a94 100644
--- a/iptables-save.8
+++ b/iptables-save.8
@@ -19,7 +19,7 @@
 .\"
 .\"
 .SH NAME
-iptables-save - dump iptables rules to stdout
+iptables-save \(em dump iptables rules to stdout
 .SH SYNOPSIS
 \fBiptables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
 [\fB\-t\fP \fItable\fP]
@@ -44,7 +44,7 @@ None known as of iptables-1.2.1 release
 .SH AUTHOR
 Harald Welte <laforge@gnumonks.org>
 .SH SEE ALSO
-.BR iptables-restore "(8), " iptables "(8) "
+\fBiptables\-restore\fP(8), \fBiptables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the
diff --git a/iptables-xml.8 b/iptables-xml.8
index 705dc5e..048c2cb 100644
--- a/iptables-xml.8
+++ b/iptables-xml.8
@@ -19,10 +19,9 @@
 .\"
 .\"
 .SH NAME
-iptables-xml \- Convert iptables-save format to XML
+iptables-xml \(em Convert iptables-save format to XML
 .SH SYNOPSIS
-.BR "iptables-xml " "[-c] [-v]"
-.br
+\fBiptables\-xml\fP [\fB\-c\fP] [\fB\-v\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-xml
@@ -42,7 +41,7 @@ Output xml comments containing the iptables line from which the XML is derived
 
 .PP
 iptables-xml does a mechanistic conversion to a very expressive xml
-format; the only semantic considerations are for -g and -j targets in
+format; the only semantic considerations are for \-g and \-j targets in
 order to discriminate between <call> <goto> and <nane-of-target> as it
 helps xml processing scripts if they can tell the difference between a
 target like SNAT and another chain.
@@ -85,5 +84,4 @@ None known as of iptables-1.3.7 release
 .SH AUTHOR
 Sam Liddicott <azez@ufomechanic.net>
 .SH SEE ALSO
-.BR iptables-save "(8), " iptables-restore "(8), " iptables "(8) "
-.PP
+\fBiptables\-save\fP(8), \fBiptables\-restore\fP(8), \fBiptables\fP(8)
diff --git a/iptables.8.in b/iptables.8.in
index cb6e6b0..6125e65 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -23,7 +23,7 @@
 .\"
 .\"
 .SH NAME
-iptables - administration tool for IPv4 packet filtering and NAT
+iptables \(em administration tool for IPv4 packet filtering and NAT
 .SH SYNOPSIS
 \fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain\fP \fIrule-specification\fP
 .PP
@@ -182,7 +182,7 @@ arguments given. The exact rules are suppressed until you use
 .TP
 \fB\-S\fP, \fB\-\-list\-rules\fP [\fIchain\fP]
 Print all rules in the selected chain.  If no chain is selected, all
-chains are printed like iptables\-save. Like every other iptables command,
+chains are printed like iptables-save. Like every other iptables command,
 it applies to the specified table (filter is the default).
 .TP
 \fB\-F\fP, \fB\-\-flush\fP [\fIchain\fP]
diff --git a/libipq/ipq_create_handle.3 b/libipq/ipq_create_handle.3
index 7840277..6c0c796 100644
--- a/libipq/ipq_create_handle.3
+++ b/libipq/ipq_create_handle.3
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-ipq_create_handle, ipq_destroy_handle - create and destroy libipq handles.
+ipq_create_handle, ipq_destroy_handle \(em create and destroy libipq handles.
 .SH SYNOPSIS
 .B #include <linux/netfilter.h>
 .br
@@ -65,7 +65,7 @@ On success,
 .B ipq_destroy_handle
 returns zero.
 .br
-On failure, -1 is returned.
+On failure, \-1 is returned.
 .SH ERRORS
 On failure, a descriptive error message will be available
 via the
diff --git a/libipq/ipq_errstr.3 b/libipq/ipq_errstr.3
index 9661469..bcb3ac4 100644
--- a/libipq/ipq_errstr.3
+++ b/libipq/ipq_errstr.3
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-ipq_errstr, ipq_perror - libipq error handling routines
+ipq_errstr, ipq_perror \(em libipq error handling routines
 .SH SYNOPSIS
 .B #include <linux/netfilter.h>
 .br
diff --git a/libipq/ipq_message_type.3 b/libipq/ipq_message_type.3
index 0594518..64b5220 100644
--- a/libipq/ipq_message_type.3
+++ b/libipq/ipq_message_type.3
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-ipq_message_type, ipq_get_packet, ipq_getmsgerr - query queue messages
+ipq_message_type, ipq_get_packet, ipq_getmsgerr \(em query queue messages
 .SH SYNOPSIS
 .B #include <linux/netfilter.h>
 .br
diff --git a/libipq/ipq_read.3 b/libipq/ipq_read.3
index 5d96737..171c916 100644
--- a/libipq/ipq_read.3
+++ b/libipq/ipq_read.3
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-ipq_read - read queue messages from ip_queue and read into supplied buffer
+ipq_read \(em read queue messages from ip_queue and read into supplied buffer
 .SH SYNOPSIS
 .B #include <linux/netfilter.h>
 .br
@@ -64,7 +64,7 @@ should not be accessed directly.  Use the
 .BR ipq_get_msgerr
 functions to access the queue message in the buffer.
 .SH RETURN VALUE
-On failure, -1 is returned.
+On failure, \-1 is returned.
 .br
 On success, a non-zero positive value is returned when no timeout
 value is specified.
diff --git a/libipq/ipq_set_mode.3 b/libipq/ipq_set_mode.3
index 241581e..672ee4e 100644
--- a/libipq/ipq_set_mode.3
+++ b/libipq/ipq_set_mode.3
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-ipq_set_mode - set the ip_queue queuing mode
+ipq_set_mode \(em set the ip_queue queuing mode
 .SH SYNOPSIS
 .B #include <linux/netfilter.h>
 .br
@@ -68,7 +68,7 @@ Note that as the underlying Netlink messaging transport is connectionless,
 the ip_queue module does not know that a userspace application is ready to
 communicate until it receives a message such as this.
 .SH RETURN VALUE
-On failure, -1 is returned.
+On failure, \-1 is returned.
 .br
 On success, a non-zero positive value is returned.
 .SH ERRORS
diff --git a/libipq/ipq_set_verdict.3 b/libipq/ipq_set_verdict.3
index 002e9fb..e9d3d3f 100644
--- a/libipq/ipq_set_verdict.3
+++ b/libipq/ipq_set_verdict.3
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-ipq_set_verdict - issue verdict and optionally modified packet to kernel
+ipq_set_verdict \(em issue verdict and optionally modified packet to kernel
 .SH SYNOPSIS
 .B #include <linux/netfilter.h>
 .br
@@ -80,7 +80,7 @@ and NULL for
 The application is responsible for recalculating any packet checksums
 when modifying packets.
 .SH RETURN VALUE
-On failure, -1 is returned.
+On failure, \-1 is returned.
 .br
 On success, a non-zero positive value is returned.
 .SH ERRORS
diff --git a/libipq/libipq.3 b/libipq/libipq.3
index 9dafa4a..0196248 100644
--- a/libipq/libipq.3
+++ b/libipq/libipq.3
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-libipq \- iptables userspace packet queuing library.
+libipq \(em iptables userspace packet queuing library.
 .SH SYNOPSIS
 .B #include <linux/netfilter.h>
 .br
@@ -51,7 +51,7 @@ running the following commands:
 .br	
 	# modprobe ip_queue
 .br	
-	# iptables -A OUTPUT -p icmp -j QUEUE
+	# iptables \-A OUTPUT \-p icmp \-j QUEUE
 .PP
 will cause any locally generated ICMP packets (e.g. ping output) to
 be sent to the ip_queue module, which will then attempt to deliver the
-- 
1.6.4

