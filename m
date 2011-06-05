From: pablo@netfilter.org
Subject: [PATCH 12/20] netfilter: ipset: Use the stored first cidr value instead of '1'
Date: Mon,  6 Jun 2011 01:09:02 +0200
Message-ID: <1307315350-17782-12-git-send-email-pablo@netfilter.org>
References: <1307315350-17782-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52223 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab1FEXJn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 19:09:43 -0400
In-Reply-To: <1307315350-17782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

The stored cidr values are tried one after anoter. The boolean
condition evaluated to '1' instead of the first stored cidr or
the default host cidr.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_ipportnet.c |   10 ++++++----
 net/netfilter/ipset/ip_set_hash_net.c       |    8 ++++++--
 net/netfilter/ipset/ip_set_hash_netport.c   |    6 ++++--
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index dcd351b..d2d6ab8 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -156,8 +156,9 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 {
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_ipportnet4_elem data =
-		{ .cidr = h->nets[0].cidr || HOST_MASK };
+	struct hash_ipportnet4_elem data = {
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+	};
 
 	if (data.cidr == 0)
 		return -EINVAL;
@@ -434,8 +435,9 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 {
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_ipportnet6_elem data =
-		{ .cidr = h->nets[0].cidr || HOST_MASK };
+	struct hash_ipportnet6_elem data = {
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+	};
 
 	if (data.cidr == 0)
 		return -EINVAL;
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index dcbb5d4..050163f 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -139,7 +139,9 @@ hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
 {
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_net4_elem data = { .cidr = h->nets[0].cidr || HOST_MASK };
+	struct hash_net4_elem data = {
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+	};
 
 	if (data.cidr == 0)
 		return -EINVAL;
@@ -336,7 +338,9 @@ hash_net6_kadt(struct ip_set *set, const struct sk_buff *skb,
 {
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_net6_elem data = { .cidr = h->nets[0].cidr || HOST_MASK };
+	struct hash_net6_elem data = {
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+	};
 
 	if (data.cidr == 0)
 		return -EINVAL;
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 72961ba..d7710a9 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -153,7 +153,8 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem data = {
-		.cidr = h->nets[0].cidr || HOST_MASK };
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+	};
 
 	if (data.cidr == 0)
 		return -EINVAL;
@@ -397,7 +398,8 @@ hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport6_elem data = {
-		.cidr = h->nets[0].cidr || HOST_MASK };
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+	};
 
 	if (data.cidr == 0)
 		return -EINVAL;
-- 
1.7.2.5

