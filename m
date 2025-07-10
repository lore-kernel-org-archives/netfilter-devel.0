Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222F86328;
	Thu, 10 Jul 2025 00:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752108424; cv=none; b=gF/dRMWBgQAkZ6m1cMUBNojwNU+gP2QTtiQPBmi7y+SLNmmx+/pxm5oXbOwmn0Oo1v2BBdDb1JS5zLlvnCYVSQQRLQO2TZC3esGEMn1NDZQImqGpZCnWwLf671bz4fzXxHDce/zDvdk100NcF5CqG4ly+UnueGrgZhwi2UTgFRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752108424; c=relaxed/simple;
	bh=RDC3j8wGaOOVJWPCP/Po/uZHOXWzsP5h47eggFQ38d8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=flu5mW/KP5pDqEpUro+l7nNXc/rkeur6YctrXyy9t7F2yKaqDNp1ukOINudCkoBz2EApxnvGdlynIEuGGGsiEq3ppAVDZmiTRnErNORulKyME7amj171VlUmebZTtNoqtq7U7Xw6mt8t4duLXdbXd1g1uU3KDP7LRej1Hz0kTdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sJXhxQJS; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sEzgshgE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sJXhxQJS";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sEzgshgE"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0190060272; Thu, 10 Jul 2025 02:47:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752108421;
	bh=VBHd4INkEeZodi67wtmxuJtMNEHdOSY0kUfPkxfgEcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJXhxQJSTo9vF1ErU6CMb8O+8lnC+mCwXFgizLuiwaE8mPgL0HiMeXFQD9NamZH4q
	 eWaHRUMefIoMKJFihVJ+2IUVnagTJ3zP/+AJmOlVtX/BWH3pSktjqeWqVTHQyJwzjp
	 SFVw3wD/8AHyXNxH9XIzXG5q6K1TnPkiuxVTxUgp7eJEsEUYy6AXPaYmKWcSf87MTs
	 9HFC78USrGp0HJ7INVqs8nNknbF063xwmviVL2z+p20ExCePrgf+BxD5iUGa0c1UKA
	 efNK+jVFY4MVKy1FAC/6KoFBWY6SEl+dba1OyPQZ8wWkMb7sfqaXQ7p9yMwzJ/IfwP
	 iL2+50yQBBa1g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 817C86026F;
	Thu, 10 Jul 2025 02:46:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752108407;
	bh=VBHd4INkEeZodi67wtmxuJtMNEHdOSY0kUfPkxfgEcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEzgshgEJkMEKlu7ALE5QJgs7sSqDgu3S1T70ITgLinbkw3aNVBdVRVPj67gr/n21
	 jd+b0ZDvoRAQiXUyjxpa6OWog1Yt2Y5P6ub3PqCz3ixbsYekuuuIHV5VcwgGH11q0G
	 3REyjbZb78nVrrmV8tyja6OSQc7nBgL1usjJ3DnLu+gvX3OGnqmboEpvciBN6cKarZ
	 IziyYvbpv7FwQFHDyytO/M+Pja2A6xXCwwU2pD9uYXd3LEEujQT4RDe/dW5khEZFMm
	 FXlPo9lij2QzSoFOlSmfzXgxcNyucp11naxvCN3wEO+dHCIKLzVcI1pxMjIaRm5sHA
	 BIaNN5EMOsYYA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 4/4] netfilter: nf_tables: adjust lockdep assertions handling
Date: Thu, 10 Jul 2025 02:46:39 +0200
Message-Id: <20250710004639.2849930-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250710004639.2849930-1-pablo@netfilter.org>
References: <20250710004639.2849930-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

It's needed to check the return value of lockdep_commit_lock_is_held(),
otherwise there's no point in this assertion as it doesn't print any
debug information on itself.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: b04df3da1b5c ("netfilter: nf_tables: do not defer rule destruction via call_rcu")
Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4ec117b31611..620824a56a55 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4042,7 +4042,7 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
 /* can only be used if rule is no longer visible to dumps */
 static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
@@ -5864,7 +5864,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
-- 
2.30.2

