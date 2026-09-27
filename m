Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610E3347C6;
	Sun, 27 Sep 2026 22:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546907; cv=none; b=cUSJiIb9lOKYjyyo2PHJTr3dQ/1F4UO+pJZFAhBLRZbCsR7hjx/pbjaQx4JLX91T33vhnUxkouRKMiBAWolsE717jJUK28YCJwGwWubHsMVsDSaxJenrMcHcD9OG7PhtRa5Z6RwLvxfVpwBpSVKLRULIUFfescfKOOxLI0KH094=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546907; c=relaxed/simple;
	bh=hvKl/MVOWB90vjhvMf6KtdrTPfMUV/fDGAwguKby5x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fE7VHjXfzh1/RLRIKErc5K70FkFEeaCcAqqTQkIZCVWO0ErPd9ZgAWoWXZOLHVpWfo2R4pk/sRfuPoSEFVcqAZ4Fhm0sQehXbowSPNemLUbnuOhRDdgzacP+FP+jaz+esivUbscDHZXXYVLd4iICYbY551dE+S4fMcCbpH7fcZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OArN/jB9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OArN/jB9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546903;
	bh=obLcSQDIiPunVN8yOBpGpgQLMPs0/ghhehx7yiIyNlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OArN/jB9OqV9+wTRVx4+imCIGk2UZio3guGbp+8sJvTbA1cW2T3zxnQ3xOowRMgeP
	 SeFhs2W+0zUBeRjI4LDsyztN0bGoztWJNFQUfwCnrqdI5pQ57isc+JDPiU0wAXaJ5/
	 ZHNA1vZO8TbjwEa0d6O2sT4JuTn/zlCVuEV0u3JXYQcAx8NMlxbC82k3REJHx+c1Js
	 rWBJ+Y6tZ+xmib6OIsLGA5GufNZnSSPYygo3lQd0tlCU0clJiLXk2v1YpBAv55LLkC
	 9vzBgClX0O+Ry40ouWx8JYLTb8ORVQUDErUyswG81w9PvtDpGOvhzMMBeLLqsZFPEo
	 pXF+oxpD+1lCg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C9CBA603DD;
	Mon, 28 Sep 2026 00:08:22 +0200 (CEST)
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
Subject: [PATCH net 01/11] netfilter: ipset: do not update comments from kernel-side adds
Date: Mon, 28 Sep 2026 00:08:06 +0200
Message-ID: <20260927220816.268206-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

'Fixes' commit stopped calling ip_set_init_comment() for hash types
from kernel-side-adds (xtables .. -j SET).  ip_set_init_comment() says:

   "The kadt functions don't use the comment extensions in any way."

But bitmap set type calls the function from kadt cb too.

While this appears to be safe (serialized via the set spinlock), it seems
better to not call the init function either, least of all to keep
behaviour consistent.

ip_set_list calls ip_set_init_comment() only from uadt cb, it can be
kept as-is.

This was triggered by yet another LLM review, hinting that the existing
rcu_dereference_protected() cannot be downgraded to only check if the
nfnl mutex is held.

Fixes: f30415929be8 ("netfilter: ipset: do not update comments from kernel-side hash adds")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index d6a7e6604542..ae376fa3e7a3 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -159,7 +159,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(x, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(x, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(x, set), ext);
-- 
2.47.3

