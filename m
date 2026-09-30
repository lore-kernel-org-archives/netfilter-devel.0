Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36269457E79;
	Wed, 30 Sep 2026 07:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754121; cv=none; b=oJeKRgpcNfrU1LHOL7p0AkgPDtC0aYuO3i6Vp0Ifs5FCOU6z7zP9OrIqTHbSA1lNChkdRC9HSLZQQUyMCJD0afUzJF8ipCr+lLA+He/Xp5bjMpzhvqxnVEiR1GEbncILCgytSvI39uKOac4mLELQV+jGF55qJN/g06F6oBcAHU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754121; c=relaxed/simple;
	bh=zN7RLxFaCttqFAGKrUYfKwwQIwVIwt0kXKfRzQpZ+k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCQYlmPsnV0GQGaJ7NUtkKlMnTDr4rQGYyrJ9vYIrNT7sFHOtDBa6edCPCquLIhxTFbrRikMaH1NUbiL0BoTzjQdksnBO8WoH0ft6uUAMxZ84ASPyjNgY+mhvohpsftzZINXz5Qv/WRf2JBKkuAW5wq4i4U8WoHdJ32rd5BLpys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T5Jmi0vt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T5Jmi0vt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790754113;
	bh=VkTiek+vpM1loiv8Nf5FsxYcfCYWxcFUH4+MUiBgmTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5Jmi0vtJzizH0g1yFlcQ9s/R3PQydr1aBkyIT6vCUgd7THymRR7G582++YAwSC/+
	 RUoiz2abYyfbgNDdwb1CPJx9L4D33h1IrI2pAd7S0xgxsApc5PjZddKVEFsN3jeaMn
	 82gsqqAct/H9EcBsyY4ca/uBQXMJ42oyeCs3NfGawXpY7kBt0ipSoAaJLq/b5OeBnP
	 nHuuvu4D5gYroZvi9FAKkj/v44SkE4Q+sXLQ2qTikS6R1OvGCuT4tnrO6NsYMvw/lQ
	 7ZWZ5JPg2ZDwV1RCel/U5B8ZvzdKMkYEsJXvaoIwe9TFR8e1w/ZNDt6Ulj5n0FpMSW
	 hkHXbJIm0kW5A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 34C9A6068D;
	Wed, 30 Sep 2026 09:41:53 +0200 (CEST)
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
Subject: [PATCH net 05/10] ipvs: do not create invisible templates
Date: Wed, 30 Sep 2026 09:41:36 +0200
Message-ID: <20260930074142.298353-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930074142.298353-1-pablo@netfilter.org>
References: <20260930074142.298353-1-pablo@netfilter.org>
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

