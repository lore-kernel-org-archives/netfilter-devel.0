Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782978;
	b=b4wrmoTqeYQbyGk8vN0rgotBXKgekSi4XYjo2IvwbSIbPZsuJL6VqvJ8Qht/azwRGXPJ
	 mLvmYuvEZtPGwE+YlmB4884fuufdyXmIUM5qMyCfycQxMDQUqwddRu8X7mJTJXGNKywog
	 LnDc5e7Tr5c5b5n/VuY6nIH5f50k6e7yGpYHtGRYp2Y19aeRn/hUGLlbQ1nMzhO7Y/8UU
	 BRovlpdo7n0THU9mw7eB3ByBxG5tVy/cB9XDGu/YWNc1j1S9O7W6IKSppRzoAwT7B2S3O
	 WLY5Wvkg1v/xP/j4hlkv5as2XsBKCbs3HlwztRQxG0z4ul0lQebn3WBvwM1uIrk6XaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782978;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=bRwI7uwCHVVt6T7DMLyhA8VEKQ0FrttDo22yhPZt5LE=;
	b=YPxKW93Oi8rouehgnibxmml+UrutGF2HKpEIWbBIc6Ex2FKOqcGjMnDbMXRkjYcLY60E
	 H0PZJZDp1Ju4lQs6WQDcpfT5rW5ZnCD/noQa5OFObgY+fI04W+Fj6xkbM4jb9psAGk5UB
	 R8cpngA2FPwHn1N039G15GA7vN3UN/EJBmQG/nBK86ZQig63ZkLTaSsktSSp7XL2RR9mO
	 DZxJylX3ZZB6eE6D6itGqTGY9lRjtLWKuKEbXgqWmt4qP41JrcgXloTC1y0s7qKzm4ZDa
	 uc8IjJgShEhmC3AYSvA8JopLgxIbH6AOXSiEmeo1Ccw8rJOksBwqhkORxGbgJ1z8PaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ERwVzww6;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4A6606D804;
	Wed,  4 Nov 2026 09:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E4A6606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ERwVzww6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793782963;
	bh=bRwI7uwCHVVt6T7DMLyhA8VEKQ0FrttDo22yhPZt5LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERwVzww6iR6P6s5bjkUKbLFdZTpr97P79pcliAuw899dDOSm8RH0pRnOCBsc4PjJs
	 uBttg2EpXalahmZjxPgNRisAMKcdBGV5zq3ml58DCs5+PAeVdk1bN2TeDtWRXU/7dJ
	 hkBjORxQq4XA6p1WFxttJvWCERyhFydwEh4+72SKRaSmJb8QOOsg7+vNUqtcqQBqRD
	 sycrCg9Dom6mru5gLVg2WPR2Urai/jF5DcUfn6iDy4QW74PWnSSYVRdzDZh3DZ3PnJ
	 lwzMfhfBKY8Ekxlx7paHWH+S7+e5AbveVGlQC6A4cA5mNAayV1mYltJ7MO0ubvb/zF
	 ALpZ5/pMsa0LQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 39C066007D;
	Wed,  4 Nov 2026 10:02:43 +0100 (CET)
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
Subject: [PATCH net 08/13] netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()
Date: Wed,  4 Nov 2026 10:02:19 +0100
Message-ID: <20261104090224.750548-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104090224.750548-1-pablo@netfilter.org>
References: <20261104090224.750548-1-pablo@netfilter.org>
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

