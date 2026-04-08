Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FAB346FC4;
	Wed,  8 Apr 2026 16:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775666135; cv=none; b=JAalVQ3BGMhXr1wBHN74A7NW/nNSkV55n8Oa3JpP1hssaOi0mVbk3fY/BB5dP9Q3C0gUf7HXYR66QiQ2KJ5z4CwjB9TJDrUQ4shmszirPR0wBbDEN0KPP+ks2ez51czukmWKDtxDt0uUhx2CTfTYWHvYS5v/IkZDzXa6NXIPHMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775666135; c=relaxed/simple;
	bh=xr5FSvfDLj8j3wV01t8Knr4ZkFGX5FbMXBoh6KAbX3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjNFBeDp31eNOp/9ocz6eEHTK2djIh4VfvyokLa/hU8c6eoFSGyvgixQSLoEjLbtUdWfqKVTDmziXkI6efSky3+rT/pr7iXRO7vimNq7ESjLWgA0RhbqnraymUkuXaKbQzcYRaDno7yvqX5V1IxNW42O3zvhFkM73vpXX4Py3Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A392B60560; Wed, 08 Apr 2026 18:35:32 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 4/7] netfilter: ip6t_eui64: reject invalid MAC header for all packets
Date: Wed,  8 Apr 2026 18:35:09 +0200
Message-ID: <20260408163512.30537-5-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260408163512.30537-1-fw@strlen.de>
References: <20260408163512.30537-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhengchuan Liang <zcliangcn@gmail.com>

`eui64_mt6()` derives a modified EUI-64 from the Ethernet source address
and compares it with the low 64 bits of the IPv6 source address.

The existing guard only rejects an invalid MAC header when
`par->fragoff != 0`. For packets with `par->fragoff == 0`, `eui64_mt6()`
can still reach `eth_hdr(skb)` even when the MAC header is not valid.

Fix this by removing the `par->fragoff != 0` condition so that packets
with an invalid MAC header are rejected before accessing `eth_hdr(skb)`.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/ip6t_eui64.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index d704f7ed300c..da69a27e8332 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -22,8 +22,7 @@ eui64_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	unsigned char eui64[8];
 
 	if (!(skb_mac_header(skb) >= skb->head &&
-	      skb_mac_header(skb) + ETH_HLEN <= skb->data) &&
-	    par->fragoff != 0) {
+	      skb_mac_header(skb) + ETH_HLEN <= skb->data)) {
 		par->hotdrop = true;
 		return false;
 	}
-- 
2.52.0

