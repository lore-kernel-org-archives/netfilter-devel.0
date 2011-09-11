From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] doc: document iptables-restore's -T option
Date: Sun, 11 Sep 2011 12:38:46 +0200
Message-ID: <1315737527-19595-5-git-send-email-jengelh@medozas.de>
References: <1315737527-19595-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56947 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab1IKKi4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 06:38:56 -0400
In-Reply-To: <1315737527-19595-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v1.4.0-rc1-12-ge8665f8 completely forgot this.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/ip6tables-restore.8 |    3 +++
 iptables/iptables-restore.8  |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/iptables/ip6tables-restore.8 b/iptables/ip6tables-restore.8
index aa09768..59a3b2e 100644
--- a/iptables/ip6tables-restore.8
+++ b/iptables/ip6tables-restore.8
@@ -33,6 +33,9 @@ restore the values of all packet and byte counters
 .TP
 \fB\-n\fR, \fB\-\-noflush\fR 
 don't flush the previous contents of the table. If not specified, 
+.TP
+\fB\-T\fP, \fB\-\-table\fP \fIname\fP
+Restore only the named table even if the input stream contains other ones.
 .B ip6tables-restore
 flushes (deletes) all previous contents of the respective IPv6 Table.
 .SH BUGS
diff --git a/iptables/iptables-restore.8 b/iptables/iptables-restore.8
index a52bceb..0dd20cb 100644
--- a/iptables/iptables-restore.8
+++ b/iptables/iptables-restore.8
@@ -21,7 +21,7 @@
 .SH NAME
 iptables-restore \(em Restore IP Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-c\fP] [\fB\-n\fP]
+\fBiptables\-restore\fP [\fB\-c\fP] [\fB\-n\fP] [\fB\-T\fP \fIname\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-restore
@@ -35,6 +35,9 @@ restore the values of all packet and byte counters
 don't flush the previous contents of the table. If not specified, 
 .B iptables-restore
 flushes (deletes) all previous contents of the respective IP Table.
+.TP
+\fB\-T\fP, \fB\-\-table\fP \fIname\fP
+Restore only the named table even if the input stream contains other ones.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHOR
-- 
1.7.3.4

