Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE98D36F438;
	Thu, 23 Jul 2026 16:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824784; cv=none; b=t6Q0bVP8Hi5npdTD+4RVRdMxdEi615YnqybcdpnL/4ZXM7Prrgt2PKw9VN9HqU4Qingdaut5C5/ksGOHndLHddMaMkJHQIilUo6iKnjsaMlbCF1J7mWOTv/+3e3oUwp7AagWa08QzgAoaL9KuKz4dEiLJ1jS0uXnyL/PLcy9fJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824784; c=relaxed/simple;
	bh=c8pWK1LK3diKpJDjy107L3GT6HIpca+2ki1CLlmhaOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIzu7YuNCf1XkqQkJvNAHqHut/4C2E9lem0hEiEBe3wg1DQFXqrnsgK4HDmg2nRgV3F1HtPQeWv8FYtoxhlqvuaxvsyBoDqAVXGzsFc2lgFf3r+QUYasFMji8wY0tiMnkMjEfKiw3dOINXHq4XMu7gNWCPMQ6kxN4L84cek+bXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Buy1fDU7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Buy1fDU7"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BE8C2601BD;
	Thu, 23 Jul 2026 18:39:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784824773;
	bh=Tfta8c8oNaR4hh/DnWLdgMKvFQm5UTb5MbPG6agsee0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Buy1fDU7wFfWTEaGDyOX3SH4o8yFtJ1ED+8bBQuBrkBsZm1tjefu4WS8y8MPrttRT
	 vNzjEdD3gvayPfwKNTp/qvArarVPf6vX+IzkbnLN7ZO/nNemR1EMvrp5qNwlqOH6Io
	 Y1tsxls/Ms1NUhA5vFReTGaFcSmSWfxt+/5aEJqmtCX1EhlOm93c8pVMQzRgrEw9GH
	 XUqHWDyynOXJ8YILRC/4ChhDn5aBRxo2N8Dqu31BRs2CanpIgyd3ed1Iq/jDh48xGD
	 PUVYlC9ArDHisxzGMrP/vcSCoh010zPGxRBZSFSu2cuwl76n3AEdDnfK17nWnW4+Nj
	 VkCGoVxEeE1Bw==
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
Date: Thu, 23 Jul 2026 18:39:01 +0200
Message-ID: <20260723163910.274695-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723163910.274695-1-pablo@netfilter.org>
References: <20260723163910.274695-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Lee <david.lee@trailofbits.com>

mtype_resize() copies comment pointers with memcpy(), not the comment
objects themselves. During the window after an entry has been copied but
before the table swap and backlog replay, the old table is still
published for packet-side updates while the replacement-table entry
already holds the same ip_set_comment_rcu pointer.

If xt_SET --add-set ... --exist hits that old entry in this window,
mtype_add() calls ip_set_init_comment() even though packet-side adds
carry no comment payload. That call frees the shared comment through the
old entry, so the replacement-table entry now holds a stale pointer.
When the queued add is replayed on the new table, mtype_add() calls
ip_set_init_comment() again and strlen() dereferences the stale pointer.

Fix this in mtype_add() by skipping ip_set_init_comment() when
ext->target marks a packet-side add. Userspace adds still update
comments, while packet-side adds can no longer free comment storage
shared with a resize copy.

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

