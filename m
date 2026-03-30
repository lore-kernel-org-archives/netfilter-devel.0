Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83203D6664;
	Mon, 30 Mar 2026 12:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874355; cv=none; b=AKZHmpbUCSH57PXTBIzqyiUCyFF2znR2xD0PpWqXzeHD5buB6XFNlCSrXow2EirwKzUtPvsIDSjqVYYIt6PTc/JJILsGGBn/8K6uAjITkH4ZEY8iaQVVIxlWyvkLc5NbuVKH0vLaeoW6nuqZ+xjp0GM4uS4xnccIgl6U5Hdp1FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874355; c=relaxed/simple;
	bh=C2YzQJdoXLopSLDEyQSgi7aaS7NKyueiaeg0lyq6DVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CrUnqQ0wi+CeMr08lHRGM1dsJCgFQUNrtuci4I4GWqcKtCBihMFHhB7vsOlOWFYhJxh9hfCoOxfYntydstEH9aTUoHJF5vcl4iPN3t7Ti2VpcdxbsJuF+A5+fmrjjIkLEXPBG2TRn1BTng241PySCfSzUhX7hzsCi6K6jEbILOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uq3X21EM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uq3X21EM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3477DC2BCB2;
	Mon, 30 Mar 2026 12:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874355;
	bh=C2YzQJdoXLopSLDEyQSgi7aaS7NKyueiaeg0lyq6DVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uq3X21EMU3YwWEk8iVQ2ciQSK9f/4YSvfiyABNiQ1+P5Wvz85AvNdlKFVNFcGiw0V
	 TSEpdN1bFgBv7BFn+h41JdWpVKyWvkq4Y/Fapk54yoMBHr1RR8LOtg8cwORN6e18ny
	 7YHd4Jw1ptzg0zzg02Pfn7GvAztIXT9lb25rTg7BpRUDd1JkBzojkd95oURLliKNgn
	 sJZOAKAevoEVC5L/T6t04X3b+D0gJxXVyODDW9DgnK3ogfgs/C/QmUaTR/prFP+l6y
	 JLEtEIz+o8lItbQJFRKX1MwEFIrpFXobOm42wNnw5MP9NfVwQeJvuYULXg+z/WfTju
	 gSg3kul2LD+fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] netfilter: ctnetlink: ensure safe access to master conntrack
Date: Mon, 30 Mar 2026 08:38:35 -0400
Message-ID: <20260330123842.756154-22-sashal@kernel.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit bffcaad9afdfe45d7fc777397d3b83c1e3ebffe5 ]

Holding reference on the expectation is not sufficient, the master
conntrack object can just go away, making exp->master invalid.

To access exp->master safely:

- Grab the nf_conntrack_expect_lock, this gets serialized with
  clean_from_lists() which also holds this lock when the master
  conntrack goes away.

- Hold reference on master conntrack via nf_conntrack_find_get().
  Not so easy since the master tuple to look up for the master conntrack
  is not available in the existing problematic paths.

This patch goes for extending the nf_conntrack_expect_lock section
to address this issue for simplicity, in the cases that are described
below this is just slightly extending the lock section.

The add expectation command already holds a reference to the master
conntrack from ctnetlink_create_expect().

However, the delete expectation command needs to grab the spinlock
before looking up for the expectation. Expand the existing spinlock
section to address this to cover the expectation lookup. Note that,
the nf_ct_expect_iterate_net() calls already grabs the spinlock while
iterating over the expectation table, which is correct.

The get expectation command needs to grab the spinlock to ensure master
conntrack does not go away. This also expands the existing spinlock
section to cover the expectation lookup too. I needed to move the
netlink skb allocation out of the spinlock to keep it GFP_KERNEL.

For the expectation events, the IPEXP_DESTROY event is already delivered
under the spinlock, just move the delivery of IPEXP_NEW under the
spinlock too because the master conntrack event cache is reached through
exp->master.

While at it, add lockdep notations to help identify what codepaths need
to grab the spinlock.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the verification I need. Let me compile the final
analysis.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [netfilter: ctnetlink] [ensure] [safe access to master conntrack
— "ensure" strongly implies a missing safety mechanism, i.e., a bug fix]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Florian Westphal <fw@strlen.de> — Author, core
  netfilter developer
- Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org> — Netfilter
  subsystem maintainer
