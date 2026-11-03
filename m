Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714613;
	b=A8dn6nPvWzvh0s8K/txHuXQvPLBLLkiHLvTRbTT29GPYDbEE9fUUA8oMO+K+8/1/K6oq
	 Aqp63fMFiKzIYMUayA4yrwnk/QT3EFw2Kbn7THedVngmox4MbibwBqrI4j+n/G/eaYJ86
	 JirV9WNSmN0fSceVYCmiNe8V5u5m746bfKvu8VpXa/5uloCrUh6/6WmlaQUNshwSnNZJn
	 3oQS79PhZss7DUMpbwLq+bsjZtGGOfWtzWxfyEeKWQWFkAZpVQe8W/MvwtXb+NMV4/bGQ
	 vg3g20ySxq1/DBdfjHjPj4LKjJipRNTxlS2jT1WH1/SoTcdc+e0RmEu30iMCAYRbRQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714613;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=bRwI7uwCHVVt6T7DMLyhA8VEKQ0FrttDo22yhPZt5LE=;
	b=kY2phQgBRjuQISunFI4Mpo31DrKLmrXOCmapJx21ELmY5lQGVzi8WvaQVFKCFsWhD+FI
	 cwxZiItwf8VMaY/9iHS7qkegJJpaXRbxNmQ6Me1thjeqeSQ7z+LtE9GSh4VwLjhw6Dwi7
	 BGxOlgUnwJr7Nr3YwVxT2s0uNKakf8C8V0JWLY9pM0cMjEUwDDdTcENZMvEz0iiU4/pR9
	 kjRwM6YjJbpIusLBDJbXcUra7L0jfVTBKKL1XpiqLPTQb++FsIHHHS1XPIHwZR2O80EA8
	 lpudmRG34O8FzZyv70vvfRpAYAw9MUtnbj33dumuNW9SNz4Mi9lIOPoADSk9rWuuOtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="t+IPB2/W";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2E0608508F;
	Tue,  3 Nov 2026 14:03:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A2E0608508F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=t+IPB2/W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714610;
	bh=bRwI7uwCHVVt6T7DMLyhA8VEKQ0FrttDo22yhPZt5LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+IPB2/WjsIjOKAhcCnC/eahsoFe5I4In69z6sWjqvlgHjLusRnYczDkIG2R5ouGD
	 J5kJwFrz/LKIG6TP+ZjJWnfQMz/5I+Xhnk9XEcSG4Phq9E7u6hJAwslIAbuSYyKesU
	 ht9la6SpZAnclaJaaJgnVbHB13u1rYdvni33mqqJvOtcMEBBoT+OOXtQnm+W55CvjM
	 PYNMvK1s8280c2thy7Usmdd+nlzXMSUYG3vN8Oe8PppyyFZeSYvimoZidL0jaYoJDT
	 eBDZ0YBm/7qeeQriIPY2zb3+SjNO3vFBQvIXP6jUcufLrLlriY5V7nX2wCVLUOgScv
	 iQMGl6KQuxLKA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 49ABF60092;
	Tue,  3 Nov 2026 15:03:30 +0100 (CET)
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
Subject: [PATCH net 10/15] netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()
Date: Tue,  3 Nov 2026 15:03:03 +0100
Message-ID: <20261103140308.591690-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
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

