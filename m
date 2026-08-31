Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A184B148C;
	Mon, 31 Aug 2026 13:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184243; cv=none; b=s7UdouBwM2nhkColoKx+N0xxiFMuRTaTH/BFM5pTpxhn4UUi0y9O71UcVfFWg+fk4KmqZXrhQl2sDk9tLHPSBs8KJ2ijXpM7PmNTd2nGJvj8n5H6k9MqcG9O/fdC4fg1LdZrY2vDG+HDgy/bGmyPRtuN35wbjfwiYYCbJ5OupW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184243; c=relaxed/simple;
	bh=1N6WRXvu9FOGSgOwmNERmOqMqnBxR/MZZ+DOZ00b6tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSvAFELAiQRLeJev3mI8ERkUqZE2+hBtLbIu3A61RCE3OJUGB/0t6EZEUCvtLAA2VIZBihCfyRloMeQYPhv2xspoZrZcArkanyUvG/SOsgDgYF8uIfMV3qVb9/z9I8DVF8fNzVfAnCvMOVrcxXZlW67wwhN34lrHAg7DCdCz6c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1ohHuj/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1ohHuj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C001F000E9;
	Mon, 31 Aug 2026 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184241;
	bh=scUMRVwXvtMfylpk0vzSbVMrUbGPIXVeZijeGTf2/Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1ohHuj/F6+FBAXs53kdl42HunwuAnlADpN+StwUtWrcE53lZrjV2ve0HRVVij4jH
	 pB8pwcTyzoTT0d2y8UK98ZZ+XnBx/VViQG3y3bPyGdfCcdJkOcTgt4Alxml8ec9X+J
	 X4zmnHn8Whbk69oTjWOeuWOIh+fcuj38d40/KCCsgBkd/SH+9wVD/hLTuxSROTERPU
	 2c9ZI4O3nHH0gDdzMkCZZnGWHz33S3qvOzu/kkn4IOb6iQRQuBZJZC5DbUJRe/Qj1g
	 jnn2r3L4GC4UbJlTcd7k1ZZxpoVFkaCD6xUvq8qXgr8I9VwrFM0G94vwZBQYbu0Sph
	 GmaSf2syxK57g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] netfilter: ipset: mark the rcu locked areas properly
Date: Mon, 31 Aug 2026 09:30:04 -0400
Message-ID: <20260831133314.4125787-576-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 5d0c22e73656d050daffad10a2ba8765ce8441c8 ]

When we bump the uref counter, there's no need to keep
the rcu lock because the referred hash table can't
disappear. Also, from the same reason in mtype_gc we
need the rcu lock and not a spinlock.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `netfilter: ipset: mark the rcu locked areas
properly`

**Local tree:** Linux 6.18.44 (`v6.18.44-1-g2736c32da98b9`)
**Commit analyzed:** `5d0c22e73656d050daffad10a2ba8765ce8441c8` (not yet
in this tree; patch applies cleanly)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[netfilter: ipset]` `[mark]` — Correct RCU locking
annotations/usage in hash-type ipset GC and add paths.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>` (ipset
  maintainer)