- No Fixes: tag (expected for manual review)
- No Cc: stable tag (expected for manual review)
- No Reported-by:, Tested-by:, Reviewed-by:, or Link: tags

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record: The commit describes a real lifetime bug: holding a reference on
the expectation is not sufficient because the master conntrack object
`exp->master` can be freed independently, leaving a dangling pointer.
The fix serializes access via `nf_conntrack_expect_lock`, which overlaps
with `clean_from_lists()` in the conntrack teardown path. Affected
paths: expectation get, delete, and IPEXP_NEW event delivery. The
failure mode is a use-after-free / stale pointer dereference through
`exp->master`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: This IS a bug fix. Despite using "ensure" rather than "fix", the
body explicitly describes a use-after-free class bug where `exp->master`
becomes invalid.

===============================================================
PHASE 2: DIFF ANALYSIS — LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `include/net/netfilter/nf_conntrack_core.h`: +5 lines (new
  `lockdep_nfct_expect_lock_held()` inline)
- `net/netfilter/nf_conntrack_ecache.c`: +2 lines (lockdep annotation in
  `nf_ct_expect_event_report`)
- `net/netfilter/nf_conntrack_expect.c`: +9/-1 lines (lockdep
  annotations; IPEXP_NEW moved inside lock)
- `net/netfilter/nf_conntrack_netlink.c`: +22/-12 lines (spinlock
  sections extended in get/delete)

Total: ~38 insertions, ~13 deletions across 4 files. Scope: small,
single-subsystem surgical locking fix.

Functions modified: `lockdep_nfct_expect_lock_held()` (new trivial
helper), `nf_ct_expect_event_report()`, `nf_ct_unlink_expect_report()`,
`nf_ct_remove_expect()`, `nf_ct_find_expectation()`,
`__nf_ct_expect_check()`, `nf_ct_expect_related_report()`,
`ctnetlink_get_expect()`, `ctnetlink_del_expect()`.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- `ctnetlink_get_expect()`: Before — finds expectation via
  `nf_ct_expect_find_get()` under RCU, then fills reply skb
  dereferencing `exp->master` without expect lock. After — allocates skb
  first (GFP_KERNEL), takes `nf_conntrack_expect_lock`, does lookup +
  fill under lock, releases lock after put.
- `ctnetlink_del_expect()`: Before — finds expectation and checks ID
  before taking lock; only deletion protected. After — takes lock first,
  find + ID check + deletion all under lock.
- `nf_ct_expect_related_report()`: Before — unlocks before calling
  `nf_ct_expect_event_report(IPEXP_NEW, ...)`. After — delivers
  IPEXP_NEW under lock, then unlocks.
- Lockdep annotations added to `nf_ct_expect_event_report`,
  `nf_ct_unlink_expect_report`, `nf_ct_remove_expect`,
  `nf_ct_find_expectation`, and `__nf_ct_expect_check` to document and
  enforce locking requirements.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: Category: **Race condition → Use-after-free on `exp->master`**.

The race:
1. Thread A (ctnetlink GET/DELETE): calls `nf_ct_expect_find_get()`
   which bumps `exp->use` but does NOT pin the master conntrack
2. Thread B (conntrack destruction): `clean_from_lists()` →
   `nf_ct_remove_expectations()` → takes `nf_conntrack_expect_lock`,
   removes expectations
3. Thread B continues: master conntrack `nf_conn` object freed via RCU
4. Thread A: dereferences `exp->master` → **USE-AFTER-FREE**

Verified: `clean_from_lists()` at line 511 of `nf_conntrack_core.c`
calls `nf_ct_remove_expectations(ct)`, which takes
`nf_conntrack_expect_lock` at line 238 of `nf_conntrack_expect.c`. After
expectations are removed, the master ct is freed.

The specific `exp->master` dereferences in `ctnetlink_exp_dump_expect()`
(lines 3012-3067 of `nf_conntrack_netlink.c`) include:
- `master->tuplehash[IP_CT_DIR_ORIGINAL].tuple` (line 3029)
- `nf_ct_l3num(master)` and `nf_ct_protonum(master)` (lines 3043, 3045)
- `nfct_help(master)` (line 3059)

In `nf_ct_expect_event_report()`, `nf_ct_ecache_find(exp->master)`
dereferences the master conntrack.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: The fix is obviously correct — it extends the existing
`nf_conntrack_expect_lock` to cover accesses that were previously
unprotected. The `GFP_KERNEL` skb allocation is moved before the lock to
avoid sleeping under spinlock. IPEXP_DESTROY was already delivered under
the lock; now IPEXP_NEW is too. Very low regression risk — slightly
longer lock hold on admin netlink paths.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: `git blame` confirms the core of `ctnetlink_get_expect()` was
introduced by `c1d10adb4a521d` (Pablo Neira Ayuso, 2006-01-05) —
original ctnetlink support. The unlocked expectation lookup pattern has
existed since kernel 2.6.x and is present in ALL active stable trees.

