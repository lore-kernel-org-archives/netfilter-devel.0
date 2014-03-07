From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH] iptables: fix version in iptables(8)
Date: Fri,  7 Mar 2014 16:23:03 +0100
Message-ID: <1394205783-17997-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaCGPXK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:23:10 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s27FNAXl032029
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 7 Mar 2014 10:23:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 iptables/iptables.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 155c97e..d67e12a 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -464,4 +464,4 @@ Man page originally written by Herve Eychenne <rv@wallfire.org>.
 .\" .. and most of all, modest ..
 .SH VERSION
 .PP
-This manual page applies to iptables/ip6tables @PACKAGE_AND_VERSION@.
+This manual page applies to iptables/ip6tables @PACKAGE_VERSION@.
-- 
1.8.5.3

