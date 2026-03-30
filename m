Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862983D47BB;
	Mon, 30 Mar 2026 12:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874350; cv=none; b=cSPVEhRmXjGTzLznkhtJEepvl+9e9RLqlDt0MmirzAJeZYNbCAT8L/5XqA8nCaVnz2i3V30a/9uidyFUN2h5LcsBesUqdUfRQfkKQ2qidUdeHT0LiZ+U5APLKxPGenqCuKAMnormamKdIfjUoek4D3IMomn4OWqk35DiWp1bCAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874350; c=relaxed/simple;
	bh=UVpgCV1aTySU0IUWgQUSPmO//Fid8a2xLvaG6hbweyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UCPVH95ZQfRi5pM8S4LNmI1Wf3S2WtMKLXDya4wWdECJuXS0IQ0qSAZkfVEkebmx9DTqaWEm8+9HdSmARbkgg6u7jCu7/sFN9v72D2IsDnTQdCEWmiuLgWmZxk4jFjAXDpzUkqHsYtPbJZHKAC58PRSTimirWr3lLMeG8dp6kAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkqGAS8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkqGAS8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0765AC4CEF7;
	Mon, 30 Mar 2026 12:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874350;
	bh=UVpgCV1aTySU0IUWgQUSPmO//Fid8a2xLvaG6hbweyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkqGAS8tDl/9pPvSn6Vr8GK/RT/BzFnwC/BvZuW9VH8go4uFIhRyHcgZjw3DM81lS
	 iC5UVcsWYzgPIcy0SD5XfevtWGqRobMyNa752q1pzH8DZB5rSi1CxT1NlwOWgum87a
	 JIgjf0gB8CrBf92H3ZYmhLHhytocQ8Fbrl7WQXiJwa1m3mWs7Ecwma6+1JYy6dAfzV
	 Svvm1E5FvcJLBrP0N4Fqy7tNQY0xf5s0KvOurOnv97kPIHfwRZt4d9437AGa7AyeOr
	 ITy6+ALV9szz0rA2LStK6wf6Dd9sw2H3ia2xwM3S14uQt40ZMXjYCcBVWPitkWlAWa
	 F6M3mbQk+4JhA==
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
Subject: [PATCH AUTOSEL 6.19-5.10] netfilter: nft_set_pipapo_avx2: don't return non-matching entry on expiry
Date: Mon, 30 Mar 2026 08:38:32 -0400
Message-ID: <20260330123842.756154-19-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
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

All verified. Now I have the complete and verified picture. Let me write
the final answer.

===============================================================
## PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: Subject Line**
Record: [netfilter: nft_set_pipapo_avx2] [don't return / fix] [Prevent
AVX2 pipapo lookup helpers from returning a non-matching entry when an
expired/invalid element is skipped]

**Step 1.2: Tags**
Record:
- Link: `https://lore.kernel.org/netfilter-
  devel/20260321152506.037f68c0@elisabeth/`
- Signed-off-by: Florian Westphal `<fw@strlen.de>` (author, netfilter
  maintainer)
- Reviewed-by: Stefano Brivio `<sbrivio@redhat.com>` (original author of
  pipapo AVX2 implementation)
- Signed-off-by: Pablo Neira Ayuso `<pablo@netfilter.org>` (netfilter
  subsystem maintainer)
- No Fixes: tag (expected for manual review)
- No Reported-by: tag
- No Cc: stable (expected for manual review)
Notable: Reviewed by the original pipapo AVX2 code author — strong
correctness signal for this specialized code.

**Step 1.3: Commit Body Analysis**
Record: [Bug: After flushing and reloading a pipapo set with multi-field
keys (e.g., `ipv4 . port`), the AVX2 code incorrectly reports element
clashes] [Symptom: `nft -f` fails with clash error on valid set reload]
[Root cause: Early `return b` in AVX2 helper functions when processing
the last field causes the loop to exit before all 256-bit map chunks are
processed, leaving stale bits from previous field matching. When an
expired/inactive element is skipped via `pipapo_refill()`, those stale
bits produce matches based only on the first key field, returning
incorrect elements] [Bisection points to 7711f4bb4b36 which merely
exposed the bug]

**Step 1.4: Hidden Bug Fix Detection**
Record: Not hidden — the commit message explicitly describes a concrete
bug with a clear reproducer and root-cause explanation.

