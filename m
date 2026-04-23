Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55040238C0A
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 07:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776928924; cv=none; b=aGZV1922QqsV+7AMwaXFW6BNOeaoyEgRtz+xKxKFZxrYxJA/GOgQPKlLJ89ILHD+KlXPcB7p9nvAb18GZ2C+eLI0qju/uCV6AWVOzHAGD4fxlcjWhTGNuZmtUodsmIMCGxgHDBNEdozKx8+MvUC7l4nomcyks7U8/3tpEP9Dedk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776928924; c=relaxed/simple;
	bh=SI0QM7qbmXQa/aVjec3B77pZnifRywfTEoDJBZ/KUTw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJ9BTC1KwDT3kHadwdbqAAgbBuyZGGTzZu2z5OX5ACVR8khAReVj+KXtiJMta4yg0L0KPWSHXgeCQ0S0rhzW27cCDKnKTZbwaX6ZrLTfeCX9RfLG0Q5L84cU0ccLiwrTf8NwNe9398KH1QPvv1kPbZeDFC9Z4gNV8hJwi80yMCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=puJjq7pQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="puJjq7pQ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9FF4E602CA
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 09:22:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776928920;
	bh=PZme9hDgRZ1+3hXMc7WMqkuFJgaBgvmK7FR596/Rozw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=puJjq7pQpgq/l/XA9kpeaawoTF596TSTrPHSHP8NoDjAGdb+ONtdimL9juFO/lfL2
	 d3pBNgd3sAc4sW4b8hiwE+wNgwTXksOPknODRM/ZmVayTb/L/j+B7ZpDw8hJMVwiZv
	 aQPHDoyz0jy0yXwuHeJvtt33ueugbywQy768Wt8vWga8wT2ZOh4ypxDbVCIGbTlH/P
	 2QxDNwAEfXX2Kl/PpGlxZXGofJiE6IJfc6P6zAxJYBDkqTuRHT0pP9HoJCDRINiV/i
	 ANO88AfVP6uwekWJbXwXDiFowx568DJTGYCSoUMTIwJXLzHQ2RvUE7SNLLU/0h7pND
	 jKeQTorKtGdqQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 2/3] netfilter: nft_fwd_netdev: drop packet if no device found when forwarding via neigh
Date: Thu, 23 Apr 2026 09:21:54 +0200
Message-ID: <20260423072155.352333-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423072155.352333-1-pablo@netfilter.org>
References: <20260423072155.352333-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ttl field has been decremented already and evaluate of this rule
would proceed, just drop this packet instead if there is no destination
device to forwards this packet. This is exactly what nf_dup already does
in this case.

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: no changes.

 net/netfilter/nft_fwd_netdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 2cc809303ce8..80416017a2d5 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -153,8 +153,10 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	}
 
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL)
-		return;
+	if (dev == NULL) {
+		verdict = NF_DROP;
+		goto out;
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-- 
2.47.3

