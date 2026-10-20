Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792502991;
	b=Q4kf7re5wHm8oWCcxmvpq3jnmcX01H0ihH2kKCQMd1kKvJsfIozwuQtqU9HkChnon/7d
	 yYrw29xpOUpzk2tgdKar+05X3Pv2GixAPychK4ZuYuzm6HhDwnx7KFrQwR5j3SS2I1DHi
	 CtTCZOtQfYdjv3IGqUvWx0Bfesr5ThoeZeFM8U3C1fbZkrqPo9RSBG3Lt8HGAkZDvLaIc
	 QwAdeJoch2zYrQoSWc6RK5Fifo7ciCYIMyvjENaPtqOeRww/BvDjAeXYL4Azp2Hitko6J
	 8geDtRMdXQdCShEMCOFk68/TCXDgF8mXl4Ca8qLzIVm493hxhA2iYJJrbVdjMYxKLiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502991;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-ZohoMailClient;
	bh=faqcXlf3am5ayTseexfa5cqCZPxHait6Gq7hGss05/o=;
	b=u1YDx3wi/TJAybhpA4ffwn2g5W8vdF3Lf6xVkGj5aWvXQoVok8tHDNxTjKKJLVSshpay
	 xqwP2ljgEOCjc1aJ7KyM9s495U7XhpiZuTAwWf/YfwVMeJLlyoygNA6YNI4CB56kYLP08
	 a4lnF26zIdAU6w6oa73wZXgBbGRhcbKd8WtkL43alKo6ymnrjmmaFiXxGNimKhQEMNxDO
	 wk0X3o4CvME9REbCfkNQS0BnETvm3CDOtoUUIyJUXvlXkazgbyHBFyZUaixChpsa1eIGi
	 njyk0Zy0dtujjO1Y7DySML61BT9zJiU3sXvlKqlFNmCIPi/79wdAAPYees/CNXv9UBw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=laveeshb@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b="R2ntOH/z";
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
Received: from sender5-op-o15.zoho.com (sender5-op-o15.zoho.com [165.173.182.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8546760A2626;
	Tue, 20 Oct 2026 13:29:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8546760A2626
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=laveeshbansal.com header.i=laveeshb@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=R2ntOH/z
ARC-Seal: i=1; a=rsa-sha256; t=1792502973; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=EuD8bntbTMkMeHimUzqDTvJkp5gf2DKwzcTvVhBYZRbLdSFKytmJR1eJAFbIhoWbf1Tf7+gAjOjBPp/L2+eOihyXKpqlMe4JmcDn6lWy2Ajj9DQLaApTgrVzO7Nod2YCobHoqu2HRm54UbAxE9L+qHReVfOE3+2Jfx6UaqEleP0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792502973; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=faqcXlf3am5ayTseexfa5cqCZPxHait6Gq7hGss05/o=; 
	b=E8c7QAJxpNL6PofIIb4S7ospQ8SfgCZ7q/Jahia6lK97gqRLA6q7/tfY3GrnzRI6XIVs5YdwWSnrLMNALcNJcKdA0Lkvf5tU6WJAE9e0PpAqAWUpw7fUSrfyUu1CoaPhhCA3GQUni0mBVxwsLN2d/Z7FxZTvxwnGSimQZuMXKKY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792502973;
	s=zoho; d=laveeshbansal.com; i=laveeshb@laveeshbansal.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=faqcXlf3am5ayTseexfa5cqCZPxHait6Gq7hGss05/o=;
	b=R2ntOH/z5zrP4NH6DRLJy731eTb0c/6yaJH66gxC0lYeKUy7fmHPgdS3xOV28yaI
	DNunMDYmzgh3Iirhx6vnJa9w2Lkt7SYTd0Qn3DlJUaC7WJLpdCTTcEns3oMnI7wIYO4
	UsUo1etcDjWFji08Hl2zhl8IUd4hzRIqexcSE+fI=
Received: by smtp.zohomail.com with SMTPS id 1792502972236450.06009507923477;
	Tue, 20 Oct 2026 06:29:32 -0700 (PDT)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH nf v2] netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()
Date: Tue, 20 Oct 2026 06:29:11 -0700
Message-ID: <20261020132911.43696-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
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
X-ZohoMailClient: External

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
---
v2:
- Reduced to DEBUG_NET_WARN_ON_ONCE(), as suggested by Pablo. Handling the
  vlan tag and the selftest will follow for nf-next.
- Dropped Reported-by, Closes and Cc: stable. This does not fix the syzbot
  report, its config has CONFIG_DEBUG_NET=y.
- Only the commit that added the warning is listed in Fixes:.

v1: https://lore.kernel.org/r/20261020005403.38212-1-laveeshb@laveeshbansal.com

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
2.43.0

