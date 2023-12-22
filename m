Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58BD18035;
	Fri, 22 Dec 2023 11:57:25 +0000 (UTC)
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
Subject: [PATCH net-next 2/8] netfilter: nf_tables: Introduce nft_set_dump_ctx_init()
Date: Fri, 22 Dec 2023 12:57:08 +0100
Message-Id: <20231222115714.364393-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231222115714.364393-1-pablo@netfilter.org>
References: <20231222115714.364393-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

This is a wrapper around nft_ctx_init() for use in
nf_tables_getsetelem() and a resetting equivalent introduced later.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 49 +++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 775b70a62140..9b58593e7729 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6039,21 +6039,18 @@ static int nft_get_set_elem(struct nft_ctx *ctx, const struct nft_set *set,
 	return err;
 }
 
-/* called with rcu_read_lock held */
-static int nf_tables_getsetelem(struct sk_buff *skb,
-				const struct nfnl_info *info,
-				const struct nlattr * const nla[])
+static int nft_set_dump_ctx_init(struct nft_set_dump_ctx *dump_ctx,
+				 const struct sk_buff *skb,
+				 const struct nfnl_info *info,
+				 const struct nlattr * const nla[],
+				 bool reset)
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
-	int rem, err = 0, nelems = 0;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct nft_set *set;
-	struct nlattr *attr;
-	struct nft_ctx ctx;
-	bool reset = false;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
 				 genmask, 0);
@@ -6068,7 +6065,24 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 		return PTR_ERR(set);
 	}
 
-	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+	nft_ctx_init(&dump_ctx->ctx, net, skb,
+		     info->nlh, family, table, NULL, nla);
+	dump_ctx->set = set;
+	dump_ctx->reset = reset;
+	return 0;
+}
+
+/* called with rcu_read_lock held */
+static int nf_tables_getsetelem(struct sk_buff *skb,
+				const struct nfnl_info *info,
+				const struct nlattr * const nla[])
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct nft_set_dump_ctx dump_ctx;
+	int rem, err = 0, nelems = 0;
+	struct net *net = info->net;
+	struct nlattr *attr;
+	bool reset = false;
 
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
 		reset = true;
@@ -6080,11 +6094,10 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			.done = nf_tables_dump_set_done,
 			.module = THIS_MODULE,
 		};
-		struct nft_set_dump_ctx dump_ctx = {
-			.set = set,
-			.ctx = ctx,
-			.reset = reset,
-		};
+
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
+		if (err)
+			return err;
 
 		c.data = &dump_ctx;
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
@@ -6093,8 +6106,12 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
+	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
+	if (err)
+		return err;
+
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&ctx, set, attr, reset);
+		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, reset);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
@@ -6103,7 +6120,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	}
 
 	if (reset)
-		audit_log_nft_set_reset(table, nft_pernet(net)->base_seq,
+		audit_log_nft_set_reset(dump_ctx.ctx.table, nft_pernet(net)->base_seq,
 					nelems);
 
 	return err;
-- 
2.30.2

