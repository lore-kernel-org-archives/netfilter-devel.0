Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA6A1E22FA
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2025 12:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738932951; cv=none; b=ART2TvuC5QbJ+N0uGIEvb+W7AtaJQ/t6djOcHxzeDix9ARG5KXxrT/QWn3cQeobhuNC9Qcy21TTk8MgXFU25+Zh+OT32ZDp+Qls1wuBNh6SG5yVz7WRfIVlvDrP1BoPGrsyLi9GTrDl7a1OBotdaLQ1oWt5DcqsXq2Pmi3OSgDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738932951; c=relaxed/simple;
	bh=CQPHj+0IEOj3lYBKQdewwFcDSB7JbQ0/Ik3XcZ5+R6k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dY6lWBbZd7Im4+JB1dSrJG/gJFhpuF9Sl89iB/00u7EWfw68/qMjEQHAmR1HdIftuS8p6Z2jmdRJ3J4yPhh3mmxNwCcEdr+Jtgnn0re0oFTPLEhxbuoYn4JT21M4qDM+zZW9VN3Vqttepb4QI7mDo2xkQi67tzTyhASsYHpTllI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mCwOgaYj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mCwOgaYj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mCwOgaYj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mCwOgaYj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E38A66034C; Fri,  7 Feb 2025 13:55:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738932946;
	bh=/GeTjANWN/W8fmJpZMGbRTW3/QFHZw/4oyRkAZtVwj8=;
	h=From:To:Cc:Subject:Date:From;
	b=mCwOgaYjcgSSE1iPaVtOemswBU+hbAqxUc4ZVIQ375RiG8NeR9GJowUS/P4I+Ufjz
	 GK6IJi8X02BfX8ZH6FdZfPyz0KzsGfvyK963K5jiGT7PhhAw6SRMX46Iy50Ki7Y0lX
	 oS+Rr7QA/uLmb8IcDEF8/7OvyP8ymfWjKhtOcHosk3WVljSVoiT96WfRyopgm/Ht2E
	 X+IFGOByBugXQP6rk3IgE4+ygVNyqh6FetEJuUa8Xlh5xGYHQRJRlFijnimai7R4YI
	 nLZC6SkNtrVg7rQpgmLOEHQCz25342DGk+wt3660nu33K0CVAhMb4eG4E0dvQndiox
	 BFe/A0S5sPDWA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3C0D7602C1;
	Fri,  7 Feb 2025 13:55:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738932946;
	bh=/GeTjANWN/W8fmJpZMGbRTW3/QFHZw/4oyRkAZtVwj8=;
	h=From:To:Cc:Subject:Date:From;
	b=mCwOgaYjcgSSE1iPaVtOemswBU+hbAqxUc4ZVIQ375RiG8NeR9GJowUS/P4I+Ufjz
	 GK6IJi8X02BfX8ZH6FdZfPyz0KzsGfvyK963K5jiGT7PhhAw6SRMX46Iy50Ki7Y0lX
	 oS+Rr7QA/uLmb8IcDEF8/7OvyP8ymfWjKhtOcHosk3WVljSVoiT96WfRyopgm/Ht2E
	 X+IFGOByBugXQP6rk3IgE4+ygVNyqh6FetEJuUa8Xlh5xGYHQRJRlFijnimai7R4YI
	 nLZC6SkNtrVg7rQpgmLOEHQCz25342DGk+wt3660nu33K0CVAhMb4eG4E0dvQndiox
	 BFe/A0S5sPDWA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: kuba@kernel.org
Subject: [PATCH nf] Revert "netfilter: flowtable: teardown flow if cached mtu is stale"
Date: Fri,  7 Feb 2025 13:55:34 +0100
Message-Id: <20250207125535.2086715-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit b8baac3b9c5cc4b261454ff87d75ae8306016ffd.

IPv4 packets with no DF flags set on result in frequent flow entry
teardown cycles, this is visible in the network topology that is used in
the nft_flowtable.sh test.

nft_flowtable.sh test ocassionally fails reporting that the dscp_fwd
test sees no packets going through the flowtable path.

Fixes: b8baac3b9c5c ("netfilter: flowtable: teardown flow if cached mtu is stale")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 97c6eb8847a0..8cd4cf7ae211 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -381,10 +381,8 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu))) {
-		flow_offload_teardown(flow);
+	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
-	}
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = (iph->ihl * 4) + ctx->offset;
@@ -662,10 +660,8 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu))) {
-		flow_offload_teardown(flow);
+	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
-	}
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = sizeof(*ip6h) + ctx->offset;
-- 
2.30.2

