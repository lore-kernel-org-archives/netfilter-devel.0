Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539595;
	b=YscQdpXyLdRvUgy+haFkRx0TcYMh4QoGkgLPjhgx3Ld9Un2tQR8gFjKQeaKtMP9ZAUmx
	 Div5DDf66zHHfT6sx+F2EQTl/p385v1SxkGDTSH7KFoSzErPeseI7OBLSy8v3C5cxIyBf
	 Gqv3bJN1biHDaAxS0o6SSwO7X8awn6VRznsPoeWIjXn2fQXNaPZV2NHssVmesXLwDe8HA
	 9apCouK26WvJTM97QcGwnkTy4gJic/p6mRWMRmEyX7/mgyHTCZe2HPfuoVzerTjqxeDds
	 SP1xUPxOe5DnI+EDW04NOL0ne3cQm12vIzzszPIeclXkUZlDC9ZOVfnwUVIMBTrEdvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539595;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=FTn/RvjjO0JCLwm4jGgHFzh7s3V+fumwtuQ0U//+dls=;
	b=GT5MzlMrZLRH7TWkbY0rVZuNJEuwrD4rtSL2dSo20xqHtqo9dBrBfNEvua1n1nJRE/0I
	 TUZMLhqAct4c0iw9bhMvyOYfr2/IbQk7LnHDDRcB1VAra/l0ILJ3QjvRdFzEz6GVmgsKc
	 PzzBlQ29fOF/7u5rU+NS2iQQew41ZQTiFwKS3sXyUiH7M/WhP0OJPJWnVEsu3upj7iZy9
	 mr6bhcorHP2XQNnUr8XQkWiHGExXzZEI2SH5etvM9DBif/IAZm5pOhdx7FViPFiMtJY4y
	 LLoQbSulcpvQHhatuK1WczvnJpgdDEVt40AzQ/+nJF6gnOsxudu8xDe1LGB36WJbOzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=A9Qyw1ka;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BC660A3807;
	Fri, 13 Nov 2026 03:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72BC660A3807
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=A9Qyw1ka
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539593;
	bh=FTn/RvjjO0JCLwm4jGgHFzh7s3V+fumwtuQ0U//+dls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9Qyw1kalENZCvSscZVsrBiQuh+1VUj9U37bLxs6aElKRM0t4HWEq56eF+shaQCmy
	 emMyYnbcSs+Y/Baz4W3hMwovEd+GdLZjS0Z1rmZ+HnX4sWgNb6VtHhby7deo/ok0bm
	 TTzPAcqDSXAnM/e78Z27CsvWwJBQ6Hw7zNDrqykqF6e+Z6+BGGr9dPdHSLZfKftchR
	 XivKiM10VPSCEAuOOVPE8fr4oPqw6Z9hL9VHZag5QtCsJGnt9RZ8nsb0xHCiWGPA17
	 ybP5FjuQtHOHgYtc9hzarRBXEnYRJIZ9ngdzbgU/Chh+PEmmXqHkK1gWBNdynuXJKO
	 usxke/kiyM+UQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3D241602A5;
	Fri, 13 Nov 2026 04:13:13 +0100 (CET)
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
Subject: [PATCH net-next 13/15] netfilter: flowtable: do not clear the offload bit twice
Date: Fri, 13 Nov 2026 04:12:49 +0100
Message-ID: <20261113031251.2437074-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
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

