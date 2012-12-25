From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 06/13] doc: document iptables-restore's -h option
Date: Wed, 26 Dec 2012 00:11:22 +0100
Message-ID: <1356477089-13241-7-git-send-email-jengelh@inai.de>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38906 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab2LYXLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:11:34 -0500
In-Reply-To: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/644221
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables-restore.8.in |    5 ++++-
 iptables/iptables-restore.8.in  |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/iptables/ip6tables-restore.8.in b/iptables/ip6tables-restore.8.in
index f3419f4..697a226 100644
--- a/iptables/ip6tables-restore.8.in
+++ b/iptables/ip6tables-restore.8.in
@@ -21,7 +21,7 @@
 .SH NAME
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBip6tables\-restore\fP [\fB\-cntv\fP] [\fB\-M\fP \fImodprobe\fP]
+\fBip6tables\-restore\fP [\fB\-chntv\fP] [\fB\-M\fP \fImodprobe\fP]
 [\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
@@ -32,6 +32,9 @@ I/O redirection provided by your shell to read from a file
 \fB\-c\fR, \fB\-\-counters\fR
 restore the values of all packet and byte counters
 .TP
+\fB\-h\fP, \fB\-\-help\fP
+Print a short option summary.
+.TP
 \fB\-n\fR, \fB\-\-noflush\fR 
 don't flush the previous contents of the table. If not specified,
 \fBip6tables-restore\fP flushes (deletes) all previous contents of the
diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index c493cf9..197f013 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -21,7 +21,7 @@
 .SH NAME
 iptables-restore \(em Restore IP Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-cntv\fP] [\fB\-M\fP \fImodprobe\fP]
+\fBiptables\-restore\fP [\fB\-chntv\fP] [\fB\-M\fP \fImodprobe\fP]
 [\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
@@ -32,6 +32,9 @@ I/O redirection provided by your shell to read from a file
 \fB\-c\fR, \fB\-\-counters\fR
 restore the values of all packet and byte counters
 .TP
+\fB\-h\fP, \fB\-\-help\fP
+Print a short option summary.
+.TP
 \fB\-n\fR, \fB\-\-noflush\fR 
 don't flush the previous contents of the table. If not specified, 
 .B iptables-restore
-- 
1.7.10.4

