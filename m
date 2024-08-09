Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55404194C82
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2024 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723208868; cv=none; b=enOtXB0bibHWXwYq02RvLmecN8iBHjYFMC7QDtLP/oiiSCP826BX0n6w6h7+gj/o21kOMMuNPoBDux5FoVKzPZRlZVfQD2va+rjfXoDqAh2UTJxVCc1cnINcZakCo7cnzJiElODHgd2IWDJgh7AKHRnErpMFuTp2qllWGjVuBxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723208868; c=relaxed/simple;
	bh=3q8En1Flx+VpxRhSUvQtMpnXqqYg4jQcg9Cf76n9GWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ/ulC9OBYEIiNouEzLj3JMirPHYif1iUcfGbixeUwlHIO/Wx2gVA4l955+yMwowK0T0ao6eGhnlrpVEO+xsDLYRgrcYaeuc2htLF7hqZj5qC/WQgpamDdsXKDpKerXrwOxtAU58YbQ7M2GuADD1mB6LpVply0JNNsAOonQlgB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UQ5BBLx1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UQ5BBLx1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ld8Z+KoxDfxYVsjQUCHHeJwCcr6Fos51lBh40MBkeeQ=; b=UQ5BBLx1ri8uHUpgCsvRt8BsEu
	ag/qUkjv7gz4+Ll3pvcszMapajlIq13Sbtk/kutr9402+BEr9Z8lf+bEW/SBcAWlumFOgKyi0bdtQ
	V86z2uQa4rA7Os7HYu2AyEALNoobqOU9NjhBiXlE7xwrP7cQkJXKs4yfHRQGh6z2/+OHgbIQWtrFD
	fnAI5+nYP6/6/UwHHM9KEk6YsU6u2zM4CqFQevHcg/XocSmWcPs2TqWHBUa28ZgyUNFpcyR2M4adK
	24y1AJs8qEGDOguDWvd5rd1BScuD7j9Rkk4CCSl5yQVFQmZhV1LmQ6rgJN3sC5FUNPt/ebN1lMe5f
	35Z1AtiQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1scPLF-000000000Dm-3FPm;
	Fri, 09 Aug 2024 15:07:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf PATCH v4 2/3] netfilter: nf_tables: Introduce nf_tables_getobj_single
Date: Fri,  9 Aug 2024 15:07:31 +0200
Message-ID: <20240809130732.13128-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240809130732.13128-1-phil@nwl.cc>
References: <20240809130732.13128-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Outsource the reply skb preparation for non-dump getrule requests into a
distinct function. Prep work for object reset locking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
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
2.43.0

