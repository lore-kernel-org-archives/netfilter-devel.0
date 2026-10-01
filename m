Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587EB496D55
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2026 12:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856417; cv=none; b=ZDTo/1QjP+ErnfHcI9T2MmMm5rVAQ0IqH1aNRUW6qEs02vW81h+4CHyKG9fnTwVEvkedTXbRN3xU0xrDFfW1RRfr9Fkoq+fMJgOajdJLzY0z1bqxQjKgCQsU1clnk48W8FUXbuWoArfEYw0Ooa0CzWHDDeZWYohpEpFjRan26pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856417; c=relaxed/simple;
	bh=gehD7MbRL+0vycUjfSozQ1K8hNORgpsV2weGbRtmwjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bs92MtFGN+jlnWhvLD2GD98MFV8TRtYb9CqjERLravLS3AN7LjcDb4gabCofhg0sHjoWo3HNhdsbHJWGaxVFUVsXa3fbVkxUgkFZRtvYMIip3LJTPuj0FjzPOjzhO0gP/lKH07LjoyqcmUCEZxhFpKNMHukGeWmj4vETi7ZabNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F0DA0605C7; Thu, 01 Oct 2026 14:06:35 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Vega <vega@nebusec.ai>
Subject: [PATCH nf-next 1/2] netfilter: add nf_skb_sk helper and use it
Date: Thu,  1 Oct 2026 14:06:20 +0200
Message-ID: <20261001120625.29659-2-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001120625.29659-1-fw@strlen.de>
References: <20261001120625.29659-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft and xt socket matching pass skb->sk to inet_sk_transparent().
On the LOCAL_OUT path an IP tunnel transmits while preserving the
original skb owner, so a non-INET socket (e.g. PF_PACKET) can reach
these code paths.  This is reachable for nft_socket.c which does allow
LOCAL_OUT. xt_socket only permits PREROUTING/LOCAL_IN.

nf_nat does this too, but there the inet_sk_transparent() call
is explicitly restricted to the INPUT hook.

For a packet socket the INET-specific offset lands inside the
packet statistics area.

Introduce nf_skb_sk() in nf_socket.h which returns skb->sk only when
it belongs to the given net namespace and passes sk_is_inet().

While at it, replace the `sk != skb->sk` refcount test with an
explicit refcounted flag that is set when the socket is obtained
via the lookup helper (the path that takes a reference).

LLM finding, no reproducer, no out-of-bounds memory access.

Assisted-by: LLM
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_socket.h | 20 ++++++++++++++++++++
 net/netfilter/nft_socket.c        | 16 +++++++++-------
 net/netfilter/xt_socket.c         | 26 ++++++++++++++------------
 3 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_socket.h b/include/net/netfilter/nf_socket.h
index f9d7bee9bd4e..39047c73b642 100644
--- a/include/net/netfilter/nf_socket.h
+++ b/include/net/netfilter/nf_socket.h
@@ -10,4 +10,24 @@ struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
 struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 				  const struct net_device *indev);
 
+/**
+ * nf_skb_sk - Return the inet socket associated with an skb
+ * @skb: The skb to fetch sk from.
+ * @net: The network namespace the socket must belong to.
+ *
+ * On the output path, skb->sk may be non-INET when the skb is passing
+ * through an IP tunnel.
+ *
+ * Return:
+ * *sk* if it is an INET socket that belongs to @net, %NULL otherwise.
+ */
+static inline struct sock *nf_skb_sk(const struct sk_buff *skb, const struct net *net)
+{
+	struct sock *sk = skb->sk;
+
+	if (sk && net_eq(net, sock_net(sk)) && sk_is_inet(sk))
+		return sk;
+
+	return NULL;
+}
 #endif
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 52d892e04261..ea6c2f3dc3ff 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -111,15 +111,17 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			    const struct nft_pktinfo *pkt)
 {
 	const struct nft_socket *priv = nft_expr_priv(expr);
-	struct sk_buff *skb = pkt->skb;
-	struct sock *sk = skb->sk;
 	u32 *dest = &regs->data[priv->dreg];
+	struct sk_buff *skb = pkt->skb;
+	bool refcounted = false;
+	struct sock *sk;
 
-	if (sk && !net_eq(nft_net(pkt), sock_net(sk)))
-		sk = NULL;
-
-	if (!sk)
+	sk = nf_skb_sk(skb, nft_net(pkt));
+	if (!sk) {
 		sk = nft_socket_do_lookup(pkt);
+		if (sk)
+			refcounted = true;
+	}
 
 	if (!sk) {
 		regs->verdict.code = NFT_BREAK;
@@ -159,7 +161,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 	}
 
 out_put_sk:
-	if (sk != skb->sk)
+	if (refcounted)
 		sock_gen_put(sk);
 }
 
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 811e53bee408..cd3fc333ccf1 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -49,14 +49,15 @@ static bool
 socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 	     const struct xt_socket_mtinfo1 *info)
 {
+	struct sock *sk = nf_skb_sk(skb, xt_net(par));
 	struct sk_buff *pskb = (struct sk_buff *)skb;
-	struct sock *sk = skb->sk;
+	bool refcounted = false;
 
-	if (sk && !net_eq(xt_net(par), sock_net(sk)))
-		sk = NULL;
-
-	if (!sk)
+	if (!sk) {
 		sk = nf_sk_lookup_slow_v4(xt_net(par), skb, xt_in(par));
+		if (sk)
+			refcounted = true;
+	}
 
 	if (sk) {
 		bool wildcard;
@@ -79,7 +80,7 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 		    transparent && sk_fullsock(sk))
 			pskb->mark = READ_ONCE(sk->sk_mark);
 
-		if (sk != skb->sk)
+		if (refcounted)
 			sock_gen_put(sk);
 
 		if (wildcard || !transparent)
@@ -110,14 +111,15 @@ static bool
 socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
+	struct sock *sk = nf_skb_sk(skb, xt_net(par));
 	struct sk_buff *pskb = (struct sk_buff *)skb;
-	struct sock *sk = skb->sk;
+	bool refcounted = false;
 
-	if (sk && !net_eq(xt_net(par), sock_net(sk)))
-		sk = NULL;
-
-	if (!sk)
+	if (!sk) {
 		sk = nf_sk_lookup_slow_v6(xt_net(par), skb, xt_in(par));
+		if (sk)
+			refcounted = true;
+	}
 
 	if (sk) {
 		bool wildcard;
@@ -140,7 +142,7 @@ socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
 		    transparent && sk_fullsock(sk))
 			pskb->mark = READ_ONCE(sk->sk_mark);
 
-		if (sk != skb->sk)
+		if (refcounted)
 			sock_gen_put(sk);
 
 		if (wildcard || !transparent)
-- 
2.55.0

