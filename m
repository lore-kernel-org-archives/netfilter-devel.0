Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882751;
	b=dz0ejqY+OOVvX/uBuLDs7GDZMFvWLo16fIIJe/zv8eYoWDjc191WisVQJdcngml7X7Mi
	 R+lxRuWl0ghW/rdGNUVLYsuXK82IXeayDUa2V1uqwr7Z6oH9EthULGGN6pRL5yNnBvMnj
	 iUiZbDDDvOZFC/H+ZMCgaC2AIOD7FWrrarqiyJoPreLKbRdBK8WFsluQqIZvdCynNRnWX
	 JmRy0OL5IvKOSr7/oKfcox4YyM4mfTL8/3pU52ox89WgWy2SCpgg9qu0GTlKrAaiTYH/c
	 yqF2fbEoonFKUmkrM139BQLVDnVqZQWHR+T0+5CnjIi3P0FRWzcDQk/2tuiwYU9dx5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882751;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=bRwI7uwCHVVt6T7DMLyhA8VEKQ0FrttDo22yhPZt5LE=;
	b=wv6cpaC9k+V9VZCNWwLa0+X1q9XgWrMOLfEXC9FhvAojzbVldq529NC0OUUzD1FHxbv5
	 d/oOWnJ7ImEelnVwJWXczwtJLCsdm30WolbnGrhqCJTKmvA73BQ0GuW+yK6UsDnNU96tO
	 2W8TL8olFv71xFU0TmqGt+4OGa6Rfd/RGmVJsrgt/rxT+s5OJjWTuuUKGmD2TV3UABhvd
	 xgbxFz+qf1egsaml6REaRJEpN03TMB8FA+euI69tfId9rx7MtBYoI0nxp1zrIg7YiHB/8
	 xxFAg8y5J4ilswnEM8TruZOhiAUe/V0/S3mnhJYVpea339e1HjvwT+ipyDC0KyXNsfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=B9G31my3;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AE5606D835;
	Thu,  5 Nov 2026 12:45:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18AE5606D835
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=B9G31my3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793882749;
	bh=bRwI7uwCHVVt6T7DMLyhA8VEKQ0FrttDo22yhPZt5LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9G31my3uxJYAv4FSiDRTuNohUuHu7s+anXoDouGBTesTCaggrnQ4Tz6FDVAhRNVD
	 1TDEUtmtMCRt/H+oSCdQ33nTSNUuQTFy2Ta9XvqOkLDiq/pbsVYtN6S0MAL1xWfInX
	 NN3B8l+JarZm/JAqH62LqI5bg42uXHAEBA+7GOUHLUpk/4SSTCsBqYA9JF0c/TfNuo
	 4gwHGdquOu3J8ev2e4zWhekOcPOHjQR68nBKa+Iv7iDtT77XV/i+fxAQ54twxcUc4+
	 Pd6cMNhvbFPhUPCkURD+xvlcG/j4Ur3DpgeZcuyRKOLAFMOn9vz47WtMW4gwGMtIrI
	 Ov1DhJ5EmkNag==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E1C0B60097;
	Thu,  5 Nov 2026 13:45:48 +0100 (CET)
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
Subject: [PATCH net 07/12] netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()
Date: Thu,  5 Nov 2026 13:45:31 +0100
Message-ID: <20261105124536.1009301-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105124536.1009301-1-pablo@netfilter.org>
References: <20261105124536.1009301-1-pablo@netfilter.org>
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

From: Laveesh Bansal <laveeshb@laveeshbansal.com>

nf_ct_bridge_refrag() warns when skb->protocol is neither IPv4 nor IPv6.
A vlan filtering bridge can get there with a vlan ethertype: if the
protocol of the tag of a frame differs from the vlan_protocol of the
bridge, br_allowed_ingress() moves the tag back into the packet after
NF_BR_PRE_ROUTING, where bridge conntrack has already defragmented it.

Anyone who can send fragments into a port of such a bridge can trigger the
warning, which takes the machine down with panic_on_warn. The packet is
dropped either way, so only warn on kernels built with CONFIG_DEBUG_NET.

This only avoids the warning. Such fragmented packets are still dropped.
syzbot reported the warning. It keeps triggering on CONFIG_DEBUG_NET
kernels until the vlan tag is handled, which is left for a follow-up:

  https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Assisted-by: LLM
Signed-off-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index b5444335b86f..8c83dc05114b 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -358,7 +358,7 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 		nf_br_ip6_fragment(state->net, state->sk, skb, &data, output);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return NF_DROP;
 	}
 
-- 
2.47.3

