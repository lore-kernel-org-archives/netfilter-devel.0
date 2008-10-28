From: Jan Engelhardt <jengelh@medozas.de>
Subject: manpage: use separate paragraphs for command syntax
Date: Tue, 28 Oct 2008 15:01:26 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810281500340.10657@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59650 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYJ1TB1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:01:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit c70cc8d8004b9571e85c2b33e85262f8238b3df3
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Oct 28 14:07:10 2008 -0400

manpage: use separate paragraphs for command syntax

This makes it (IMO) easier to follow when the terminal is small and the
command line specifications begin to wrap.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables.8.in |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/iptables.8.in b/iptables.8.in
index 9decfe7..1d2ffec 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -26,23 +26,23 @@
 iptables \- administration tool for IPv4 packet filtering and NAT
 .SH SYNOPSIS
 \fBiptables\fP [\fB-t\fP \fItable\fP] {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
-.br
+.PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
-.br
+.PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
-.br
+.PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-D\fP \fIchain rulenum\fP [\fIoptions...\fP]
-.br
+.PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-S\fP [\fIchain\fP]
-.br
+.PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
-.br
+.PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-N\fP \fIchain\fP
-.br
+.PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-X\fP [\fIchain\fP]
-.br
+.PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-P\fP \fIchain target\fP [\fIoptions...\fP]
-.br
+.PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-E\fP \fIold-chain-name new-chain-name\fP
 .SH DESCRIPTION
 \fBIptables\fP is used to set up, maintain, and inspect the

