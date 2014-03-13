From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 1/3] iptables-restore(8): missing -T in synopsis
Date: Thu, 13 Mar 2014 17:01:19 +0100
Message-ID: <1394726481-6001-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbaCMQBa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:01:30 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2DG1Tlj000689
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2014 12:01:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 iptables/iptables-restore.8.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index feb57ef..4ad7a52 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -24,6 +24,7 @@ iptables-restore \(em Restore IP Tables
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
 \fBiptables\-restore\fP [\fB\-chntv\fP] [\fB\-M\fP \fImodprobe\fP]
+[\fB\-T\fP \fIname\fP]
 .P
 \fBip6tables\-restore\fP [\fB\-chntv\fP] [\fB\-M\fP \fImodprobe\fP]
 [\fB\-T\fP \fIname\fP]
-- 
1.8.5.3

