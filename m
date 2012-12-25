From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 02/13] doc: fixup omissions in ip6tables-restore.8
Date: Wed, 26 Dec 2012 00:11:18 +0100
Message-ID: <1356477089-13241-3-git-send-email-jengelh@inai.de>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38894 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab2LYXLd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:11:33 -0500
In-Reply-To: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables-restore.8.in |    6 ++++--
 iptables/iptables-restore.8.in  |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/iptables/ip6tables-restore.8.in b/iptables/ip6tables-restore.8.in
index a9859ae..e9018d0 100644
--- a/iptables/ip6tables-restore.8.in
+++ b/iptables/ip6tables-restore.8.in
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
diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 37faae0..75de847 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
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

