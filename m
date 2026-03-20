Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A27375AA2
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 15:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774020069; cv=none; b=df5s9+VPBkSWl1lVt+t6FFy4j7AjQshOkuuWl2+bWEa0m4u0CX44ZExrECM0z9QEVVyH6aTafAHPlgKS8v2XK9nCHFSXa5BeV+OY6YR51nzhK4OKRdMBqefEPtN5L16HdhRrtvOlddOFsQHaw2gQLJdhm74G2x9XOqKL9EtoApI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774020069; c=relaxed/simple;
	bh=xmI0F23LrLkLqWpBNxw/hCNx6pETHromDT1UVXoGz8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fQUZaBNUfRT7vr6kBIlYsn2UWkJNLBXLoKniTkoPef0itP0gzCdPAAQ7mJVErTzXXZHFw/LnDWr9KNVcETXBR2Ix7J8kTYjVB+bX41qeNUQU6y83YW0XViVnBxtMRGzeiCZ1FckbfCRSLkYYjS9C3W+eAr4KmxZAue7ThZob/eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YZnEitVU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YZnEitVU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yfCrvjx+S+Qn9/QN5KNwPNGdWytHdg4bchNOEZvk94I=; b=YZnEitVUjaYlhQz6ycpe75doXb
	35baOp80c4P2PgOx/Mlb+WISAFc64clH4hAn1sG2X8tiJ7j9SQS0pOFmt6L8182/16Alf92dyHh12
	t0XihqU2B+V9pPEd8IfyhDmwxrNUB3O9RTX+oyNoOzXoCr2r10WYAQQSW/2X7B29qnP1UKDvmyeNe
	1cWoIMZUoYu0ZmMVJpowdH9kASN5wG7dO4ZvkpkblVslSYfC4mS/i8Cj1q2DcillTElQnfdtTKuOX
	jnvcuePLo6wF9/Yr/TpVIMxRTeuH2bHb8tPLVNUgbGM0CxzoscuqEDOIRver7DKDvV+J1FK5790qA
	K/XlpuMA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3beq-0000000020G-2Enf;
	Fri, 20 Mar 2026 16:21:04 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v2] netfilter: nfnetlink_hook: Dump nat type chains
Date: Fri, 20 Mar 2026 16:19:39 +0100
Message-ID: <20260320152059.7714-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These chains are indirectly attached to the hook since they are
not called for packets belonging to an established connection.

Introduce NF_HOOK_OP_NAT to identify the container and dump attached
entries instead of the container itself.

Dump these entries with the dispatcher's priority value since their own
priority merely defines ordering within the dispatcher's list.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Use dispatcher's priority value in dumps
---
 include/linux/netfilter.h      |  7 +++++++
 net/netfilter/nf_nat_core.c    |  6 ------
 net/netfilter/nf_nat_proto.c   |  8 ++++++++
 net/netfilter/nfnetlink_hook.c | 37 ++++++++++++++++++++++++++++++----
 4 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index efbbfa770d66..e99afc1414cd 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -93,6 +93,7 @@ enum nf_hook_ops_type {
 	NF_HOOK_OP_NF_TABLES,
 	NF_HOOK_OP_BPF,
 	NF_HOOK_OP_NFT_FT,
+	NF_HOOK_OP_NAT,
 };
 
 struct nf_hook_ops {
@@ -140,6 +141,12 @@ struct nf_hook_entries {
 	 */
 };
 
+struct nf_nat_lookup_hook_priv {
+	struct nf_hook_entries __rcu *entries;
+
+	struct rcu_head rcu_head;
+};
+
 #ifdef CONFIG_NETFILTER
 static inline struct nf_hook_ops **nf_hook_entries_get_hook_ops(const struct nf_hook_entries *e)
 {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 3b5434e4ec9c..1f9576056e2d 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -39,12 +39,6 @@ static struct hlist_head *nf_nat_bysource __read_mostly;
 static unsigned int nf_nat_htable_size __read_mostly;
 static siphash_aligned_key_t nf_nat_hash_rnd;
 
-struct nf_nat_lookup_hook_priv {
-	struct nf_hook_entries __rcu *entries;
-
-	struct rcu_head rcu_head;
-};
-
 struct nf_nat_hooks_net {
 	struct nf_hook_ops *nat_hook_ops;
 	unsigned int users;
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 97c0f841fc96..f29e896e62c9 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -790,6 +790,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_NAT_DST,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* After packet filtering, change source */
 	{
@@ -797,6 +798,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_NAT_SRC,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* Before packet filtering, change destination */
 	{
@@ -804,6 +806,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_NAT_DST,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* After packet filtering, change source */
 	{
@@ -811,6 +814,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 };
 
@@ -1051,6 +1055,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_NAT_DST,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* After packet filtering, change source */
 	{
@@ -1058,6 +1063,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_NAT_SRC,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* Before packet filtering, change destination */
 	{
@@ -1065,6 +1071,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_NAT_DST,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* After packet filtering, change source */
 	{
@@ -1072,6 +1079,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_NAT_SRC,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 };
 
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 531706982859..fa5600116e2c 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -190,7 +190,7 @@ static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
 
 static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 			      const struct nfnl_dump_hook_data *ctx,
-			      const struct nf_hook_ops *ops,
+			      const struct nf_hook_ops *ops, int priority,
 			      int family, unsigned int seq)
 {
 	u16 event = nfnl_msg_type(NFNL_SUBSYS_HOOK, NFNL_MSG_HOOK_GET);
@@ -244,7 +244,7 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	if (ret)
 		goto nla_put_failure;
 
-	ret = nla_put_be32(nlskb, NFNLA_HOOK_PRIORITY, htonl(ops->priority));
+	ret = nla_put_be32(nlskb, NFNLA_HOOK_PRIORITY, htonl(priority));
 	if (ret)
 		goto nla_put_failure;
 
@@ -337,6 +337,30 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
 	return hook_head;
 }
 
+static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
+			      const struct nfnl_dump_hook_data *ctx,
+			      const struct nf_hook_ops *ops,
+			      int family, unsigned int seq)
+{
+	struct nf_nat_lookup_hook_priv *priv = ops->priv;
+	struct nf_hook_entries *e = rcu_dereference(priv->entries);
+	struct nf_hook_ops **nat_ops;
+	int i, err;
+
+	if (!e)
+		return 0;
+
+	nat_ops = nf_hook_entries_get_hook_ops(e);
+
+	for (i = 0; i < e->num_hook_entries; i++) {
+		err = nfnl_hook_dump_one(nlskb, ctx, nat_ops[i],
+					 ops->priority, family, seq);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static int nfnl_hook_dump(struct sk_buff *nlskb,
 			  struct netlink_callback *cb)
 {
@@ -365,8 +389,13 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		err = nfnl_hook_dump_one(nlskb, ctx, ops[i], family,
-					 cb->nlh->nlmsg_seq);
+		if (ops[i]->hook_ops_type == NF_HOOK_OP_NAT)
+			err = nfnl_hook_dump_nat(nlskb, ctx, ops[i], family,
+						 cb->nlh->nlmsg_seq);
+		else
+			err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
+						 ops[i]->priority, family,
+						 cb->nlh->nlmsg_seq);
 		if (err)
 			break;
 	}
-- 
2.51.0

