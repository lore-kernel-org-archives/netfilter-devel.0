From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Thu,  5 Jul 2012 23:34:32 +0100
Message-ID: <1341527720-10125-2-git-send-email-mr.dash.four@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com>
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44300 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975Ab2GEWfX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:35:23 -0400
Received: by werb14 with SMTP id b14so5722007wer.19
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Jul 2012 15:35:22 -0700 (PDT)
In-Reply-To: <cover.1341525006.git.mr.dash.four@googlemail.com>
In-Reply-To: <cover.1341525006.git.mr.dash.four@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kernel changes to ipset, allowing 'in' and 'out' values to be
specified for the 'iface' part of hash:net,iface type sets.

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
 include/linux/netfilter/ipset/ip_set.h      |    5 +++++
 net/netfilter/ipset/ip_set_bitmap_ipmac.c   |    4 ++++
 net/netfilter/ipset/ip_set_hash_ipport.c    |    6 ++++--
 net/netfilter/ipset/ip_set_hash_ipportip.c  |    6 ++++--
 net/netfilter/ipset/ip_set_hash_ipportnet.c |    6 ++++--
 net/netfilter/ipset/ip_set_hash_netport.c   |    6 ++++--
 6 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 2edc64c..a9fc982 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -190,6 +190,10 @@ enum ip_set_dim {
 	 * If changed, new revision of iptables match/target is required.
 	 */
 	IPSET_DIM_MAX = 6,
+	/* 
+	 * Indicates whether the new 'iface' format (in/out) has been used.
+	 */
+	IPSET_DIM_IFACE = 7, 
 };
 
 /* Option flags for kernel operations */
@@ -198,6 +202,7 @@ enum ip_set_kopt {
 	IPSET_DIM_ONE_SRC = (1 << IPSET_DIM_ONE),
 	IPSET_DIM_TWO_SRC = (1 << IPSET_DIM_TWO),
 	IPSET_DIM_THREE_SRC = (1 << IPSET_DIM_THREE),
+	IPSET_DIM_IFACE_INOUT = (1 << IPSET_DIM_IFACE),
 };
 
 #ifdef __KERNEL__
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index d7eaf10..1d8d754 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -348,6 +348,10 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct ipmac data;
 
+	/* in|out not allowed in this set type, only src|dst */
+	if (opt->flags & IPSET_DIM_IFACE_INOUT)
+		return -EINVAL;
+
 	/* MAC can be src only */
 	if (!(opt->flags & IPSET_DIM_TWO_SRC))
 		return 0;
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 92722bb..615a6e3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -143,7 +143,8 @@ hash_ipport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem data = { };
 
-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+	if ((opt->flags & IPSET_DIM_IFACE_INOUT) || /* in|out not allowed in this set type, only src|dst */
+		!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &data.port, &data.proto))
 		return -EINVAL;
 
@@ -361,7 +362,8 @@ hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport6_elem data = { };
 
-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+	if ((opt->flags & IPSET_DIM_IFACE_INOUT) || /* in|out not allowed in this set type, only src|dst */
+		!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &data.port, &data.proto))
 		return -EINVAL;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 0637ce0..732fe63 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -146,7 +146,8 @@ hash_ipportip4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip4_elem data = { };
 
-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+	if ((opt->flags & IPSET_DIM_IFACE_INOUT) || /* in|out not allowed in this set type, only src|dst */
+		!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &data.port, &data.proto))
 		return -EINVAL;
 
@@ -374,7 +375,8 @@ hash_ipportip6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip6_elem data = { };
 
-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+	if ((opt->flags & IPSET_DIM_IFACE_INOUT) || /* in|out not allowed in this set type, only src|dst */
+		!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &data.port, &data.proto))
 		return -EINVAL;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 1ce21ca..4a01705 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -192,7 +192,8 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	if (adt == IPSET_TEST)
 		data.cidr = HOST_MASK - 1;
 
-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+	if ((opt->flags & IPSET_DIM_IFACE_INOUT) || /* in|out not allowed in this set type, only src|dst */
+		!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &data.port, &data.proto))
 		return -EINVAL;
 
@@ -503,7 +504,8 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	if (adt == IPSET_TEST)
 		data.cidr = HOST_MASK - 1;
 
-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+	if ((opt->flags & IPSET_DIM_IFACE_INOUT) || /* in|out not allowed in this set type, only src|dst */
+		!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &data.port, &data.proto))
 		return -EINVAL;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index fc3143a..554a468 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -189,7 +189,8 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	if (adt == IPSET_TEST)
 		data.cidr = HOST_MASK - 1;
 
-	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+	if ((opt->flags & IPSET_DIM_IFACE_INOUT) || /* in|out not allowed in this set type, only src|dst */
+		!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &data.port, &data.proto))
 		return -EINVAL;
 
@@ -467,7 +468,8 @@ hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	if (adt == IPSET_TEST)
 		data.cidr = HOST_MASK - 1;
 
-	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
+	if ((opt->flags & IPSET_DIM_IFACE_INOUT) || /* in|out not allowed in this set type, only src|dst */
+		!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &data.port, &data.proto))
 		return -EINVAL;
 
-- 
1.7.10.4

