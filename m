From: Thierry Du Tre <thierry@dtsystems.be>
Subject: [PATCH] netfilter : add NAT support for shifted portmap ranges
Date: Wed, 20 Dec 2017 13:28:09 +0100
Message-ID: <3d98278c-6c33-72e1-163d-2f6270060620@dtsystems.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35951 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752886AbdLTM2M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 07:28:12 -0500
Received: by mail-wm0-f65.google.com with SMTP id b76so9483014wmg.1
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2017 04:28:11 -0800 (PST)
Content-Language: nl
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a patch proposal to support shifted ranges in portmaps.
(i.e. tcp/udp incoming port 5000-5100 on WAN redirected to LAN 
192.168.1.5:2000-2100)

Currently DNAT only works for single port or identical port ranges.
(i.e. ports 5000-5100 on WAN interface redirected to a LAN host while 
original destination port is not altered)
When different port ranges are configured, either 'random' mode should 
be used, or else all incoming connections are mapped onto the first port 
in the redirect range. (in described example WAN:5000-5100 will all be 
mapped to 192.168.1.5:2000)

This patch introduces a new mode indicated by flag 
NF_NAT_RANGE_PROTO_OFFSET which uses a base port value to calculate an 
offset with the destination port present in the incoming stream. That 
offset is then applied as index within the redirect port range (index 
modulo rangewidth to handle range overflow).

In described example the base port would be 5000. An incoming stream 
with destination port 5004 would result in an offset value 4 which means 
that the NAT'ed stream will be using destination port 2004.

Other possibilities include deterministic mapping of larger or multiple 
ranges to a smaller range : WAN:5000-5999 -> LAN:5000-5099 (maps WAN 
port 5*xx to port 51xx)

This patch does not change any current behavior. It just adds new NAT 
proto range functionality which must be selected via the specific flag 
when intended to use.

A patch for iptables (libipt_DNAT.c) will also be proposed which makes 
this functionality immediately available.

Signed-off-by: Thierry Du Tre <thierry@dtsystems.be>

---
  include/uapi/linux/netfilter/nf_nat.h | 5 ++++-
  net/netfilter/nf_nat_core.c           | 7 ++++---
  net/netfilter/nf_nat_proto_common.c   | 5 ++++-
  net/netfilter/xt_nat.c                | 1 +
  4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_nat.h 
b/include/uapi/linux/netfilter/nf_nat.h
index a33000d..5b3952b 100644
--- a/include/uapi/linux/netfilter/nf_nat.h
+++ b/include/uapi/linux/netfilter/nf_nat.h
@@ -10,6 +10,7 @@
  #define NF_NAT_RANGE_PROTO_RANDOM		(1 << 2)
  #define NF_NAT_RANGE_PERSISTENT			(1 << 3)
  #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
+#define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)

  #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
  	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
@@ -17,7 +18,7 @@
  #define NF_NAT_RANGE_MASK					\
  	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
  	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
-	 NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET)

  struct nf_nat_ipv4_range {
  	unsigned int			flags;
@@ -25,6 +26,7 @@ struct nf_nat_ipv4_range {
  	__be32				max_ip;
  	union nf_conntrack_man_proto	min;
  	union nf_conntrack_man_proto	max;
+	union nf_conntrack_man_proto	base;
  };

  struct nf_nat_ipv4_multi_range_compat {
@@ -38,6 +40,7 @@ struct nf_nat_range {
  	union nf_inet_addr		max_addr;
  	union nf_conntrack_man_proto	min_proto;
  	union nf_conntrack_man_proto	max_proto;
+	union nf_conntrack_man_proto	base_proto;
  };

  #endif /* _NETFILTER_NF_NAT_H */
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index af8345f..753d616 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -347,9 +347,10 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
  	/* Only bother mapping if it's not already in range and unique */
  	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
  		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-			if (l4proto->in_range(tuple, maniptype,
-					      &range->min_proto,
-					      &range->max_proto) &&
+			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
+			    l4proto->in_range(tuple, maniptype,
+			          &range->min_proto,
+			          &range->max_proto) &&
  			    (range->min_proto.all == range->max_proto.all ||
  			     !nf_nat_used_tuple(tuple, ct)))
  				goto out;
diff --git a/net/netfilter/nf_nat_proto_common.c 
b/net/netfilter/nf_nat_proto_common.c
index fbce552..2c30eca 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -80,6 +80,8 @@ void nf_nat_l4proto_unique_tuple(const struct 
nf_nat_l3proto *l3proto,
  						  : tuple->src.u.all);
  	} else if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
  		off = prandom_u32();
+	} else if (range->flags & NF_NAT_RANGE_PROTO_OFFSET) {
+		off = (ntohs(*portptr) - ntohs(range->base_proto.all));
  	} else {
  		off = *rover;
  	}
@@ -88,7 +90,8 @@ void nf_nat_l4proto_unique_tuple(const struct 
nf_nat_l3proto *l3proto,
  		*portptr = htons(min + off % range_size);
  		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
  			continue;
-		if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL))
+		if (!(range->flags & (NF_NAT_RANGE_PROTO_RANDOM_ALL|
+					NF_NAT_RANGE_PROTO_OFFSET)))
  			*rover = off;
  		return;
  	}
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index 0fd14d1..985b81b 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -47,6 +47,7 @@ static void xt_nat_convert_range(struct nf_nat_range *dst,
  	dst->max_addr.ip = src->max_ip;
  	dst->min_proto	 = src->min;
  	dst->max_proto	 = src->max;
+	dst->base_proto	 = src->base;
  }

  static unsigned int
-- 
2.7.4
