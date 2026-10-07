Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE4535675E
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 22:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791410646; cv=none; b=lee48ROvhGLBZfMOxykM5StTa+AI58fiHe7FcLegmon3ljA1T45fBFEO/UaU3s0OJvSPYmpHzgT3y1uqaDPOom2yNlWRBp9yrLZK8rHBikPywNCtX5Y/he/H8hWqM2RFjfy74s7IkXFCyPxFSccA2kkpMCytpKkO1XEr9PqK9Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791410646; c=relaxed/simple;
	bh=n3bDD1rSMAm7VXkGsY5p2kNrMofAAqj3d3bwyvytJn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b+lhCwONhfmZqfbqkETzcvVHWIjXXqsrUuZjrEgfIhIfPxV3bA8WyxvURKNZTWAUcKM2fqKP5/IAHLKMFaFs45K/oNJ1wj9lfE+IXIt8sRbGRoL3RxgBylnkpqE9nSNtYdXoZrZzTaM9xxyjlU4F8rAk001qpkgiIdker12PlGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IyfrpkCR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IyfrpkCR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791410641;
	bh=N7wdCIlBmKecXFUFL0GyP3ogy7z1fmCaWmvlPSAKv7k=;
	h=From:To:Cc:Subject:Date:From;
	b=IyfrpkCR82Le7NhNhWalP48jZW2sW42xlBgZB4+cJy4J9oytSIAsitskdgjJVp882
	 CNei3ZnsxaH2QMQvdUALmniUbBLjAPhAOo/v3s/2eVXdZY1OaOYfRDxn/5nKg6AxjT
	 ejUkEZJ5+FEzCjPZE4e+iX1JJxWzjbiG6ZQ8xIYP1gjaTwkrKgwxOJp9L4bk/8FTe0
	 0DrGaU8ML13BwLmgGqMwCa67L+w9Md9j1IZvf405677xaY4Xrec8ECx3SbQrhYx5lg
	 K7bgUDQfeb7BdSNszzlCGwRTwNmj4WAwdeZzl2hRE56ViNgWoHgca0LZ6vzJMmAA57
	 DaN1efxBUtGAA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A95AF60051;
	Thu,  8 Oct 2026 00:04:01 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Jeremy.Jean@oss.cyber.gouv.fr
Subject: [PATCH nf] netfilter: nft_set_rbtree: narrow down range completion to anonymous sets
Date: Thu,  8 Oct 2026 00:03:58 +0200
Message-ID: <20261007220358.1140284-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For anonymous sets, when adjacent ranges are found, the end element is
not added to the set to pack the set representation. Use next start
element to complete this interval.

Jérémy Jean says:

Consider two ranges in a netfilter verdict map:
* keys 10-19 accept packets, and
* keys 30-39 jump to chain 'victim'.
Now, delete the end marker at 20. The lookup array now uses element 30
as the first range's end, so an INTERVAL_END query for key 15 returns
element 30, including its jump verdict and chain pointer. This can make
KASAN reports a UAF after the GC releases reference chain for 30 that
has expired:

  BUG: KASAN: slab-use-after-free in nft_verdict_dump+0xdd/0x110
  Read of size 8 at addr ff110000009dfb58 by task repro/50
  ...
  Call Trace:
  ...
   nft_verdict_dump+0xdd/0x110
   nft_data_dump+0x4d/0x80
   nf_tables_fill_setelem+0x30b/0x8a0
   ? __asan_memcpy+0x3c/0x60
   nf_tables_fill_setelem_info+0x1b0/0x200
   nft_get_set_elem+0x3fd/0x4b0
  ...
  Freed by task 24:
  ...
   kfree+0x1a5/0x280
   nf_tables_trans_destroy_work+0x2cb/0x520

Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
Reported-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/netfilter-devel/20261005200404.3544062-2-Jeremy.Jean@oss.cyber.gouv.fr/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 12431b55752f..fbe1750f1ca2 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -1091,7 +1091,8 @@ static void nft_rbtree_commit(struct nft_set *set)
 		 * representation. Use next start element to complete this
 		 * interval.
 		 */
-		if (nft_rbtree_interval_start(rbe) &&
+		if (nft_set_is_anonymous(set) &&
+		    nft_rbtree_interval_start(rbe) &&
 		    nft_rbtree_interval_start(prev_rbe) &&
 		    priv->array_next->intervals[num_intervals].from)
 			priv->array_next->intervals[num_intervals++].to = &prev_rbe->ext;
-- 
2.47.3

