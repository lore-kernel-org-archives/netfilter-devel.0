Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B748124E;
	Mon, 20 Apr 2026 13:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691899; cv=none; b=u2PoNRFJmFGHp3Ri8Rj6H51ssadyQ0VoAZl3E4VYQkWbpXct12g+5vDipZ09Jmt8szUkzxGmJMsHxOCqX+OI2HnuzaqVn4+tjV3jTvV/sgK32cTiQQhC+WjPfTHl8eDUObka8K/RBzXEnCTGz2eaoGcnFwkEXxmQf54pj/5mQug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691899; c=relaxed/simple;
	bh=sUSLvh693OL3obP0CWu4hreToBFRqSn+nA03HkUj3Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GD4lkehWt7ZoRY8k0BRsE2cP3UQgigKiFkze7zncG06c6PWDXTkWjxmkENogO8/KmwTNNFc27jsZStDpFIbq9ZSsP7IHtfmr2zyjD+noYi/6I4pb8fcVk9t3+jkJNG4PrhYQVSAK5KEl12tyjvTvKkxDy3BN6kHhekLima25S7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umE1FY00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umE1FY00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D58C19425;
	Mon, 20 Apr 2026 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691899;
	bh=sUSLvh693OL3obP0CWu4hreToBFRqSn+nA03HkUj3Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umE1FY00DD52eek2CQUkZCTL4eHBhDPujnxowvj0aM1Kx9n0mJQ1aNJ9BI8uH4D4l
	 QcsaewJavw/0OXgySoTpZOVdxEf/UHPEmezGGonI+Rjw1D3yr6tfQlG4wx21s+Kur/
	 j8E7eeYnYSKu+qxK0t98Byhq16/t1vWamfrEklYgw9/8Mcap2FhVmrPYjsfAl1oM7X
	 wekIFtjOS3m6twU/Z0KC0yeLi+HXzWdQksBfW7pimOQA+Mmb0oyQeO8xIOuuww2o5/
	 kcYc/ds62TqYgYHyjyu11Uhy5H1oErvS5D24LwTPH0ntxjo41hdMFzoE0s8WvQixnu
	 b5e35cYSHwCxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] netfilter: nft_set_pipapo_avx2: don't return non-matching entry on expiry
Date: Mon, 20 Apr 2026 09:20:52 -0400
Message-ID: <20260420132314.1023554-258-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d3c0037ffe1273fa1961e779ff6906234d6cf53c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/netfilter/nft_set_pipapo_avx2.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 7ff90325c97fa..6395982e4d95c 100644
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
2.53.0