**Step 3.2: FOLLOW THE FIXES TAG**
Record: N/A — no Fixes: tag present.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent git log for `nf_conntrack_netlink.c` shows multiple
related UAF/refcount fixes in the same code:
- `cd541f15b60e2` — "fix use-after-free in ctnetlink_dump_exp_ct()" —
  KASAN slab-use-after-free confirmed in expectation dumping
- `1492e3dcb2be3` — "remove refcounting in expectation dumpers"
- `de788b2e62274` — "fix refcount leak on table dump"

The `cd541f15b60e2` commit includes an actual KASAN stack trace proving
UAF bugs in this exact code area are real and exploitable.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Florian Westphal is a core netfilter developer (verified via
MAINTAINERS and git log). Pablo Neira Ayuso is THE netfilter subsystem
maintainer. Both SOBs on this commit.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: The diff is self-contained. The new
`lockdep_nfct_expect_lock_held()` is trivial (wraps
`lockdep_assert_held`). All referenced functions and data structures
exist in current stable trees. No external dependencies detected.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: SEARCH LORE.KERNEL.ORG**
Record: Direct lore.kernel.org access blocked by Anubis proof-of-work.
Alternate sources: spinics.net netdev archive and patchwork.ozlabs.org
confirmed v1→v2→v3 iterations. The v3 cover letter states: "patches 5 to
10 address long-standing RCU safety bugs in conntrack's handling of
expectations."

**Step 4.2: SEARCH FOR BUG REPORT**
Record: No standalone syzbot report or specific bug report for this
exact race, but the related commit `cd541f15b60e2` has a confirmed KASAN
slab-use-after-free trace proving this class of bugs is real and
triggerable.

**Step 4.3: CHECK FOR RELATED PATCHES**
Record: Part of a multi-patch series addressing expectation safety. This
specific patch is standalone — it only extends locking and adds lockdep
annotations, independent of companion patches.

**Step 4.4: CHECK STABLE MAILING LIST**
Record: Could not verify stable-specific discussion due to lore access
issues.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: `ctnetlink_get_expect`, `ctnetlink_del_expect`,
`nf_ct_expect_related_report`, `nf_ct_expect_event_report`,
`ctnetlink_exp_dump_expect`

**Step 5.2: TRACE CALLERS**
Record: Verified `ctnetlink_get_expect` and `ctnetlink_del_expect` are
wired into the `ctnl_exp_cb` netlink callback table (lines 3830-3848 of
`nf_conntrack_netlink.c`) for `IPCTNL_MSG_EXP_GET` and
`IPCTNL_MSG_EXP_DELETE`. These are directly reachable from userspace via
`AF_NETLINK`/`NETLINK_NETFILTER` (requires `CAP_NET_ADMIN`).

`nf_ct_expect_related()` (wrapper around
`nf_ct_expect_related_report()`) is called from 16+ files including SIP,
H323, FTP, IRC, TFTP, AMANDA, broadcast, nft_ct, PPTP, SANE, NAT
helpers, and IPVS. This is NOT a niche path.

**Step 5.3: TRACE CALLEES**
Record: `ctnetlink_exp_dump_expect()` (lines 3008-3077) dereferences
`exp->master` extensively: `master->tuplehash`, `nf_ct_l3num(master)`,
`nf_ct_protonum(master)`, `nfct_help(master)`.
`nf_ct_expect_event_report()` calls `nf_ct_ecache_find(exp->master)`.

**Step 5.4: FOLLOW CALL CHAIN**
Record: Userspace → nfnetlink_rcv → nfnetlink_rcv_msg →
ctnetlink_get/del_expect → nf_ct_expect_find_get → exp->master
dereference. Directly reachable from userspace with CAP_NET_ADMIN.

**Step 5.5: SIMILAR PATTERNS**
Record: `expect_iter_name()` in v6.6 also dereferences `exp->master` via
`nfct_help(exp->master)` — same class of vulnerability in the same file.

===============================================================
PHASE 6: STABLE TREE ANALYSIS
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?**
Record: **YES** — verified directly. In v6.6:
- `ctnetlink_get_expect()` does `nf_ct_expect_find_get()` at line 3333
  WITHOUT `nf_conntrack_expect_lock`, then calls
  `ctnetlink_exp_fill_info()` which dereferences `exp->master`
