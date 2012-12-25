From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 05/13] doc: document iptables-restore's -M option
Date: Wed, 26 Dec 2012 00:11:21 +0100
Message-ID: <1356477089-13241-6-git-send-email-jengelh@inai.de>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38905 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab2LYXLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:11:34 -0500
In-Reply-To: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/644221
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables-restore.8.in |    7 ++++++-
 iptables/iptables-restore.8.in  |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/iptables/ip6tables-restore.8.in b/iptables/ip6tables-restore.8.in
index 6c0009e..f3419f4 100644
--- a/iptables/ip6tables-restore.8.in
+++ b/iptables/ip6tables-restore.8.in
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
diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 27440fb..c493cf9 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
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