===============================================================
## PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: Inventory**
Record: Single file changed: `net/netfilter/nft_set_pipapo_avx2.c`. 10
identical one-token changes across 10 functions:
`nft_pipapo_avx2_lookup_4b_{2,4,8,12,32}` and
`nft_pipapo_avx2_lookup_8b_{1,2,4,6,16}`. Each changes `return b;` to
`ret = b;`. Scope: single-file surgical fix.

**Step 2.2: Code Flow Change**
Record: For each of the 10 hunks: Before — when processing the last
field (`last == true`) and a match is found via
`nft_pipapo_avx2_refill()`, the helper immediately returns `b`, skipping
processing of remaining 256-bit chunks. After — the match index is
stored in `ret` and the loop continues via `continue`, processing all
remaining chunks (clearing/updating the map for each). The function
returns `ret` at the end of the loop (line unchanged). This ensures the
full bitmap is consistent before the caller uses it.

**Step 2.3: Bug Mechanism**
Record: [Category: Logic/state correctness bug in bitmap processing] The
AVX2 helpers process the result map in `m256_size` chunks. When the last
field is being processed and a match is found in chunk `i`, the early
`return b` skips chunks `i+1`, `i+2`, etc. Those chunks retain stale
bits from the previous field's matching. When `pipapo_get_avx2()` (line
1240-1244) finds the matched element is expired/inactive and calls
`pipapo_refill()` on the same `res` map, those stale bits are found and
return incorrect matches that match only on a subset of key fields. The
generic C path and `nft_pipapo_avx2_lookup_slow` don't have this issue
because they process the full map in one pass.

**Step 2.4: Fix Quality**
Record: Obviously correct — mechanical, identical change across all 10
helpers. The loop simply continues processing remaining chunks (which is
already the behavior for non-last fields). Reviewed by the original AVX2
implementation author (Stefano Brivio). No public API changes.
Negligible regression risk — marginally more SIMD iterations when `last`
is true, but this is the correct behavior.

===============================================================
## PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: Blame**
Record: `git blame` confirms all buggy `if (last) return b;` lines were
introduced by commit `7400b063969bd` (Stefano Brivio, 2020-03-07) —
"nft_set_pipapo: Introduce AVX2-based lookup implementation", first in
v5.7-rc1. The bug has existed since the original AVX2 pipapo code was
written.

**Step 3.2: Fixes Tag**
Record: No explicit Fixes: tag. The commit body references
`7711f4bb4b36` ("fix range overlap detection") as the commit that
exposed the bug (by changing duplicate comparison from
`sizeof(*dup_key->data)` to `set->klen`). Verified: `7711f4bb4b36` first
appeared in v6.19-rc5, and has been backported to v6.18 stable (as
`704c0258f0d79`).

**Step 3.3: File History and Related Changes**
Record: The critical prerequisite chain is:
1. `416e53e395167` (v6.18-rc1) — Split `nft_pipapo_avx2_lookup()` into
   `pipapo_get_avx2()` helper + thin wrapper. Created the shared AVX2
   lookup function.
2. `84c1da7b38d9a` (v6.18-rc1) — Made control-plane `pipapo_get()`
   dispatch to `pipapo_get_avx2()` when AVX2 is available. Made
   `pipapo_get_avx2()` non-static.
3. `5823699a11cf3` (v6.18-rc1) — Fixed expired-entry retry from full-
   loop restart to `pipapo_refill()` on existing map. This is the commit
   that makes stale bits in the map a real problem — because now
   `pipapo_refill()` operates on the existing `res` map which has stale
   bits left by the early-returning helpers.

**Step 3.4: Author Context**
Record: Florian Westphal is a netfilter maintainer. Stefano Brivio
(reviewer) is the original pipapo AVX2 author. Pablo Neira Ayuso (co-
signer) is the netfilter subsystem maintainer.

**Step 3.5: Dependencies**
Record: The fix itself is self-contained and applies cleanly. However,
the bug is only reachable in trees that contain all three prerequisites
(`416e53e395167`, `84c1da7b38d9a`, `5823699a11cf3`). Verified via `git
merge-base --is-ancestor`:
- v5.15: none present (exit code 1)
- v6.1: none present (exit code 1)
- v6.6: none present (exit code 1)
- v6.12: none present (exit code 1)
- v6.18: all present (exit code 0)
- v6.19: all present (exit code 0)

