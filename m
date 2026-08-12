Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B77408607
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Aug 2026 23:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786577606; cv=none; b=mqZ9iVTjinLj79SQvv4I3N/TBU41tn6Z5Gfe5obZ4HahN8mE1TI8yljJKM1+SVm7MBctDiAHdEVFOkl5PyFvZnopTN/03HBuCBnEWNOrAjvOjEjxeAH3lfixjh6jQqXpMjuDhpjao37Qq5p4o7Tss1F57I5AndxC+T7wTDG0ZfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786577606; c=relaxed/simple;
	bh=H15OiQlBE9PrjbMMpTKCEGjz4Dopi8G/5BfcxKPprms=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Dggfuf5WrKDFo0QwMxSPyNSKkq00JHkhTdkE+3YbilUuVCY64baJFawO1//P9/4NP33Epagx6XxbvSb3/a4Beh8bosIVvcyOpca4aowimmFhh0y+S2hRQKXqaSYagJKwvA1N/LNtjetDgBzYClgiuenig9AVXfkaCwIq1W9NPy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VZ/otFBF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VZ/otFBF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786577602;
	bh=SVDcFTpaNjccKUOhVg6FQU37Q6w7gX06jZ7T+kGnD3s=;
	h=From:To:Subject:Date:From;
	b=VZ/otFBFGORJ/Jwm1VG+Po90RNsHBgnzMefkX43kNNCMsieYW1uub3eTgexqm3b1F
	 rykrtvT1iORRGwYid4pJJE2kxV+xYUH3Jz+XlcrppR64vJ39EFoLUit9yVEAGO6Jxm
	 TJCSWkZqea26DrZXw6Aey5rJx00x9g1CfBe08ZEmMZfg+eApx0qsZaIVlIpDEHcWTm
	 bhLcGXJRfQW7wC7yJ/c290dfP8UPuyacgGbat7TaQdSLpvqolCLv+YQuqgIRuU7A5e
	 R7L6uxNlGTa7pvlJI/pS9s4lB0wN0OjYB9VslnVreMI3nmiyaVjBrqvaRmUkV9mzyj
	 V0Sx1XN0R/pAw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DC8A160074
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 01:33:21 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: ctnetlink: do not expose expectation DEAD flag
Date: Thu, 13 Aug 2026 01:33:18 +0200
Message-ID: <20260812233318.1051706-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose expectation flags included in the NF_CT_EXPECT_MASK bitmask
only. The DEAD flag is internal, do not expose it.

Fixes: b8b09dc2bf35 netfilter: nf_conntrack_expect: use conntrack GC to reap expectations
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index fc3f60099af3..9b4e29557ec3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3042,7 +3042,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
 	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
-	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
+	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags & NF_CT_EXPECT_MASK)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
 
-- 
2.47.3