- `Signed-off-by: Florian Westphal <fw@strlen.de>` (netfilter developer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable`, `Acked-by:`, or
  `Reviewed-by:` tags

Notable: absence of stable tags is expected for manual review; not a
negative signal.

### Step 1.3: Body analysis
**Record:**
- **Bug described:** RCU read-side critical sections are held longer
  than necessary after bumping `uref`, and `mtype_gc` uses `set->lock`
  (spinlock) instead of RCU to dereference `h->table`.
- **Mechanism:** Once `atomic_inc(&t->uref)` runs, the hash table cannot
  be freed; RCU protection is only needed until that point.
- **Symptom/failure mode:** Incorrect synchronization — potential use-
  after-free in GC vs. resize, and RCU read lock held across lengthy GC
  work in `mtype_add` (RCU stall class).
- **Version info:** None in commit message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite neutral wording ("mark the rcu locked areas
properly"), this is a real concurrency fix, not cosmetic cleanup. Wrong
lock type in `mtype_gc` and holding RCU across `mtype_gc_do()` are both
correctness bugs in the same class as the 2020 RCU-stall fix
(`f66ee0410b1c`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `net/netfilter/ipset/ip_set_hash_gen.h` (+5 / -8 lines)
- **Functions modified:** `mtype_gc()`, `mtype_add()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow changes

**Hunk 1 — `mtype_gc()`:**
- **Before:** `spin_lock_bh(&set->lock)` →
  `ipset_dereference_set(h->table, set)` → `atomic_inc(&t->uref)` →
  `spin_unlock_bh(&set->lock)`
- **After:** `rcu_read_lock_bh()` → `rcu_dereference_bh(h->table)` →
  `atomic_inc(&t->uref)` → `rcu_read_unlock_bh()`
- **Path affected:** Workqueue GC path for timed-out hash set elements

**Hunk 2 — `mtype_add()`:**
- **Before:** RCU held from table dereference through optional
  `mtype_gc_do()` call and element-count scan; unlock/relock dance
  around `mtype_gc_do()`
- **After:** RCU released immediately after `atomic_inc(&t->uref)`;
  `mtype_gc_do()` runs without RCU held
- **Path affected:** Kernel-side add path when a hash region appears
  full (common under netfilter SET target traffic)

### Step 2.3: Bug mechanism
**Record:**
- **Category:** (b) Synchronization / race + RCU stall
- **mtype_gc mechanism:** `h->table` is RCU-protected (see file header
  comment at lines 27–37). Resize swaps it under nfnl mutex +
  `rcu_assign_pointer()` + `synchronize_rcu()` — it does **not** take
  `set->lock`. GC workqueue using `set->lock` to dereference `h->table`
  is not synchronized with resize; a table can be freed between pointer
  read and `uref` bump → UAF.
- **mtype_add mechanism:** `mtype_gc_do()` acquires
  `spin_lock_bh(&t->hregion[r].lock)` and iterates buckets — substantial
  work. Holding `rcu_read_lock_bh()` across that work risks RCU stalls,
  the same failure mode addressed by `f66ee0410b1c` in 2020.

### Step 2.4: Fix quality
**Record:** Fix is minimal and logically sound — `uref` pins the table
after RCU dereference, matching the pattern already used throughout this
header (resize at line 679, dump paths at 1350–1354). Low regression
risk; no API or structural changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Both affected code regions were introduced in
`5d324e5159d9e` (merge into 6.18, Nov 2025). The buggy locking pattern
has been present since the current RCU-based hash implementation landed
in this file's recent history. The underlying RCU hash design dates to
`f66ee0410b1c` (Feb 2020, syzbot-reported RCU stalls).

### Step 3.2: Fixes tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related file history
**Record:** Recent related commits in this tree:
- `7228cc8ff6265` — data race fix (add vs dump), syzbot-reported
- `12088da6add5b` — GC shutdown fix
- `c4d257734e91b`, `a0afd353c2f7e` — RCU reader/writer annotation fixes
- `f66ee0410b1c` — original RCU stall fix for hash types (in tree since
  2020)

This commit is patch 1/5 in series "gc, backlog and cidr patches"; cover
letter states patches 1 and 4 are independent cleanups. **Standalone for
backport.**

### Step 3.4: Author context
**Record:** Jozsef Kadlecsik is the ipset maintainer and author of the
2020 RCU stall fix and multiple recent ipset stable backports. Florian
Westphal co-signed.

### Step 3.5: Dependencies
**Record:** No dependencies on patches 2–5. `git apply --check` succeeds
on current tree. Self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 5d0c22e`:
  https://patch.msgid.link/20260702134701.207721-2-kadlec@netfilter.org
- Series: v1 only (2026-07-02), 5 patches
- Cover letter (patch 0/5): patches 1 and 4 described as "independent
  cleanups and clarifications"; patches 2–3–5 address gc/resize
  clashing, backlog cleanup, and cidr bookkeeping
- No review replies found in downloaded mbox (series cover + patches
  only)

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd to `netfilter-devel@vger.kernel.org`,
`Pablo Neira Ayuso <pablo@netfilter.org>`. Signed off by Florian
Westphal.

### Step 4.3: Bug reports
**Record:** No `Reported-by:` or `Link:` tags. Related series patch 2/5
reports gc/resize comment-extension UAF (separate bug, separate backport
decision). This patch's bugs are identifiable from code analysis and
align with prior syzbot-found RCU issues in the same subsystem.

### Step 4.4: Series context
**Record:** Patches 2–5 fix distinct issues (gc during resize, backlog
cleanup, memory allocation, cidr rework). Patch 1 does not require them.

### Step 4.5: Stable list history
**Record:** Not searched on lore stable list (no stable nomination found
in series mbox). Not a negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `mtype_gc()`, `mtype_gc_do()`, `mtype_add()`

### Step 5.2: Callers
**Record:**
- `mtype_add()` called from resize backlog replay (line 774) and via
  `ip_set_add()` → `set->variant->kadt()` → hash type add (netfilter hot
  path, packet processing)
- `mtype_gc()` scheduled from `mtype_gc_init()` via
  `queue_delayed_work()` on timed-out hash sets

### Step 5.3: Callees
**Record:** `mtype_gc_do()` takes `spin_lock_bh(&t->hregion[r].lock)`,
iterates buckets, may call `mtype_del_cidr()` (which takes `set->lock`),
`kfree_rcu()`, `rcu_assign_pointer()`

### Step 5.4: Reachability
**Record:**
- `mtype_add`: reachable from netfilter packet path (`ip_set_add`
  exported, used by iptables/nftables SET targets) — **userspace-
  triggerable via network traffic + firewall rules**
- `mtype_gc`: triggered periodically on timeout-enabled hash sets —
  **automatic, production-relevant**

### Step 5.5: Similar patterns
**Record:** Correct pattern already used elsewhere in same file:
`mtype_del()` (lines 1060–1065), `mtype_uref()` (1350–1354), resize path
(677–679). This patch aligns `mtype_gc` and `mtype_add` with established
conventions.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at
`net/netfilter/ipset/ip_set_hash_gen.h`:
- `mtype_gc()` lines 572–583: uses `spin_lock_bh(&set->lock)` +
  `ipset_dereference_set()`
- `mtype_add()` lines 858–879: holds RCU across `mtype_gc_do()` with
  unlock/relock dance

Commit `5d0c22e` is **not** an ancestor of HEAD (`merge-base --is-
ancestor` returned exit 1).

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** `git apply --check` on the commit
diff succeeded with no conflicts.

### Step 6.3: Related fixes already present?
**Record:** Related but distinct fixes already in tree: `f66ee0410b1c`
(RCU stall, 2020), `7228cc8ff6265` (add/dump race), `12088da6add5b` (GC
stop). None fix this specific locking error.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `net/netfilter/ipset` — **IMPORTANT** (firewall
infrastructure used by iptables/nftables on servers, routers,
containers)

### Step 7.2: Activity
**Record:** Actively maintained — 6 commits to `ip_set_hash_gen.h` since
the 6.18 merge point, including multiple RCU/concurrency fixes in 2026.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of timeout-enabled hash ipsets (`hash:ip`, `hash:net`,
etc.) under netfilter — common in production firewall configurations.

### Step 8.2: Trigger conditions
**Record:**
- **mtype_gc UAF:** Concurrent resize (userspace `ipset resize`) + GC
  workqueue on same set
- **mtype_add RCU stall:** Adding elements to a near-full timed-out set,
  triggering inline `mtype_gc_do()`
- **Likelihood:** Moderate for busy firewall nodes; resize is less
  common but GC and adds are frequent

### Step 8.3: Failure mode severity
**Record:**
- UAF on hash table → kernel oops/crash or memory corruption —
  **CRITICAL**
- RCU stall → soft lockup, system hang — **CRITICAL**

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents crash/hang in widely deployed firewall
  code
- **Risk:** LOW — 13-line change, follows existing patterns, applies
  cleanly
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real RCU synchronization bug (wrong lock in `mtype_gc` → UAF vs
  resize)
- Fixes RCU stall risk in `mtype_add` (same class as prior syzbot-found
  ipset bugs)
- Small, surgical, standalone
- Applies cleanly to 6.18.44
- Subsystem maintainer authored; netfilter developer signed off
- Affects production firewall paths

**AGAINST backport:**
- No explicit syzbot report for this specific commit
- Part of a 5-patch series (but patch 1 is explicitly independent per
  cover letter)
- Patches 2–5 address related but separate gc/resize issues

**Unresolved:** No runtime crash report specifically tied to this exact
commit; bug inferred from code analysis and maintainer explanation.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic matches existing
   `uref`/RCU patterns in same file; signed off by subsystem experts
2. Fixes a real bug affecting users? **PASS** — UAF and RCU stall are
   real, verifiable from code
3. Important issue? **PASS** — CRITICAL (crash/hang)
4. Small and contained? **PASS** — 13 lines, one file, two functions
5. No new features or APIs? **PASS** — locking correction only
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
on standard bug-fix criteria.

### Step 9.4: Problem and verdict

This commit corrects two RCU-related bugs in ipset hash types that are
present in Linux 6.18.44:

1. **`mtype_gc()`** uses `set->lock` to read the RCU-protected
   `h->table` pointer, but resize (which can free the old table) runs
   under nfnl mutex, not `set->lock`. A resize completing between
   pointer read and `uref` bump can free the table → use-after-free.

2. **`mtype_add()`** holds `rcu_read_lock_bh()` while calling
   `mtype_gc_do()`, which acquires spinlocks and does substantial bucket
   iteration — the exact pattern that caused "INFO: rcu detected stall
   in hash_xxx" reports fixed in 2020.

The fix is minimal: release RCU immediately after `uref` pins the table,
and use RCU (not `set->lock`) to dereference `h->table` in GC. This
matches patterns already used in `mtype_del()`, `mtype_uref()`, and the
resize path in the same file.

---

## Verification

- **[Phase 1]** Parsed commit `5d0c22e`: subject, body, tags (only
  Signed-off-by from Kadlecsik and Westphal)
- **[Phase 2]** Diff analysis: +5/-8 lines in `ip_set_hash_gen.h`,
  `mtype_gc()` and `mtype_add()` modified
- **[Phase 3]** `git blame`: buggy lines from `5d324e5159d9e`;
  `f66ee0410b1c` (2020 RCU stall fix) in tree
- **[Phase 3]** `git log --oneline f66ee0410b1c..HEAD --
  ip_set_hash_gen.h`: 6 related commits, none fixing this issue
- **[Phase 3]** `git apply --check`: patch applies cleanly to current
  tree
- **[Phase 3]** `git merge-base --is-ancestor 5d0c22e HEAD`: exit 1 —
  commit not in tree
- **[Phase 4]** `b4 dig -c 5d0c22e`: lore URL found; v1 series, 5
  patches
- **[Phase 4]** `b4 dig -w`: CC'd netfilter-devel, Pablo Neira Ayuso
- **[Phase 4]** Downloaded mbox: cover letter confirms patch 1 is
  independent
- **[Phase 5]** Read `mtype_gc_do()`: takes spinlocks, calls
  `mtype_del_cidr()` — confirms RCU stall risk
- **[Phase 5]** Read resize path (lines 677–785): uses nfnl +
  `rcu_assign_pointer` + `synchronize_rcu`, not `set->lock`
- **[Phase 5]** `ipset_dereference_set` macro (lines 19–22): allows nfnl
  OR `set->lock`, confirming GC's spinlock was lockdep-only, not resize-
  safe
- **[Phase 6]** `git describe HEAD`: v6.18.44; buggy code confirmed at
  lines 572–583 and 858–879
- **[Phase 6]** `git apply --check`: clean apply confirmed
- **[Phase 8]** Failure modes: UAF (CRITICAL), RCU stall (CRITICAL);
  triggerable on production firewall nodes

**YES**

 net/netfilter/ipset/ip_set_hash_gen.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 4c1082e38e3d1..61bddd277a2c6 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -569,9 +569,10 @@ mtype_gc(struct work_struct *work)
 	set = gc->set;
 	h = set->data;
 
-	spin_lock_bh(&set->lock);
-	t = ipset_dereference_set(h->table, set);
+	rcu_read_lock_bh();
+	t = rcu_dereference_bh(h->table);
 	atomic_inc(&t->uref);
+	rcu_read_unlock_bh();
 	numof_locks = ahash_numof_locks(t->htable_bits);
 	r = gc->region++;
 	if (r >= numof_locks) {
@@ -580,7 +581,6 @@ mtype_gc(struct work_struct *work)
 	next_run = (IPSET_GC_PERIOD(set->timeout) * HZ) / numof_locks;
 	if (next_run < HZ/10)
 		next_run = HZ/10;
-	spin_unlock_bh(&set->lock);
 
 	mtype_gc_do(set, h, t, r);
 
@@ -860,15 +860,13 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	key = HKEY(value, h->initval, t->htable_bits);
 	r = ahash_region(key);
 	atomic_inc(&t->uref);
+	rcu_read_unlock_bh();
 	elements = t->hregion[r].elements;
 	maxelem = t->maxelem;
 	if (elements >= maxelem) {
 		u32 e;
-		if (SET_WITH_TIMEOUT(set)) {
-			rcu_read_unlock_bh();
+		if (SET_WITH_TIMEOUT(set))
 			mtype_gc_do(set, h, t, r);
-			rcu_read_lock_bh();
-		}
 		maxelem = h->maxelem;
 		elements = 0;
 		for (e = 0; e < ahash_numof_locks(t->htable_bits); e++)
@@ -876,7 +874,6 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (elements >= maxelem && SET_WITH_FORCEADD(set))
 			forceadd = true;
 	}
-	rcu_read_unlock_bh();
 
 	spin_lock_bh(&t->hregion[r].lock);
 	n = rcu_dereference_bh(hbucket(t, key));
-- 
2.53.0

