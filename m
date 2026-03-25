Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3384C355F39;
	Wed, 25 Mar 2026 22:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477594; cv=none; b=prUXSaEY9VQyxD6+4zzvWV19T6EXhRa29/jMLA41Xb7oauXc+kbeAPtUN0eLFv0RRDyU9bQ7+8Sg9wPhMkrA9tSEjW6btIZEtaAkMo7AIDFl/VL2Zi+49fgLjY+aZ2kyEQYynAHecOh+1wqZY+BtqSBX1DvErxRMIC/igezDxSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477594; c=relaxed/simple;
	bh=B/PR3ro6kDm/h1WL2reV58k4U8UyFxrpi+1XRIXQgsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLdLciTMqNAyVUZlAC9dcA5/EtjD/tPFvVMXGz/HLFT0fJQa6TgbtMdk1as0IwVHxTJLA8L8OPh9gWqY4h32fDRQUy9aDzfVYYQH8waktODcNC84XafMXJIL5sLObOO61wyZ1Bj4oJvbJC0bZmLY48y+BgI2RtuncO6N8ECQMGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PzXLCM6S; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PzXLCM6S"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E7E1F6017A;
	Wed, 25 Mar 2026 23:26:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477585;
	bh=zNhPcQvv9ix+U6mE34OvR0ov6W+xNh0ysGj3Uq+7CXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzXLCM6SCEykoChxK53aUNgWuWKlxh05ECyVjY5eyDUTWhxr9Z0ZzMMELICX8fJVg
	 PqFWkso7p5/LDUjOKojxEfldQOS2ASnRpo+rFezaqPLzt4+rJbv68ILOmlPKO1kUcr
	 K7emFu0p5wW6Epegj/z5f3R8c/KutGWkeR43I/gVdjUsvfPQ8X9RfiLbN0npB9qXBt
	 KrgOcw4ulGu9n9k9RCA8xGxfHLMj2+Nvvmo2I/3QUZUHrRW/rHaZb8oZo2FlswJpRY
	 t1nKGu7edkivpJ/S0fwP3kzjjvTAM+2AZmx4QkFqSwx20NMomU+cVPRKi16BUdNhkE
	 uafRB7WuewlCg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/14] netfilter: nft_set_pipapo_avx2: don't return non-matching entry on expiry
Date: Wed, 25 Mar 2026 23:26:02 +0100
Message-ID: <20260325222615.637793-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

New test case fails unexpectedly when avx2 matching functions are used.

The test first loads a ranomly generated pipapo set
with 'ipv4 . port' key, i.e.  nft -f foo.

This works.  Then, it reloads the set after a flush:
(echo flush set t s; cat foo) | nft -f -

This is expected to work, because its the same set after all and it was
already loaded once.

But with avx2, this fails: nft reports a clashing element.

The reported clash is of following form:

    We successfully re-inserted
      a . b
      c . d

Then we try to insert a . d

avx2 finds the already existing a . d, which (due to 'flush set') is marked
as invalid in the new generation.  It skips the element and moves to next.

Due to incorrect masking, the skip-step finds the next matching
element *only considering the first field*,

i.e. we return the already reinserted "a . b", even though the
last field is different and the entry should not have been matched.

No such error is reported for the generic c implementation (no avx2) or when
the last field has to use the 'nft_pipapo_avx2_lookup_slow' fallback.

Bisection points to
7711f4bb4b36 ("netfilter: nft_set_pipapo: fix range overlap detection")
but that fix merely uncovers this bug.

Before this commit, the wrong element is returned, but erronously
reported as a full, identical duplicate.

The root-cause is too early return in the avx2 match functions.
When we process the last field, we should continue to process data
until the entire input size has been consumed to make sure no stale
bits remain in the map.

Link: https://lore.kernel.org/netfilter-devel/20260321152506.037f68c0@elisabeth/
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 7ff90325c97f..6395982e4d95 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -242,7 +242,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -319,7 +319,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -414,7 +414,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -505,7 +505,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -641,7 +641,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -699,7 +699,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -764,7 +764,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -839,7 +839,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -925,7 +925,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -1019,7 +1019,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
-- 
2.47.3

