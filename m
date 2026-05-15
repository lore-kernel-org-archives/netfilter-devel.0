Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620583AD514;
	Fri, 15 May 2026 10:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778839467; cv=none; b=VHMQUDK3KJiHoq20vUP61Pw+OKWO3Hlhi0BV+//2+cfU0vONxAvX7tgS71WkDHsWlHJaUwS1VoU0G8so340wCGA4vTBrm0VsBelMQkwA8IPadiC+rBQtM6mpCGodRFaGtWfOPxuYcdGMzCMzrGyJ2bf+Bk2Yf8g4/3A3mneG+vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778839467; c=relaxed/simple;
	bh=u652Chsnsi/k6W9YlM0FwQSKUPm8kgRHazuxH37ZCEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ufBW4+SpAV/AmxX0LpUZZN/0pRRQU/UJl8eADau6uaTK651GJGtrMSBlHU1KfoGFSNXPTMdWVRxm7HbSMfMmq0bHjGtNjtbeWRbLdWoqteQGtKAAFvs6DXLoI+a3KEuqwAkhaxdNTsDN3rsj7djxoWne0WZKQW6d0WkVet28Pn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5783C6092A; Fri, 15 May 2026 12:04:23 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Qi Tang <tpluszz77@gmail.com>
Subject: [RFC] netfilter: disable payload mangling in userns
Date: Fri, 15 May 2026 12:04:11 +0200
Message-ID: <20260515100411.3141-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
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

This could be relaxed later.  Example:
 - allow userns only for ingress hook.
 - allow userns write if base is transport header
 - allow userns write if base is linklayer and offset
   below network header offset
 - allow userns write for ipv4 if offset+len match saddr/daddr
 - allow userns write for ipv6 if offset+len match saddr/daddr
 ... etc.

tcp option handling might be safe even for LOCAL_IN, as LOCAL_IN gets
invoked before tcp stack, but this turns it off too.
optstrip remains enabled, see no problem with that one.

I don't think these are the only means to alter packets, but these
appear to be relatively prominent.

Another option would be to restrict this generally, however, this
is harder to do for nfqueue.  For nftables we know where the
modification happens and can even reject a subset from netlink path
directly.  But for nfqueue, we'd need to 'revalidate' at least
ip/ipv6 header for ipv4/ipv6 families.  Bridge path might be okay with
arbitray header modifications.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Qi Tang <tpluszz77@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 3 +++
 net/netfilter/nft_exthdr.c      | 3 +++
 net/netfilter/nft_payload.c     | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 58304fd1f70f..e1e1d11fdf04 100644
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
 
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index e6a07c0df207..577a15383e98 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -551,6 +551,9 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 	u32 offset, len, flags = 0, op = NFT_EXTHDR_OP_IPV6;
 	int err;
 
+	if (ctx->net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	if (!tb[NFTA_EXTHDR_SREG] ||
 	    !tb[NFTA_EXTHDR_TYPE] ||
 	    !tb[NFTA_EXTHDR_OFFSET] ||
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

