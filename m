Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FD814D6E9;
	Wed, 14 Aug 2024 22:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723674059; cv=none; b=c6idqKYAbEn4XUjYNyy2Us1xVCZXDjsOffX/I/OGQIHqLGTin2zcXZppWvz4IuMuPX7A8LOggTmjZCVf0TuNjm8IipmLqHdOuk1Y3VNyj5QqQxN4FQVWH9hUXBlqRJSzUcJCjYsT2QFZJqfAx3CMBpP9ZjFwUZCPHr/cR5MlwGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723674059; c=relaxed/simple;
	bh=V7+o/iCcRdA03ouMWE2KtpAUY+6UY/6lguGE/lXQv7s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bNMxHkc+FM9TWmp9ddpEVNODvgA/aij9svXzTrE//ag7SW9AMZRvCeZGHTh/gDFNWenzDfTmLZ9WkWlx5TFCEfxwi4GOy2A+nfntIo3Ygugp8NqpbX+lxBaKTF+NksliDArpw+cDMCQ0xHZy48P9kczjVah9UGBtKNPa5VWmrYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 7/8] netfilter: nf_tables: Introduce nf_tables_getobj_single
Date: Thu, 15 Aug 2024 00:20:41 +0200
Message-Id: <20240814222042.150590-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240814222042.150590-1-pablo@netfilter.org>
References: <20240814222042.150590-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Outsource the reply skb preparation for non-dump getrule requests into a
distinct function. Prep work for object reset locking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 75 ++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4fa132715fcc..c12c9cae784d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8052,10 +8052,10 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
-			    const struct nlattr * const nla[])
+static struct sk_buff *
+nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
+			const struct nlattr * const nla[], bool reset)
 {
-	const struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -8063,52 +8063,69 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	struct net *net = info->net;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
-	bool reset = false;
 	u32 objtype;
-	char *buf;
 	int err;
 
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start = nf_tables_dump_obj_start,
-			.dump = nf_tables_dump_obj,
-			.done = nf_tables_dump_obj_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
 	if (!nla[NFTA_OBJ_NAME] ||
 	    !nla[NFTA_OBJ_TYPE])
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
-		return PTR_ERR(table);
+		return ERR_CAST(table);
 	}
 
 	objtype = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 	obj = nft_obj_lookup(net, table, nla[NFTA_OBJ_NAME], objtype, genmask);
 	if (IS_ERR(obj)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_NAME]);
-		return PTR_ERR(obj);
+		return ERR_CAST(obj);
 	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
+
+	err = nf_tables_fill_obj_info(skb2, net, portid,
+				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
+				      family, table, obj, reset);
+	if (err < 0) {
+		kfree_skb(skb2);
+		return ERR_PTR(err);
+	}
+
+	return skb2;
+}
+
+static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	u32 portid = NETLINK_CB(skb).portid;
+	struct net *net = info->net;
+	struct sk_buff *skb2;
+	bool reset = false;
+	char *buf;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_obj_start,
+			.dump = nf_tables_dump_obj,
+			.done = nf_tables_dump_obj_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
 
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
-	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
-				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
-				      family, table, obj, reset);
-	if (err < 0)
-		goto err_fill_obj_info;
+	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
 
 	if (!reset)
 		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
@@ -8121,11 +8138,7 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
 	kfree(buf);
 
-	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
-
-err_fill_obj_info:
-	kfree_skb(skb2);
-	return err;
+	return nfnetlink_unicast(skb2, net, portid);
 }
 
 static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
-- 
2.30.2

