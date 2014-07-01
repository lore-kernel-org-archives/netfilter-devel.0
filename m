From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [linux PATCH v2 1/5] netfilter: nft_nat: include a flag attribute
Date: Tue, 01 Jul 2014 12:46:01 +0200
Message-ID: <20140701104553.6831.59253.stgit@nfdev.cica.es>
References: <20140701104524.6831.83230.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36911 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755996AbaGAKqK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:46:10 -0400
In-Reply-To: <20140701104524.6831.83230.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Both SNAT and DNAT (and the upcoming masquerade) can have additional
configuration parameters, such as port randomization or NAT addressing
persistence.
We can cover these scenarios by simply adding a flag attribute for
userspace to fill when needed.

The flags to use are defined in include/uapi/linux/netfilter/nf_nat.h,
 NF_NAT_RANGE_MAP_IPS
 NF_NAT_RANGE_PROTO_SPECIFIED
 NF_NAT_RANGE_PROTO_RANDOM
 NF_NAT_RANGE_PERSISTENT
 NF_NAT_RANGE_PROTO_RANDOM_FULLY
 NF_NAT_RANGE_PROTO_RANDOM_ALL

The caller must take care of not messing up with the flags, as they are
added unconditionally to the final resulting nf_nat_range.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: address Florian Westphal's comments: check all flag bits to be known.

 include/uapi/linux/netfilter/nf_nat.h    |    5 +++++
 include/uapi/linux/netfilter/nf_tables.h |    2 ++
 net/netfilter/nft_nat.c                  |   16 ++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_nat.h b/include/uapi/linux/netfilter/nf_nat.h
index 1ad3659..f42b118 100644
--- a/include/uapi/linux/netfilter/nf_nat.h
+++ b/include/uapi/linux/netfilter/nf_nat.h
@@ -13,6 +13,11 @@
 #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
 	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
 
+#define NF_NAT_RANGE_OPS_MASK			\
+	(NF_NAT_RANGE_MAP_IPS|NF_NAT_RANGE_PROTO_SPECIFIED \
+	 |NF_NAT_RANGE_PROTO_RANDOM|NF_NAT_RANGE_PERSISTENT \
+	 |NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+
 struct nf_nat_ipv4_range {
 	unsigned int			flags;
 	__be32				min_ip;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 2a88f64..92c211b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -773,6 +773,7 @@ enum nft_nat_types {
  * @NFTA_NAT_REG_ADDR_MAX: source register of address range end (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_NAT_FLAGS: additional NAT configuration (NF_NAT_RANGE_*) (NLA_U32)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
@@ -782,6 +783,7 @@ enum nft_nat_attributes {
 	NFTA_NAT_REG_ADDR_MAX,
 	NFTA_NAT_REG_PROTO_MIN,
 	NFTA_NAT_REG_PROTO_MAX,
+	NFTA_NAT_FLAGS,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 79ff58c..51bb05f 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -33,6 +33,7 @@ struct nft_nat {
 	enum nft_registers      sreg_proto_max:8;
 	enum nf_nat_manip_type  type:8;
 	u8			family;
+	u32			flags;
 };
 
 static void nft_nat_eval(const struct nft_expr *expr,
@@ -71,6 +72,8 @@ static void nft_nat_eval(const struct nft_expr *expr,
 		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
+	range.flags |= priv->flags;
+
 	data[NFT_REG_VERDICT].verdict =
 		nf_nat_setup_info(ct, &range, priv->type);
 }
@@ -82,6 +85,7 @@ static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
 	[NFTA_NAT_REG_ADDR_MAX]	 = { .type = NLA_U32 },
 	[NFTA_NAT_REG_PROTO_MIN] = { .type = NLA_U32 },
 	[NFTA_NAT_REG_PROTO_MAX] = { .type = NLA_U32 },
+	[NFTA_NAT_FLAGS]	 = { .type = NLA_U32 },
 };
 
 static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
@@ -149,6 +153,12 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	} else
 		priv->sreg_proto_max = priv->sreg_proto_min;
 
+	if (tb[NFTA_NAT_FLAGS]) {
+		priv->flags = ntohl(nla_get_be32(tb[NFTA_NAT_FLAGS]));
+		if (priv->flags &~ NF_NAT_RANGE_OPS_MASK)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -183,6 +193,12 @@ static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
 				 htonl(priv->sreg_proto_max)))
 			goto nla_put_failure;
 	}
+
+	if (priv->flags != 0) {
+		if (nla_put_be32(skb, NFTA_NAT_FLAGS, htonl(priv->flags)))
+			goto nla_put_failure;
+	}
+
 	return 0;
 
 nla_put_failure:

