Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFB04D73B8;
	Mon, 19 Oct 2026 14:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418526; cv=none; b=GetcLJtOMoaYpl4cEa7reYjmQqqh5NXFUkCzSthPHkvfCL+mgpkXNrFV149Oex8HCnJwrXirKzG4S4ZbWClFKMYqnO7NUA9ih4kyUxiXdrXmppSv8NJWENznHw8S8aKLH9nTmkozNIdyvTJFRpFAKg0uAaDZw1ptG4a7HfHOo7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418526; c=relaxed/simple;
	bh=Qb75CgYlwdM8XV9iRNoXRIk8ViIQgsrvj9Ml8WaJ+Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aMvkikubKQiUQC5boMck/3tvZQliWs/UBSV1Lfj3VVGatJAexDx4LBBgmm4m4aHXd4bE0uCHEBTXdqghU7IKi9dQsVcf9g9eIB4yUJGaCWA4d6iKk8apwkCg8PRGEKygl8k8czUoijPGzzSHD9mvE1kIlQL5ESIiW5Vg5KQ/SUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/39ILUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/39ILUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67381F000C6;
	Mon, 19 Oct 2026 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418524;
	bh=Ma8s4LVFQY649KjDepXzI1/wOG9UbmIpugztJsBFM5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/39ILUjHHJR8izdvcINKSvGFnYZJzUU3Q7dbGNfu2S1hYFkNFHahDGvSFUZwG4ut
	 LWVadlWxQVY8licl2LSyQHSgh6KybNnAxRIrmV/h1MaqknsCde57n/g1tHrnVwX5It
	 GDuDLX1V+0nCveOzRCZi5w+DbRWLKc0/6KYNR64oXakGtAhVHt6aEQxYyGQuytyLfI
	 CbiUxZLWtkUyvzXjqj6lcanZc+FinnDG/JmeNd6Id62rccqspj4f8Nk7E0f+P/omXi
	 BK1tYVwST6HnHXXkqzFG+BIxJlJ9raMZHBDgDR/zxOSOdcpR4xQhS4lnuFCR7IlCFm
	 XaLQss2dwDyBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	razor@blackwall.org,
	idosch@nvidia.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] netfilter: ebtables: bound num_counters like nentries in do_replace()
Date: Mon, 19 Oct 2026 09:50:00 -0400
Message-ID: <20261019135441.1420968-309-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 43ae85af154b27f9a0ff602f7a01e3a7583ffdab ]

do_replace_finish() allocates the counter buffer before it is validated:

   counterstmp = vmalloc_array(repl->num_counters, sizeof(*counterstmp));

do_replace() only checks num_counters against INT_MAX / sizeof(struct
ebt_counter), so vmalloc_array() can be asked for up to 134217726 * 16 =
2147483616 bytes (~2 GiB).

num_counters must in fact equal nentries: do_replace_finish() later
rejects the request when repl->num_counters != t->private->nentries.
get_counters() folds the per-CPU counters back into one entry per rule,
so what userspace gets is bounded by nentries, never by nentries *
nr_cpus. Apply the same upper bound used for nentries (MAX_EBT_ENTRIES)
to the incoming num_counters so the over-sized allocation can no longer
be requested.

The allocation is still kept outside the ebt_mutex, since vmalloc() may
sleep and trigger reclaim; only the bound is tightened.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real allocate-before-validate bound bug in legacy ebtables
`do_replace()`. The local tree is **6.18.53**; the buggy checks are
present here and the fix is small enough to apply cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
- Subsystem: `netfilter: ebtables`
- Action verb: **bound** (limit an existing userspace-controlled size)
- Intent: cap `num_counters` with the same ceiling already used for
  `nentries` in `do_replace()`
Record: [netfilter/ebtables] [bound] [tighten `num_counters` so
`do_replace()` cannot request a ~2 GiB counter `vmalloc`]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- Signed-off-by: Jiayuan Chen \<jiayuan.chen@linux.dev\> (author)
- Signed-off-by: Florian Westphal \<fw@strlen.de\> (netfilter/ebtables
  maintainer; applied the patch)
- Signed-off-by: Sasha Levin — **ignored** (pipeline)
- `[Upstream commit 43ae85af154b…]` — **ignored** (pipeline)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable
Record: Author SOB + maintainer SOB only. Absence of Fixes/Cc-stable is
expected and not a negative.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Bug: `do_replace_finish()` does `vmalloc_array(repl->num_counters,
sizeof(*counterstmp))` **before** checking `repl->num_counters !=
t->private->nentries`. `do_replace()` only rejects `num_counters >=
INT_MAX / sizeof(struct ebt_counter)`, so the allocation can be up to
`134217726 * 16 = 2147483616` bytes (~2 GiB). Semantically
`num_counters` must equal the current table’s `nentries`;
`get_counters()` returns one summed entry per rule, not per-CPU.
Symptom: a crafted `EBT_SO_SET_ENTRIES` sockopt can force a huge
`vmalloc` and reclaim/OOM, then the request is rejected.
Root cause: allocate-then-validate; the `nentries` overflow formula is
much tighter than the `num_counters` formula.
Record: [oversized counter vmalloc before validation] [memory exhaustion
/ reclaim DoS] [bug present since the 2010 overflow checks] [same
MAX_EBT_ENTRIES ceiling as nentries]

Step 1.4: DETECT HIDDEN BUG FIXES
Not disguised. Explicit bound-check fix for a userspace-controlled
allocation. Extracting the existing `nentries` formula into
`MAX_EBT_ENTRIES` is mechanical, not a hidden refactor.
Record: [Direct bug fix, not a hidden cleanup]

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
File: `net/bridge/netfilter/ebtables.c` — 6 insertions, 6 deletions.
Functions: file-scope `#define MAX_EBT_ENTRIES`; `do_replace()`;
`compat_copy_ebt_replace_from_user()`.
Record: [1 file, ±6 lines] [do_replace,
compat_copy_ebt_replace_from_user] [single-file surgical fix]

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Hunk 1: existing `nentries` overflow expression becomes
`MAX_EBT_ENTRIES` (same formula).
Hunk 2 (`do_replace`): `num_counters >= INT_MAX / sizeof(struct
ebt_counter)` → `num_counters >= MAX_EBT_ENTRIES`.
Hunk 3 (compat): same `num_counters` change.
Normal sockopt replace path, before any allocation of `newinfo` /
`counterstmp`.
Record: [before: num_counters allowed up to ~134M; after: same ceiling
as nentries]

Step 2.3: IDENTIFY THE BUG MECHANISM
Category: memory-safety / resource-exhaustion bound check (not UAF,
leak, or race).
Mechanism: `num_counters` is independent of sockopt `len` (`len` only
covers `sizeof(ebt_replace) + entries_size`). A small blob plus a huge
`num_counters` still reaches `vmalloc_array()`. `vmalloc_array()` uses
`check_mul_overflow`, so this is not an integer-wrap heap overflow; it
is a ~2 GiB allocation request. Later `do_replace_finish()` rejects
mismatched `num_counters` and `vfree`s the buffer.
Record: [resource exhaustion] [userspace size used for vmalloc before
semantic validation]

Step 2.4: ASSESS THE FIX QUALITY
Obviously correct: `num_counters` must equal current `nentries`, and
`nentries` was already capped by this formula. Kernel-registered initial
tables (`ebtable_filter` etc.) have a handful of entries. No API/ABI
change; oversized requests now get `-ENOMEM` earlier instead of
allocating then `-EINVAL`. Allocation stays outside `ebt_mutex` (vmalloc
may sleep). Regression risk is very low.
Record: [minimal, maintainer-applied] [very low regression risk]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
The pair of overflow checks was added in `e788759f44b2` (“netfilter:
ebtables: split do_replace into two functions”, Florian Westphal,
2010-02-04), first appearing around **v2.6.34-rc1**. The loose
`num_counters` bound has been unchanged since then (aside from a 2015
revert of an unrelated `num_counters == 0` check).
Record: [e788759f44b2, v2.6.34-rc1] [bug ~16 years old; present in this
6.18.y tree]

Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag. The introducing commit is an ancestor of HEAD and of
`v6.18.53`.
Record: [no Fixes tag] [introducing commit is in this tree] [no
intermediate tightening of this bound]

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Nearby ebtables work (`terminate table name`, `zero chainstack`, `module
names must be null-terminated`) is independent. This commit is not patch
N/M.
Record: [standalone] [no prerequisites beyond the 2010 overflow checks]

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Jiayuan Chen is not the ebtables maintainer. Florian Westphal applied
it. Same-period netfilter work from this author is unrelated (`nft_ct`).
Record: [regular contributor; maintainer SOB] [no dependent series]

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
`MAX_EBT_ENTRIES` is introduced here from an in-tree formula.
`vmalloc_array()` exists (`mm/util.c`). Compat path exists under
`CONFIG_NETFILTER_XTABLES_COMPAT`. Applies standalone.
Record: [none] [standalone apply]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
`b4 dig -c 43ae85af154b` →
https://patch.msgid.link/20260610030259.194456-1-jiayuan.chen@linux.dev
Subject: `[PATCH nf-next] netfilter: ebtables: bound num_counters like
nentries in do_replace()`
v1 only (`b4 dig -a`). Mbox is the patch itself; **no replies, NAKs, or
Cc: stable**. Applied as-is by Florian on 2026-07-02. Merged via `nf-
next-26-07-02`; pull text: “Bound num_counters in ebtables: do_replace()
by MAX_EBT_ENTRIES to prevent oversized vmalloc_array() allocations.”
Record: [msgid 20260610030259.194456-1] [v1 only] [no review comments]
[sent to nf-next, not nf] [no stable nomination in thread]

Step 4.2: CHECK WHO REVIEWED THE PATCH
`b4 dig -w`: To netfilter-devel@vger.kernel.org and the author only.
Florian’s SOB is the review.
Record: [netfilter-devel + maintainer applied]

Step 4.3: SEARCH FOR THE BUG REPORT
No Reported-by, syzbot, bugzilla, or CVE in the commit or thread. Bug is
derived from code analysis in the message (exact 2 GiB arithmetic).
Record: [no external bug report] [mechanism documented in the patch]

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Standalone v1. iptables still uses `INT_MAX / sizeof(xt_counters)` plus
`xt_counters_alloc()`’s extra `XT_MAX_TABLE_SIZE` (512 MiB) cap.
ebtables had no equivalent extra cap before this patch.
Record: [standalone] [iptables already had a tighter allocator cap]

Step 4.5: CHECK STABLE MAILING LIST HISTORY
lore.kernel.org HTTP fetch returned 403. `b4 dig` mbox has no stable@
traffic. No evidence it was rejected for stable.
Record: [no stable-list discussion found; lore HTTP 403]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: [`do_replace`, `compat_copy_ebt_replace_from_user`; allocation
in `do_replace_finish`]

Step 5.2: TRACE CALLERS
`do_ebt_set_ctl()` (CAP_NET_ADMIN via `ns_capable(net->user_ns,
CAP_NET_ADMIN)`) → `EBT_SO_SET_ENTRIES` → `do_replace()` /
`compat_do_replace()` → `compat_copy_ebt_replace_from_user()` then
`do_replace_finish()`.
Record: [privileged sockopt; user_ns capable] [not IRQ; process context]

Step 5.3: TRACE CALLEES
`vmalloc_array()` → overflow-checked `__vmalloc`. `get_counters()`
memcpy/sum into `nentries` slots. `copy_to_user` of `num_counters`
entries only after the match check.
Record: [vmalloc_array, get_counters, copy_to_user]

Step 5.4: FOLLOW THE CALL CHAIN
Reachable from `setsockopt` with `EBT_SO_SET_ENTRIES`. `len` need not
include the counter array. Unprivileged user namespaces that have
CAP_NET_ADMIN in that netns can call it if
`CONFIG_BRIDGE_NF_EBTABLES_LEGACY` is loaded. `find_table_lock` failure
still happens **after** the `counterstmp` allocation.
Record: [userspace sockopt] [reachable; userns-relevant]

Step 5.5: SEARCH FOR SIMILAR PATTERNS
`do_update_counters()` also `vmalloc_array(num_counters)` but `len` must
equal `sizeof(hlp) + num_counters * sizeof(ebt_counter)`, so the sockopt
size bounds it. `copy_counters_to_user()` allocates from validated
`nentries`. Sibling not the same bug; this commit does not need to wait
for a series.
Record: [replace path is the unbounded one]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Local tree: `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`; `make
kernelversion` = **6.18.53**; Makefile VERSION/PATCHLEVEL/SUBLEVEL =
6.18.53.
At `v6.18.53`, `do_replace()` still has the old `INT_MAX / sizeof(struct
ebt_counter)` check. `git merge-base --is-ancestor 43ae85af154b
v6.18.53` fails (fix not in 6.18.53). Introducing commit **is** in
6.18.53.
Record: [yes, both native and compat replace] [introduced v2.6.34-rc1]

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
The overflow-check lines at `v6.18.53` match the pre-image of this
patch. `MAX_EBT_ENTRIES` is new here. Clean apply expected.
Record: [clean apply]

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
No earlier equivalent bound on `num_counters`. Name-termination commits
nearby do not fix this.
Record: [no alternate fix in 6.18.y]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
`net/bridge/netfilter/ebtables.c`, `CONFIG_BRIDGE_NF_EBTABLES_LEGACY`
(default n). Still used by docker/libvirt/firewalld-style bridge
filtering on distro kernels that enable it.
Record: [netfilter/ebtables legacy] [IMPORTANT for those configs, not
core mm/VFS]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Mature (2002-era) with occasional correctness/security fixes. Not churny
new code.
Record: [mature/stable]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Systems with legacy ebtables loaded. Trigger is a sockopt, not data-
plane forwarding.
Record: [config-specific / legacy-ebtables users]

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Crafted `EBT_SO_SET_ENTRIES`: small `entries_size`, `num_counters` near
`INT_MAX/16`. Cheap. Needs CAP_NET_ADMIN in the socket’s user_ns
(`ns_capable`), so unprivileged userns can hit it when the module is
present. Not every boot; attacker- or test-triggered.
Record: [malicious/buggy replace] [easy if capable] [userns-capable, not
world-unprivileged without userns]

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Success: ~2 GiB kernel vmalloc held through verify/translate, then freed
— OOM/reclaim. Failure: `-ENOMEM`. Not UAF, not silent corruption, not a
panic by itself. iptables caps similar allocations at 512 MiB; ebtables
could request ~4× that.
Record: [local memory-exhaustion DoS] [HIGH, not crash/corruption
CRITICAL]

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Benefit: stops a documented ~2 GiB sockopt vmalloc on a long-lived path;
high for hosts that ship legacy ebtables. Risk: 6-line bound change,
same formula as `nentries`; very low.
Record: [high benefit for ebtables users] [very low risk] [favorable]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real allocate-before-validate bug; commit shows the 2 GiB request
- Small (6/6), obviously correct, maintainer-applied
- Bug in this 6.18.y tree since v2.6.34; patch applies cleanly
- Reachable from `setsockopt`; `ns_capable` makes userns relevant
- Matches stable “oh, that’s not good” / security-DoS class
- Does not add features or APIs

AGAINST:
- Sent to **nf-next**, not `nf` (not treated as an urgent -rc fix)
- No user/syzbot/CVE report
- Legacy ebtables, Kconfig default n
- Requires CAP_NET_ADMIN in the netns user_ns
- Transient allocation (freed on the later `-EINVAL` path), not a leak

UNRESOLVED:
- lore.kernel.org WebFetch 403; thread recovered via `b4 dig -m` (patch-
  only)
- No stable@ discussion found

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — same ceiling as `nentries`;
   maintainer applied v1
2. Fixes a real bug that affects users? **PASS** — oversized vmalloc
   from a sockopt field that is later rejected
3. Important (crash/security/corruption/deadlock)? **PASS** — local DoS
   / “oh, that’s not good” memory exhaustion, including userns
   CAP_NET_ADMIN; not a panic
4. Small and contained? **PASS** — 6 lines, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — pre-image matches v6.18.53

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not a device ID, quirk, DT, build, or docs exception. Ordinary small
bugfix.

Step 9.4: MAKE YOUR DECISION
nf-next targeting and lack of a reporter argue it is hardening rather
than an emergency, but the defect is concrete, old, reachable, and the
patch is the lowest-risk way to close a ~2 GiB kernel allocation. That
is appropriate for 6.18.y.

What the commit solves for stable users: a crafted ebtables replace can
ask `vmalloc` for up to ~2 GiB of counter scratch space before the
kernel checks that `num_counters` equals the table’s `nentries`.
Tightening that field to `MAX_EBT_ENTRIES` stops the request without
moving vmalloc under `ebt_mutex`.

Risk vs benefit: benefit is preventing reclaim/OOM on a privileged (and
userns-capable) sockopt; risk is a stricter `-ENOMEM` on values that
could never succeed the later equality check.

Verification:
- [Phase 1] Parsed tags: author + Florian Westphal SOB only; no
  Fixes/Reported-by/Cc-stable
- [Phase 1] Body: 134217726 * 16 = 2147483616 documented; verified
  `sizeof(struct ebt_counter)` is two `__u64` in `ebtables.h`
- [Phase 2] Diff: 6/6 in `ebtables.c`; `do_replace` + compat copy;
  `MAX_EBT_ENTRIES` is the old nentries formula
- [Phase 2] Pre-fix at `c06e4b417f61^` and `v6.18.53`: `num_counters >=
  INT_MAX / sizeof(struct ebt_counter)`
- [Phase 2] `do_replace_finish()` still allocates then checks
  `num_counters != t->private->nentries` (lines 1025–1056)
- [Phase 2] `get_counters()` copies/sums `nentries` entries only (lines
  992–1011)
- [Phase 3] `git log -L` on the overflow checks: introduced
  `e788759f44b2` (2010-02-04); `git describe --contains` → v2.6.34-rc1
- [Phase 3] `git merge-base --is-ancestor e788759f44b2 v6.18.53` exit 0;
  `43ae85af154b` not ancestor of v6.18.53
- [Phase 3] No MAX_EBT_ENTRIES before this commit (`git log -S
  MAX_EBT_ENTRIES`)
- [Phase 4] `b4 dig -c 43ae85af154b`: msgid 20260610030259.194456-1; nf-
  next; v1 only
- [Phase 4] `b4 dig -w`: netfilter-devel only; `b4 dig -m`: 110-line
  mbox, no replies
- [Phase 4] Florian nf-next pull `b73bc9ca3686b` item 11 describes
  oversized vmalloc_array prevention
- [Phase 4] UNVERIFIED: stable@ lore search (HTTP 403)
- [Phase 5] Callers: `do_ebt_set_ctl` requires `ns_capable(...,
  CAP_NET_ADMIN)`; `EBT_SO_SET_ENTRIES`
- [Phase 5] `vmalloc_array` uses `check_mul_overflow`
  (`mm/util.c:656-662`) — overflow-safe, still ~2 GiB
- [Phase 5] `xt_counters_alloc` extra cap `XT_MAX_TABLE_SIZE` 512 MiB;
  ebtables lacked that
- [Phase 6] `git describe HEAD` v6.18.53-5049; kernelversion 6.18.53
- [Phase 6] `git show v6.18.53:net/bridge/netfilter/ebtables.c` still
  has the loose num_counters checks at 1132 and 2275
- [Phase 7] `obj-$(CONFIG_BRIDGE_NF_EBTABLES_LEGACY) += ebtables.o`;
  Kconfig default n
- [Phase 8] Failure mode: vmalloc/reclaim/OOM DoS, not oops/corruption
- UNVERIFIED: whether a specific distro 6.18 config enables
  BRIDGE_NF_EBTABLES_LEGACY

The patch meets the stable rules for this 6.18.y tree: real, important,
small, and it applies.

**YES**

 net/bridge/netfilter/ebtables.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 96176aa881117..5266f4d021c6d 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -39,6 +39,8 @@
 #define COUNTER_OFFSET(n) (SMP_ALIGN(n * sizeof(struct ebt_counter)))
 #define COUNTER_BASE(c, n, cpu) ((struct ebt_counter *)(((char *)c) + \
 				 COUNTER_OFFSET(n) * cpu))
+#define MAX_EBT_ENTRIES (((INT_MAX - sizeof(struct ebt_table_info)) / \
+			 NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
 
 struct ebt_pernet {
 	struct list_head tables;
@@ -1126,10 +1128,9 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -EINVAL;
 
 	/* overflow check */
-	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) /
-			NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
+	if (tmp.nentries >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
-	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
+	if (tmp.num_counters >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
 
 	tmp.name[sizeof(tmp.name) - 1] = 0;
@@ -2269,10 +2270,9 @@ static int compat_copy_ebt_replace_from_user(struct ebt_replace *repl,
 	if (tmp.entries_size == 0)
 		return -EINVAL;
 
-	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) /
-			NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
+	if (tmp.nentries >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
-	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
+	if (tmp.num_counters >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
 
 	memcpy(repl, &tmp, offsetof(struct ebt_replace, hook_entry));
-- 
2.53.0

