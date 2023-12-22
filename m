Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FAF17753;
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
Subject: [PATCH net-next 3/8] netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests
Date: Fri, 22 Dec 2023 12:57:09 +0100
Message-Id: <20231222115714.364393-4-pablo@netfilter.org>
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

Set expressions' dump callbacks are not concurrency-safe per-se with
reset bit set. If two CPUs reset the same element at the same time,
values may underrun at least with element-attached counters and quotas.

Prevent this by introducing dedicated callbacks for nfnetlink and the
asynchronous dump handling to serialize access.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 98 +++++++++++++++++++++++++++++------
 1 file changed, 81 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9b58593e7729..ed6b6bcd6608 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5817,10 +5817,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
-	if (dump_ctx->reset && args.iter.count > args.iter.skip)
-		audit_log_nft_set_reset(table, cb->seq,
-					args.iter.count - args.iter.skip);
-
 	rcu_read_unlock();
 
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
@@ -5836,6 +5832,26 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	return -ENOSPC;
 }
 
+static int nf_tables_dumpreset_set(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	struct nft_set_dump_ctx *dump_ctx = cb->data;
+	int ret, skip = cb->args[0];
+
+	mutex_lock(&nft_net->commit_mutex);
+
+	ret = nf_tables_dump_set(skb, cb);
+
+	if (cb->args[0] > skip)
+		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
+					cb->args[0] - skip);
+
+	mutex_unlock(&nft_net->commit_mutex);
+
+	return ret;
+}
+
 static int nf_tables_dump_set_start(struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
@@ -6079,13 +6095,8 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	struct nft_set_dump_ctx dump_ctx;
-	int rem, err = 0, nelems = 0;
-	struct net *net = info->net;
 	struct nlattr *attr;
-	bool reset = false;
-
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
-		reset = true;
+	int rem, err = 0;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -6095,7 +6106,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			.module = THIS_MODULE,
 		};
 
-		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
 		if (err)
 			return err;
 
@@ -6106,22 +6117,75 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
-	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
+	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
 	if (err)
 		return err;
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, reset);
+		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, false);
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
+			break;
+		}
+	}
+
+	return err;
+}
+
+static int nf_tables_getsetelem_reset(struct sk_buff *skb,
+				      const struct nfnl_info *info,
+				      const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	struct netlink_ext_ack *extack = info->extack;
+	struct nft_set_dump_ctx dump_ctx;
+	int rem, err = 0, nelems = 0;
+	struct nlattr *attr;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_set_start,
+			.dump = nf_tables_dumpreset_set,
+			.done = nf_tables_dump_set_done,
+			.module = THIS_MODULE,
+		};
+
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
+		if (err)
+			return err;
+
+		c.data = &dump_ctx;
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
+		return -EINVAL;
+
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+	rcu_read_unlock();
+	mutex_lock(&nft_net->commit_mutex);
+	rcu_read_lock();
+
+	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
+	if (err)
+		goto out_unlock;
+
+	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
+		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, true);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
 		}
 		nelems++;
 	}
+	audit_log_nft_set_reset(dump_ctx.ctx.table, nft_net->base_seq, nelems);
 
-	if (reset)
-		audit_log_nft_set_reset(dump_ctx.ctx.table, nft_pernet(net)->base_seq,
-					nelems);
+out_unlock:
+	rcu_read_unlock();
+	mutex_unlock(&nft_net->commit_mutex);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
 
 	return err;
 }
@@ -9095,7 +9159,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETSETELEM_RESET] = {
-		.call		= nf_tables_getsetelem,
+		.call		= nf_tables_getsetelem_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
-- 
2.30.2

