Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788224;
	b=2DpYnK7GufsTeeS020bq7A8OMR0i1sr044cyFS190I1l4KU2cDMsgI7i263kqVkvA8Qh
	 LTpuSeFevPGxhoWXlILwss+nLi/oq1+idEiuQxTgYPpfJVI5eA1XBA6uKzl6JM5mMWpw4
	 ilwUN6qxV3ZSdhbbqeDCKfPfyKYEbunhuz5s4nCice5R9FgPaPm80p/mjkEQSNx5egSkG
	 8LbKEI4agAhnT9HgW7KN/CRAfuz55hDFmVeNiKpAxLAFKx3Mx7GY4TVQarURyysk0ej5X
	 mSDuKus8qfS/gsCGQMsXG1e2GhHXzDlzpPC+fRuQdEXBvqBsXz9z56aMzxgEnK9ghpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788224;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=FTn/RvjjO0JCLwm4jGgHFzh7s3V+fumwtuQ0U//+dls=;
	b=kc7a1JSWZhU8dYy0N7NYeixrjl3vS2Hlz337txXmEdwG1uEwQy1Qdcs9XjgUxkGEpBku
	 n2x7KpmX3ja1GkroZsb/l43R7WwWia/rojxQZ/UWPZ6W9Cz4kaoNrVeyLOUZOye9lf+oH
	 RlEUxKhAc7A0OoTkb84W7O2/m2j7twkAlpSzprbX4UsHPN/9ZsrE61EcvJXXc0ZlbZG84
	 OMfRHGd/unQHRUjw+y6lWmycwGJssrfTEjgz0LgCAfMNVBXjS7HlKZttfgPbZtixGMoYk
	 adCn4J5o9x1CSX5S2powfVmaz2pfelZZ/DUzropb208iEZtEUurqi1/8tthLjMxHJ7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Jd7tU1rk;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B03606A33E;
	Mon, 16 Nov 2026 00:17:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4B03606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Jd7tU1rk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788222;
	bh=FTn/RvjjO0JCLwm4jGgHFzh7s3V+fumwtuQ0U//+dls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jd7tU1rktL/q5LTl8i1u7W8D72sXbzfyrwZMXWW6nm1dmZyclCNKGoboPwO7HhfUI
	 bEQnJBVl3qXFkx7lftPxCnWxleIyg4SAp1e1nWbVrO321DZR/PLKqGVCpnahPalptL
	 veLEUjvapeRCLqFXMG8nZacMPfT7I20VjO1hunXpzEeE2qfCQWC0Wn0bAW7VOcVmtU
	 v6VrTx4M20WoQ7zbqfL7Aa8Ru60DdDm8K3yuVkpugWV/Ac7II0eH4SHkSFC8mKnRUq
	 Fzxg/xocJwqLpMwio4RpSqlw7wUWtTc9hWNwOJEI69OOk4kAbUfO/b5PGoSgeLjmXG
	 f86xFI5Lna4Zw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B35746008B;
	Mon, 16 Nov 2026 01:17:01 +0100 (CET)
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
Subject: [PATCH net-next 11/13] netfilter: flowtable: do not clear the offload bit twice
Date: Mon, 16 Nov 2026 01:16:10 +0100
Message-ID: <20261116001612.2806263-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116001612.2806263-1-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: João Silva <jgc3silva@gmail.com>

An expired hardware flow remains in the flowtable until its asynchronous
hardware deletion completes. Teardown clears IPS_OFFLOAD_BIT, so a packet
can create a replacement flow referencing the same conntrack entry while
the old flow is still waiting for deletion.

The next GC pass calls flow_offload_teardown() on the expired old flow
again, clearing the replacement's offload bit. More packets can then
create additional flows for the same conntrack entry. A pending hardware
work item can also delay deletion and expose the same repeated teardown.

Commit d2d31ea8cd80 ("netfilter: conntrack: fix erronous removal of
offload bit") closed this window for software flows by unlinking them in
the same GC pass and made the conntrack state fixup one-shot, but
hardware flows stay linked until NF_FLOW_HW_DEAD is set.

Make clearing IPS_OFFLOAD_BIT part of the existing one-time teardown
transition, alongside the conntrack state fixup. Subsequent teardown calls
must not alter the offload state now owned by a replacement flow.

Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
Signed-off-by: João Silva <jgc3silva@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 733107180d56..d5652e45ee04 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -398,9 +398,11 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
+	if (test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		return;
+
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
-		flow_offload_fixup_ct(flow);
+	flow_offload_fixup_ct(flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
-- 
2.47.3