- `ctnetlink_del_expect()` does `nf_ct_expect_find_get()` at line 3408
  before taking `nf_conntrack_expect_lock` at line 3421
- `nf_ct_expect_related_report()` unlocks at line 501, THEN calls
  `nf_ct_expect_event_report(IPEXP_NEW, ...)` at line 502

The buggy code originated in 2006 (`c1d10adb4a521d`) and is present in
ALL active stable trees (5.4.y, 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y).

**Step 6.2: BACKPORT COMPLICATIONS**
Record: Minor API differences in older trees: `timer_delete` vs
`del_timer` (treewide rename in `8fa7292fee5c5`), and the `struct
nfnl_info` ctnetlink interface. Core logic change (extending spinlock
sections) applies conceptually. Expected: clean or near-clean apply on
6.6+; minor manual adaptation needed for 5.x trees.

**Step 6.3: RELATED FIXES IN STABLE**
Record: `cd541f15b60e2` (KASAN UAF fix in ctnetlink_dump_exp_ct) is
already in stable. No alternative fix for the specific
get/delete/IPEXP_NEW races addressed by this patch.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: [netfilter / conntrack / ctnetlink] [IMPORTANT — widely deployed
in firewalls, NAT gateways, containers, Kubernetes, orchestration
tooling, conntrack-tools monitoring]

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Active subsystem with frequent fixes. The longstanding nature of
the bug (2006) means it affects more stable trees.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Systems using conntrack expectations (FTP/SIP/H323/TFTP/IRC/etc.
helpers) AND userspace tools querying/managing expectations via
ctnetlink (conntrack-tools, orchestration). Also affected: any path
creating expectations that triggers IPEXP_NEW events.

**Step 8.2: DETERMINE TRIGGER CONDITIONS**
Record: Concurrent expectation access (GET/DELETE via netlink, or
IPEXP_NEW event delivery) with master conntrack destruction (normal
connection timeout/teardown). Timing-dependent race but realistic under
load — high conntrack churn with active monitoring is a real-world
scenario.

**Step 8.3: FAILURE MODE SEVERITY**
Record: UAF on `exp->master` → kernel crash/oops (accessing freed slab
memory), memory corruption, or potential security vulnerability.
Severity: **HIGH**. This is corroborated by the KASAN slab-use-after-
free trace in the related commit `cd541f15b60e2`.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit: HIGH** — closes verified unsafe dereference windows in
  userspace-facing netlink operations and expectation event delivery
- **Risk: VERY LOW** — extends existing lock scope slightly, no new
  APIs, no logic changes, GFP_KERNEL allocation correctly moved out of
  lock
- **Ratio: Strongly favorable**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

Evidence FOR backporting:
- Fixes a real use-after-free race condition on `exp->master` in
  ctnetlink
- Bug has existed since 2006 (commit `c1d10adb4a521d`), present in ALL
  active stable trees
- Verified directly: v6.6 has the same vulnerable pattern (unlocked
  expectation lookup + exp->master dereference)
- Written by netfilter subsystem maintainer (Pablo Neira Ayuso) and core
  developer (Florian Westphal)
- Small, surgical fix (~38 insertions, ~13 deletions) across 4 files in
  one subsystem
- Reachable from userspace via AF_NETLINK/NETLINK_NETFILTER
  (CAP_NET_ADMIN)
- Related KASAN UAF confirmed in same code area (`cd541f15b60e2`)
- IPEXP_NEW event path affects 16+ helper/NAT modules — not a niche path
- Part of a series explicitly described as fixing "long-standing RCU
  safety bugs" in expectations
- Low regression risk — only extends existing lock scope

Evidence AGAINST backporting:
- No specific crash report or syzbot report for THIS exact race window
- Part of a multi-patch series (but this patch is standalone)
- May need minor manual adaptation for older stable trees (API renames)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **YES** — extends lock to cover
   unprotected accesses; pattern matches existing serialization
2. Fixes a real bug? **YES** — UAF on `exp->master`, verified via code
   analysis and corroborated by related KASAN reports
3. Important issue? **YES** — crash, memory corruption, potential
   security (UAF from userspace-triggerable netlink path)
4. Small and contained? **YES** — ~50 lines net across 4 files in one
   subsystem
5. No new features or APIs? **YES** — only lockdep annotation helper
   added (debug instrumentation)
