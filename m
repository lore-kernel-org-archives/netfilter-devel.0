From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/4 v2] nf: netfilter: nf_tables_api: Add new attributes into nft_set to store user data.
Date: Tue,  5 Jan 2016 14:03:32 +0100
Message-ID: <1451999013-4313-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:44846 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbcAENLD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 08:11:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

User data is stored at after 'nft_set_ops' private data into 'data[]'
flexible array. The field 'udata' points to user data and 'udlen' store=
s
its length.

Add new flag NFTA_SET_USERDATA.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/net/netfilter/nf_tables.h        |  4 ++++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 21 ++++++++++++++++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/=
nf_tables.h
index 4bd7508..ef44df3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -293,6 +293,8 @@ void nft_unregister_set(struct nft_set_ops *ops);
  * 	@timeout: default timeout value in msecs
  * 	@gc_int: garbage collection interval in msecs
  *	@policy: set parameterization (see enum nft_set_policies)
+ *	@udlen: user data length
+ *	@udata: user data
  * 	@ops: set ops
  * 	@pnet: network namespace
  * 	@flags: set flags
@@ -312,6 +314,8 @@ struct nft_set {
 	u64				timeout;
 	u32				gc_int;
 	u16				policy;
+	u16				udlen;
+	unsigned char			*udata;
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
 	possible_net_t			pnet;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/li=
nux/netfilter/nf_tables.h
index d8c8a7c..33ac070 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -289,6 +289,7 @@ enum nft_set_desc_attributes {
  * @NFTA_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  * @NFTA_SET_TIMEOUT: default timeout value (NLA_U64)
  * @NFTA_SET_GC_INTERVAL: garbage collection interval (NLA_U32)
+ * @NFTA_SET_USERDATA: user data (NLA_BINARY)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -304,6 +305,7 @@ enum nft_set_attributes {
 	NFTA_SET_ID,
 	NFTA_SET_TIMEOUT,
 	NFTA_SET_GC_INTERVAL,
+	NFTA_SET_USERDATA,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 2cb429d..628b3d2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2333,6 +2333,8 @@ static const struct nla_policy nft_set_policy[NFT=
A_SET_MAX + 1] =3D {
 	[NFTA_SET_ID]			=3D { .type =3D NLA_U32 },
 	[NFTA_SET_TIMEOUT]		=3D { .type =3D NLA_U64 },
 	[NFTA_SET_GC_INTERVAL]		=3D { .type =3D NLA_U32 },
+	[NFTA_SET_USERDATA]		=3D { .type =3D NLA_BINARY,
+					    .len  =3D NFT_USERDATA_MAXLEN },
 };
=20
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX +=
 1] =3D {
@@ -2494,6 +2496,9 @@ static int nf_tables_fill_set(struct sk_buff *skb=
, const struct nft_ctx *ctx,
 			goto nla_put_failure;
 	}
=20
+	if (nla_put(skb, NFTA_SET_USERDATA, set->udlen, set->udata))
+		goto nla_put_failure;
+
 	desc =3D nla_nest_start(skb, NFTA_SET_DESC);
 	if (desc =3D=3D NULL)
 		goto nla_put_failure;
@@ -2704,6 +2709,8 @@ static int nf_tables_newset(struct net *net, stru=
ct sock *nlsk,
 	u64 timeout;
 	u32 ktype, dtype, flags, policy, gc_int;
 	struct nft_set_desc desc;
+	u16 udlen;
+	unsigned char *udata;
 	int err;
=20
 	if (nla[NFTA_SET_TABLE] =3D=3D NULL ||
@@ -2816,12 +2823,16 @@ static int nf_tables_newset(struct net *net, st=
ruct sock *nlsk,
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
=20
+	udlen =3D 0;
+	if (nla[NFTA_SET_USERDATA])
+		udlen =3D nla_len(nla[NFTA_SET_USERDATA]);
+
 	size =3D 0;
 	if (ops->privsize !=3D NULL)
 		size =3D ops->privsize(nla);
=20
 	err =3D -ENOMEM;
-	set =3D kzalloc(sizeof(*set) + size, GFP_KERNEL);
+	set =3D kzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
 	if (set =3D=3D NULL)
 		goto err1;
=20
@@ -2830,6 +2841,12 @@ static int nf_tables_newset(struct net *net, str=
uct sock *nlsk,
 	if (err < 0)
 		goto err2;
=20
+	udata =3D NULL;
+	if (udlen) {
+		udata =3D set->data + size;
+		nla_memcpy(udata, nla[NFTA_SET_USERDATA], udlen);
+	}
+
 	INIT_LIST_HEAD(&set->bindings);
 	write_pnet(&set->pnet, net);
 	set->ops   =3D ops;
@@ -2840,6 +2857,8 @@ static int nf_tables_newset(struct net *net, stru=
ct sock *nlsk,
 	set->flags =3D flags;
 	set->size  =3D desc.size;
 	set->policy =3D policy;
+	set->udlen  =3D udlen;
+	set->udata  =3D udata;
 	set->timeout =3D timeout;
 	set->gc_int =3D gc_int;
=20
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
