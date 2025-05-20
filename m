Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCC0268FDC
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 09:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747732840; cv=none; b=bFZYRxRW6ShA2MdxMW2evmqUN2cxDI4ogj3AWM5jzFzj6cNglEfhoO8AfOYBC7zGZdJMdZluMVzFmKYuf468+lpuo6+JWtFy58bB0KOAwlcZRYot6T6wncI8pyaks5mqyc7Us/wo5WJgZ0i35Qrp2nxMI92N59pGb2COsO1iN24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747732840; c=relaxed/simple;
	bh=mEPc92pNyNTFwKhFE+C5fccdzYtlzQTdGiSLhdeX9Ts=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=k3HpD2uNcUcV77FRm/bUkRfLcwuZhNiIv2HJ0vyLzRuNGgE9q0DkYFC4rY0H33T3I0O3N7gcPoPRTng6nAE5YsQFseuihZYSi7yPjC2LYSz2GW1qh5aUTWADfbWnNnmKNMslfm5IbXyDEWH9BEcRjuOQX0TCFjatC1Ggt1Mettk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a6jsu1sh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a6jsu1sh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a6jsu1sh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a6jsu1sh"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E4B286026C; Tue, 20 May 2025 11:20:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747732833;
	bh=vsoot1rVzdvDpGZuA7MWUlKOEENVmcfygSxDimIRyqU=;
	h=From:To:Subject:Date:From;
	b=a6jsu1shOzLRW1cF/PM729ZcKg4S5imMfXqxq5eDQcgTQ69CAf5WXA4QznRcvmsDw
	 7eaChF8I98r9+ZsIq84N9NuKVZNElx6GwGKfqotQn3YC6jTZ87a6MHb5rCELdwdTk/
	 R4WdvDupfIfO80kdkJ8KJP6atalYISTnyl4MMXhNX6HZcHwOMVl/VTYpS0Gaucffxt
	 jLleJiJujC3/UmE9ckd94m2hXrjgwoDPBG8g9MFw+6qc0lfZOoJ3AXm4gwFC07t4rw
	 4tek/g20T+zHDqyER3/L6YkrCbySVxeFQPKRz3C/wGjZAsHLDXVN9YuZPOzQAwD4xf
	 7V2se39lj+Gpg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7D73660269
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 11:20:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747732833;
	bh=vsoot1rVzdvDpGZuA7MWUlKOEENVmcfygSxDimIRyqU=;
	h=From:To:Subject:Date:From;
	b=a6jsu1shOzLRW1cF/PM729ZcKg4S5imMfXqxq5eDQcgTQ69CAf5WXA4QznRcvmsDw
	 7eaChF8I98r9+ZsIq84N9NuKVZNElx6GwGKfqotQn3YC6jTZ87a6MHb5rCELdwdTk/
	 R4WdvDupfIfO80kdkJ8KJP6atalYISTnyl4MMXhNX6HZcHwOMVl/VTYpS0Gaucffxt
	 jLleJiJujC3/UmE9ckd94m2hXrjgwoDPBG8g9MFw+6qc0lfZOoJ3AXm4gwFC07t4rw
	 4tek/g20T+zHDqyER3/L6YkrCbySVxeFQPKRz3C/wGjZAsHLDXVN9YuZPOzQAwD4xf
	 7V2se39lj+Gpg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 1/2] netfilter: nf_tables: honor EINTR in ruleset validation from commit/abort path
Date: Tue, 20 May 2025 11:20:28 +0200
Message-Id: <20250520092029.190588-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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
v2: fix check for EINTR (Phil Sutter)

 net/netfilter/nf_tables_api.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b28f6730e26d..b57ef8f4834f 100644
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
+				if (err == -EINTR)
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

