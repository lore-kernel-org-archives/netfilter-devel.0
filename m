Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9299C221F25
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 21:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747258954; cv=none; b=pAt96d3MOW2fYRZMquIgzhJUMgjQsR2lHzOXWYApeXIyhCKEZOqfklYB3xAAAOFk69VC7k0W+kQbT2nKXzK4A2CP7xy9tn9laaVakTwRl7dSeYwb8UAuXaWmmX5wVKH8R+nOoUXLVWrHqv6lNRhnDOwaHx68vowDGEFraXRVau0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747258954; c=relaxed/simple;
	bh=tl1xyj5EcNLIMwrLRB88QGgQ/H8aPPPca1dgKsu6Ejw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dGTlL76RFiWpjccF+7m0oXQckLgijgv6Rs4+rV92lWwtGBIS01Mg/MwFpjHQ1vO0pGoEr4upljaqzWoieZ0a+RLn1x2AhFMJ5RVVpxwaWxlqHsgyugZwW6PWMPqGQ3Y02Nl60x6rv9rYQPhZA74+/V1X6xzMtghov33eTfLJQRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=A3fhUQzA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=A3fhUQzA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="A3fhUQzA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="A3fhUQzA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 633E460742; Wed, 14 May 2025 23:42:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747258949;
	bh=OIPPduiGPEx9KzpTiyNw8pXNOqfSzGTgEOX9GGIaV5s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=A3fhUQzAm2aLd9HshrSgZOj7shsBZeOcuuia0OZjETuuZaZN8OKaaxIy83/RL60YD
	 mGgSk+cGF1i3Paiwe+egwlLLPt1hNdYFIceh4C5ZpkdAExbLb4/PlW4mpUWka1LHwp
	 tPl7h9vWbrIxHAqDOy06jvaa0J0GF6DUhw3FDlzH9fX02Ex2CuoeIEC0N/92QX2nA1
	 doK8oxSXnZaQpgkam7Fb9wpQBxAVJIcMXxBLlP2enoCBknY6y+38+OhtfcOCXrYH4d
	 jAUQGsRdeyIl8wQWyPHFXk3DIkstMjM0+pg5ShJ5orVWgrgWaak1u/CpPT/ktwejSW
	 XI3/4Yv4/xuCg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F26C46073E
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 23:42:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747258949;
	bh=OIPPduiGPEx9KzpTiyNw8pXNOqfSzGTgEOX9GGIaV5s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=A3fhUQzAm2aLd9HshrSgZOj7shsBZeOcuuia0OZjETuuZaZN8OKaaxIy83/RL60YD
	 mGgSk+cGF1i3Paiwe+egwlLLPt1hNdYFIceh4C5ZpkdAExbLb4/PlW4mpUWka1LHwp
	 tPl7h9vWbrIxHAqDOy06jvaa0J0GF6DUhw3FDlzH9fX02Ex2CuoeIEC0N/92QX2nA1
	 doK8oxSXnZaQpgkam7Fb9wpQBxAVJIcMXxBLlP2enoCBknY6y+38+OhtfcOCXrYH4d
	 jAUQGsRdeyIl8wQWyPHFXk3DIkstMjM0+pg5ShJ5orVWgrgWaak1u/CpPT/ktwejSW
	 XI3/4Yv4/xuCg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 1/6] netfilter: nf_tables: honor EINTR in ruleset validation from commit/abort path
Date: Wed, 14 May 2025 23:42:11 +0200
Message-Id: <20250514214216.828862-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250514214216.828862-1-pablo@netfilter.org>
References: <20250514214216.828862-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not return EAGAIN to replay the transaction if table validation
reports EINTR. Abort the transaction and report EINTR error instead.

Fixes: 169384fbe851 ("netfilter: nf_tables: allow loop termination for pending fatal signal")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b28f6730e26d..d5de843ee773 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9885,6 +9885,7 @@ static int nf_tables_validate(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_table *table;
+	int err;
 
 	list_for_each_entry(table, &nft_net->tables, list) {
 		switch (table->validate_state) {
@@ -9894,15 +9895,24 @@ static int nf_tables_validate(struct net *net)
 			nft_validate_state_update(table, NFT_VALIDATE_DO);
 			fallthrough;
 		case NFT_VALIDATE_DO:
-			if (nft_table_validate(net, table) < 0)
-				return -EAGAIN;
+			err = nft_table_validate(net, table);
+			if (err < 0) {
+				if (err == EINTR)
+					goto err_eintr;
 
+				return -EAGAIN;
+			}
 			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
 			break;
 		}
 	}
 
 	return 0;
+err_eintr:
+	list_for_each_entry(table, &nft_net->tables, list)
+		nft_validate_state_update(table, NFT_VALIDATE_SKIP);
+
+	return -EINTR;
 }
 
 /* a drop policy has to be deferred until all rules have been activated,
@@ -10710,7 +10720,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	}
 
 	/* 0. Validate ruleset, otherwise roll back for error reporting. */
-	if (nf_tables_validate(net) < 0) {
+	err = nf_tables_validate(net);
+	if (err < 0) {
+		if (err == -EINTR)
+			return -EINTR;
+
 		nft_net->validate_state = NFT_VALIDATE_DO;
 		return -EAGAIN;
 	}
@@ -11054,9 +11068,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	};
 	int err = 0;
 
-	if (action == NFNL_ABORT_VALIDATE &&
-	    nf_tables_validate(net) < 0)
-		err = -EAGAIN;
+	if (action == NFNL_ABORT_VALIDATE) {
+		err = nf_tables_validate(net);
+		if (err < 0 && err != -EINTR)
+			err = -EAGAIN;
+	}
 
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
-- 
2.30.2

