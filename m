Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422189;
	b=3uwyKDqA2eY7IZ+RD8ylzrAMnOPFKzDal+zmlotMVtVa7PapvJ5L6TV8HXlWUg9DVoiO
	 J8JeBLHgccxpnI7d381A1rA8gUEeOueYMyN6NL253qPJ5m6QNOpepRzeL/ECK3sR2zjQ1
	 xE9uzvOupR3HwLqYMkIGewRyC5mA5lJ3Ko3Xn80DSgfxGKAffeY3TRagjum4VsveVSBVv
	 j+gxLzpFYhcB9OdqHJzGhJVFHkA/oRv1Ol88rAqvSTSIN7Mv5PcBW87CP4OlMKnqJQMAf
	 AopjrXYaPEGoTW1UxDQLFScU95IjB4pp4C9IaMLOa/FWM5eaKHvYqywQDnUwRcsuQaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422189;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=CYNpmVXRLHMAAVus7/gfQUc1TWW6VTf4/aSf8Tlez+s=;
	b=lbARv1J98BU+iKoNBXmtIh5KCiPO6D2gi6YTFW4km6pop2vdmGZP95kABbuy2gMdeDV6
	 5aNUmQa4MkVFRKjTYDl9iszbRxpmA/g/28gyCmqyDHuaTxdn6N3g+iIiaSeJ+TOX+gYC1
	 dvt66LLXJ/pSFZ7xZui2IrkbnH74irt2Z0Yyp/rQk1uhdly5WujntYYqh1nzzPC0dAeqR
	 kEvboHUolvs4uZiay7WAGhzSF466yhI/Er74YNN3Lq1i9SHGI3TxM82j1tyhpjTxzhNUM
	 Dgj6AAYklbUB4sbSE0Kx0Pvcljz2Nv/mAUSSJgvumFeNfDwnyB0002qCpJpV6An+rUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Y803IFXS;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5568B607D354;
	Mon, 19 Oct 2026 15:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5568B607D354
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Y803IFXS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422185;
	bh=CYNpmVXRLHMAAVus7/gfQUc1TWW6VTf4/aSf8Tlez+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y803IFXSYCm8RB3z09rcHdIHVTMeVP3SMwuGKtPSBGfBzloQfV45ZvyKESBo9zYwO
	 kmZSjJBww3RCyhObeCJn3TgvCZC2JyBPIduosSZvPPa2kAiCHm+nJlVj6+N/XOg5xi
	 xqKgmqkdFoZGMzjN++3w6PfOLxXe7fYHEwvG2sfwzKDSB/zGZ7Z25HnVuni6vn9kZ8
	 TzdyraFDfQF/KtjZCbwGPFzAFZdTf9dNoLqFEkIauoI55bDn1DAXCTiJJB2LaupJWO
	 IBh0rkqAUKGG4e8UwVYzUp28rPGCKH3Od5ZjxBvig1Xu/MtZ0fUBwTx2dtdD6V6FPT
	 HVZ8HI/neLeMQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 80FF760074;
	Mon, 19 Oct 2026 17:03:04 +0200 (CEST)
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
Subject: [PATCH net 05/10] netfilter: flowtable: use the vlan id, not the full tci, in the tuple key
Date: Mon, 19 Oct 2026 17:02:44 +0200
Message-ID: <20261019150249.1879516-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019150249.1879516-1-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shuangfeng He <huangya90@gmail.com>

nf_flow_tuple_encap() stores the skb vlan tag in the encap tuple id
using skb_vlan_tag_get(), which returns the unmasked TCI including
the 3 PCP priority bits. The flowtable entry, however, is programmed
by nf_dev_path_info() with vlan_dev_vlan_id(), a plain 12-bit VID.

When a NIC delivers RX vlan offload skbs with a non-zero priority
(an RTL9617C EPON ONU was observed handing over vid 818 skbs with
tci 0x6332, PCP 3), the runtime lookup key never matches the
programmed entry, so every packet misses the flow table and
software flow offload is silently defeated.

Mask both parse sites to the 12-bit VID so the lookup key matches
for any priority. The in-header variant has the same problem for
frames received with PCP != 0 on a non-offload path.

The egress side is unaffected: nf_flow_encap_push() restores tags
from the programmed tuple id, which never carried priority bits.

Measured on an RTL9617C ONU (PPPoE over VLAN 818 WAN, NATed 6-flow
download over a 1G EPON line), before -> after:

  download throughput      377 Mbps -> 936 Mbps
  CPU0 %soft at that rate    91.5%  ->  70.9%

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Shuangfeng He <huangya90@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..2dec15d402ca 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -170,14 +170,14 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 	int i = 0;
 
 	if (skb_vlan_tag_present(skb)) {
-		tuple->encap[i].id = skb_vlan_tag_get(skb);
+		tuple->encap[i].id = skb_vlan_tag_get_id(skb);
 		tuple->encap[i].proto = skb->vlan_proto;
 		i++;
 	}
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
-		tuple->encap[i].id = ntohs(veth->h_vlan_TCI);
+		tuple->encap[i].id = ntohs(veth->h_vlan_TCI) & VLAN_VID_MASK;
 		tuple->encap[i].proto = skb->protocol;
 		offset += VLAN_HLEN;
 		break;
-- 
2.47.3

