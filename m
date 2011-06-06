From: pablo@netfilter.org
Subject: [PATCH 4/7] netfilter: ipset: Use the stored first cidr value instead of '1'
Date: Mon,  6 Jun 2011 02:11:37 +0200
Message-ID: <1307319100-21827-5-git-send-email-pablo@netfilter.org>
References: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54940 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1FFAMG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:12:06 -0400
In-Reply-To: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
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
index 4743e54..565a7c5 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -146,8 +146,9 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
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
@@ -394,8 +395,9 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index c4db202..2aeeabc 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -131,7 +131,9 @@ hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
 {
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_net4_elem data = { .cidr = h->nets[0].cidr || HOST_MASK };
+	struct hash_net4_elem data = {
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+	};
 
 	if (data.cidr == 0)
 		return -EINVAL;
@@ -296,7 +298,9 @@ hash_net6_kadt(struct ip_set *set, const struct sk_buff *skb,
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
index d2a4036..e50d9bb 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -144,7 +144,8 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem data = {
-		.cidr = h->nets[0].cidr || HOST_MASK };
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+	};
 
 	if (data.cidr == 0)
 		return -EINVAL;
@@ -357,7 +358,8 @@ hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,
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

