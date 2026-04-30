Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAD93AB276
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 20:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777580757; cv=none; b=g16kfEDAaIGcOtQDFoa/OH7iMaxJDma8zO5k+wrpzzdbmNccIOKckQECrpK1f2laM6a8hUtiVucaLcXkZ6HRHcS7u/bgkq5hgXSQ7ZftqKnJIxhqwO++elx4KaPipw9qakFWh+depa/Mq5nJu3Rp6i8dY/m7l+5JbUamNuvWfbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777580757; c=relaxed/simple;
	bh=8h+cRN5Xtws4ryEYUVG7313Jg75pB84ccAaO7ItDQj0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgWsDa8TMPDbqA6o7w3yWSjKqWA9mCJ5bWoqdNtZ/DnTccrrjj8gDddKPfmwDSU7nyKhwofEK0Q/GFB4bCtVNPUR2ToEt/6CaC8YpuF2vztbhHo/pcBwCOm46hahy/MsUnYUbHg96I3pGgI5tB7fdra7ugVmIrLIev35humuaJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jIYzDXfK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jIYzDXfK"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9CFAA60251
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 22:25:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777580754;
	bh=f2ul8dcnRvRSpXba3ePxwEyY3DqG3eemg9bi82KzMLI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jIYzDXfKluJecFgQuDj7Ynwgxe3oUX56+tFf5d0tYzaDY0P02TfJ9r0f7dUxmkH/u
	 jB6KG6O+nFapqn1pNPoU8GReUurlSo0kAGRNmysFzSe+J46yEmImYZ8NliVMnaIvCq
	 gb9rImr6ketRvBaqcgC6qWf29zXxAzPnjfdPpJKXgUcsiui/PZjFrbNavBVxSIjbDE
	 GjTyJw8MmKwX9fceSiJIvmUrRgA7CAFUdu6As1JRd+txaP1BbxEwBJey6nuzOrsqnQ
	 0YV6kgWeoQBBKQgHkynRteVkNadaG04kGfqw91cDX4RtciNmGdFFbT0E/1lLPakhjz
	 EG3+MkcFaMTeA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 4/4] netfilter: flowtable: call skb_postpull_rcsum() after popping vlan header
Date: Thu, 30 Apr 2026 22:25:47 +0200
Message-ID: <20260430202547.274256-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430202547.274256-1-pablo@netfilter.org>
References: <20260430202547.274256-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adjust checksum, if required, after removing the inner vlan tag in
double-tagged vlan packets.

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: new in this series, add skb_postpull_rcsum() to vlan decapsulation path.

 net/netfilter/nf_flow_table_ip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 2eba64eb393a..238ed3d7d73a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -444,6 +444,7 @@ static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
 		}
 		switch (skb->protocol) {
 		case htons(ETH_P_8021Q):
+			skb_postpull_rcsum(skb, skb->data, VLAN_HLEN);
 			vlan_hdr = (struct vlan_hdr *)skb->data;
 			__skb_pull(skb, VLAN_HLEN);
 			vlan_set_encap_proto(skb, vlan_hdr);
-- 
2.47.3

