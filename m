From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/9] doc: fixup omissions in ip6tables-restore.8
Date: Wed, 10 Oct 2012 14:26:26 +0200
Message-ID: <1349871992-31115-4-git-send-email-jengelh@inai.de>
References: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57550 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab2JJM0i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:26:38 -0400
In-Reply-To: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables-restore.8in |    6 ++++--
 iptables/iptables-restore.8in  |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/iptables/ip6tables-restore.8in b/iptables/ip6tables-restore.8in
index a9859ae..e9018d0 100644
--- a/iptables/ip6tables-restore.8in
+++ b/iptables/ip6tables-restore.8in
@@ -21,7 +21,7 @@
 .SH NAME
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBip6tables\-restore\fP [\fB\-c\fP] [\fB\-n\fP]
+\fBip6tables\-restore\fP [\fB\-c\fP] [\fB\-n\fP] [\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
 .B ip6tables-restore
@@ -32,7 +32,9 @@ I/O redirection provided by your shell to read from a file
 restore the values of all packet and byte counters
 .TP
 \fB\-n\fR, \fB\-\-noflush\fR 
-don't flush the previous contents of the table. If not specified, 
+don't flush the previous contents of the table. If not specified,
+\fBip6tables-restore\fP flushes (deletes) all previous contents of the
+respective table.
 .TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
diff --git a/iptables/iptables-restore.8in b/iptables/iptables-restore.8in
index 37faae0..75de847 100644
--- a/iptables/iptables-restore.8in
+++ b/iptables/iptables-restore.8in
@@ -34,7 +34,7 @@ restore the values of all packet and byte counters
 \fB\-n\fR, \fB\-\-noflush\fR 
 don't flush the previous contents of the table. If not specified, 
 .B iptables-restore
-flushes (deletes) all previous contents of the respective IP Table.
+flushes (deletes) all previous contents of the respective table.
 .TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
-- 
1.7.10.4