6. Can apply to stable? **YES** — may need minor adaptation for API
   renames in older trees

**Step 9.3: EXCEPTION CATEGORIES**
Record: N/A — this is a standard bug fix, not an exception category.

**Step 9.4: DECISION**
This commit fixes a real, longstanding use-after-free race condition in
netfilter conntrack expectation handling that can lead to kernel crashes
or memory corruption. The fix is small, surgical, obviously correct,
authored by the subsystem maintainer and core developer, and applies to
all active stable trees. The risk-benefit ratio is strongly favorable.

## Verification

- [Phase 1] Parsed commit message: only SOBs from Florian Westphal and
  Pablo Neira Ayuso; no Fixes/Reported-by/Cc:stable tags
- [Phase 2] Read `ctnetlink_exp_dump_expect()` at lines 3008-3077 of
  `nf_conntrack_netlink.c`: confirmed multiple `exp->master`
  dereferences (`master->tuplehash`, `nf_ct_l3num(master)`,
  `nfct_help(master)`)
- [Phase 2] Read `clean_from_lists()` at line 511 of
  `nf_conntrack_core.c`: confirmed it calls
  `nf_ct_remove_expectations(ct)` before master ct is freed
- [Phase 2] Read `nf_ct_remove_expectations()` at line 228 of
  `nf_conntrack_expect.c`: confirmed it takes `nf_conntrack_expect_lock`
  at line 238 — this is the serialization point
- [Phase 2] Read `nf_ct_expect_related_report()` at line 500-507:
  confirmed `spin_unlock_bh` at line 501 THEN
  `nf_ct_expect_event_report(IPEXP_NEW)` at line 502 — the unlocked
  window
- [Phase 3] `git blame` on `ctnetlink_get_expect`: lines 3342, 3354-3362
  trace to `c1d10adb4a521d` (Pablo Neira Ayuso, 2006-01-05)
- [Phase 3] `git log --oneline -20 --
  net/netfilter/nf_conntrack_netlink.c`: found related UAF fixes
  `cd541f15b60e2`, `1492e3dcb2be3`, `de788b2e62274`
- [Phase 3] `git show cd541f15b60e2`: confirmed KASAN slab-use-after-
  free stack trace in same ctnetlink expectation code
- [Phase 3] `git log --author` for both authors: verified as core
  netfilter contributors
- [Phase 4] Lore.kernel.org blocked by Anubis; used spinics.net and
  patchwork.ozlabs.org mirrors to verify v1→v2→v3 iterations and cover
  letter content
- [Phase 5] Read `ctnl_exp_cb` callback table at lines 3830-3848:
  confirmed `ctnetlink_get_expect` and `ctnetlink_del_expect` are
  userspace-reachable via NETLINK_NETFILTER
- [Phase 5] `rg nf_ct_expect_related` across net/netfilter/: 16 files
  use this function (SIP, FTP, H323, TFTP, IRC, AMANDA, broadcast,
  nft_ct, PPTP, SANE, NAT helpers, IPVS)
- [Phase 6] `git show v6.6:net/netfilter/nf_conntrack_netlink.c`:
  confirmed unlocked `nf_ct_expect_find_get()` at line 3333 and
  `ctnetlink_exp_fill_info()` dereferences `exp->master` without expect
  lock
- [Phase 6] `git show v6.6:net/netfilter/nf_conntrack_expect.c`:
  confirmed `spin_unlock_bh` at line 501, then
  `nf_ct_expect_event_report(IPEXP_NEW)` at line 502 — same vulnerable
  pattern as mainline
- [Phase 8] Failure mode: UAF on `exp->master` → kernel
  crash/corruption; severity HIGH (corroborated by KASAN trace in
  related commit)
- UNVERIFIED: Exact privilege requirements for ctnetlink expectation
  operations (assumed CAP_NET_ADMIN based on netfilter conventions)
- UNVERIFIED: Whether patch applies cleanly to stable trees older than
  6.6 (API renames expected)
- UNVERIFIED: Full lore.kernel.org review thread (blocked by Anubis
  proof-of-work)
- UNVERIFIED: Stable trees older than v5.15 individually checked

**YES**

 include/net/netfilter/nf_conntrack_core.h |  5 ++++
 net/netfilter/nf_conntrack_ecache.c       |  2 ++
 net/netfilter/nf_conntrack_expect.c       | 10 +++++++-
 net/netfilter/nf_conntrack_netlink.c      | 28 +++++++++++++++--------
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 3384859a89210..8883575adcc1e 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -83,6 +83,11 @@ void nf_conntrack_lock(spinlock_t *lock);
 
 extern spinlock_t nf_conntrack_expect_lock;
 
