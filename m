Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581042;
	b=FDAnpqYxssdMZL9C196j0sWinz6yFTlAmjQKLczfkBzpeOPFaTYz3JOK63EOQXL+7PwE
	 Myqz4XKVpy95tDbNlfDbUHMBPZ9HAbTZXFfFRiHXVPN+fneBaeixBHyTaveZqUFLy/p7f
	 aV3q9wCDe3OEsoAMQVvDW4/89Ma6jnvmAZJVL8JAYC4/ZzSanCHIFggT6lQRTdjzx45CR
	 Iys6RczVKskqN/S8NYPlBQfL/5GIdGnbPo8z6bEtWAXeyvTQthXiDsaIl6NzRU2bQ6DoK
	 odNx1IsgW22HMWguKhK28NSylmWjELk1J+MX+qSykrSoa8Ci8a3ksRk74StMmHvNTKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581042;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=bRwI7uwCHVVt6T7DMLyhA8VEKQ0FrttDo22yhPZt5LE=;
	b=hi3SphseF3t/AuCtpHYfLMT9xAG6LGc9rcU+IxjDJoR4ncX1sGZI1ndV4X8vHKF6neH3
	 6Up5CV3X0y1SS7iU6hgNpmD19PGt4TFcw2OK5HydLZIsku33BH2HfRTDckEPrxDj6GGvN
	 UY7LyieJ7USOtOxX+1XYQ3ETbqCSl9GwNekUOEGZ3aX03UM3nCvmGjR7nb9JZdZHCeM8k
	 tc6ZjIzNuXMW4YjYlpAnAy1C/qdM9/O82Ew11geFkGKei2Cq8VvxqoiQLavUsKmLE+7CQ
	 ltLoWynfoSnbz+S8gz6Z4q5kl0dt4AuzFjaNaRhJWrBxFyzuEwLWl1V1jSdm5Q/LNtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fNN+63Kz;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAC3606A327;
	Mon,  2 Nov 2026 00:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DAC3606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fNN+63Kz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793581040;
	bh=bRwI7uwCHVVt6T7DMLyhA8VEKQ0FrttDo22yhPZt5LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNN+63KzBne/vokxP5STTF6EJYSdq7x0+knbJEo9nLK0cGrW8Rjg46BlibJ/pulWK
	 lOA1vM4uBBZOWLgRZp+OVSXCoKJiKfSAOSDPUKszkPCsOqCf9VrqwWwqWb3xmMg+u8
	 iF5V04noZGH2ORnVt6RP6jJLV+DfJ/acdPGtjfYED/M0Y5CMnDKY5Al/wwXdZCcjYM
	 AfZU6KVzMlbeoroAWRS1lS22Wz7JsJBJEak4q5jPrshBz/bXBXHTrSiq2LR1BMnn9r
	 uIkBaZSDfhtJVUycraUqqAO2dcyGVFmpjvp7cksegkoKQRP2cJICszZK2oQbHr4eeY
	 T9y0LLMBliYrQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 77B8A6007A;
	Mon,  2 Nov 2026 01:57:19 +0100 (CET)
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
Date: Mon,  2 Nov 2026 01:56:49 +0100
Message-ID: <20261102005654.532438-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102005654.532438-1-pablo@netfilter.org>
References: <20261102005654.532438-1-pablo@netfilter.org>
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

