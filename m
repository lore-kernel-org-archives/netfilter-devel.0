From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/6] doc: resynchronize manpage with in-code help
Date: Sat, 21 Feb 2009 04:17:59 +0100
Message-ID: <1235186284-31661-2-git-send-email-jengelh@medozas.de>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, hadi@cyberus.ca
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37804 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZBUDSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:18:06 -0500
In-Reply-To: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.8.in |    6 +++---
 ip6tables.c    |    5 +++--
 iptables.8.in  |    6 +++---
 iptables.c     |    5 +++--
 4 files changed, 12 insertions(+), 10 deletions(-)

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
index 06c0a60..7847ebc 100644
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
@@ -250,7 +251,7 @@ exit_printhelp(struct xtables_rule_match *matches)
 "       %s -h (print this help information)\n\n",
 	       prog_name, prog_vers, prog_name, prog_name,
 	       prog_name, prog_name, prog_name, prog_name,
-	       prog_name, prog_name, prog_name);
+	       prog_name, prog_name, prog_name, prog_name);
 
 	printf(
 "Commands:\n"
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
index a8e97c7..8448c18 100644
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
@@ -264,7 +265,7 @@ exit_printhelp(struct xtables_rule_match *matches)
 "       %s -h (print this help information)\n\n",
 	       prog_name, prog_vers, prog_name, prog_name,
 	       prog_name, prog_name, prog_name, prog_name,
-	       prog_name, prog_name, prog_name);
+	       prog_name, prog_name, prog_name, prog_name);
 
 	printf(
 "Commands:\n"
-- 
1.6.1.3

