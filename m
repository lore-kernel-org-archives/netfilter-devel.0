Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4ABD14B947;
	Wed, 14 Aug 2024 22:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723674058; cv=none; b=jyJug6qLO8QofH/v+aWZh8a2Z5N5dya7X5kzZ8KlgSvwc/Ke6/OcR2feMtHWe+UI2Vw0+8KflSHYhcAU1hkcwNrKlbEuTIdX3bejPjW/9VUayyOi1xvtf0p2WRHKnJlMhtHeUeUKbyi7YxySHuMiD6PfxvibZ8jHerS0QrCkilc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723674058; c=relaxed/simple;
	bh=x9cfzGdYD8vxaTejJ2HeMaRW0yRC6QJx5zgGA5TeA2M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=arl0XJykkc+lSfYEJrRd7BbP+Q9dR1ye0JqwragwZkLjYskp2VnlKvqbcRIbsje6SHsArC8Jf9QtuWMqKDPozcd1/Mt0BswwwFR/kWFOlYyTB4QaxcjPq4SJIIOlcQee4rqrxHox2M67g2R9mfD2K5UydegjPm8hY+0eiNZlCq8=
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
Subject: [PATCH net 6/8] netfilter: nf_tables: Audit log dump reset after the fact
Date: Thu, 15 Aug 2024 00:20:40 +0200
Message-Id: <20240814222042.150590-7-pablo@netfilter.org>
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

In theory, dumpreset may fail and invalidate the preceeding log message.
Fix this and use the occasion to prepare for object reset locking, which
benefits from a few unrelated changes:

* Add an early call to nfnetlink_unicast if not resetting which
  effectively skips the audit logging but also unindents it.
* Extract the table's name from the netlink attribute (which is verified
  via earlier table lookup) to not rely upon validity of the looked up
  table pointer.
* Do not use local variable family, it will vanish.

Fixes: 8e6cf365e1d5 ("audit: log nftables configuration change events")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 481ee78e77bc..4fa132715fcc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8055,6 +8055,7 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
+	const struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -8064,6 +8065,7 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	struct sk_buff *skb2;
 	bool reset = false;
 	u32 objtype;
+	char *buf;
 	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -8102,27 +8104,23 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
-	if (reset) {
-		const struct nftables_pernet *nft_net;
-		char *buf;
-
-		nft_net = nft_pernet(net);
-		buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
-
-		audit_log_nfcfg(buf,
-				family,
-				1,
-				AUDIT_NFT_OP_OBJ_RESET,
-				GFP_ATOMIC);
-		kfree(buf);
-	}
-
 	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
 				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
 				      family, table, obj, reset);
 	if (err < 0)
 		goto err_fill_obj_info;
 
+	if (!reset)
+		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
+	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
+			nla_len(nla[NFTA_OBJ_TABLE]),
+			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
+			nft_net->base_seq);
+	audit_log_nfcfg(buf, info->nfmsg->nfgen_family, 1,
+			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
+	kfree(buf);
+
 	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
 err_fill_obj_info:
-- 
2.30.2

