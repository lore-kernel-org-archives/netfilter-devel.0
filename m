Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DC434C140
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773415950; cv=none; b=LkPZgGYorLokV16MQVuw7ksellSP0/4WxTdQPp1ReNI0fk9ndibSFx/HEoJVbuGKhuMpjyUT6NNls0ANdHZF80Y1U54lreOsszNtRDj16Cnqhfn2e1k4X6AyFOQ54vQl3iC+y2UwMvGyGDUR6gyL386l6fNPRZcOt0xcPIt+lJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773415950; c=relaxed/simple;
	bh=QQB+ZaDMEeCCd/XCEdAju0u6rrZsrQPjz+Zt9utRKNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OrSpsKxdyQQ/rknO1oVsJTABRF32/AWDbjBTHN8BI0jC/0HDHnvx40zM1aQb1bfRy34530JxXzGHYof0ydkHtaJ7CErrRK7yCcChMUuT8+fV+HS3VH9KGm5LpPbNN0wnYyVWHXDtwSIRUwv9FI/hMvqDqdYstOq/GHGPy23egR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pSAf9TzW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pSAf9TzW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PI9BVmqs4n8Y/q2UcOKpCEDDQc4gswG1jHzOHxSeBnU=; b=pSAf9TzW9vq1thxlFdsbBgb6KR
	6zsC6XMNEmhfkUbQaPqs9j+lzyr6ca8uY4sbsulJsKmD3aqPIgXq4LhTr0BAOi6ctbPeO+bjcIdqi
	cMsk8hNYVozxMJOmHXyPA0Y92WWCCN9cewky6poudh9vLuKWwJgk/vylh+Zv/h1EprCtNXOyOtuix
	6OJEnYONZ+W5NIQepp+fd0OTOkgqeYmeQ6h22IwZ/d09yOZb7SYgMOsohzS8pi6J6QHrTRVNj8iQB
	IXFfX5KR5FPzgBlhyL3UeVPFm0IMyvXtFY1CXoEwnoQCdGMWcwdU7vPCJ+uIj+LRcOtqNeCl49m8J
	qHDedtBQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w14Uz-000000005Fj-3KT2;
	Fri, 13 Mar 2026 16:32:25 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Date: Fri, 13 Mar 2026 16:32:20 +0100
Message-ID: <20260313153220.19662-1-phil@nwl.cc>
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

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter.h      |  7 +++++++
 net/netfilter/nf_nat_core.c    |  6 ------
 net/netfilter/nf_nat_proto.c   |  8 ++++++++
 net/netfilter/nfnetlink_hook.c | 31 +++++++++++++++++++++++++++++--
 4 files changed, 44 insertions(+), 8 deletions(-)

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
index 531706982859..924316e673cb 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -337,6 +337,29 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
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
+		err = nfnl_hook_dump_one(nlskb, ctx, nat_ops[i], family, seq);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static int nfnl_hook_dump(struct sk_buff *nlskb,
 			  struct netlink_callback *cb)
 {
@@ -365,8 +388,12 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		err = nfnl_hook_dump_one(nlskb, ctx, ops[i], family,
-					 cb->nlh->nlmsg_seq);
+		if (ops[i]->hook_ops_type == NF_HOOK_OP_NAT)
+			err = nfnl_hook_dump_nat(nlskb, ctx, ops[i], family,
+						 cb->nlh->nlmsg_seq);
+		else
+			err = nfnl_hook_dump_one(nlskb, ctx, ops[i], family,
+						 cb->nlh->nlmsg_seq);
 		if (err)
 			break;
 	}
-- 
2.51.0

