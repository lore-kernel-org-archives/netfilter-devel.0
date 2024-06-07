Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7482315B0FD;
	Fri,  7 Jun 2024 08:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717749385; cv=none; b=ZldG3tRJtVOxmBCalUQ3NbOYyaY2mgC/JZt97AzT1BWLjjGdSgVdzHsWUcK8ED/WjZAVGdr0OWgJzQ+4zSn1/9zrsp7veJ3gIy79l3EvNGjjHmFrqu3kaEBExf977Whq8qK+1unRGAab7tnmFDOFvIqjzmH9nQ/e+a3RKGV3/Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717749385; c=relaxed/simple;
	bh=vFtHfQFmKucqlq55Krid4EX8Q2ICnW7WSm1dE/Ob8ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WU7afiFcv6m/Y/DQLhEjI1R/e4Ssi49uLUHVpltlTDDlhjwPlcn5JOO+eGcYUYcpik0CNKjCS/qXFIA90KWyODzQdRUBJhwppTqnsxaZioiMKaMN7MdzAJ0TYWCPn5zTfS5hxoMjzJ2pc3Fh7p7JPUvrSqRNszbi7O5KL3wZ5no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sFV58-0001pZ-TK; Fri, 07 Jun 2024 10:36:18 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	willemb@google.com
Subject: [PATCH net-next 2/2] net: add and use __skb_get_hash_symmetric_net
Date: Fri,  7 Jun 2024 10:32:00 +0200
Message-ID: <20240607083205.3000-3-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240607083205.3000-1-fw@strlen.de>
References: <20240607083205.3000-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to previous patch: apply same logic for
__skb_get_hash_symmetric and let callers pass the netns to the dissector
core.

Existing function is turned into a wrapper to avoid adjusting all
callers, nft_hash.c uses new function.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/skbuff.h    | 8 +++++++-
 net/core/flow_dissector.c | 6 +++---
 net/netfilter/nft_hash.c  | 3 ++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6e78019f899a..813406a9bd6c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1498,8 +1498,14 @@ __skb_set_sw_hash(struct sk_buff *skb, __u32 hash, bool is_l4)
 	__skb_set_hash(skb, hash, true, is_l4);
 }
 
+u32 __skb_get_hash_symmetric_net(const struct net *net, const struct sk_buff *skb);
+
+static inline u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
+{
+	return __skb_get_hash_symmetric_net(NULL, skb);
+}
+
 void __skb_get_hash_net(const struct net *net, struct sk_buff *skb);
-u32 __skb_get_hash_symmetric(const struct sk_buff *skb);
 u32 skb_get_poff(const struct sk_buff *skb);
 u32 __skb_get_poff(const struct sk_buff *skb, const void *data,
 		   const struct flow_keys_basic *keys, int hlen);
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 32454181be60..f6a97aec38da 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1845,19 +1845,19 @@ EXPORT_SYMBOL(make_flow_keys_digest);
 
 static struct flow_dissector flow_keys_dissector_symmetric __read_mostly;
 
-u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
+u32 __skb_get_hash_symmetric_net(const struct net *net, const struct sk_buff *skb)
 {
 	struct flow_keys keys;
 
 	__flow_hash_secret_init();
 
 	memset(&keys, 0, sizeof(keys));
-	__skb_flow_dissect(NULL, skb, &flow_keys_dissector_symmetric,
+	__skb_flow_dissect(net, skb, &flow_keys_dissector_symmetric,
 			   &keys, NULL, 0, 0, 0, 0);
 
 	return __flow_hash_from_keys(&keys, &hashrnd);
 }
-EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
+EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric_net);
 
 /**
  * __skb_get_hash_net: calculate a flow hash
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 92d47e469204..868d68302d22 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -51,7 +51,8 @@ static void nft_symhash_eval(const struct nft_expr *expr,
 	struct sk_buff *skb = pkt->skb;
 	u32 h;
 
-	h = reciprocal_scale(__skb_get_hash_symmetric(skb), priv->modulus);
+	h = reciprocal_scale(__skb_get_hash_symmetric_net(nft_net(pkt), skb),
+			     priv->modulus);
 
 	regs->data[priv->dreg] = h + priv->offset;
 }
-- 
2.44.2

