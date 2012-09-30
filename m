From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 12/17] doc: document iptables-restore's -t option
Date: Sun, 30 Sep 2012 12:22:15 +0200
Message-ID: <1349000540-17508-13-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38819 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2I3KW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:28 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/644221
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables-restore.8in |    5 ++++-
 iptables/iptables-restore.8in  |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/iptables/ip6tables-restore.8in b/iptables/ip6tables-restore.8in
index e9018d0..e1c9abf 100644
--- a/iptables/ip6tables-restore.8in
+++ b/iptables/ip6tables-restore.8in
@@ -21,7 +21,7 @@
 .SH NAME
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBip6tables\-restore\fP [\fB\-c\fP] [\fB\-n\fP] [\fB\-T\fP \fIname\fP]
+\fBip6tables\-restore\fP [\fB\-cnt\fP] [\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
 .B ip6tables-restore
@@ -36,6 +36,9 @@ don't flush the previous contents of the table. If not specified,
 \fBip6tables-restore\fP flushes (deletes) all previous contents of the
 respective table.
 .TP
+\fB\-t\fP, \fB\-\-test\fP
+Only parse and construct the ruleset, but do not commit it.
+.TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
 .B ip6tables-restore
diff --git a/iptables/iptables-restore.8in b/iptables/iptables-restore.8in
index 75de847..f98488e 100644
--- a/iptables/iptables-restore.8in
+++ b/iptables/iptables-restore.8in
@@ -21,7 +21,7 @@
 .SH NAME
 iptables-restore \(em Restore IP Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-c\fP] [\fB\-n\fP] [\fB\-T\fP \fIname\fP]
+\fBiptables\-restore\fP [\fB\-cnt\fP] [\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-restore
@@ -36,6 +36,9 @@ don't flush the previous contents of the table. If not specified,
 .B iptables-restore
 flushes (deletes) all previous contents of the respective table.
 .TP
+\fB\-t\fP, \fB\-\-test\fP
+Only parse and construct the ruleset, but do not commit it.
+.TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
 .SH BUGS
-- 
1.7.10.4

