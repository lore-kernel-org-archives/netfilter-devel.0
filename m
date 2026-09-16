Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E31511E6D;
	Wed, 16 Sep 2026 23:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600633; cv=none; b=B3kVqiDOnQAljbqrpw2heo1xm3PlwZHYs1fgmcVgXFjp3s1hsf2e8VqoyhT3Gi0aHudlIB/Q+ieSl1S2jIiEPD8dCG2b8Hh2o0FnIj1+MbDdzYM4SQ7aUJntbZ/947KySZ95luk+rRWH0yumr49bu1Qbo4fZSOvOWx29Y3lyGUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600633; c=relaxed/simple;
	bh=HP6jvkLTNPWJSxMRYllXLi3lU1kcG6cheH3+0moBigU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU1r81UxKaDW7lnDEQ+YASJ9Dico7r+n2f7WmIverfzLf4xqpeHw2ip8mNU7xsmIJZKqH9GdhM4VFvHhY8SiOuSkT4xQAIX8e4VL6uo5fGOfTabGjpkLRt7tuaNUUug8UnVYw9QJF5uEd6qOKQ1TxnhzPWgTVizCeJSZAH4I6hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EdSGu14x; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EdSGu14x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789600629;
	bh=6pOicZ8zYe8k4VWuQf94VKWEZW9lQx64+l2rkDKAYD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdSGu14xYNVqnZ8fIdzbHjU9xeqfYThxA2dalwIFkL1ZudmaFA0yT/4alWBDJv1gi
	 8HfbZcLhZ2HghfHnhycES3WU/ETZNqmt3yEqSuZe9bKgpFPAag6jZOft41CgRnh+x3
	 7dYYtwBgSMxdEHSOFJQoppNITGrlYosn19JKXzZRloEnirhqZn2c9OpQTeJhb2h8J4
	 PYw1S8omN1/Gu733ienwPx8iHWf/rKBsIAfN+xbStnrlgiIt1tX00UmAMzFUDLudY9
	 Hp2v5tPUH/J4lbc07JtJgpjNLZYEBZJAT2WsBAOi0ipze3pZ66tDNb2eW8fp4xB2JF
	 3thpyKYovN4aw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 57C0D60088;
	Thu, 17 Sep 2026 01:17:09 +0200 (CEST)
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
Subject: [PATCH net 10/10] netfilter: nf_tables: skip expired catchall elements on insert and delete
Date: Thu, 17 Sep 2026 01:16:51 +0200
Message-ID: <20260916231652.127456-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916231652.127456-1-pablo@netfilter.org>
References: <20260916231652.127456-1-pablo@netfilter.org>
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
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c0b754a2d45b..800efb4d91eb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6995,11 +6995,13 @@ static int nft_setelem_catchall_insert(const struct net *net,
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (nft_set_elem_active(ext, genmask)) {
+		if (nft_set_elem_active(ext, genmask) &&
+		    !__nft_set_elem_expired(ext, tstamp)) {
 			*priv = catchall->elem;
 			return -EEXIST;
 		}
@@ -7092,11 +7094,13 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
 					   struct nft_set_elem *elem)
 {
 	struct nft_set_elem_catchall *catchall;
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_is_active_next(net, ext))
+		if (!nft_is_active_next(net, ext) ||
+		    __nft_set_elem_expired(ext, tstamp))
 			continue;
 
 		kfree(elem->priv);
-- 
2.47.3

