Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A9551B9835
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2025 17:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735925740; cv=none; b=HYwO6SAMfB+zJRtP6w/293uyo5iM/NuJtNk55t1T4TclrAC+qZABZhvLds7MUulSPCEEZGvisZaWK2iJCxYtDKrfhbC57QERXeKhDryEvqaLyikdbnImHaStCrbQFgJy1t94C8PoUKEsEFDQ9BrwtpnTBOul/0a+JlvCaUzykJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735925740; c=relaxed/simple;
	bh=AAgJZox071VwoHpgIBX1ejOm0q5TjC0VpXosIPe5CeE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D84RrABTYlesuztaWQZmXVJIRQG+NPNflkiuUZBPBuVlFyVJ4kJcGZcVZdwuEwTxZJ64SKOuFC8XzHLsEJe6jH9ZJQfOzdfOfFZiXemUcOmqQi57Nh0mUalu269J6A9JQTki/Vz9p8kQCG2uPzHgWCVWxkyz28801EX/Rqi9fNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 4/7] rule: constify set_is_non_concat_range()
Date: Fri,  3 Jan 2025 18:35:19 +0100
Message-Id: <20250103173522.773063-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250103173522.773063-1-pablo@netfilter.org>
References: <20250103173522.773063-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is read-only, constify it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 include/rule.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 238be23eca90..86477c709544 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -423,7 +423,7 @@ static inline bool set_is_interval(uint32_t set_flags)
 	return set_flags & NFT_SET_INTERVAL;
 }
 
-static inline bool set_is_non_concat_range(struct set *s)
+static inline bool set_is_non_concat_range(const struct set *s)
 {
 	return (s->flags & NFT_SET_INTERVAL) && s->desc.field_count <= 1;
 }
-- 
2.30.2

