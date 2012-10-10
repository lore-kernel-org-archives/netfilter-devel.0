From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 7/9] doc: document iptables-restore's -h option
Date: Wed, 10 Oct 2012 14:26:30 +0200
Message-ID: <1349871992-31115-8-git-send-email-jengelh@inai.de>
References: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57560 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab2JJM0j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:26:39 -0400
In-Reply-To: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/644221
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables-restore.8in |    5 ++++-
 iptables/iptables-restore.8in  |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/iptables/ip6tables-restore.8in b/iptables/ip6tables-restore.8in
index f3419f4..697a226 100644
--- a/iptables/ip6tables-restore.8in
+++ b/iptables/ip6tables-restore.8in
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
diff --git a/iptables/iptables-restore.8in b/iptables/iptables-restore.8in
index c493cf9..197f013 100644
--- a/iptables/iptables-restore.8in
+++ b/iptables/iptables-restore.8in
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

