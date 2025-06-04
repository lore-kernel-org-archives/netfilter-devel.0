Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F7F12B73;
	Wed,  4 Jun 2025 00:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998662; cv=none; b=JSHnlnUWNcWi/Dz8Tmnyrf6rW7pylTKJ0wce/OeKOQ1H7yt8wX6pbYjY9WRolzly/EwwhatnCDiCkaCrWI8q1ueDkmGpJmaN1hPrETV95WMh7rfVsiVQX0YbgPsaseni+REimG2j3Ac8WP6jPlMov1qMfI1wVyo7nfBsS22X2es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998662; c=relaxed/simple;
	bh=Jr9MwdDprcQ+Crks6HijpDIg2s9H+OgSY2RNAPf+0JQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phwbJe/1t52U2JLdK+0R1Rw5myaHMXaCn7LyOTidXRfgci/zlLmjfEM+RjXT05lfRpqL01MLVzktMJnRaJ9EhQxyeHzhd2qv8zvT/gAo5TbtO4tAhGAJePqeoUNB0UxISyzKcNUIL0yBsWWa8FfXdilFl8FKg93qMid5ZgHCobM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=innMIEMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="innMIEMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA54C4CEED;
	Wed,  4 Jun 2025 00:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998662;
	bh=Jr9MwdDprcQ+Crks6HijpDIg2s9H+OgSY2RNAPf+0JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=innMIEMeUAtKDGPa6rTk7tZwVI6mlyE1CYj8+OFj6CZjtWV/6dlhRHgjmoiOAbhrH
	 4IEPzCb8CKqy7YNgsT6ryJswPfV84mjVdipGR6DAniVDqKnGJOQR0gA1PJD81mNcQo
	 uvGH9RdzrpdYXcoAIz5lFa++/M/NfMVHbHODHQsAo5N+4mLqX0amnjwniaEA0IJglM
	 guRgfKK+6bVruJcGnER8+XFcQNkdtNmbxJrGfCu3JwMAB2i1ARnzI1IRLpELGaDNm/
	 6thTG2VEbVPB70e1wGBJz6vrdXdAZnZWqIX/wgDHlEmEAUvhrqkzf32fuLVkgpVZ4Y
	 UmBxXtnuBFLaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH AUTOSEL 6.14 063/108] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
Date: Tue,  3 Jun 2025 20:54:46 -0400
Message-Id: <20250604005531.4178547-63-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b85e3367a5716ed3662a4fe266525190d2af76df ]

Otherwise, it is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof()
when resizing hashtable because __GFP_NOWARN is unset.

Similar to:

  b541ba7d1f5a ("netfilter: conntrack: clamp maximum hashtable size to INT_MAX")

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and kernel context, here is my
assessment: **YES** This commit should be backported to stable kernel
trees. Here's my extensive analysis: ## Analysis of the Commit **1.
Nature of the Fix** This commit addresses a kernel warning/crash
prevention issue in the netfilter nft_set_pipapo subsystem. It adds
`INT_MAX` bounds checking to prevent oversized `kvmalloc_array()` calls
in two functions: - `pipapo_realloc_mt()` (line 666): `if (rules_alloc >
(INT_MAX / sizeof(*new_mt)))` - `pipapo_clone()` (line 1505): `if
(src->rules_alloc > (INT_MAX / sizeof(*src->mt)))` **2. Root Cause and
Impact** The commit prevents `WARN_ON_ONCE` triggers in
`__kvmalloc_node_noprof()` when `__GFP_NOWARN` is unset during kvmalloc
operations. This is similar to commit `b541ba7d1f5a` which fixed the
same issue in `nf_conntrack_core.c`. The kernel warning infrastructure
change in commit `0708a0afe291` ("mm: Consider __GFP_NOWARN flag for
oversized kvmalloc() calls") made these warnings more prominent and
exposed this issue. **3. Code Analysis** The changes are minimal and
surgical: - **pipapo_realloc_mt()**: Adds a single check before
`kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL_ACCOUNT)` on
line 669 - **pipapo_clone()**: Adds a single check before
`kvmalloc_array(src->rules_alloc, sizeof(*src->mt), GFP_KERNEL_ACCOUNT)`
on line 1508 Both functions return appropriate error codes (`-ENOMEM`)
when the size limit is exceeded, maintaining existing error handling
patterns. **4. Risk Assessment - Very Low** - **Minimal code change**:
Only adds safety checks, doesn't modify core logic - **Fail-safe
behavior**: Returns error instead of potentially triggering
warnings/crashes - **Well-established pattern**: Mirrors similar fixes
in the same subsystem (`nf_conntrack_core.c`, `x_tables.c`) - **No
functional change**: Normal operations under `INT_MAX` limits are
unaffected **5. Alignment with Stable Tree Criteria** - ✅ **Fixes
important bugs**: Prevents kernel warnings and potential system
instability - ✅ **Small and contained**: Two single-line additions with
clear bounds checking - ✅ **Minimal regression risk**: Only adds safety
limits, doesn't change behavior - ✅ **Critical subsystem**: Affects
netfilter, which is core network filtering infrastructure - ✅ **Clear
fix pattern**: Follows established pattern from similar commits that
were backported **6. Comparison with Historical Similar Commits**
Looking at the provided reference commits, this aligns perfectly with
commits marked "YES" for backporting: - Similar to "netfilter:
conntrack: clamp maximum hashtable size to INT_MAX" (Status: YES) -
Similar to "netfilter: nf_tables: Fix oversized kvmalloc() calls"
(Status: YES) - Similar to "netfilter: nf_tables: fix out of memory
error handling" (Status: YES) **7. User Impact** Users with systems that
trigger large netfilter set allocations would benefit from this fix, as
it prevents kernel warnings that could indicate system problems and
potential instability. **Conclusion**: This is a clear, low-risk
stability fix that prevents kernel warnings in a critical networking
subsystem. It follows established patterns and should be backported to
ensure system stability across kernel versions.

 net/netfilter/nft_set_pipapo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7be342b495f5f..efbe2f027cab4 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -663,6 +663,9 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	    check_add_overflow(rules, extra, &rules_alloc))
 		return -EOVERFLOW;
 
+	if (rules_alloc > (INT_MAX / sizeof(*new_mt)))
+		return -ENOMEM;
+
 	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL_ACCOUNT);
 	if (!new_mt)
 		return -ENOMEM;
@@ -1469,6 +1472,9 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
 		if (src->rules > 0) {
+			if (src->rules_alloc > (INT_MAX / sizeof(*src->mt)))
+				goto out_mt;
+
 			dst->mt = kvmalloc_array(src->rules_alloc,
 						 sizeof(*src->mt),
 						 GFP_KERNEL_ACCOUNT);
-- 
2.39.5

