From: Jan Engelhardt <jengelh@medozas.de>
Subject: manpages: name and markup fixes
Date: Wed, 23 Jul 2008 22:20:50 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807232220090.23410@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48711 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbYGWUUw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:20:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit b0d57fe19c66184b3ad317290131cadd4f045786
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jul 3 20:33:19 2008 +0200

manpages: name and markup fixes

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.8.in |   28 ++++++++++++++--------------
 iptables.8.in  |   20 ++++++++++----------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/ip6tables.8.in b/ip6tables.8.in
index 666616d..7142b4a 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -27,25 +27,25 @@
 .SH NAME
 ip6tables \- IPv6 packet filter administration
 .SH SYNOPSIS
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB]\fP {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB-t\fP \fItable\fP] {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
 .br
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
 .br
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
 .br
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -D\fP \fIchain rulenum\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-D\fP \fIchain rulenum\fP [\fIoptions...\fP]
 .br
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -S\fP [\fIchain\fP]
+\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-S\fP [\fIchain\fP]
 .br
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB]\fP {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
+\fBip6tables\fP [\fB-t\fP \fItable\fP] {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
 .br
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -N\fP \fIchain\fP
+\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-N\fP \fIchain\fP
 .br
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -X\fP [\fIchain\fP]
+\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-X\fP [\fIchain\fP]
 .br
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -P\fP \fIchain target\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-P\fP \fIchain target\fP [\fIoptions...\fP]
 .br
-\fBip6tables\fP [\fB-t\fP \fItable\fP\fB] -E\fP \fIold-chain-name new-chain-name\fP
+\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-E\fP \fIold-chain-name new-chain-name\fP
 .SH DESCRIPTION
 \fBIp6tables\fP is used to set up, maintain, and inspect the
 tables of IPv6 packet
@@ -155,10 +155,10 @@ fail.  Rules are numbered starting at 1.
 .TP
 \fB-L\fP, \fB--list\fP [\fIchain\fP]
 List all rules in the selected chain.  If no chain is selected, all
-chains are listed. Like every other iptables command, it applies to the
+chains are listed. Like every other ip6tables command, it applies to the
 specified table (filter is the default), so NAT rules get listed by
 .nf
- iptables -t nat -n -L
+ ip6tables -t nat -n -L
 .fi
 Please note that it is often used with the \fB-n\fP
 option, in order to avoid long reverse DNS lookups.
@@ -167,12 +167,12 @@ It is legal to specify the \fB-Z\fP
 listed and zeroed.  The exact output is affected by the other
 arguments given. The exact rules are suppressed until you use
 .nf
- iptables -L -v
+ ip6tables -L -v
 .fi
 .TP
 \fB-S\fP, \fB--list-rules\fP [\fIchain\fP]
 Print all rules in the selected chain.  If no chain is selected, all
-chains are printed like iptables-save. Like every other iptables command,
+chains are printed like ip6tables-save. Like every other ip6tables command,
 it applies to the specified table (filter is the default).
 .TP
 \fB-F\fP, \fB--flush\fP [\fIchain\fP]
diff --git a/iptables.8.in b/iptables.8.in
index c08d27d..9decfe7 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -25,25 +25,25 @@
 .SH NAME
 iptables \- administration tool for IPv4 packet filtering and NAT
 .SH SYNOPSIS
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB]\fP {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
 .br
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
 .br
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
 .br
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -D\fP \fIchain rulenum\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-D\fP \fIchain rulenum\fP [\fIoptions...\fP]
 .br
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -S\fP [\fIchain\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-S\fP [\fIchain\fP]
 .br
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB]\fP {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
 .br
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -N\fP \fIchain\fP
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-N\fP \fIchain\fP
 .br
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -X\fP [\fIchain\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-X\fP [\fIchain\fP]
 .br
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -P\fP \fIchain target\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-P\fP \fIchain target\fP [\fIoptions...\fP]
 .br
-\fBiptables\fP [\fB-t\fP \fItable\fP\fB] -E\fP \fIold-chain-name new-chain-name\fP
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-E\fP \fIold-chain-name new-chain-name\fP
 .SH DESCRIPTION
 \fBIptables\fP is used to set up, maintain, and inspect the
 tables of IPv4 packet

