From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 2/2] iptables: missing bracket in iptables-save(8)
Date: Thu, 13 Mar 2014 10:02:14 +0100
Message-ID: <1394701334-23508-2-git-send-email-jpopelka@redhat.com>
References: <1394701334-23508-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaCMJCa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:02:30 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2D92T7o013698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2014 05:02:29 -0400
In-Reply-To: <1394701334-23508-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 iptables/iptables-save.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 5e939b1..6128280 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -27,7 +27,7 @@ ip6tables-save \(em dump iptables rules to stdout
 [\fB\-t\fP \fItable\fP]
 .P
 \fBip6tables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
-[\fB\-t\fP \fItable\fP
+[\fB\-t\fP \fItable\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-save
-- 
1.8.5.3

