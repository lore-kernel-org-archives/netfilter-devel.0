From: Jan Engelhardt <jengelh@medozas.de>
Subject: manpage: explain what rule-specification is
Date: Tue, 28 Oct 2008 15:01:48 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810281501320.10657@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0810281500340.10657@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59652 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYJ1TBt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:01:49 -0400
In-Reply-To: <alpine.LNX.1.10.0810281500340.10657@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7ce5d4839ec877440b2d1b58c2fcfa378fcc4cc7
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Oct 28 14:59:19 2008 -0400

manpage: explain what rule-specification is

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables.8.in |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/iptables.8.in b/iptables.8.in
index 1d2ffec..9947da4 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -25,13 +25,13 @@
 .SH NAME
 iptables \- administration tool for IPv4 packet filtering and NAT
 .SH SYNOPSIS
-\fBiptables\fP [\fB-t\fP \fItable\fP] {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] {\fB-A\fP|\fB-D\fP} \fIchain\fP \fIrule-specification\fP
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-I\fP [\fIrulenum\fP] \fIrule-specification\fP
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-R\fP \fIrulenum rule-specification\fP
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-D\fP \fIchain rulenum\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-D\fP \fIchain rulenum\fP
 .PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-S\fP [\fIchain\fP]
 .PP
@@ -41,9 +41,15 @@ iptables \- administration tool for IPv4 packet filtering and NAT
 .PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-X\fP [\fIchain\fP]
 .PP
-\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-P\fP \fIchain target\fP [\fIoptions...\fP]
+\fBiptables\fP [\fB-t\fP \fItable\fP] \fB-P\fP \fIchain target\fP
 .PP
 \fBiptables\fP [\fB-t\fP \fItable\fP] \fB-E\fP \fIold-chain-name new-chain-name\fP
+.PP
+rule-specification = [\fImatches...\fP] [\fItarget\fP]
+.PP
+match = \fB-m\fP \fImatchname\fP [\fIper-match-options\fP]
+.PP
+target = \fB-j\fP \fItargetname\fP [\fIper-target-options\fP]
 .SH DESCRIPTION
 \fBIptables\fP is used to set up, maintain, and inspect the
 tables of IPv4 packet