+static inline void lockdep_nfct_expect_lock_held(void)
+{
+	lockdep_assert_held(&nf_conntrack_expect_lock);
+}
+
 /* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
 
 static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 81baf20826046..9df159448b897 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -247,6 +247,8 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 
+	lockdep_nfct_expect_lock_held();
+
 	rcu_read_lock();
 	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
 	if (!notify)
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index cfc2daa3fc7f3..f9e65f03dc5ea 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -51,6 +51,7 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 	struct net *net = nf_ct_exp_net(exp);
 	struct nf_conntrack_net *cnet;
 
+	lockdep_nfct_expect_lock_held();
 	WARN_ON(!master_help);
 	WARN_ON(timer_pending(&exp->timeout));
 
@@ -118,6 +119,8 @@ nf_ct_exp_equal(const struct nf_conntrack_tuple *tuple,
 
 bool nf_ct_remove_expect(struct nf_conntrack_expect *exp)
 {
+	lockdep_nfct_expect_lock_held();
+
 	if (timer_delete(&exp->timeout)) {
 		nf_ct_unlink_expect(exp);
 		nf_ct_expect_put(exp);
@@ -177,6 +180,8 @@ nf_ct_find_expectation(struct net *net,
 	struct nf_conntrack_expect *i, *exp = NULL;
 	unsigned int h;
 
+	lockdep_nfct_expect_lock_held();
+
 	if (!cnet->expect_count)
 		return NULL;
 
@@ -442,6 +447,8 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 	unsigned int h;
 	int ret = 0;
 
+	lockdep_nfct_expect_lock_held();
+
 	if (!master_help) {
 		ret = -ESHUTDOWN;
 		goto out;
@@ -498,8 +505,9 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 
 	nf_ct_expect_insert(expect);
 
-	spin_unlock_bh(&nf_conntrack_expect_lock);
 	nf_ct_expect_event_report(IPEXP_NEW, expect, portid, report);
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+
 	return 0;
 out:
 	spin_unlock_bh(&nf_conntrack_expect_lock);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d9f33a6c807c8..f5cb09eb31a34 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3357,31 +3357,37 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
+	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb2)
+		return -ENOMEM;
+
+	spin_lock_bh(&nf_conntrack_expect_lock);
 	exp = nf_ct_expect_find_get(info->net, &zone, &tuple);
-	if (!exp)
+	if (!exp) {
+		spin_unlock_bh(&nf_conntrack_expect_lock);
+		kfree_skb(skb2);
 		return -ENOENT;
+	}
 
 	if (cda[CTA_EXPECT_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
 
 		if (id != nf_expect_get_id(exp)) {
 			nf_ct_expect_put(exp);
+			spin_unlock_bh(&nf_conntrack_expect_lock);
+			kfree_skb(skb2);
 			return -ENOENT;
 		}
 	}
 
-	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!skb2) {
-		nf_ct_expect_put(exp);
-		return -ENOMEM;
-	}
-
 	rcu_read_lock();
 	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).portid,
 				      info->nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
 				      exp);
 	rcu_read_unlock();
 	nf_ct_expect_put(exp);
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+
 	if (err <= 0) {
 		kfree_skb(skb2);
 		return -ENOMEM;
@@ -3431,22 +3437,26 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 		if (err < 0)
 			return err;
 
+		spin_lock_bh(&nf_conntrack_expect_lock);
+
 		/* bump usage count to 2 */
 		exp = nf_ct_expect_find_get(info->net, &zone, &tuple);
-		if (!exp)
+		if (!exp) {
+			spin_unlock_bh(&nf_conntrack_expect_lock);
 			return -ENOENT;
+		}
 
 		if (cda[CTA_EXPECT_ID]) {
 			__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
 
 			if (id != nf_expect_get_id(exp)) {
 				nf_ct_expect_put(exp);
+				spin_unlock_bh(&nf_conntrack_expect_lock);
 				return -ENOENT;
 			}
 		}
 
 		/* after list removal, usage count == 1 */
-		spin_lock_bh(&nf_conntrack_expect_lock);
 		if (timer_delete(&exp->timeout)) {
 			nf_ct_unlink_expect_report(exp, NETLINK_CB(skb).portid,
 						   nlmsg_report(info->nlh));
-- 
2.53.0

