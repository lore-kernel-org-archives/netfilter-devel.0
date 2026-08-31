Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A05A4B2048;
	Mon, 31 Aug 2026 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184271; cv=none; b=XqBls/QTiyYxTsRDRJgtA7cOK3cAXVM5l3dLAHsn7OdouV9j/A71/EOnJ5k7Y+3RnrKIHrOUuX5JyXV4g+EgmX+fodrMNMEZxSns90uOIPquxYtBF2BcSMyU/dPy3C6R6qsx1Z6dh6WvvxdAHmznE14D/qqnYNXsW+hvj9MgZ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184271; c=relaxed/simple;
	bh=3HuJbXzlqEDGzPUxPWLOHrmcX6KHIf2LB9bOys2hxZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uKUxKW7BYJIhpfT50TZihm+O5/K5H8P0BH59r8/f5l0MrD+7nkDCNXgZ4a4JxcnH5/7BdJkPV7NJCkDqPnhyQTY/3/PTXfwNPs85YmXHWzokEglqKGTXY5W1uOkBEW0p3cNhNbazvYbO3Z4XS8TNUOEWhFors26x57yNYFUnhh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqigD6mp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqigD6mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A051F00A3D;
	Mon, 31 Aug 2026 13:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184268;
	bh=a7KGhVOScPlEMGSP5V3+3FsIFjW5YlebcbymBRGHCow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqigD6mpsRv/8bDQCqeRGCcDSn01YgzvYTs8DXcVtbo3ZChfNE8tApgR53PrY2g96
	 w4SqyX0C/6M640EffJ//zy11guBwUmXrpdA6+uxe9QGk+QK1VPEDygt9/7Pen8UsAM
	 cDB1/B7Q86sm2y7XpiG3yr3YuXLkv3YsVEAmFQdffbml+Lnyno7y2eo1h1s7hRnoaE
	 OR/lW8RRH1uivlFsOccYQ3NzgQV/5cO4fwDiP5xxYAizMr3B+2P7G8M7Pvpjw5uYrR
	 GAv/hAl/8YtGOza6iX8S2gG5yWoajGGRkkz5k/dnTNWG35OGpak8DWygF7K8lM1sJp
	 iSQ3sUMa/YOmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] netfilter: nf_tables: use DEBUG_NET_WARN_ON_ONCE in packet and control paths
Date: Mon, 31 Aug 2026 09:30:19 -0400
Message-ID: <20260831133314.4125787-591-sashal@kernel.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 42eb1ca711b6f3c0cc09d872ff49fa7aa17a56e1 ]

