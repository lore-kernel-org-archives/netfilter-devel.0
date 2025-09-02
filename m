Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF010261B7F
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 11:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756812502; cv=none; b=IzHtaJ+q3sQADtmcQsfixnIhYDSdUutyp7OXQacuOH4Cjz3dzdGUAkGPOzpQNzfG/WjiohJJjUGuYQMPmatvTbJBNCTobj3g6WjOuG3DKFAjADhG7vfFvmbJRcbjJm8al2XgBcUlW1cPLBP6TdxEXPOzIXbVh8hhUF9/dQIH6uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756812502; c=relaxed/simple;
	bh=pJQBswfBChAWFcFkfJKugZh14aPrL27TuKj8gwJ9ww4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HBLPRIr8u62wOHeThTwvajl3BtJGua5nwo57xCwImIWpXGM2gcmhnv7qAzXjbCnTAbjVg8GzTQ4C0Tj4SEF1n5BbJudog5fOBy0vfX09VA0aaP8T4am4hi8WQChim3X/Qfvgha+eSXaBMM6m9kylhcYKoVax6ptCWdfzZII/+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id 7342724DA0B1; Tue,  2 Sep 2025 13:28:19 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next] netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support
Date: Tue,  2 Sep 2025 13:28:08 +0200
Message-ID: <20250902112808.5139-1-fmancera@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
v0: this requires a follow-up patch on nft and libnftnl which is ready.
I have tested the result and it matches the behavior of ebtables -j
redirect
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/bridge/netfilter/nft_meta_bridge.c   | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 2beb30be2c5f..a0d9daa05a8f 100644
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
2.51.0

