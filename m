Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECFD33CEAA;
	Thu, 11 Sep 2025 14:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757601520; cv=none; b=pkuDekUHpNrs5k1+MpgsNZ2r4elCf1BqgPcgHz/ZTa4wevACnGYGhHvnJ0QN1FF7B5nXJzXdqEYaeZX22mqCuEB7e637msM1hjI7Ox8GDPvD71Gr7PRuS/6vNc025XHFoUpQqJsdpNMOwzg/ClD0VBXqX4AUjEraeKXi+T4whD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757601520; c=relaxed/simple;
	bh=SpTw2QQNaO5WQFOnE1ckCnU2ny1LNEJziXyn+y0USgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iy+fvgsPztGd2/UGh1j/8XNBfP8JX+U1SPmkEVJfl/JYty3QSR3zU1nysTBceJHgHVJ5+9t+euWXA8vF/37r7COnui1p0F8tVLoxRaKxMy7iPI+vyOKkrJb224AB19SwLo3f9ASfwaGfrEGgZZsPUNC+RNjMbju650ZVtsvrRnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CB66C60326; Thu, 11 Sep 2025 16:38:36 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 3/5] netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support
Date: Thu, 11 Sep 2025 16:38:17 +0200
Message-ID: <20250911143819.14753-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250911143819.14753-1-fw@strlen.de>
References: <20250911143819.14753-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Expose the input bridge interface ethernet address so it can be used to
redirect the packet to the receiving physical device for processing.

Tested with nft command line tool.

table bridge nat {
	chain PREROUTING {
		type filter hook prerouting priority 0; policy accept;
		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
	}
}

Joint work with Pablo Neira.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/bridge/netfilter/nft_meta_bridge.c   | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 8e0eb832bc01..7c0c915f0306 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -959,6 +959,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
  * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
+ * @NFT_META_BRI_IIFHWADDR: packet input bridge interface ethernet address
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -999,6 +1000,7 @@ enum nft_meta_keys {
 	NFT_META_SDIFNAME,
 	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
+	NFT_META_BRI_IIFHWADDR,
 };
 
 /**
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 5adced1e7d0c..b7af36bbd306 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -59,6 +59,13 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		nft_reg_store_be16(dest, htons(p_proto));
 		return;
 	}
+	case NFT_META_BRI_IIFHWADDR:
+		br_dev = nft_meta_get_bridge(in);
+		if (!br_dev)
+			goto err;
+
+		memcpy(dest, br_dev->dev_addr, ETH_ALEN);
+		return;
 	default:
 		return nft_meta_get_eval(expr, regs, pkt);
 	}
@@ -86,6 +93,9 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 	case NFT_META_BRI_IIFVPROTO:
 		len = sizeof(u16);
 		break;
+	case NFT_META_BRI_IIFHWADDR:
+		len = ETH_ALEN;
+		break;
 	default:
 		return nft_meta_get_init(ctx, expr, tb);
 	}
@@ -175,6 +185,7 @@ static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
 
 	switch (priv->key) {
 	case NFT_META_BRI_BROUTE:
+	case NFT_META_BRI_IIFHWADDR:
 		hooks = 1 << NF_BR_PRE_ROUTING;
 		break;
 	default:
-- 
2.49.1

