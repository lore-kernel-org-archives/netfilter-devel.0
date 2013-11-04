From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/20] ipvs: fix the IPVS_CMD_ATTR_MAX definition
Date: Mon,  4 Nov 2013 22:50:23 +0100
Message-ID: <1383601842-4570-2-git-send-email-pablo@netfilter.org>
References: <1383601842-4570-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55657 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab3KDVuw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Nov 2013 16:50:52 -0500
In-Reply-To: <1383601842-4570-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Julian Anastasov <ja@ssi.bg>

It was wrong (bigger) but problem is harmless.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/uapi/linux/ip_vs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index 2945822..fbcffe8 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -334,7 +334,7 @@ enum {
 	__IPVS_CMD_ATTR_MAX,
 };
 
-#define IPVS_CMD_ATTR_MAX (__IPVS_SVC_ATTR_MAX - 1)
+#define IPVS_CMD_ATTR_MAX (__IPVS_CMD_ATTR_MAX - 1)
 
 /*
  * Attributes used to describe a service
-- 
1.7.10.4