Replace raw warning macros with DEBUG_NET_WARN_ON_ONCE across the
nf_tables API, core engine, and expression evaluations. This prevents
unnecessary system panics when panic_on_warn=1 is enabled in production
systems.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[netfilter: nf_tables]` / `use` / Replace raw `WARN_ON_ONCE`
with `DEBUG_NET_WARN_ON_ONCE` in nftables packet and control paths to
avoid panics under `panic_on_warn=1`.

**Step 1.2 — Tags**

Record:
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none
- **Cc: stable@vger.kernel.org:** none (expected for manual review)
- **Signed-off-by:** Fernando Fernandez Mancera `<fmancera@suse.de>`,
  Pablo Neira Ayuso `<pablo@netfilter.org>` (netfilter maintainer)

Notable: maintainer sign-off; no syzbot/fuzzer tags; patch 2/9 in a
broader netfilter `DEBUG_NET_WARN_ON_ONCE` series.

**Step 1.3 — Body**

Record:
- **Bug:** `WARN_ON_ONCE` on nftables packet/control paths can panic the
  kernel when `panic_on_warn=1`.
- **Symptom:** Full system panic during nftables processing, even though
  the code already handles the condition (drop packet, return error,
  defensive fallback).
- **Root cause:** `WARN_ON_ONCE` always emits a kernel warning;
  `panic_on_warn` turns any warning into `panic()`.
- **Version info:** none in message.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Framed as macro replacement, but it fixes a real
stability bug: handled internal-invariant failures become fatal panics
on hardened production configs instead of graceful degradation.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **22 files**, roughly **+76 / -46** lines.
- Core files: `nf_tables_api.c`, `nf_tables_core.c`,
  `nf_tables_offload.c`, `nf_tables_trace.c`, plus ~18 `nft_*.c`
  expression modules.
- Functions touched include `nft_do_chain()`, `nft_register_expr()`,
  `nft_expr_clone()`, `nf_tables_commit_chain_prepare()`,
  `nft_parse_register_load()`, `nft_data_init()`, and many expression
  `*_eval()` default branches.
- **Scope:** Multi-file but mechanical; not a refactor.

**Step 2.2 — Code flow changes**

Record per hunk pattern:
- **Before:** `if (WARN_ON_ONCE(cond)) return error;` — condition
  checked, warning emitted on failure, then existing error handling
  runs.
- **After:** `if (unlikely(cond)) { DEBUG_NET_WARN_ON_ONCE(1); return
  error; }` — same runtime handling; warning only when
  `CONFIG_DEBUG_NET=y`.
- **`nft_do_chain()` jump overflow:** Before `WARN_ON_ONCE` + `NF_DROP`;
  after `DEBUG_NET_WARN_ON_ONCE` + `NF_DROP_REASON(..., ELOOP)`
  (slightly better drop reason).
- **Default switch branches:** `WARN_ON_ONCE(1)` / `WARN_ON(1)` →
  `DEBUG_NET_WARN_ON_ONCE(1)` with existing fallthrough/error behavior
  unchanged.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Logic/correctness + production-stability interaction
  with `panic_on_warn`.
- **Mechanism:** Defensive invariant checks on hot packet path and
  netlink control path use `WARN_ON_ONCE`, which calls
  `check_panic_on_warn("kernel")` when `panic_on_warn=1` (verified in
  `kernel/panic.c`). The underlying failure is already handled; the WARN
  makes it fatal.

**Step 2.4 — Fix quality**

Record:
- **Obviously correct:** Yes; follows `DEBUG_NET_WARN_ON_ONCE` design
  from `include/net/net_debug.h`.
- **Minimal:** Yes; mechanical replacements.
- **Regression risk:** Low. `DEBUG_NET_WARN_ON_ONCE` without
  `CONFIG_DEBUG_NET` is a no-op via `BUILD_BUG_ON_INVALID`; runtime
  checks remain via explicit `unlikely()` branches.
- **Red flags:** 22 files, but no API/struct changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- Jump-stack `WARN_ON_ONCE` introduced in `adc972c5b8882` (Jun 2018):
  replaced `BUG_ON` with `WARN_ON_ONCE` + `NF_DROP` because hard crash
  was unnecessary.
- That code is present in this tree at `nf_tables_core.c:317-318`.
- `DEBUG_NET_WARN_ON_ONCE` macro added in `d268c1f5cfc92` (May 2022).

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**

Record:
- `nf_tables_api.c` already has one `DEBUG_NET_WARN_ON_ONCE` use (export
  path); most nftables code still uses raw `WARN_ON_ONCE` (~77
  occurrences across nftables files in this tree).
- Target commit `42eb1ca711b6f` is **not** an ancestor of HEAD; patch
  applies cleanly (`git apply --check` passed).

**Step 3.4 — Author context**

Record: Fernando Fernandez Mancera (SUSE) submitted patch 2/9 of a
netfilter-wide series; Pablo Neira Ayuso (maintainer) committed it.

**Step 3.5 — Dependencies**

Record:
- **Standalone for nftables:** Yes.
- **Prerequisite:** `CONFIG_DEBUG_NET` / `DEBUG_NET_WARN_ON_ONCE` —
  present since 2022 in this tree.
- **Prerequisite:** `NF_DROP_REASON()` — present in
  `include/linux/netfilter.h`.
- Part of a 9-patch series, but this hunk does not require the other
  patches.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c 42eb1ca711b6f` →
  https://patch.msgid.link/20260601193049.8131-3-fmancera@suse.de
- Series cover letter (web search): patch 2/9; motivation is preventing
  `panic_on_warn=1` panics on already-handled netfilter invariant
  failures.
