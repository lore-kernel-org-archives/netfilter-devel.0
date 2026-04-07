Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1F53B9607;
	Tue,  7 Apr 2026 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571386; cv=none; b=ATByn40F2M6zR1BnfOJtk+B0bxPLROjufeCemHXqMgAxX4A7SQtEZFglxssPud6VmmEj35A0pdjarYr22kqNT3G5KW4yRyfqUMfoGMgOvoHyTrR1oj5d8EJLDE+Q6H9OcVQZ8nJzOP8GO9ZGbEv4GqwuBhGze9zvEw28bbVOz4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571386; c=relaxed/simple;
	bh=erd96RASErcinQKBm372hH9mr8X45YdCi0pQxfNnJrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8g+t+l7hAncRJV9ecWSA4mOTQMx8biiPFptV98J+ZLMNfnUZnpIdGhwbwZNA149+LMacxMqEUKT69BHQoU+zhbFOEspeYvYdoAeNnYTMGrkX1YSOZ+xW9qM1OsfoZmQzicEnr2HKLuPnyPW+FVN5vRDlDImowoPCTCQVmjBPdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 32D6360670; Tue, 07 Apr 2026 16:16:24 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 09/13] netfilter: nft_set_pipapo_avx2: remove redundant loop in lookup_slow
Date: Tue,  7 Apr 2026 16:15:36 +0200
Message-ID: <20260407141540.11549-10-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260407141540.11549-1-fw@strlen.de>
References: <20260407141540.11549-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_pipapo_avx2_lookup_slow will never be used in reality, because the
common sizes are handled by avx2 optimized versions.

However, nft_pipapo_avx2_lookup_slow loops over the data just like the
avx2 functions.  However, _slow doesn't need to do that.

As-is, first loop sets all the right result bits and the next iterations
boil down to 'x = x & x'.  Remove the loop.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 32 ++++++++---------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 6395982e4d95..dad265807b8b 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1041,7 +1041,6 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
  * @map:	Previous match result, used as initial bitmap
  * @fill:	Destination bitmap to be filled with current match result
  * @f:		Field, containing lookup and mapping tables
- * @offset:	Ignore buckets before the given index, no bits are filled there
  * @pkt:	Packet data, pointer to input nftables register
  * @first:	If this is the first field, don't source previous result
  * @last:	Last field: stop at the first match and return bit index
@@ -1056,32 +1055,19 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 static int nft_pipapo_avx2_lookup_slow(const struct nft_pipapo_match *mdata,
 					unsigned long *map, unsigned long *fill,
 					const struct nft_pipapo_field *f,
-					int offset, const u8 *pkt,
+					const u8 *pkt,
 					bool first, bool last)
 {
-	unsigned long bsize = f->bsize;
-	int i, ret = -1, b;
-
 	if (first)
 		pipapo_resmap_init(mdata, map);
 
-	for (i = offset; i < bsize; i++) {
-		if (f->bb == 8)
-			pipapo_and_field_buckets_8bit(f, map, pkt);
-		else
-			pipapo_and_field_buckets_4bit(f, map, pkt);
-		NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
-
-		b = pipapo_refill(map, bsize, f->rules, fill, f->mt, last);
+	if (f->bb == 8)
+		pipapo_and_field_buckets_8bit(f, map, pkt);
+	else
+		pipapo_and_field_buckets_4bit(f, map, pkt);
+	NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
 
-		if (last)
-			return b;
-
-		if (ret == -1)
-			ret = b / XSAVE_YMM_SIZE;
-	}
-
-	return ret;
+	return pipapo_refill(map, f->bsize, f->rules, fill, f->mt, last);
 }
 
 /**
@@ -1201,7 +1187,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 16);
 			} else {
 				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
-								  ret, data,
+								  data,
 								  first, last);
 			}
 		} else {
@@ -1217,7 +1203,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 32);
 			} else {
 				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
-								  ret, data,
+								  data,
 								  first, last);
 			}
 		}
-- 
2.52.0

