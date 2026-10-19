Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422190;
	b=lRum0xNN83Jeq3ltMnIBqmONRMi72bmgJZUo4yqN5sISvnG+WPBtn4XA8z/pJvX56UEF
	 JHOlc4QsOVXwhL+O33J6XfSNy/cZQ1JrmnphZOtj53l2N0ekUR9mTvyJ8598UMZUNcsDg
	 mfaA7M8Aj8jW4LkPci8XJJ4g+EU+TpOz7KTfmNOvT2Oil/4gZYGuNSHTiLjMv3mkRP+/z
	 oZa3RzTSEEHnDrRNZiGgS050RmrQS7h0BSfW1WCogPBAoqglqSgg1pFljnUW63s1OmSDX
	 I24Ab19WAJ0NQsG3GDThWjGW/0qkwEqu0K/9WoVoLaPqTZSibahipJTyZql3eDynkpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422190;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=N7wdCIlBmKecXFUFL0GyP3ogy7z1fmCaWmvlPSAKv7k=;
	b=zAofyEUnv9NHTmFFv/vf7Hq1g+fyu1iE2GJN2WwLbZaHnF8go76ll+g6NHi5uUoVP2w/
	 cuiMR+G89q02TihOuN7ngUHxkNNRukh+oV3G0M4bal5dVZAD4xE+MHagq2BRyhH3NETGk
	 E6ALCeHLZucb8g7O5ztgFv3lUlEG+82d7ywQHiKOlfe6N3tKiIsiX4L6r9kDCvQY0/TNz
	 qP2iBZP64756nMW/w5Ir1jK5deaQVhlx+bkQ0expozwB9xqv5BGuvLtIYHTZjcu1w/kAY
	 biHK8CgV16aQycZccGCLr9aO3UHwTcGTaxt4E9m2SFSgu6LYB6RtBdkdDOrWdwBO21Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=UpACSvGt;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4462607D35E;
	Mon, 19 Oct 2026 15:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4462607D35E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=UpACSvGt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422188;
	bh=N7wdCIlBmKecXFUFL0GyP3ogy7z1fmCaWmvlPSAKv7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpACSvGtgCaN1fRC5RQ/+uTo8GirRZhAd+++dh3Bi6SZ3UnmJQxNofEU1uRL64UnI
	 PWj5XbgHhSQsXnPeYbLBO8h12vfPkBBsMZE1KyN2gpnt3P5DKzUPIcJ1Kc7YxJzSQc
	 M3Dyes+gIq39Lsw3v+aid2RzVf8K22ussXy/416qKHmY92LSm0N6xuTKmXi0fmIi/w
	 pEgEWAEO0eLaIfTXuiLjC5qRd7Lfjo38kWV4S2g7Jspu6naUWsVF6wx8Cl9o0y4x5f
	 HzpECdfrr0yDBEYDKlycOKCLDQJuTv+xZr/Y0autuyEjS9iQZxMJNd2QmVWdpQ/z/o
	 dzmTF8GIpBcAA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7F41E6005C;
	Mon, 19 Oct 2026 17:03:07 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 07/10] netfilter: nft_set_rbtree: narrow down range completion to anonymous sets
Date: Mon, 19 Oct 2026 17:02:46 +0200
Message-ID: <20261019150249.1879516-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019150249.1879516-1-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
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

