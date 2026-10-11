Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF709400E0D;
	Sun, 11 Oct 2026 22:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756006; cv=none; b=RroLBXuUATNx92bNy7z7c/AfR4Ii3dtVZsi+uQvbY6MTrOHQUsh7iVgXXotQRg5cu5+PWVT7iXrj79oZ9Y70bOSw/DACm0ZLu6Gd4zFC2rRyWiGK9P4z5k8vAdwjMAmpD66+Dpn+vABJjRmnBStZpSlCXaaCpgLLPdU5WrrcH84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756006; c=relaxed/simple;
	bh=D4kY5eN+JSUlEpmktjN5qRW4/mdeNQpfeNOt3AEXBpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzu33inRU/GZ5FkJGvZIQHmeEllA84EYJ/4rl40FoOIcoearG2waYUEwIhmvzsotMZmckF4KGyxPzLnSM/z/gYnpUQwHXuh1iQ7BQaNpA97k7qBnd/tX8J5pThE9EI7x2TOtz696C2kOoPnngjK8AmRdVmNK1siHQaU/5Lf5jMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=r2eGvkUJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="r2eGvkUJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756002;
	bh=pzfbO2Is66UdsNiXNkdbv7c+oSTYP441Oq8ICKwHUAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2eGvkUJSFDGsa7vZw75k+Z2piBT1Z2mWiVDDmLf2NSRSsXTCfrzTPznrHU9A2ztv
	 nn6BVWjX/OtwQjBCAwtZqWe5w1rTgaz5t8aMrr0zq1vxeAz+ENsG4bRfKMYb2bnBZg
	 AUnp1I+iddKC5zwC8sd6vgzyl00MFrb7P/IOINsLQ6N/kpMtQvQixnTPW8B05HCBDz
	 CINEA8Yg7A9YllrbQwqHzPWyWg0MfU7+t1ESHbnnLnaBOuri+pDQ6Q83Lf8H4NdXAI
	 upzeJLIF25HqX7GSvPjW4wuVM6LyuvB+hHdcrhGQ3gBrfvQGLjiTP+ZCsMCyVu6Mxs
	 zm9lojA5XM27A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1382960077;
	Mon, 12 Oct 2026 00:00:02 +0200 (CEST)
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
Subject: [PATCH net-next 03/15] netfilter: flowtable: set inner protocol when popping tunnel header
Date: Sun, 11 Oct 2026 23:59:41 +0200
Message-ID: <20261011215953.1334630-4-pablo@netfilter.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Pop the outer tunnel header and set skb->protocol to the inner protocol
derived from ctx->tun.inner_proto in nf_flow_ip_tunnel_pop(), instead of
bailing out unless the tunnel carries IP-in-IP or IPv6-in-IPv6.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 42e8de696474..cd636b4cf74b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -372,6 +372,11 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 
 	skb_pull(skb, ctx->tun.hdr_size);
 	skb_reset_network_header(skb);
+
+	if (ctx->tun.inner_proto == IPPROTO_IPIP)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
 }
 
 static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
-- 
2.47.3

