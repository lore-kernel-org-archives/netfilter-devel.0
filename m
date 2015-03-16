From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH] libxt_tcp: manpage correction
Date: Mon, 16 Mar 2015 17:12:48 +0100
Message-ID: <1426522368-16133-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965017AbbCPQNI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 12:13:08 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t2GGD87A001188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 12:13:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

$ iptables -A INPUT -m tcp --sport 6500:6400 -j ACCEPT
iptables v1.4.21: invalid portrange (min > max)

Error message added with d15fb34c

Signed-off-by: Jiri Popelka <jpopelka@redhat.com>
---
 extensions/libxt_tcp.man | 1 -
 1 file changed, 1 deletion(-)

diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
index 7a16118..8019461 100644
--- a/extensions/libxt_tcp.man
+++ b/extensions/libxt_tcp.man
@@ -7,7 +7,6 @@ name or a port number. An inclusive range can also be specified,
 using the format \fIfirst\fP\fB:\fP\fIlast\fP.
 If the first port is omitted, "0" is assumed; if the last is omitted,
 "65535" is assumed.
-If the first port is greater than the second one they will be swapped.
 The flag
 \fB\-\-sport\fP
 is a convenient alias for this option.
-- 
2.3.2

