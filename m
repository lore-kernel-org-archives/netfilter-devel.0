From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 2/3] iptables-restore(8): file to read from can be specified as argument
Date: Thu, 13 Mar 2014 17:01:20 +0100
Message-ID: <1394726481-6001-2-git-send-email-jpopelka@redhat.com>
References: <1394726481-6001-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaCMQBa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:01:30 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2DG1UtG016801
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2014 12:01:30 -0400
In-Reply-To: <1394726481-6001-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

original bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=1022228
---
 iptables/iptables-restore.8.in | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 4ad7a52..7a286b9 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -24,17 +24,18 @@ iptables-restore \(em Restore IP Tables
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
 \fBiptables\-restore\fP [\fB\-chntv\fP] [\fB\-M\fP \fImodprobe\fP]
-[\fB\-T\fP \fIname\fP]
+[\fB\-T\fP \fIname\fP] [\fBfile\fP]
 .P
 \fBip6tables\-restore\fP [\fB\-chntv\fP] [\fB\-M\fP \fImodprobe\fP]
-[\fB\-T\fP \fIname\fP]
+[\fB\-T\fP \fIname\fP] [\fBfile\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-restore
 and
 .B ip6tables-restore
-are used to restore IP and IPv6 Tables from data specified on STDIN. Use
-I/O redirection provided by your shell to read from a file
+are used to restore IP and IPv6 Tables from data specified on STDIN or in
+\fIfile\fP. Use I/O redirection provided by your shell to read from a file or
+specify \fIfile\fP as an argument.
 .TP
 \fB\-c\fR, \fB\-\-counters\fR
 restore the values of all packet and byte counters
-- 
1.8.5.3

