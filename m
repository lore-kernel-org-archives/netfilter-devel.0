Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88E1B7910
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626387; cv=none; b=OItdClt+v3jyKgqkv5P8vZvJIuutV9h7U2JierknUKbXAYU/2KaIXLT7t4bz/WzAqRO75eYjRVezQWilpYIp4NQPY0XWf/O/Eq4iTWDiqjfNBsFUHCzhnhvhnPDzBwPXdMA7mHh431JbTWTqPf4B7Q6pkAV/sgvVpUUsLG9mFt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626387; c=relaxed/simple;
	bh=LnawNG6QG+PsL314t0XVooykDRfRJ5Frdu5yU9tYaR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXRX5IZW6aJ9e/kb8NuAGuAVpB72SgQ7wBA6HKXtqpEy174byqknN9vCdrzKST20siC2S+Ud1st3bx/z9ez5nWJvmClGrumV285CKfNvJgaeBnPSS6ETCZTs+xOml7lP2YVsedtei6oazxGKP5wr/PaUZCxZmwxEJ5dWVq9L0Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qcWd5f5B; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qcWd5f5B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W3Z3ScozcjpZ2jw6d9qow1YYtQ0hnBJl2vfDiBMqRNs=; b=qcWd5f5BNnzKCabyiOdBNO49yi
	L9gsAeo2NHZHGTFKQcPi5g/E+p2yrs6qqz3umoGViQRTfaMW9y1cpH2pjZOvsz4ErmQXaDQ2mk5Yn
	tY63POvsuXmDgnyXoBeV8yxkMRw2q0CEs3uKQZuUlJz71g7F/k/3UWTkXL5BDAJ0i550zKBmEDQMJ
	PSodvkdEnGXAyJqjGHen8jeJJ6p7/FTvrpOExwZ9thjs9tVCKMJzfs7Y2MQIRL7MYoteWv3cYbkOB
	GXmnUaVj+WQFIULAlVZ2q/NBpJadHF2vRatx0ex8Ifp/N9Bib4QvH7tO1uTRURwmcGjkcz+Q/qT4j
	fBDhAoNw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1whuhP-000000002jO-1CEx;
	Thu, 09 Jul 2026 21:46:19 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v2 3/5] netfilter: nfnetlink_hook: Address hook ops using READ_ONCE()
Date: Thu,  9 Jul 2026 21:46:10 +0200
Message-ID: <20260709194612.1995795-4-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709194612.1995795-1-phil@nwl.cc>
References: <20260709194612.1995795-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Writer (nf_remove_net_hook) assigns to the field value using
WRITE_ONCE(), appropriately call READ_ONCE() to make sure reader
(nfnl_hook_dump) sees either the old or new value, not both.

Fixes: b010e2a4a9ac ("netfilter: nfnetlink_hook: Dump nat type chains")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Cover for previously missed ops[i]->priority parameter
- Also cover for nat_ops field access, adjust patch subject
- Declare temporary variable as const
---
 net/netfilter/nfnetlink_hook.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index b0cf0ec41bc5..95cc9a0cee20 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -360,7 +360,8 @@ static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
 	nat_ops = nf_hook_entries_get_hook_ops(e);
 
 	for (i = 0; i < e->num_hook_entries; i++) {
-		err = nfnl_hook_dump_one(nlskb, ctx, nat_ops[i],
+		err = nfnl_hook_dump_one(nlskb, ctx,
+					 READ_ONCE(nat_ops[i]),
 					 ops->priority, family,
 					 cb->nlh->nlmsg_seq);
 		if (err)
@@ -397,11 +398,13 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		if (ops[i]->hook_ops_type == NF_HOOK_OP_NAT)
-			err = nfnl_hook_dump_nat(nlskb, cb, ops[i], family);
+		const struct nf_hook_ops *cur = READ_ONCE(ops[i]);
+
+		if (cur->hook_ops_type == NF_HOOK_OP_NAT)
+			err = nfnl_hook_dump_nat(nlskb, cb, cur, family);
 		else
-			err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
-						 ops[i]->priority, family,
+			err = nfnl_hook_dump_one(nlskb, ctx, cur,
+						 cur->priority, family,
 						 cb->nlh->nlmsg_seq);
 		if (err)
 			break;
-- 
2.54.0

