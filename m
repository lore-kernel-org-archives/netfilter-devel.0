Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553D03C5539
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 23:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777591568; cv=none; b=qT6DahoiT7lQq4XRdDxdmJX84JGuLMbvDeyHrfxAOSq2JYLE+fd35mvbgvF364898+4wpySYNSrLc6mJSoHnUIChImCWIEWgmfZA8h5cye5HE9xGg7b9dMAkufX/RMcindThxxyl6zPFUKAn9Wtx9sHc4/zMPlPsmdDUVyaQ9Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777591568; c=relaxed/simple;
	bh=op26drVnlAZANF828pU9seVggArE7EBbP8XO6TCU+iE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhhq1FI4z6Qjn/4FX7jll9A82OajVxq1qYWJPqqkMj2Lr/W8p7niX+y317Mi2iJWk/i6OBCPuKcDVxZOww1xIEfcX+8chvtxVu/wNqJ3ojk4mxUYemjAiXSERVodM9NstowXBUEErESMHZYgOhgjJPNg7TQl5u3mK7YZLe1xFkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UAStU+Sy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UAStU+Sy"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9C62860180
	for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2026 01:26:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777591565;
	bh=3czWPMD5Wed6tWpQ1YLxsLZ9gbgPx/elV31P8aAVpNc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UAStU+SyjsU58SxA27a2O95CgmqaGtNVe2EsRj+u8rjsmbBwIOBTztTF08mnRTnZc
	 a4YZ5PY7qSn/m9mdKifdwGDa/B2y2BWOCE+QB35JIAQS9b2wqONBs4c5EcKn6Ip/Jy
	 4hQv+PRGJ5c+XjB0TnSld9KxjcdU8bdW29WcqBL8yKr3Gd4Ss6GLJio6qeDX/fdhYh
	 fuZ/HGqIe5yuBHl8WLEarDCoZMrehsESTca+kYQ2GZVWuaxs8Uthzd/qWd0VdKXpyR
	 JtdI9hmUuC32cOyKENxsllsCkc7+6IgpMqX+U5EkMLd5461P7VwaDg693hrr2POELE
	 DYw8hDOh+hfXQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 4/4] netfilter: flowtable: use skb_pull_rcsum() pop vlan/pppoe header
Date: Fri,  1 May 2026 01:25:58 +0200
Message-ID: <20260430232559.285492-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430232559.285492-1-pablo@netfilter.org>
References: <20260430232559.285492-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adjusts the checksum, if required, after pulling the layer 2
header, either the pppoe header or the inner vlan header in the
double-tagged vlan packets.

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v7: replace previous patch 4/4, use skb_pull_rcsum() for both vlan/pppoe

 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 2eba64eb393a..9c05a50d6013 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -445,13 +445,13 @@ static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
 		switch (skb->protocol) {
 		case htons(ETH_P_8021Q):
 			vlan_hdr = (struct vlan_hdr *)skb->data;
-			__skb_pull(skb, VLAN_HLEN);
+			skb_pull_rcsum(skb, VLAN_HLEN);
 			vlan_set_encap_proto(skb, vlan_hdr);
 			skb_reset_network_header(skb);
 			break;
 		case htons(ETH_P_PPP_SES):
 			skb->protocol = __nf_flow_pppoe_proto(skb);
-			skb_pull(skb, PPPOE_SES_HLEN);
+			skb_pull_rcsum(skb, PPPOE_SES_HLEN);
 			skb_reset_network_header(skb);
 			break;
 		}
-- 
2.47.3

