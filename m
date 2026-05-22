Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99893BB106;
	Fri, 22 May 2026 10:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779446607; cv=none; b=cFmpoS3e0LphUGu4o9rorg/P903U+F/T8nrqa8UMLuAcuodYiJUU09x+3q8EXdHc5npFK3juj+xduc6bTuk+X8DYv6nGEKsJS3vSoKGdwQ6dqkwKh1JFbyo1jPoTLo6D5XVqB/UZdMD91e4XZH3mlqGkK/Ero63u8FVjxAoCsMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779446607; c=relaxed/simple;
	bh=m5dFyx0/gpDQFaXfr4uI0GwAjpdAo23LC3l/a/YgLhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vm9jvLriY5oWwEPBpKi4EMmBzaNO5Qo9nFl/XPcU6mMD1etsmN0KYmNU/TnZkohuXyhnrJbc5gu7UmAIA4s44su7l+KNBY14Ik6D8ySmes/kEsfiHi5QfrKCVU2CQVhHLTlC04ZBhixSw4u2/0E8woR5n4w9N4gvrRReObLFs8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 32F77602C8; Fri, 22 May 2026 12:43:25 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 05/10] netfilter: disable payload mangling in userns
Date: Fri, 22 May 2026 12:42:52 +0200
Message-ID: <20260522104257.2008-6-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522104257.2008-1-fw@strlen.de>
References: <20260522104257.2008-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several parts of network stack rely on iph->ihl validation
done by network stack before PRE_ROUTING.

Disable this feature for user namespaces for now.

tcp option handling is likely safe even for LOCAL_IN, so this
this leaves tcp option mangling via nft_exthdr.c as-is.

I don't think these are the only means to alter packets, but these
appear to be relatively prominent.

This could be relaxed later.  Example:
 - allow userns for ingress hook.
 - allow userns if base is transport header.

 Also, we should revalidate or restrict generally:
 - Don't allow linklayer writes to spill into network header
 - restrict ipv4 and ipv6 to 'known safe' writes, e.g.
   saddr/daddr/check/tos

Reported-by: Qi Tang <tpluszz77@gmail.com>
Reported-by: Tong Liu <lyutoon@gmail.com>
Tested-by: Qi Tang <tpluszz77@gmail.com>
Link: https://lore.kernel.org/netfilter-devel/20260515100411.3141-1-fw@strlen.de/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 6 ++++--
 net/netfilter/nft_payload.c     | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 984a0eb9e149..60ab88d45096 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1141,6 +1141,9 @@ nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int di
 {
 	struct sk_buff *nskb;
 
+	if (e->state.net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	if (diff < 0) {
 		unsigned int min_len = skb_transport_offset(e->skb);
 
@@ -1537,8 +1540,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 		if (nfqnl_mangle(nla_data(nfqa[NFQA_PAYLOAD]),
 				 payload_len, entry, diff) < 0)
 			verdict = NF_DROP;
-
-		if (ct && diff)
+		else if (ct && diff)
 			nfnl_ct->seq_adjust(entry->skb, ct, ctinfo, diff);
 	}
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 01e13e5255a9..484a5490832e 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -917,6 +917,9 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	struct nft_payload_set *priv = nft_expr_priv(expr);
 	int err;
 
+	if (ctx->net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
-- 
2.53.0