===============================================================
## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: Patch Discussion**
Record: Direct lore.kernel.org fetch blocked by Anubis anti-bot
protection. The Link: tag points to the netfilter-devel discussion.

**Step 4.2: Bug Report**
Record: Bug was found via a new test case (described in the commit
message), not via an external bug report. The test exercises
flush+reload of pipapo sets with multi-field keys.

**Step 4.3: Related Patches**
Record: This is patch 1 of a 2-patch series. Patch 2 adds a regression
selftest (`selftests: netfilter: nft_concat_range.sh`). The code fix is
standalone.

**Step 4.4: Stable Discussion**
Record: Could not search lore stable archives due to access
restrictions. No evidence found of prior stable discussion.

===============================================================
## PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: Functions Modified**
Record: 10 AVX2 lookup helpers: `nft_pipapo_avx2_lookup_{4b_2, 4b_4,
4b_8, 4b_12, 4b_32, 8b_1, 8b_2, 8b_4, 8b_6, 8b_16}`.

**Step 5.2: Callers**
Record: All 10 helpers are called from `pipapo_get_avx2()` via the
`NFT_SET_PIPAPO_AVX2_LOOKUP` macro (lines 1186-1222).
`pipapo_get_avx2()` is called from:
1. **Control plane**: `pipapo_get()` in `nft_set_pipapo.c` (line 534),
   which is called during element insertion/duplicate checking
   (`nft_pipapo_insert()` at lines 1309, 1330), element retrieval
   (`nft_pipapo_get()` at line 605), and deactivation (line 1905).
2. **Data path**: `nft_pipapo_avx2_lookup()` (line 1298), called during
   packet classification.

Both paths are affected when an expired/inactive element is found and
`pipapo_refill()` is invoked on a stale bitmap.

**Step 5.3: Callees**
Record: Each helper calls `nft_pipapo_avx2_refill()` which for
`last==true` returns the first set bit index in the current chunk. The
caller (`pipapo_get_avx2()`) then checks expiry/genmask and may call
`pipapo_refill()` for retry (line 1242).

**Step 5.4: Call Chain**
Record: Control plane: `nf_tables_newsetelem()` → `nft_add_set_elem()` →
`nft_pipapo_insert()` → `pipapo_get()` → `pipapo_get_avx2()` → AVX2
helpers. Data path: packet → `nft_pipapo_avx2_lookup()` →
`pipapo_get_avx2()` → AVX2 helpers. Both are reachable — control plane
from nftables netlink, data path from every packet hitting a pipapo set.

**Step 5.5: Similar Patterns**
Record: `nft_pipapo_avx2_lookup_slow()` has the same `if (last) return
b;` at line 1078 but is NOT affected because its `pipapo_refill()` call
processes the entire map, not per-chunk. All 10 affected helpers have
the identical pattern.

===============================================================
## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS
===============================================================

**Step 6.1: Bug Existence in Stable Trees**
Record: Verified via `git merge-base --is-ancestor`:
- The early `return b` pattern exists since v5.7 in all stable trees
- BUT the bug is only triggerable after the retry-via-`pipapo_refill()`
  mechanism from `5823699a11cf3` is present
- `5823699a11cf3`, `416e53e395167`, and `84c1da7b38d9a` are NOT in
  v5.15, v6.1, v6.6, or v6.12 (exit code 1)
- All three ARE in v6.18 and v6.19 (exit code 0)
- Confirmed: v6.18.20 and v6.19.10 still contain the buggy `return b;`
  in all 10 helpers
- Confirmed: v6.18.20 and v6.19.10 both contain the `pipapo_refill()`
  retry at line 1242
- Confirmed: v6.18.20 has the `pipapo_get_avx2()` dispatch in
  `pipapo_get()`
- Confirmed: v6.6 has zero references to `pipapo_get_avx2` in
  `nft_set_pipapo.c`

**Step 6.2: Backport Complications**
Record: Clean apply expected for v6.18.y and v6.19.y. The buggy lines
are identical in both trees. Not relevant to v6.12 and older.

**Step 6.3: Related Fixes in Stable**
Record: `7711f4bb4b36` (range overlap detection fix) was backported to
v6.18 stable as `704c0258f0d79`. This backport makes the false-clash
symptom more visible on v6.18. No equivalent of the commit under review
is present in any stable tree.

