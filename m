Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE95B3FF1B4;
	Sun, 11 Oct 2026 22:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756007; cv=none; b=Z/TzMBQxE2gghTdjx4KF2LyD2UJ6VCPCGPwzQxmQgjG7SncrZCVIZhMFXXjs//2P4nZnFOui5qIcXZDUACFvg2YV42Tu4bb8RJtg6OBTXw4vgaC/w+KfqZjG7rF7V68qqsRO4IEX2GRkcFOblXijfrdi3QmK2lsxipUzFvlTpl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756007; c=relaxed/simple;
	bh=2cxi/1pa73Nw+z/VHUnd323zI/KGHNWX08rE/+o3ZZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YomtK0Uht4d7RCITccyVGpmPiqyiAxQKFrpMPk5Ahwp5OIbAdBLFHFZ/XHSPb27oSJW2qMOBBLn2K+ptEzNXGmqo1Db19af3XdyaYB3a4Lldc963iZH5E2PsxKa+HYxzCbSnmaOixZvO54zUUoYKZYHOpgVYciNZS/LEpeqPLPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iVflayhY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iVflayhY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756003;
	bh=a5wZbldjiQsigpvnfDshag8Il7isgyoL842vXZg20UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVflayhYbukJcELVtJBkfZ1GgC1Q7FIjB8Dv8BhsDC3ukSqVcvUV/a2qJ+vPamXzm
	 56Zk0Pywk44jObmliwsbVfKRrrYhxbBLmnJnxV9y/Lhk19onw897Ax8+gpsM8DNAo3
	 z9bzH2mpkGGHcRoV3QT7mfA1aZ5+Y3MrsHVZCtfaQSL6oip0nrwi6ZTW01jtQLr547
	 tLPXBG5J71wROMXuQrwlTj9R3XuM/PsyjUZ4TiWe3RbqWst0sc4xOnLUqFjQsfwgVJ
	 ydCR+c7i7nRJ7OVfm8l6jI3PlzQKleAIyUVm4wGDq2Xc3t1/GeI+cknDpiknitbCfX
	 1pdvyVIaGXUDA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 712D260078;
	Mon, 12 Oct 2026 00:00:03 +0200 (CEST)
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
Subject: [PATCH net-next 04/15] netfilter: flowtable: populate tunnel tuple regardless of inner protocol
Date: Sun, 11 Oct 2026 23:59:42 +0200
Message-ID: <20261011215953.1334630-5-pablo@netfilter.org>
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

Store the outer tunnel addresses and inner protocol in the flow tuple
unconditionally in nf_flow_tuple_encap(), instead of only when the
tunnel is IP-in-IP or IPv6-in-IPv6. Bail out early when the inner
protocol is neither IPPROTO_IPIP nor IPPROTO_IPV6.
This makes the tuple usable for cross-family tunnels such as
IPv4-over-IPv6 and SIT, where the inner protocol differs from the
outer address family.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.
Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
enabled yet.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index cd636b4cf74b..a53393f8eda0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -189,22 +189,22 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		break;
 	}
 
+	if (ctx->tun.inner_proto != IPPROTO_IPIP &&
+	    ctx->tun.inner_proto != IPPROTO_IPV6)
+		return;
+
 	switch (ctx->ether_type) {
 	case htons(ETH_P_IP):
 		iph = (struct iphdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.inner_proto == IPPROTO_IPIP) {
-			tuple->tun.dst_v4.s_addr = iph->daddr;
-			tuple->tun.src_v4.s_addr = iph->saddr;
-			tuple->tun.inner_proto = IPPROTO_IPIP;
-		}
+		tuple->tun.dst_v4.s_addr = iph->daddr;
+		tuple->tun.src_v4.s_addr = iph->saddr;
+		tuple->tun.inner_proto = ctx->tun.inner_proto;
 		break;
 	case htons(ETH_P_IPV6):
 		ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.inner_proto == IPPROTO_IPV6) {
-			tuple->tun.dst_v6 = ip6h->daddr;
-			tuple->tun.src_v6 = ip6h->saddr;
-			tuple->tun.inner_proto = IPPROTO_IPV6;
-		}
+		tuple->tun.dst_v6 = ip6h->daddr;
+		tuple->tun.src_v6 = ip6h->saddr;
+		tuple->tun.inner_proto = ctx->tun.inner_proto;
 		break;
 	default:
 		break;
-- 
2.47.3

