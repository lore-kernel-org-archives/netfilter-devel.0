From: Jan Engelhardt <jengelh@medozas.de>
Subject: doc: resynchronize markup in iptables,ip6tables.8.in
Date: Thu, 8 Jan 2009 17:08:57 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901081708490.26931@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53142 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZAHQJA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:09:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent e994c6afd02cf70fc85256bb143df496e24effc3
commit fbb9d345e207d1441922d22e0be86f428c815ae7
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jan 8 17:07:41 2009 +0100

doc: resynchronize markup in iptables,ip6tables.8.in

Change .br to .PP in the intro section and use consistent
paragraphing in later ones.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.8.in |   23 +++++++++++------------
 iptables.8.in  |    5 ++---
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/ip6tables.8.in b/ip6tables.8.in
index 3b473bf..6308e02 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -28,23 +28,23 @@
 ip6tables \- IPv6 packet filter administration
 .SH SYNOPSIS
 \fBip6tables\fP [\fB-t\fP \fItable\fP] {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
-.br
+.PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
-.br
+.PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
-.br
+.PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-D\fP \fIchain rulenum\fP [\fIoptions...\fP]
-.br
+.PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-S\fP [\fIchain\fP]
-.br
+.PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
-.br
+.PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-N\fP \fIchain\fP
-.br
+.PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-X\fP [\fIchain\fP]
-.br
+.PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-P\fP \fIchain target\fP [\fIoptions...\fP]
-.br
+.PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-E\fP \fIold-chain-name new-chain-name\fP
 .SH DESCRIPTION
 \fBIp6tables\fP is used to set up, maintain, and inspect the
@@ -52,12 +52,11 @@ tables of IPv6 packet
 filter rules in the Linux kernel.  Several different tables
 may be defined.  Each table contains a number of built-in
 chains and may also contain user-defined chains.
-
+.PP
 Each chain is a list of rules which can match a set of packets.  Each
 rule specifies what to do with a packet that matches.  This is called
 a `target', which may be a jump to a user-defined chain in the same
 table.
-
 .SH TARGETS
 A firewall rule specifies criteria for a packet and a target.  If the
 packet does not match, the next rule in the chain is the examined; if
@@ -337,7 +336,7 @@ module.  You can specify multiple extended match modules in one line,
 and you can use the \fB-h\fP or \fB--help\fP
 options after the module has been specified to receive help specific
 to that module.
-
+.PP
 The following are included in the base package, and most of these can
 be preceded by a "\fB!\fP" to invert the sense of the match.
 .\" @MATCH@
diff --git a/iptables.8.in b/iptables.8.in
index b9d6383..7754c8c 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -56,12 +56,11 @@ tables of IPv4 packet
 filter rules in the Linux kernel.  Several different tables
 may be defined.  Each table contains a number of built-in
 chains and may also contain user-defined chains.
-
+.PP
 Each chain is a list of rules which can match a set of packets.  Each
 rule specifies what to do with a packet that matches.  This is called
 a `target', which may be a jump to a user-defined chain in the same
 table.
-
 .SH TARGETS
 A firewall rule specifies criteria for a packet and a target.  If the
 packet does not match, the next rule in the chain is the examined; if
@@ -342,7 +341,7 @@ module.  You can specify multiple extended match modules in one line,
 and you can use the \fB-h\fP or \fB--help\fP
 options after the module has been specified to receive help specific
 to that module.
-
+.PP
 The following are included in the base package, and most of these can
 be preceded by a "\fB!\fP" to invert the sense of the match.
 .\" @MATCH@

