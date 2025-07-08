Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166592356CB
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 23:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752017044; cv=none; b=A6iSuM8fa/gGQkXmX1BrTovSuz9hYxGF9VVZaO1Ov9Pse7ObIzvp9iDxKzFFtyj+ZKMcgj2h81reJTXA+b6fBamrpYFig4MxEn+XMi6bQwhE44xVzF1AwBmus4fzX/A5+GxANs85Dj9GxuSb4V99Fwnv/kfvu1soJlWYqos35iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752017044; c=relaxed/simple;
	bh=4VLDgOyqAREcEmL6Qn3Kb2Z8gqe4+UlIPdil64QXV4Q=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BWNWBJqwjG0rQGpvXVq7tbopwKZ+ezruJzBvh3qlOFeKqwtlnfwEDxn/H0dPml1hZkQa8I1ucv+qQmiidrx0MQrfEmmfCvsy1J0YSIfuPTaGp1IX1Vg++1BAwgCmz3S9dvalP064J76Br7B5lQWlQj+4m+amtZ9SfPG7vQwUYFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qriXKJAo; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qriXKJAo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qriXKJAo";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qriXKJAo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 93C8960279; Wed,  9 Jul 2025 01:24:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017040;
	bh=RB+M6WFk5h1QvLLtYzK9s4cFQ8sE4Ahr1MvW+AS5CPw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qriXKJAokYntLj/YEBbir6yDrWAiaPRmme9tleDAd3BC86ciOPvDdXLjE3C1GfjuE
	 uCvBA+WlSuWeiW3kxPcBXf1UI/44YXms0bRMSeOrQBIG0XpagUd9czXWYeXcf+Qg55
	 5xtkD2HrhrxCrj05e256iZUmj0BQWX72m83LgtYgozb8KO1xrtNlBwX+zqLgii6grT
	 8uQYGaLjc/Xsn7/54M7VIvViR0pRGdUyw0cEIsR4UhiM5Km79lLNxUG1Kjee4Iq/Kz
	 DmUYZX3AZvNsGV4iUf09NJ3z1VIyiyUinkRYNHKHwAQduv3NUUIRvKJLIEVRndGkrq
	 RDj4qOeqLmigA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 41CA060273
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 01:24:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017040;
	bh=RB+M6WFk5h1QvLLtYzK9s4cFQ8sE4Ahr1MvW+AS5CPw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qriXKJAokYntLj/YEBbir6yDrWAiaPRmme9tleDAd3BC86ciOPvDdXLjE3C1GfjuE
	 uCvBA+WlSuWeiW3kxPcBXf1UI/44YXms0bRMSeOrQBIG0XpagUd9czXWYeXcf+Qg55
	 5xtkD2HrhrxCrj05e256iZUmj0BQWX72m83LgtYgozb8KO1xrtNlBwX+zqLgii6grT
	 8uQYGaLjc/Xsn7/54M7VIvViR0pRGdUyw0cEIsR4UhiM5Km79lLNxUG1Kjee4Iq/Kz
	 DmUYZX3AZvNsGV4iUf09NJ3z1VIyiyUinkRYNHKHwAQduv3NUUIRvKJLIEVRndGkrq
	 RDj4qOeqLmigA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] evaluate: validate set expression type before accessing flags
Date: Wed,  9 Jul 2025 01:23:52 +0200
Message-Id: <20250708232354.2189045-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250708232354.2189045-1-pablo@netfilter.org>
References: <20250708232354.2189045-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate set->init is of EXPR_SET before accessing set_flags.

Fixes: 81e36530fcac ("src: replace interval segment tree overlap and automerge")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 83381b4ef3d0..f4f72ee4a4f7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5290,7 +5290,8 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		set->flags |= NFT_SET_EXPR;
 
 	if (set_is_anonymous(set->flags)) {
-		if (set_is_interval(set->init->set_flags) &&
+		if (set->init->etype == EXPR_SET &&
+		    set_is_interval(set->init->set_flags) &&
 		    !(set->init->set_flags & NFT_SET_CONCAT) &&
 		    interval_set_eval(ctx, set, set->init) < 0)
 			return -1;
-- 
2.30.2