===============================================================
## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: Subsystem Criticality**
Record: [netfilter / nftables] [IMPORTANT — core packet
filtering/firewalling infrastructure used by virtually all Linux
systems]

**Step 7.2: Subsystem Activity**
Record: Actively maintained with frequent correctness fixes. The pipapo
AVX2 implementation has seen several related fixes recently
(5823699a11cf3, 7711f4bb4b36, etc.), indicating this area is under
active maintenance.

===============================================================
## PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: Who Is Affected**
Record: All x86_64 systems with AVX2 (essentially all modern x86 since
Haswell/2013) running kernel v6.18+ that use nftables with concatenated
range sets (pipapo). Affects both:
- **Control plane**: Element insertion/overlap checking fails with false
  clashes
- **Data path**: Packet lookup can return wrong element/verdict when
  expired entries exist in the set

**Step 8.2: Trigger Conditions**
Record:
- Control plane: Load a pipapo set, flush it, reload it → false clash
  reported
- Data path: Any packet hitting a pipapo set where an expired element
  exists and the map spans >1 YMM chunk
- Trigger is realistic for any system that periodically reloads firewall
  rules or uses element timeouts
- Requires no special privileges beyond nftables administration for
  control-plane path

**Step 8.3: Failure Mode Severity**
Record:
- Control plane: False element clashes → nftables set reload fails →
  **firewall update/deployment breaks** → HIGH
- Data path: Wrong element matched → **wrong firewall verdict applied to
  packet** → **CRITICAL** (security-relevant: packets could be
  incorrectly allowed or denied)
- Combined severity: **HIGH**

**Step 8.4: Risk-Benefit Ratio**
Record:
- Benefit: **HIGH** — fixes both control-plane set operations and
  potential data-path incorrect matching
- Risk: **VERY LOW** — 10 identical one-token changes, each replacing
  `return b` with `ret = b`, letting the loop finish naturally. Reviewed
  by original pipapo AVX2 author. No API/ABI changes.
- Ratio: Strongly favors backporting

===============================================================
## PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: Evidence Compilation**

FOR backporting:
- Real, verified correctness bug in netfilter set matching with concrete
  reproducer
- Affects both control-plane (set reload fails) and data-path (wrong
  packet matching — security-relevant)
- Extremely minimal fix: 10 identical one-token changes in a single file
- Reviewed by original pipapo AVX2 implementation author (Stefano
  Brivio)
- Applied through proper netfilter maintainer chain (Florian Westphal →
  Pablo Neira Ayuso)
- Bug has existed since v5.7 but only reachable after v6.18-rc1
  refactoring
- Both v6.18.20 and v6.19.10 confirmed to still contain the buggy
  pattern
- Netfilter is critical security/networking infrastructure

AGAINST backporting:
- Only relevant to v6.18.y and v6.19.y (not older stable trees)
- No explicit Fixes: or Cc: stable tags (expected for manual review)

UNRESOLVED:
- Could not fetch lore.kernel.org discussion due to anti-bot protection
- Could not verify whether reviewer suggested Cc: stable in discussion

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — trivial change, reviewed by
   original author, companion selftest exists
2. Fixes a real bug? **YES** — false element clashes on set reload,
   potential wrong packet matching
3. Important issue? **YES** — breaks firewall management, potentially
   wrong packet filtering (security)
4. Small and contained? **YES** — 10 lines changed in 1 file, all
   identical
5. No new features or APIs? **YES** — pure bug fix
6. Can apply to stable? **YES** — clean apply to v6.18.y and v6.19.y
   (not relevant to older trees)

**Step 9.3: Exception Categories**
Record: Not applicable — standard bug fix, not an exception category.

**Step 9.4: Decision**
This is a clear, surgical fix for a serious correctness bug in
netfilter's AVX2 pipapo matching. The bug causes incorrect element
matching that can break firewall rule reload operations (false clashes)
and potentially cause wrong data-path packet classification (security-
relevant). The fix is minimal (10 identical one-token changes), reviewed
by the original code author, and carries virtually no regression risk.
It should be backported to v6.18.y and v6.19.y stable trees, which are
the only active stable branches containing the prerequisite code that
makes this bug reachable.

## Verification

