From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 13/17] doc: document iptables-restore's -v option
Date: Sun, 30 Sep 2012 12:22:16 +0200
Message-ID: <1349000540-17508-14-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38821 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab2I3KW3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:29 -0400
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
index e1c9abf..6c0009e 100644
--- a/iptables/ip6tables-restore.8in
+++ b/iptables/ip6tables-restore.8in
@@ -21,7 +21,7 @@
 .SH NAME
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBip6tables\-restore\fP [\fB\-cnt\fP] [\fB\-T\fP \fIname\fP]
+\fBip6tables\-restore\fP [\fB\-cntv\fP] [\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
 .B ip6tables-restore
@@ -39,6 +39,9 @@ respective table.
 \fB\-t\fP, \fB\-\-test\fP
 Only parse and construct the ruleset, but do not commit it.
 .TP
+\fB\-v\fP, \fB\-\-verbose\fP
+Print additional debug info during ruleset processing.
+.TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
 .B ip6tables-restore
diff --git a/iptables/iptables-restore.8in b/iptables/iptables-restore.8in
index f98488e..27440fb 100644
--- a/iptables/iptables-restore.8in
+++ b/iptables/iptables-restore.8in
@@ -21,7 +21,7 @@
 .SH NAME
 iptables-restore \(em Restore IP Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-cnt\fP] [\fB\-T\fP \fIname\fP]
+\fBiptables\-restore\fP [\fB\-cntv\fP] [\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-restore
@@ -39,6 +39,9 @@ flushes (deletes) all previous contents of the respective table.
 \fB\-t\fP, \fB\-\-test\fP
 Only parse and construct the ruleset, but do not commit it.
 .TP
+\fB\-v\fP, \fB\-\-verbose\fP
+Print additional debug info during ruleset processing.
+.TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
 .SH BUGS
-- 
1.7.10.4

