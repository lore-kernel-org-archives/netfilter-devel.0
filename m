From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/1] netfilter: ipset: Check IPSET_ATTR_ETHER netlink attribute length
Date: Tue,  8 Mar 2016 20:44:20 +0100
Message-ID: <1457466260-20373-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1457466260-20373-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:41563 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbcCHTni (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 14:43:38 -0500
In-Reply-To: <1457466260-20373-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Julia Lawall pointed out that IPSET_ATTR_ETHER netlink attribute length
was not checked explicitly, just for the maximum possible size. Malicious
netlink clients could send shorter attribute and thus resulting a kernel
read after the buffer.

The patch adds the explicit length checkings.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 ++
 net/netfilter/ipset/ip_set_hash_mac.c     | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 29dde20..9a065f6 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -267,6 +267,8 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	e.id = ip_to_id(map, ip);
 	if (tb[IPSET_ATTR_ETHER]) {
+		if (nla_len(tb[IPSET_ATTR_ETHER]) != ETH_ALEN)
+			return -IPSET_ERR_PROTOCOL;
 		memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
 		e.add_mac = 1;
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index f1e7d2c..8f004ed 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -110,7 +110,8 @@ hash_mac4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	if (unlikely(!tb[IPSET_ATTR_ETHER]))
+	if (unlikely(!tb[IPSET_ATTR_ETHER] ||
+		     nla_len(tb[IPSET_ATTR_ETHER]) != ETH_ALEN))
 		return -IPSET_ERR_PROTOCOL;
 
 	ret = ip_set_get_extensions(set, tb, &ext);
-- 
1.8.5.1

