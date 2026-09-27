Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04B83CC7CC;
	Sun, 27 Sep 2026 22:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546914; cv=none; b=GOjNJKqVdaw22HLGTUsHFGaY7V9mnm2A1Htb8aGfMF1mut/aML80uj54EiJcnPtkVjm/dK0b2ojoijqSDu3HgduGWKCOYI6Qu5lISSs8ocF8rumw35siGz9dgxjgv6iEhI84yWAD0i+mYAHTNWz3u79TWpAWuTwB2PxV102mTqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546914; c=relaxed/simple;
	bh=zN7RLxFaCttqFAGKrUYfKwwQIwVIwt0kXKfRzQpZ+k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVTSIuefM/utukCSuO8Ze8fCqgV9hYw/M11r1KGnECL9u+YDLqQXWQBdDLSDMiWsqlcwvBp6mR9IUEBe6VDvW1geezqEhu24cWTCf1wXzTcsOyJ+scva46Y0Nt2LObDro6Rx4OJGXhQ75t1DHZthDFmkY9PghGKHf72XOkvxYik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B8GGcEvn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B8GGcEvn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546909;
	bh=VkTiek+vpM1loiv8Nf5FsxYcfCYWxcFUH4+MUiBgmTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8GGcEvnJtpMz93pqXafA0RLHWTX8fAeXIlG2B6eNb/YhW7tADPBW//SPnAJVkkrV
	 VN5a8ng96uyaXe9HV48M9RoH/Q2woqv86xWH7uwbr64uhMRIgP5R0gMYHqLvurkcXB
	 3FP9MK8b/7ple9BQGYGdRCgv+IQiRGv5Li5CIiverNGUSUDzRXqpcc6/Zj2EvIxvh6
	 Xzx32xYadysEXqYiBZOXI5zueJ8zLiQ5+9XwrTAnXkznT8mKMcRVUIFl66RdfYY31k
	 GbbKi6Ak+Zfso2FLNL7oylZj5wdr97tihI7EV3RZDwF0tDqMtTTM/WYoSTupOpqBLT
	 eZe3/nea4gSkQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 10635603E2;
	Mon, 28 Sep 2026 00:08:29 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 06/11] ipvs: do not create invisible templates
Date: Mon, 28 Sep 2026 00:08:11 +0200
Message-ID: <20260927220816.268206-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

The IP_VS_CONN_F_ONE_PACKET flag was implemented for normal
connections. When conn template inherits this flag from
dest->conn_flags it will not be hashed. As result, we will
create new template for every new normal connection.

Fix it to allow one template to be used by many normal
connections.

Fixes: 26ec037f9841 ("IPVS: one-packet scheduling")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260916231652.127456-1-pablo%40netfilter.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 6fa3e1dc534c..cb009208826f 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1102,6 +1102,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	if (cp->protocol != IPPROTO_UDP)
 		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	flags = cp->flags;
+	/* Only visible templates can control multiple connections */
+	if (flags & IP_VS_CONN_F_TEMPLATE)
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
 		/* Synced conns are hashed, so they can not get this flag */
-- 
2.47.3

