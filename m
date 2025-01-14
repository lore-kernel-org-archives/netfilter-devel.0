Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C54C91C2DB2
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2025 16:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736872037; cv=none; b=TKKb78ClgEbRAqX5E+FCYWzarlRKSM3pTrp7R5zl3kQuIdUFoztngODKbqr4+kqhj+hh5ggY8q6F1pNg1RhLWFL4OlbqHGTmJEjX3qd1h3wgNrG3eG7Bbn2ztWxrCGHV5cheTBIpeVoBDjj4MjcOXG08KevaBHD5zGZYNXhLTFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736872037; c=relaxed/simple;
	bh=tincgim+KKFenhTz0bGQ05TkhtRGJzjf/Solym9XpCk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FartZg0qvdifveJJ0g/94GdqRP1xPwLstCWnA//21q+SF86MO/QHTJrbTVhGP5e43ylyiDLAZFtXHfLpoxg7Oigzg1iscA61lf7WlHbmy8++rn0ulGlrZWhloD3shmBnUKLCI/kBdTHWnWOEpiOh9RSLHjfnZhDdh9FIGeYJZ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v2 2/6] netfilter: nft_flow_offload: update tcp state flags under lock
Date: Tue, 14 Jan 2025 17:26:58 +0100
Message-Id: <20250114162702.9128-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250114162702.9128-1-pablo@netfilter.org>
References: <20250114162702.9128-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

The conntrack entry is already public, there is a small chance that another
CPU is handling a packet in reply direction and racing with the tcp state
update.

Move this under ct spinlock.

This is done once, when ct is about to be offloaded, so this should
not result in a noticeable performance hit.

Fixes: 8437a6209f76 ("netfilter: nft_flow_offload: set liberal tracking mode for tcp")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nft_flow_offload.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 3b474d235663..221d50223018 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -289,6 +289,15 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 	return false;
 }
 
+static void flow_offload_ct_tcp(struct nf_conn *ct)
+{
+	/* conntrack will not see all packets, disable tcp window validation. */
+	spin_lock_bh(&ct->lock);
+	ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	spin_unlock_bh(&ct->lock);
+}
+
 static void nft_flow_offload_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
@@ -356,11 +365,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto err_flow_alloc;
 
 	flow_offload_route_init(flow, &route);
-
-	if (tcph) {
-		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-	}
+	if (tcph)
+		flow_offload_ct_tcp(ct);
 
 	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
-- 
2.30.2

