From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 14/17] doc: document iptables-restore's -M option
Date: Sun, 30 Sep 2012 12:22:17 +0200
Message-ID: <1349000540-17508-15-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38820 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab2I3KW3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:29 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/644221
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables-restore.8in |    7 ++++++-
 iptables/iptables-restore.8in  |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/iptables/ip6tables-restore.8in b/iptables/ip6tables-restore.8in
index 6c0009e..f3419f4 100644
--- a/iptables/ip6tables-restore.8in
+++ b/iptables/ip6tables-restore.8in
@@ -21,7 +21,8 @@
 .SH NAME
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBip6tables\-restore\fP [\fB\-cntv\fP] [\fB\-T\fP \fIname\fP]
+\fBip6tables\-restore\fP [\fB\-cntv\fP] [\fB\-M\fP \fImodprobe\fP]
+[\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
 .B ip6tables-restore
@@ -42,6 +43,10 @@ Only parse and construct the ruleset, but do not commit it.
 \fB\-v\fP, \fB\-\-verbose\fP
 Print additional debug info during ruleset processing.
 .TP
+\fB\-M\fP, \fB\-\-modprobe\fP \fImodprobe_program\fP
+Specify the path to the modprobe program. By default, ip6tables-restore will
+inspect /proc/sys/kernel/modprobe to determine the executable's path.
+.TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
 .B ip6tables-restore
diff --git a/iptables/iptables-restore.8in b/iptables/iptables-restore.8in
index 27440fb..c493cf9 100644
--- a/iptables/iptables-restore.8in
+++ b/iptables/iptables-restore.8in
@@ -21,7 +21,8 @@
 .SH NAME
 iptables-restore \(em Restore IP Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-cntv\fP] [\fB\-T\fP \fIname\fP]
+\fBiptables\-restore\fP [\fB\-cntv\fP] [\fB\-M\fP \fImodprobe\fP]
+[\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-restore
@@ -42,6 +43,10 @@ Only parse and construct the ruleset, but do not commit it.
 \fB\-v\fP, \fB\-\-verbose\fP
 Print additional debug info during ruleset processing.
 .TP
+\fB\-M\fP, \fB\-\-modprobe\fP \fImodprobe_program\fP
+Specify the path to the modprobe program. By default, iptables-restore will
+inspect /proc/sys/kernel/modprobe to determine the executable's path.
+.TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
 .SH BUGS
-- 
1.7.10.4

