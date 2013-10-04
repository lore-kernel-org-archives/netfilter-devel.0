From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/33] netfilter: ipset: Use fix sized type for timeout in the extension part
Date: Fri,  4 Oct 2013 10:32:54 +0200
Message-ID: <1380875598-5250-10-git-send-email-pablo@netfilter.org>
References: <1380875598-5250-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55447 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab3JDIdl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:33:41 -0400
In-Reply-To: <1380875598-5250-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index f900f33..69aa604 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -67,7 +67,7 @@ enum ip_set_offset {
 #define SET_WITH_COUNTER(s)	((s)->extensions & IPSET_EXT_COUNTER)
 
 struct ip_set_ext {
-	unsigned long timeout;
+	u32 timeout;
 	u64 packets;
 	u64 bytes;
 };
-- 
1.7.10.4

