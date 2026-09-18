Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41A64E36E6;
	Fri, 18 Sep 2026 11:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730943; cv=none; b=JOzh7xrQQtTj2GgL+bY4t/H0kv1BO4nPrBonEOyQHThg1Wh6e7VJgZXQYH524nEcAqxlHCsZ8JrVPaaAKlbgBQLANyjtnyMeofM93bUvBha6GKBE7mHpJ9lME0cg+kM0F3phzK1bhy7V5ZKjhqLqMNgzEJmUn4fOF3i8oHneWUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730943; c=relaxed/simple;
	bh=ME4NCPfxagzh7tFws70EHZjhU6c2pN339nLhTqt2WB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jlba2OVoRr8WXQz7hh+S2NSz6NMPJO0uHHSplxC8BTbnLqTtdAAnoj7qOON7Aa6qTEuMN67E+c7a7qlugA+0MpubaFPEdJ+2otcUbeqWvAs4f7ofl/Ot1H0Kote1XNIiyWPBhfDu82kyV6LAavNc8/ITNL8xpBottWd/NivTKS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UbkMGPhu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UbkMGPhu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789730939;
	bh=KVZTq5uDb9l9+SWKtdDkh9PqAyoahNYYn2CJ7MBwxNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbkMGPhuGRgeqNihzdASyv/W7fyHGFhEE+j1iV55w2HjNTORgjIk1os9iAQl+Hf04
	 +5OXsU3SbKao7A7yWBeZ45BT4ln5wiXGV5puuz96Mpgg2GVLbCFCDXz3A78KvEioCt
	 iQq9psXVwDaK26VY89XC/z2s53aZv22pDTl2ArUZCcocZmrHVtMQulPA6DSa27zZfb
	 64PWIWfbXw7NQUBun+6KQkmG+G0QbX2iOIfXUH+fx/2yAz379lJ8Oolx40oe+Ds+2d
	 QZuaf4vLTVn7kONX8NAqX60DEvozAHnmxeNNMpsUeo9c7UwnQdUwM8hQE+VmaxC1mm
	 u3jJhq3IvEC7w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5D7C660077;
	Fri, 18 Sep 2026 13:28:59 +0200 (CEST)
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
Subject: [PATCH net 8/8] netfilter: nf_tables: skip expired catchall elements on insert and delete
Date: Fri, 18 Sep 2026 13:28:44 +0200
Message-ID: <20260918112844.194503-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918112844.194503-1-pablo@netfilter.org>
References: <20260918112844.194503-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

nft_setelem_catchall_insert() looks up duplicates with
nft_set_elem_active() only, while nft_set_catchall_lookup() and the
dump path additionally skip expired elements.

Once a catchall element with a timeout expires, this predicate drift
makes it invisible to userspace dumps, yet it still blocks
re-insertion: with NLM_F_EXCL the request fails with -EEXIST, and
without it the request reports success but silently inserts nothing.
The stale entry only goes away when the (user-tunable) gc interval
elapses, so the catchall rule may silently stop matching for an
arbitrarily long time after its first expiration.

The delete path shows the same drift: nft_setelem_catchall_deactivate()
picks the first active-next entry in the catchall list, so with an
expired entry still pending GC it retires the stale entry instead of
the fresh one, and it deactivates an element that userspace no longer
sees instead of failing with -ENOENT.

Align both walks with the lookup and dump predicates: only an element
that is active and not expired counts as a duplicate or delete
candidate, using the per-netns timestamp taken at transaction start,
in line with the set backend .insert/.deactivate and catchall GC sync
paths.

Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c0b754a2d45b..b59628e6240c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6995,11 +6995,14 @@ static int nft_setelem_catchall_insert(const struct net *net,
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (nft_set_elem_active(ext, genmask)) {
+		if (nft_set_elem_active(ext, genmask) &&
+		    !__nft_set_elem_expired(ext, tstamp) &&
+		    !nft_set_elem_is_dead(ext)) {
 			*priv = catchall->elem;
 			return -EEXIST;
 		}
@@ -7092,11 +7095,14 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
 					   struct nft_set_elem *elem)
 {
 	struct nft_set_elem_catchall *catchall;
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_is_active_next(net, ext))
+		if (!nft_is_active_next(net, ext) ||
+		    __nft_set_elem_expired(ext, tstamp) ||
+		    nft_set_elem_is_dead(ext))
 			continue;
 
 		kfree(elem->priv);
-- 
2.47.3