- [Phase 1] Parsed tags: Reviewed-by from Stefano Brivio (original
  pipapo AVX2 author), Signed-off-by from Pablo Neira Ayuso (netfilter
  maintainer), Link to lore discussion
- [Phase 2] Diff analysis: 10 identical changes `return b;` → `ret = b;`
  across 10 AVX2 lookup functions in single file `nft_set_pipapo_avx2.c`
- [Phase 3] `git blame -L 240,260`: buggy `return b` introduced by
  `7400b063969bd` (Stefano Brivio, v5.7-rc1)
- [Phase 3] `git describe --contains 7400b063969bd`: confirmed v5.7-rc1
- [Phase 3] `git log --oneline -30 --
  net/netfilter/nft_set_pipapo_avx2.c`: verified complete file history
  including all prerequisite commits
- [Phase 3] `git show 84c1da7b38d9a`: confirmed it creates
  `pipapo_get()` dispatcher calling `pipapo_get_avx2()` from control
  plane, and renames old `pipapo_get()` to `pipapo_get_slow()`
- [Phase 3] `git show 5823699a11cf3`: confirmed it changes expired-entry
  retry from full-loop restart to `pipapo_refill()` on existing map
- [Phase 3] `git show 416e53e395167`: confirmed it splits
  `nft_pipapo_avx2_lookup()` into `pipapo_get_avx2()` helper
- [Phase 3] `git describe --contains`: 84c1da7b38d9a → v6.18-rc1,
  5823699a11cf3 → v6.18-rc1, 7711f4bb4b36 → v6.19-rc5
- [Phase 3] `git merge-base --is-ancestor 84c1da7b38d9a v6.6`: exit code
  1 (NOT present)
- [Phase 3] `git merge-base --is-ancestor 84c1da7b38d9a v6.12`: exit
  code 1 (NOT present)
- [Phase 3] `git merge-base --is-ancestor 84c1da7b38d9a v6.18`: exit
  code 0 (present)
- [Phase 3] `git merge-base --is-ancestor 84c1da7b38d9a v6.19`: exit
  code 0 (present)
- [Phase 3] `git merge-base --is-ancestor 416e53e395167 v6.18`: exit
  code 0 (present)
- [Phase 3] `git merge-base --is-ancestor 5823699a11cf3 v6.18`: exit
  code 0 (present)
- [Phase 3] Same two commits also verified present in v6.19
- [Phase 4] UNVERIFIED: lore.kernel.org blocked by Anubis anti-bot
  protection
- [Phase 5] Grep `pipapo_get_avx2` in `net/netfilter/`: confirmed called
  from `pipapo_get()` (control plane, line 534 of nft_set_pipapo.c) and
  `nft_pipapo_avx2_lookup()` (datapath, line 1298 of avx2 file)
- [Phase 5] Read lines 1228-1261: confirmed retry path with
  `pipapo_refill()` at line 1242, `goto next_match` at line 1244
- [Phase 5] Grep `pipapo_get` in `nft_set_pipapo.c`: confirmed call
  sites at insert path (lines 1309, 1330), get path (line 605),
  deactivation (line 1905)
- [Phase 6] `git show v6.19.10:net/netfilter/nft_set_pipapo_avx2.c |
  grep 'return b;'`: 11 matches confirm buggy pattern still present
- [Phase 6] `git show v6.18.20:net/netfilter/nft_set_pipapo_avx2.c |
  grep 'return b;'`: 11 matches confirm buggy pattern still present
- [Phase 6] `git show v6.18.20:net/netfilter/nft_set_pipapo_avx2.c |
  grep pipapo_refill`: confirmed retry mechanism at line 1242
- [Phase 6] `git show v6.18.20:net/netfilter/nft_set_pipapo.c | grep
  pipapo_get_avx2`: confirmed control-plane dispatch present
- [Phase 6] `git show v6.6:net/netfilter/nft_set_pipapo.c | grep -c
  pipapo_get_avx2`: 0 matches — NOT present in v6.6
- [Phase 6] `git log v6.18..v6.18.20 --
  net/netfilter/nft_set_pipapo*.c`: confirmed no equivalent fix already
  backported
- [Phase 8] Failure mode: control-plane false clashes (HIGH), data-path
  wrong matching (CRITICAL for security), combined severity HIGH

**YES**

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

