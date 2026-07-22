Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFB137FF5D;
	Wed, 22 Jul 2026 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754877; cv=none; b=J7ogYchoegjda1guAp4/Xd/7Gca+C2bog7qa/x17g30W9UYmwDirMpGQOuRM/2sulSzr814+rezqRc+qafvnV+kf0cL3MhddwdRFosylk6k5kIyaxvUtOk/8YXmg6yAG82fOgz1IOeN0bajUlcD68UXgoNWZFwN3sec46IKcpCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754877; c=relaxed/simple;
	bh=mDSz1MIjzMyz31vnMoXV/s9vbmmmSstcq2hWrptWMyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f421Ac7p6FFLNzj3n/ISa5WAJGiV+6GpTe8x43NGaD2pTqPp1BxIxPeK93t4tEpW9d09Te5imBk+M6ZjV3Msi0rSPBoMUj2njTbWkVGFP+awq7KgwyKITfOynBEJ209mqH3/qEeyKdV6zdPyxdjDkjEN072Pxzm41q7/qyXnd3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E4BCpwWo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E4BCpwWo"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 976206019F;
	Wed, 22 Jul 2026 23:14:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784754873;
	bh=71NVPj8I43azYiGvGocLyKoevF+eWOgg9UZ2QBwWOPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4BCpwWo2hNdWGvoq77Ab40bQAOuL7uhjMtkB76ZpQ1R0HWyXqJjs4XftNurP7aKD
	 seC3CwFOoD6XqG/HjRB6cItqeUEEthwL//UAygutsnm+A8D110aOWqnTziEYEfJWso
	 ngQn11ZvSTlKaiqAg5bz73AwKOkpAsVykThxWeP8Ryd7B4GLRvEua+LIiN8VQK5kmZ
	 TzguiLbOyP1ulkJHHMluHlJXDFRIfg89+gbB6RopBKlpqct9lUuhdV/gbCpjlj0UBq
	 v8t/jBqxDf2dbiF/1dv9LMZwbPzJ+Mn0CccZfCfvDt2BRmE/Sh73eW4zedIwQwBeZp
	 Ao2EWRxtDjKAg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 04/13] netfilter: ipset: do not update comments from kernel-side hash adds
Date: Wed, 22 Jul 2026 23:14:11 +0200
Message-ID: <20260722211420.153933-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722211420.153933-1-pablo@netfilter.org>
References: <20260722211420.153933-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Lee <david.lee@trailofbits.com>

mtype_resize() copies comment pointers with memcpy(), not the comment objects
themselves. During the window after an entry has been copied but before the
table swap and backlog replay, the old table is still published for
packet-side updates while the replacement-table entry already holds the same
ip_set_comment_rcu pointer.

If xt_SET --add-set ... --exist hits that old entry in this window,
mtype_add() calls ip_set_init_comment() even though packet-side adds carry no
comment payload. That call frees the shared comment through the old entry, so
the replacement-table entry now holds a stale pointer. When the queued add is
replayed on the new table, mtype_add() calls ip_set_init_comment() again and
strlen() dereferences the stale pointer.

Fix this in mtype_add() by skipping ip_set_init_comment() when ext->target
marks a packet-side add. Userspace adds still update comments, while
packet-side adds can no longer free comment storage shared with a resize copy.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8231317b0f1f..b2d77973272d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1005,7 +1005,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #endif
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(data, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);
-- 
2.47.3