- Lore fetch blocked by bot protection; could not read thread replies
  directly.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` returned only the patch URL; cover letter CC list
(from openwall mirror) included `edumazet@google.com`, `fw@strlen.de`,
`kuba@kernel.org`, `pablo@netfilter.org`.

**Step 4.3 — Bug report**

Record: N/A — no external bug report or syzbot link.

**Step 4.4 — Related patches**

Record: 9-patch series across xtables, nf_tables, nfnetlink, conntrack,
nat, tproxy, bpf, flowtable, conncount. This commit only touches
nf_tables.

**Step 4.5 — Stable list history**

Record: UNVERIFIED — could not search lore stable archive due to bot
protection.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `nft_do_chain()`, `nft_register_expr()`, `nft_expr_clone()`,
`nf_tables_commit_chain_prepare()`, `nft_parse_register_load()`,
`nft_data_init()`, plus expression evaluators in `nft_meta.c`,
`nft_payload.c`, `nft_socket.c`, etc.

**Step 5.2 — Callers**

Record:
- `nft_do_chain()` — packet hot path via netfilter hooks; every
  nftables-filtered packet.
- `nft_register_expr()` / netlink handlers — control plane from
  `nft`/`iptables-nft` with `CAP_NET_ADMIN`.
- Expression `*_eval()` — per-rule packet evaluation.

**Step 5.3 — Callees**

Record: `DEBUG_NET_WARN_ON_ONCE`, `NF_DROP_REASON`, existing nftables
error returns (`-EINVAL`, `-ENOMEM`, `NFT_BREAK`, etc.).

**Step 5.4 — Reachability**

Record:
- **Packet path:** Yes — reachable on every packet through nftables
  rules.
- **Jump stack overflow:** Reachable with >16 nested `jump` operations
  (`NFT_JUMP_STACK_SIZE` is 16); requires admin-configured rules, but is
  a known path since 2018.
- **Unprivileged trigger:** No direct unprivileged syscall path; netlink
  config needs privileges. Packet-path panics affect all traffic on the
  host.

**Step 5.5 — Similar patterns**

Record: Networking already migrated many sites to
`DEBUG_NET_WARN_ON_ONCE` (e.g. `skb_release_head_state()` in
`7890e2f09d437`, multiple `skbuff.c` sites). nftables is late to adopt
the same pattern.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record:
- **Local tree:** `v6.18.44` (`git describe HEAD` →
  `v6.18.44-1-g2736c32da98b9`).
- **Buggy `WARN_ON_ONCE` calls present:** Yes (e.g.
  `nf_tables_core.c:317,329`; many more in `nf_tables_api.c` and
  `nft_*.c`).
- **Fix not yet merged:** `42eb1ca711b6f` is **NOT IN TREE**.

**Step 6.2 — Backport complications**

Record: **Clean apply** verified with `git format-patch | git apply
--check`. No rework expected.

**Step 6.3 — Related fixes already present?**

Record: Partial — one `DEBUG_NET_WARN_ON_ONCE` in `nf_tables_api.c`;
bulk of nftables still uses raw `WARN_ON_ONCE`. This specific fix is not
present.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: **netfilter / nf_tables** — **IMPORTANT** (firewall/NAT for
servers, routers, containers; packet hot path).

**Step 7.2 — Activity**

Record: Actively maintained; recent commits in `nf_tables_api.c` include
UAF fixes, set/chain handling changes.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Systems running nftables with `panic_on_warn=1`
(enterprise/hardened configs; SUSE motivation). Affects all network
traffic on those hosts when an invariant fires.

**Step 8.2 — Trigger conditions**

Record:
- `panic_on_warn=1` (sysctl, non-default but used in production).
- Plus any nftables internal invariant failure (jump depth, malformed
  internal state, default switch branches).
- Jump overflow: uncommon but possible with complex admin rules.
- **Unprivileged direct trigger:** No.

**Step 8.3 — Failure mode severity**

Record: **CRITICAL** — full kernel panic on packet path, despite
existing graceful drop/error handling.

**Step 8.4 — Risk/benefit**

Record:
- **Benefit:** High for `panic_on_warn=1` + nftables deployments;
  prevents total outage when a handled condition occurs.
- **Risk:** Low — mechanical macro swap, no structural changes, clean
  apply.
- **Ratio:** Favorable for stable.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

**FOR:**
- Prevents kernel panic on handled nftables errors when
  `panic_on_warn=1`.
- Packet-path impact (`nft_do_chain`) is severe when triggered.
- Follows established `DEBUG_NET_WARN_ON_ONCE` networking pattern (Eric
  Dumazet, 2022).
- Small per-hunk changes; applies cleanly to v6.18.44.
- Netfilter maintainer signed off.
- Restores intent of 2018 change that replaced `BUG_ON` with graceful
  `NF_DROP` on jump-stack overflow.

**AGAINST:**
- Only matters when `panic_on_warn=1` (not default).
- Not a memory-safety bug (UAF/OOB).
- 22 files (though mechanically simple).
- Arguably reduces visibility of internal bugs for admins who explicitly
  chose `panic_on_warn=1`.
- Part of a larger series (other netfilter subsystems not covered by
  this commit).

**Unresolved:** Lore thread replies and explicit stable nominations —
UNVERIFIED due to fetch blocking.

**Step 9.2 — Stable rules checklist**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — established macro
pattern; maintainer SOB; no Tested-by |
| 2. Fixes real bug affecting users? | **PASS** — panic on handled
nftables path with `panic_on_warn=1` |
| 3. Important issue? | **PASS** — kernel panic (CRITICAL) |
| 4. Small and contained? | **PASS** — mechanical, +76/-46, no refactor
|
| 5. No new features/APIs? | **PASS** |
| 6. Can apply to local tree? | **PASS** — clean apply verified;
prerequisites present |

**Step 9.3 — Exception category**

Record: None (not device ID, quirk, DT, build fix, or docs). Standard
stability bug fix.

**Step 9.4 — Decision rationale**

For **this** tree (v6.18.44), the buggy pattern exists, prerequisites
exist, and the patch applies cleanly. The commit fixes a real
production-stability issue: nftables already handles these conditions
gracefully, but `WARN_ON_ONCE` + `panic_on_warn=1` turns them into full
system crashes on the packet hot path. That matches stable criteria for
serious crashes with a low-risk, maintainer-reviewed fix.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  `git show 42eb1ca711b6f`
- [Phase 2] Diff analysis: 22 files, +76/-46; `WARN_ON_ONCE` →
  `unlikely()` + `DEBUG_NET_WARN_ON_ONCE`
- [Phase 3] `git describe HEAD` → v6.18.44; `git merge-base --is-
  ancestor 42eb1ca HEAD` → NOT IN TREE
- [Phase 3] `git blame nf_tables_core.c:317` → `adc972c5b8882` (2018,
  BUG_ON→WARN_ON_ONCE+NF_DROP)
- [Phase 3] `d268c1f5cfc92` added `CONFIG_DEBUG_NET` and
  `DEBUG_NET_WARN_ON_ONCE`
- [Phase 3] `git apply --check` on patch → applies cleanly
- [Phase 4] `b4 dig -c 42eb1ca711b6f` → patch URL found
- [Phase 4] Web search found series cover letter (9 patches,
  panic_on_warn motivation)
- [Phase 4] Lore/patch.msgid.link fetch → blocked; thread content
  UNVERIFIED
- [Phase 5] `NFT_JUMP_STACK_SIZE` = 16 in
  `include/net/netfilter/nf_tables.h`
- [Phase 5] `check_panic_on_warn()` in `kernel/panic.c:372-377` panics
  when `panic_on_warn` set
- [Phase 5] `DEBUG_NET_WARN_ON_ONCE` definition in
  `include/net/net_debug.h:151-156`
- [Phase 6] All 22 modified files exist in tree
- [Phase 6] Current tree: 77 `WARN_ON_ONCE` vs 2
  `DEBUG_NET_WARN_ON_ONCE` in nftables files
- [Phase 6] `NF_DROP_REASON` exists in `include/linux/netfilter.h`
- [Phase 8] `nf_tables_core.c:317-318` still has unfixed `WARN_ON_ONCE`
  on jump-stack path

**YES**

 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++++++++++--------
 net/netfilter/nf_tables_core.c    |  8 ++++---
 net/netfilter/nf_tables_offload.c |  2 +-
 net/netfilter/nf_tables_trace.c   |  6 +++--
 net/netfilter/nft_ct.c            |  2 +-
 net/netfilter/nft_ct_fast.c       |  2 +-
 net/netfilter/nft_exthdr.c        |  2 +-
 net/netfilter/nft_fib.c           |  2 +-
 net/netfilter/nft_inner.c         |  2 +-
 net/netfilter/nft_lookup.c        |  2 +-
 net/netfilter/nft_masq.c          |  2 +-
 net/netfilter/nft_meta.c          | 10 ++++----
 net/netfilter/nft_payload.c       |  6 ++---
 net/netfilter/nft_redir.c         |  2 +-
 net/netfilter/nft_reject.c        |  8 +++++--
 net/netfilter/nft_rt.c            |  2 +-
 net/netfilter/nft_set_hash.c      |  2 +-
 net/netfilter/nft_set_pipapo.c    |  2 +-
 net/netfilter/nft_set_rbtree.c    |  6 +++--
 net/netfilter/nft_socket.c        |  8 ++++---
 net/netfilter/nft_tunnel.c        |  2 +-
 net/netfilter/nft_xfrm.c          |  6 ++---
 22 files changed, 76 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ca6d2041eee66..d2f890627d0af 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3258,8 +3258,10 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
-	if (WARN_ON_ONCE(type->maxattr > NFT_EXPR_MAXATTR))
+	if (unlikely(type->maxattr > NFT_EXPR_MAXATTR)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -ENOMEM;
+	}
 
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
@@ -3571,8 +3573,10 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp)
 {
 	int err;
 
-	if (WARN_ON_ONCE(!src->ops->clone))
+	if (unlikely(!src->ops->clone)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	dst->ops = src->ops;
 	err = src->ops->clone(dst, src, gfp);
@@ -8211,8 +8215,10 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 			return 0;
 
 		type = nft_obj_type_get(net, objtype, family);
-		if (WARN_ON_ONCE(IS_ERR(type)))
+		if (IS_ERR(type)) {
+			DEBUG_NET_WARN_ON_ONCE(1);
 			return PTR_ERR(type);
+		}
 
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
@@ -10161,19 +10167,25 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 
 		prule = (struct nft_rule_dp *)data;
 		data += offsetof(struct nft_rule_dp, data);
-		if (WARN_ON_ONCE(data > data_boundary))
+		if (unlikely(data > data_boundary)) {
+			DEBUG_NET_WARN_ON_ONCE(1);
 			return -ENOMEM;
+		}
 
 		size = 0;
 		nft_rule_for_each_expr(expr, last, rule) {
-			if (WARN_ON_ONCE(data + size + expr->ops->size > data_boundary))
+			if (unlikely(data + size + expr->ops->size > data_boundary)) {
+				DEBUG_NET_WARN_ON_ONCE(1);
 				return -ENOMEM;
+			}
 
 			memcpy(data + size, expr, expr->ops->size);
 			size += expr->ops->size;
 		}
-		if (WARN_ON_ONCE(size >= 1 << 12))
+		if (unlikely(size >= 1 << 12)) {
+			DEBUG_NET_WARN_ON_ONCE(1);
 			return -ENOMEM;
+		}
 
 		prule->handle = rule->handle;
 		prule->dlen = size;
@@ -10184,8 +10196,10 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 		chain->blob_next->size += (unsigned long)(data - (void *)prule);
 	}
 
-	if (WARN_ON_ONCE(data > data_boundary))
+	if (unlikely(data > data_boundary)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -ENOMEM;
+	}
 
 	prule = (struct nft_rule_dp *)data;
 	nft_last_rule(chain, prule);
@@ -11494,8 +11508,10 @@ int nft_parse_register_load(const struct nft_ctx *ctx,
 	next_register = DIV_ROUND_UP(len, NFT_REG32_SIZE) + reg;
 
 	/* Can't happen: nft_validate_register_load() should have failed */
-	if (WARN_ON_ONCE(next_register > NFT_REG32_NUM))
+	if (unlikely(next_register > NFT_REG32_NUM)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	/* find first register that did not see an earlier store. */
 	invalid_reg = find_next_zero_bit(ctx->reg_inited, NFT_REG32_NUM, reg);
@@ -11742,8 +11758,10 @@ int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
 	struct nlattr *tb[NFTA_DATA_MAX + 1];
 	int err;
 
-	if (WARN_ON_ONCE(!desc->size))
+	if (unlikely(!desc->size)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	err = nla_parse_nested_deprecated(tb, NFTA_DATA_MAX, nla,
 					  nft_data_policy, NULL);
@@ -11809,7 +11827,7 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 		break;
 	default:
 		err = -EINVAL;
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 	}
 
 	nla_nest_end(skb, nest);
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 6557a4018c099..267b8849fef19 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -314,8 +314,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 
 	switch (regs.verdict.code) {
 	case NFT_JUMP:
-		if (WARN_ON_ONCE(stackptr >= NFT_JUMP_STACK_SIZE))
-			return NF_DROP;
+		if (unlikely(stackptr >= NFT_JUMP_STACK_SIZE)) {
+			DEBUG_NET_WARN_ON_ONCE(1);
+			return NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, ELOOP);
+		}
 		jumpstack[stackptr].rule = nft_rule_next(rule);
 		stackptr++;
 		fallthrough;
@@ -326,7 +328,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	case NFT_RETURN:
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 	}
 
 	if (stackptr > 0) {
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index fd30e205de849..e43470d0e3bd2 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -361,7 +361,7 @@ static int nft_block_setup(struct nft_base_chain *basechain,
 		err = nft_flow_offload_unbind(bo, basechain);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		err = -EOPNOTSUPP;
 	}
 
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index a88abae5a9de2..d85b6a2fb43ca 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -227,8 +227,10 @@ static const struct nft_chain *nft_trace_get_chain(const struct nft_rule_dp *rul
 
 	last = (const struct nft_rule_dp_last *)rule;
 
-	if (WARN_ON_ONCE(!last->chain))
+	if (unlikely(!last->chain)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return &info->basechain->chain;
+	}
 
 	return last->chain;
 }
@@ -354,7 +356,7 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 	return;
 
  nla_put_failure:
-	WARN_ON_ONCE(1);
+	DEBUG_NET_WARN_ON_ONCE(1);
 	kfree_skb(skb);
 }
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index b29ff555979b2..c3063d5c70951 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1135,7 +1135,7 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 		to_assign = priv->helper6;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return;
 	}
 
diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
index ecf7b3a404be2..a44524c4fe630 100644
--- a/net/netfilter/nft_ct_fast.c
+++ b/net/netfilter/nft_ct_fast.c
@@ -53,7 +53,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 		return;
 #endif
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		regs->verdict.code = NFT_BREAK;
 		break;
 	}
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index cee93149dca7e..da772081f1ed7 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -298,7 +298,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 						 old.v32, new.v32, false);
 			break;
 		default:
-			WARN_ON_ONCE(1);
+			DEBUG_NET_WARN_ON_ONCE(1);
 			break;
 		}
 
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 7b2a0a031c4b4..660ee0115323b 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -170,7 +170,7 @@ void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 			strscpy_pad(reg, dev ? dev->name : "", IFNAMSIZ);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		*dreg = 0;
 		break;
 	}
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index ad08a43535b55..35cb2feb34fee 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -308,7 +308,7 @@ static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		nft_meta_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, &tun_ctx);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	nft_inner_save_tun_ctx(pkt, &tun_ctx);
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 699254cb3ecd6..c37c21272cebf 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -50,7 +50,7 @@ __nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 	if (set->ops == &nft_set_rbtree_type.ops)
 		return nft_rbtree_lookup(net, set, key);
 
-	WARN_ON_ONCE(1);
+	DEBUG_NET_WARN_ON_ONCE(1);
 #endif
 	return set->ops->lookup(net, set, key);
 }
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 2b01128737a3a..841efd981e200 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -123,7 +123,7 @@ static void nft_masq_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 19e6d1c2436af..6d43e20c71de4 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -114,12 +114,12 @@ nft_meta_get_eval_pkttype_lo(const struct nft_pktinfo *pkt,
 			nft_reg_store8(dest, PACKET_MULTICAST);
 			break;
 		default:
-			WARN_ON_ONCE(1);
+			DEBUG_NET_WARN_ON_ONCE(1);
 			return false;
 		}
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return false;
 	}
 
@@ -405,7 +405,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_meta_get_eval_sdifname(dest, pkt);
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	return;
@@ -451,7 +451,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 	}
 }
 EXPORT_SYMBOL_GPL(nft_meta_set_eval);
@@ -832,7 +832,7 @@ void nft_meta_inner_eval(const struct nft_expr *expr,
 		nft_reg_store8(dest, tun_ctx->l4proto);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	return;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e07888aaf1475..8ebd1ef9f935c 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -196,7 +196,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	offset += priv->offset;
@@ -599,7 +599,7 @@ void nft_payload_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		offset = tun_ctx->inner_thoff;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	offset += priv->offset;
@@ -866,7 +866,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 58ae802db8f52..a98aa28180fbe 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -126,7 +126,7 @@ static void nft_redir_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 196a92c7ea09b..e3972e904cf0f 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -102,8 +102,10 @@ static u8 icmp_code_v4[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmp_code(u8 code)
 {
-	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+	if (unlikely(code > NFT_REJECT_ICMPX_MAX)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return ICMP_NET_UNREACH;
+	}
 
 	return icmp_code_v4[code];
 }
@@ -120,8 +122,10 @@ static u8 icmp_code_v6[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmpv6_code(u8 code)
 {
-	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+	if (unlikely(code > NFT_REJECT_ICMPX_MAX)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return ICMPV6_NOROUTE;
+	}
 
 	return icmp_code_v6[code];
 }
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index ad527f3596c03..560734d0d7531 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -93,7 +93,7 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	return;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index b0e571c8e3f38..eb4e382119d4f 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -385,7 +385,7 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 		break;
 	default:
 		iter->err = -EINVAL;
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index b377bef60b212..0e4b91c3248b3 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2226,7 +2226,7 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 		break;
 	default:
 		iter->err = -EINVAL;
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index a698420ab2b8c..0264bcb4bdb50 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -661,8 +661,10 @@ static int nft_array_may_resize(const struct nft_set *set, bool flush)
 	}
 
 realloc_array:
-	if (WARN_ON_ONCE(nelems > new_max_intervals))
+	if (unlikely(nelems > new_max_intervals)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -ENOMEM;
+	}
 
 	if (priv->array_next) {
 		if (max_intervals == new_max_intervals)
@@ -890,7 +892,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 		break;
 	default:
 		iter->err = -EINVAL;
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index c55a1310226a4..8f7ee6313f2b5 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -71,8 +71,10 @@ static noinline int nft_socket_cgroup_subtree_level(void)
 	if (level > 255)
 		return -ERANGE;
 
-	if (WARN_ON_ONCE(level < 0))
+	if (unlikely(level < 0)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	return level;
 }
@@ -97,7 +99,7 @@ static struct sock *nft_socket_do_lookup(const struct nft_pktinfo *pkt)
 		break;
 #endif
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 
@@ -152,7 +154,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		regs->verdict.code = NFT_BREAK;
 	}
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 78d47f5503551..06debdb6f3d85 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -60,7 +60,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 			regs->verdict.code = NFT_BREAK;
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		regs->verdict.code = NFT_BREAK;
 	}
 }
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 7ffe6a2690d13..311169c7d4d06 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -132,7 +132,7 @@ static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
 	switch (priv->key) {
 	case NFT_XFRM_KEY_UNSPEC:
 	case __NFT_XFRM_KEY_MAX:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	case NFT_XFRM_KEY_DADDR_IP4:
 		*dest = (__force __u32)state->id.daddr.a4;
@@ -206,7 +206,7 @@ static void nft_xfrm_get_eval(const struct nft_expr *expr,
 		nft_xfrm_get_eval_out(priv, regs, pkt);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		regs->verdict.code = NFT_BREAK;
 		break;
 	}
@@ -252,7 +252,7 @@ static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *e
 			(1 << NF_INET_POST_ROUTING);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
 	}
 
-- 
2.53.0

