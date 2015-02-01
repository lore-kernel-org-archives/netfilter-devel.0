From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] meta: register pkttype_type datatype
Date: Sun,  1 Feb 2015 21:56:14 +0100
Message-ID: <1422824174-14407-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, sverd.johnsen+nf@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44346 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbbBAUxR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Feb 2015 15:53:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=995
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/meta.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/meta.c b/src/meta.c
index 6689ead..ad57228 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -569,4 +569,5 @@ static void __init meta_init(void)
 	datatype_register(&uid_type);
 	datatype_register(&gid_type);
 	datatype_register(&devgroup_type);
+	datatype_register(&pkttype_type);
 }
-- 
1.7.10.4

