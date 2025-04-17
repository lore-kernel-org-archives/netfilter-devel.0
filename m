Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B6F134B0
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 12:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744892123; cv=none; b=cjxZ0LwUujney3xVwzgIv1tY1iV5c28shZX59Z1a08x/NlWg1LStSMj6SlQm3SbLO9J75Zl941Z8Q2kG7bwd+wO7u2fYBmFkYLAofZfSyq1OlKozI1Ubxg0hfGsCdv1s65zSGpp/lRPKczjNnno1z5sEAr8tPdiYyoKtTUoKHTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744892123; c=relaxed/simple;
	bh=AuXc3u+W0hnY8yddpc58OhU7EhpSDM2xCWYEgPL76PM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sX74O0o1VhUXhW49ClsHcQ7isuc0KqoBOQfj+gdOSWVuGj+ZDkA/xvi+gNJ66Uv0lNK/vRLfuJw0W/o9gQhMEN6Qi4j57GUpR6tW9+nt2VyvQMb9NBGDB/h/ZgquyblItm2LL9zrxoqzmxjsLlP04ViHsy7ewv53fSIpAf1In1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mYhX3MYz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mYhX3MYz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mYhX3MYz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mYhX3MYz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9734E60A87; Thu, 17 Apr 2025 14:15:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744892116;
	bh=MtjivIK88FWDFXxThNJ9PdmUCeSBykZkevfTeaCrIag=;
	h=From:To:Cc:Subject:Date:From;
	b=mYhX3MYzZPtXXgxGSwKIxJsv6J5SxriRQcFdQP3YoV7DmjWtO0gWfh70B27cCtnAX
	 05TC/fnPKmqRy5vBrYcA5KB2fyJoofpMD06V9ncYW4ovG7SYEONYu+AMT6GwXAdXmC
	 0HdQt+q08OWlcvvhJ1sZE68ulD5Bej344g09Y2EjfMONQuTDO2ifuQEpsUYglbMLxs
	 mXFQxdwIRW34fYnQI7D2W+UAKdpFlt1e/LzoU95ExXFfSMcpX0+yopWPMEr5y/lPyj
	 a6fqyH0guHn7A969HGG1oR6yGZKkx0gnUUSRHTfv04pGnnuPUO+z0AZ0SOQZtKElR5
	 KdBlGB5N29MzA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DD7A960A87;
	Thu, 17 Apr 2025 14:15:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744892116;
	bh=MtjivIK88FWDFXxThNJ9PdmUCeSBykZkevfTeaCrIag=;
	h=From:To:Cc:Subject:Date:From;
	b=mYhX3MYzZPtXXgxGSwKIxJsv6J5SxriRQcFdQP3YoV7DmjWtO0gWfh70B27cCtnAX
	 05TC/fnPKmqRy5vBrYcA5KB2fyJoofpMD06V9ncYW4ovG7SYEONYu+AMT6GwXAdXmC
	 0HdQt+q08OWlcvvhJ1sZE68ulD5Bej344g09Y2EjfMONQuTDO2ifuQEpsUYglbMLxs
	 mXFQxdwIRW34fYnQI7D2W+UAKdpFlt1e/LzoU95ExXFfSMcpX0+yopWPMEr5y/lPyj
	 a6fqyH0guHn7A969HGG1oR6yGZKkx0gnUUSRHTfv04pGnnuPUO+z0AZ0SOQZtKElR5
	 KdBlGB5N29MzA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: linux@slavino.sk
Subject: [PATCH nft] Revert "intervals: do not merge intervals with different timeout"
Date: Thu, 17 Apr 2025 14:15:11 +0200
Message-Id: <20250417121511.19312-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit da0bac050c8b2588242727f9915a1ea8bc48ceb2.

This results in an error when adding an interval that overlaps an
existing interval in the kernel, this defeats the purpose of the
auto-merge feature.

Reported-by: Slavko <linux@slavino.sk>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 1ab443bcde87..bf125a0c59d3 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -162,8 +162,6 @@ static void set_prev_elem(struct expr **prev, struct expr *i,
 	mpz_set(prev_range->high, range->high);
 }
 
-static struct expr *interval_expr_key(struct expr *i);
-
 static void setelem_automerge(struct set_automerge_ctx *ctx)
 {
 	struct expr *i, *next, *prev = NULL;
@@ -183,9 +181,7 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 		range_expr_value_low(range.low, i);
 		range_expr_value_high(range.high, i);
 
-		if (!prev ||
-		    interval_expr_key(prev)->timeout != interval_expr_key(i)->timeout ||
-		    interval_expr_key(prev)->expiration != interval_expr_key(i)->expiration) {
+		if (!prev) {
 			set_prev_elem(&prev, i, &prev_range, &range);
 			continue;
 		}
-- 
2.30.2

