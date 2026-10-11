Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97580402BA9;
	Sun, 11 Oct 2026 22:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756024; cv=none; b=ffjpx5QYcRkRqHfMtwkkW4e5ODPgXTTfx7eykqniCtvo37P2nKUvhPxHeI/WsM6xmhqjISVUncugILYR9l/i0Kl5nPKyJh1bA4kPeXev2L+6Zzsym8ko36FbjuAh5UKa+wMc7r7DAbHBkDY1msTjTcVVBwMe+5nIagJBbpSH7Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756024; c=relaxed/simple;
	bh=32hpkRCRdyFadDzwL9v2B5md/tQdzwLZTbUci/PTS88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlQXCEo0SwTMuSPiOtTsJfCZWgaoxYKd68d0DyQJTo5BJe5jn+9AlUYeXBCqRxeTHZE70DtoiXZVDBTl/yXou+lodOQk+TJq/W9oZVNbBSdk4Q9SFUbfi9B5C4MuN/7Djnsx6i0e34qZVLdbMfFv3OjAYbrr967SXzHaUN/8Rpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=taY7UXHe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="taY7UXHe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756020;
	bh=2bt9GGuXyXQ5LLG0o2hYuWwiv5S6kqH39sCQ5BfSpzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taY7UXHeDIw82BNwIesHHNTHHMwMHjzAccsa+qmaMCmt+zdc1jI8JCK79k2Aq05VX
	 Y+J+aEn9TA8C9uXG+msL7k/TCDKjsubBSUA7EcjDzs8V7PLsSeLYZr8vHug3MC8ekY
	 Gi68RfTr6/Ya0lQl11hRxYvJYV2FoDbRxMEqkT02hXyhVuECLImjyo0BulaZxk6t7N
	 vxwA/jhr5kOjtWNTqavqRwwLge+l94Qasz0KT3PELOSKGMlLlMztPEOQtEQFpKwf0O
	 giSCQGBtHCCzofmdzDKyLnZuH3KaxbK/3EknDW2Q4MJ1rHyDumQGoXOKi1ADLjm9aH
	 Otab64wBYClag==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B450060074;
	Mon, 12 Oct 2026 00:00:19 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 12/15] netfilter: add nf_skb_sk helper and use it
Date: Sun, 11 Oct 2026 23:59:50 +0200
Message-ID: <20261011215953.1334630-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>
References: <20261011215953.1334630-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.47.3

