From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 13/15] netfilter: ipset: Use the stored first cidr value instead of '1'
Date: Tue,  7 Jun 2011 18:56:18 +0200
Message-ID: <1307465780-28980-14-git-send-email-kadlec@blackhole.kfki.hu>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-9-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-11-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-12-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-13-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:58855 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab1FGQ4Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:56:25 -0400
In-Reply-To: <1307465780-28980-13-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
1.7.0.4

