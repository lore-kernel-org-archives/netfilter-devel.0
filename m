From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 01/13] NFNL_SUBSYS_IPSET id and NLA_PUT_NET* macros
Date: Fri, 21 Jan 2011 15:01:54 +0100
Message-ID: <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:36461 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab1AUOCI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:02:08 -0500
In-Reply-To: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch adds the NFNL_SUBSYS_IPSET id and NLA_PUT_NET* macros to the vanilla
kernel.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/nfnetlink.h |    3 ++-
 include/net/netlink.h               |    9 +++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 361d6b5..2b11fc1 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -47,7 +47,8 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_QUEUE		3
 #define NFNL_SUBSYS_ULOG		4
 #define NFNL_SUBSYS_OSF			5
-#define NFNL_SUBSYS_COUNT		6
+#define NFNL_SUBSYS_IPSET		6
+#define NFNL_SUBSYS_COUNT		7
 
 #ifdef __KERNEL__
 
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 373f1a9..8a3906a 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -856,18 +856,27 @@ static inline int nla_put_msecs(struct sk_buff *skb, int attrtype,
 #define NLA_PUT_BE16(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, __be16, attrtype, value)
 
+#define NLA_PUT_NET16(skb, attrtype, value) \
+	NLA_PUT_BE16(skb, attrtype | NLA_F_NET_BYTEORDER, value)
+
 #define NLA_PUT_U32(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, u32, attrtype, value)
 
 #define NLA_PUT_BE32(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, __be32, attrtype, value)
 
+#define NLA_PUT_NET32(skb, attrtype, value) \
+	NLA_PUT_BE32(skb, attrtype | NLA_F_NET_BYTEORDER, value)
+
 #define NLA_PUT_U64(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, u64, attrtype, value)
 
 #define NLA_PUT_BE64(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, __be64, attrtype, value)
 
+#define NLA_PUT_NET64(skb, attrtype, value) \
+	NLA_PUT_BE64(skb, attrtype | NLA_F_NET_BYTEORDER, value)
+
 #define NLA_PUT_STRING(skb, attrtype, value) \
 	NLA_PUT(skb, attrtype, strlen(value) + 1, value)
 
-- 
1.7.0.4

