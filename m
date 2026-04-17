Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C158D3B38A6;
	Fri, 17 Apr 2026 09:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776417494; cv=none; b=UzrFkgMw3P+Ds5YLPB37pZ6ARzPy8cW6umi1rs80vXga5dsAP+VkKjf07wrjukcQsb64/vTfByYSq1aB0qZi6+zhBGSu4/+Pyc4gq/UrXZaowb+/Ncg8WbKM16fG+xvlAUMncUmKXA6ACXc/gxrYzIY6xFpQo2AV5OIW20CtDMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776417494; c=relaxed/simple;
	bh=G1dlwFqzGt9lBjAkAqGl7iFAepQ2BoX2NhTIjjNOUwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TME2dHxVWQVBexSrAX8wanI1sOqAzlAzxYUodaCuFif5rwHSFCAtJyHsbECtur1tYnDdStdzorHZr/PvYT43uGTa9zVI1cbYK64eoprWwvtuuLDnHxiaoR04+ZJfq3aRyFL1lo/5ds1nuxL6hTqtzmx4xmJ2zQ6ZHpJm1gI2z3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KI2IDCEB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KI2IDCEB"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E672D60294;
	Fri, 17 Apr 2026 11:18:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776417491;
	bh=iSYuLNsvPdWqm0p+6eljUaX71GlbtmpsAoP3TTZhDug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KI2IDCEBfLO/gUYa98Bpr/j9IdbXcFG6relWY86Wvi2RMr0AQ0ir0W0ttKUM5c5Oa
	 N1BpwJ+PzuwSBhJZEr0EHI9Uur2osERaH9WlyIAf8/5Asnp6lXOyxHeKm+2+2hXhpF
	 C92ogvvULZ82xm1NmycUAk5UMiUviRrox1aUPWTFHwigOl15cK1HEShQqx/4whpuZ4
	 bCpl0KsJYcsJRQJ5ID2J2pl1ScpPLH38gnFVIAXRHa3mXEfQlfrgrtaEuKCfd4yHJc
	 krmNrRmMXBwFYV+8ZEFt2o9VRTtB2hf9o/ib+tzrrMW5o6/qKLxSB1IG1fu2C1CSVR
	 M+fx4qQDtgPKA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH nf,v5 2/3] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Fri, 17 Apr 2026 11:18:05 +0200
Message-ID: <20260417091806.342830-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417091806.342830-1-pablo@netfilter.org>
References: <20260417091806.342830-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Publish new hooks in the list into the basechain/flowtable using
splice_list_rcu() to ensure netlink dump list traversal via rcu is safe
while concurrent ruleset update is going on.

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: no changes, just including the full series to address AI report.

 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 090d4d688a33..8c0706d6d887 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10904,8 +10904,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_commit_update(nft_trans_container_chain(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				list_splice_rcu(&nft_trans_chain_hooks(trans),
+						&nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
@@ -11034,8 +11034,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   NFT_MSG_NEWFLOWTABLE);
-				list_splice(&nft_trans_flowtable_hooks(trans),
-					    &nft_trans_flowtable(trans)->hook_list);
+				list_splice_rcu(&nft_trans_flowtable_hooks(trans),
+						&nft_trans_flowtable(trans)->hook_list);
 			} else {
 				nft_clear(net, nft_trans_flowtable(trans));
 				nf_tables_flowtable_notify(&ctx,
-- 
2.47.3

