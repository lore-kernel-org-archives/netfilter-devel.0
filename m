From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Syntax errors in man and help regarding rulenum placement
Date: Fri, 20 Feb 2009 16:40:30 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902201640001.27281@fbirervta.pbzchgretzou.qr>
References: <gnmh9h$vt7$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, Ralf <rm@amitrader.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42261 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZBTPkc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:40:32 -0500
In-Reply-To: <gnmh9h$vt7$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-02-20 16:12, Ralf wrote:

> man iptables of v1.4.2 gives these 2 different syntaxes
> for example for the -I option: 
> iptables [-t table] -I [rulenum] rule-specification [options...]
>
> iptables [-t table] -I chain [rulenum] rule-specification
>
>
> And iptables --help gives these:
>
> iptables -[RI] chain rulenum rule-specification [options]
>
> --insert  -I chain [rulenum]
>
> This is all irritating, don't you think so?
> Which of them is the officially correct one
> regarding the placement (location) of the rulenum?


parent 6db2ded2f22a7e78743c86af523b8430876582e9 (v1.4.3-rc1-81-g6db2ded)
commit 26128f4386b9eb202d9288e7b414cb3ae43819f9
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Feb 20 16:39:54 2009 +0100

doc: resynchronize manpage with in-code help

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.8.in |    6 +++---
 ip6tables.c    |    3 ++-
 iptables.8.in  |    6 +++---
 iptables.c     |    3 ++-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/ip6tables.8.in b/ip6tables.8.in
index 3d19a4c..a31887e 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -30,16 +30,16 @@ ip6tables - IPv6 packet filter administration
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain
 rule-specification\fP [\fIoptions...\fP]
 .PP
-\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP [\fIrulenum\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP \fIchain\fP [\fIrulenum\fP]
 \fIrule-specification\fP [\fIoptions...\fP]
 .PP
-\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIrulenum
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIchain rulenum
 rule-specification\fP [\fIoptions...\fP]
 .PP
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-D\fP \fIchain rulenum\fP
 [\fIoptions...\fP]
 .PP
-\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP [\fIrulenum\fP]]
 .PP
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-F\fP|\fB\-L\fP|\fB\-Z\fP}
 [\fIchain\fP] [\fIoptions...\fP]
diff --git a/ip6tables.c b/ip6tables.c
index 06c0a60..21a0a4e 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -240,7 +240,8 @@ exit_printhelp(struct xtables_rule_match *matches)
 
 	printf("%s v%s\n\n"
 "Usage: %s -[AD] chain rule-specification [options]\n"
-"       %s -[RI] chain rulenum rule-specification [options]\n"
+"       %s -I chain [rulenum] rule-specification [options]\n"
+"       %s -R chain rulenum rule-specification [options]\n"
 "       %s -D chain rulenum [options]\n"
 "       %s -[LS] [chain [rulenum]] [options]\n"
 "       %s -[FZ] [chain] [options]\n"
diff --git a/iptables.8.in b/iptables.8.in
index 2bbd9a7..10dcb73 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -27,13 +27,13 @@ iptables - administration tool for IPv4 packet filtering and NAT
 .SH SYNOPSIS
 \fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain\fP \fIrule-specification\fP
 .PP
-\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP [\fIrulenum\fP] \fIrule-specification\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
 .PP
-\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIrulenum rule-specification\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIchain rulenum rule-specification\fP
 .PP
 \fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-D\fP \fIchain rulenum\fP
 .PP
-\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP]
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP [\fIrulenum\fP]]
 .PP
 \fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-F\fP|\fB\-L\fP|\fB\-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
 .PP
diff --git a/iptables.c b/iptables.c
index a8e97c7..56b46b8 100644
--- a/iptables.c
+++ b/iptables.c
@@ -254,7 +254,8 @@ exit_printhelp(struct xtables_rule_match *matches)
 
 	printf("%s v%s\n\n"
 "Usage: %s -[AD] chain rule-specification [options]\n"
-"       %s -[RI] chain rulenum rule-specification [options]\n"
+"       %s -I chain [rulenum] rule-specification [options]\n"
+"       %s -R chain rulenum rule-specification [options]\n"
 "       %s -D chain rulenum [options]\n"
 "       %s -[LS] [chain [rulenum]] [options]\n"
 "       %s -[FZ] [chain] [options]\n"
-- 
# Created with git-export-patch
