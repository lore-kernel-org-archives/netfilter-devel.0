Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9E73CF03E;
	Thu,  9 Apr 2026 13:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740079; cv=none; b=Oy2mTNiUNDMcLQ/MfdW5E7o36lwBaKXzgswHjqljd0pHUTOCAWGJi/dzM4N6HKDzmvm0eRiiWQkl5Y/fdBZy7I4CNi9vM+wTsqLaWhBnI+r5jlUvZqJCbL1CbLeAMou+ibGY3Rv6Zxe80fWxviZ4t/n1zXc3Z8Mdh/qMo2HACSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740079; c=relaxed/simple;
	bh=JToKvM0nCAeg2dU3OZHC3s+o3UUMhQuLTgZjYTPMY9U=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+uSLpfqDFD5lzgbm5MMeb33DslOWuNf5c88eaygTk7MWR1VxRiZnC2grKojKXdTkdWoTvg83R6AyotMpE+/ZJK+9Qbhm9xvylxb+yTGC2u6W8l9dxPdgCObM3IzHAczJTEJpWbwV84OpeUy9ZyKsxHqxAC/cVdOv9V5XCER3/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wAp6w-000000001l8-25rf;
	Thu, 09 Apr 2026 13:07:54 +0000
Date: Thu, 9 Apr 2026 14:07:51 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH RFC net-next 4/4] net: ethernet: mtk_eth_soc: report
 INGRESS_L2 byte_type in flow stats
Message-ID: <2a1df22e3ff326cee3a70d346fb87b4a446554f3.1775739840.git.daniel@makrotopia.org>
References: <cover.1775739840.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775739840.git.daniel@makrotopia.org>

The MediaTek PPE MIB counters report ingress L2 frame bytes
including Ethernet, VLAN and PPPoE headers. Tell the flow offload
framework so it can derive correct L3 byte counts for conntrack
and update sub-interface counters.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index cc8c4ef8038f3..68cb03a193f3f 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -557,6 +557,7 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 				  &diff)) {
 		f->stats.pkts += diff.packets;
 		f->stats.bytes += diff.bytes;
+		f->stats.byte_type = FLOW_STATS_BYTES_INGRESS_L2;
 	}
 
 	return 0;
-- 
2.53.0
