Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3489657980B;
	Mon, 31 Aug 2026 13:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184159; cv=none; b=UTsb34yAORgfxHPjTuwao4JoUsxnogKsDfUeQPUeHG8R54gM5M53sfdNlBE8up9k4XGjnXxub5e/JbuQ+c4cNo0Njae76HXLmyD550YyFA20ep4KRywLuAxsnmyQvY+/25Lj4gog7e9YT2gZ1Dzh1sYU6LA0qc4RAK2DRNG30LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184159; c=relaxed/simple;
	bh=27AlrlHHQDrB37ocvfhmevcnlWC4/Vudw53uhZl9NRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ObW/T5QoDxCwXl7SCA5YhIIyL+F6w0HfjASGPNeLEqUwtN74U3OS6V/jtd0eaj4HE94vCcfI62LaWoqOg3MvMo2E8uWUNQUJ3XdrCluDssgnIup74TsQN1whdaYIob7tp3EC0ZE9D9kH96WpjO0Iq+YqPkRKyayZQP34kQQgCuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfOd0979; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfOd0979"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534A11F00A3F;
	Mon, 31 Aug 2026 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184157;
	bh=SQpntyENqJTnNv3xaMo2fTwVx/dWGZvM4OiG2Xkio+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfOd0979ZQNaIGZR9AJ/FZxP79LmtmoCcYfUF6GgcvqQvUBaG9eQ8BYS6ZaBYDxKH
	 /lbrWGDQt01NBR0trlYbjAr2FT74BfydIGw6kL1yy3a+P8ZMOwLN4Jq3CY8xl4lC0M
	 iOUv99fl2hBU93Ngzi2zS86RhnVaiBBhdkCNQ3kPjjsbeuOwkCL+/iDxsZSBc0Loko
	 EuffdqYWzy4iET1wJb9ZtuXlEvuimmSxrVKUZwtHKv8g4uZW1/I0TbgrZJJy5QAoGc
	 5nAomLw/CTvGKUvLgFMndnGwg/26d9oeZaVKpVGMHPFmBj6wYRjiH3mUuCHHZVce+k
	 hfm33nFN664Mg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
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
Subject: [PATCH AUTOSEL 6.18-5.10] netfilter: nf_conntrack_expect: zero at allocation time
Date: Mon, 31 Aug 2026 09:29:13 -0400
Message-ID: <20260831133314.4125787-525-sashal@kernel.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 241ccd2fed9051db443aadce248fc0ab30f55e97 ]

There are occasional LLM hints wrt. leaking uninitialized data to
userspace via ctnetlink.  Just zero at allocation time,
expectations are not frequently used these days.

Intentionally keeps _init as-is because we could theoretically
support re-init, so add the missing exp->dir there.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[netfilter: nf_conntrack_expect]` `[zero]` — zero expectation
objects at allocation time to avoid leaking uninitialized slab data.

**Step 1.2 — Tags**

Record:
- Signed-off-by: Florian Westphal \<fw@strlen.de\>
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable tags

Notable: no formal bug report or syzbot link; author cites “occasional
LLM hints” about ctnetlink leaks.

**Step 1.3 — Body analysis**

Record:
- Bug: `nf_ct_expect_alloc()` uses non-zeroing `kmem_cache_alloc()`;
  fields not explicitly initialized can retain stale slab contents and
  be exposed to userspace via ctnetlink expectation dumps.
- Symptom: spurious or stale data in netlink expectation dumps
  (especially NAT-related attributes).
- Root cause: per-field initialization is incomplete across allocation
  paths; centralized zeroing at alloc is safer.
- Author notes expectations are rarely used today; keeps
  `nf_ct_expect_init()` behavior but adds missing `exp->dir`
  initialization there.

**Step 1.4 — Hidden bug fix?**

Record: Yes. Despite the soft wording, this is a kernel heap
information-leak fix, not a style change. The `kmem_cache_alloc` →
`kmem_cache_zalloc` change and `exp->dir = 0` addition address
uninitialized memory exposure.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- `net/netfilter/nf_conntrack_expect.c`: +2 / -1 (3 lines touched)
- `net/netfilter/nf_conntrack_netlink.c`: +1 / -10 (11 lines removed)
- Functions: `nf_ct_expect_alloc()`, `nf_ct_expect_init()`,
  `ctnetlink_alloc_expect()`
- Scope: small, two-file, surgical fix

**Step 2.2 — Code flow per hunk**

Record:
1. `nf_ct_expect_alloc()`: `kmem_cache_alloc` → `kmem_cache_zalloc` —
   all struct fields start zeroed.
2. `nf_ct_expect_init()`: adds `exp->dir = 0` under `CONFIG_NF_NAT`
   alongside existing `saved_addr`/`saved_proto` zeroing.
3. `ctnetlink_alloc_expect()`: removes redundant `else` branches that
   zeroed `flags`, `expectfn`, and NAT fields — now handled by zalloc.

**Step 2.3 — Bug mechanism**

Record: **Uninitialized data / information leak (category 8)**. Slab
reuse leaves stale kernel data in `struct nf_conntrack_expect` fields.
`ctnetlink_exp_dump_expect()` reads `exp->flags`, and under
`CONFIG_NF_NAT` emits `CTA_EXPECT_NAT` when `saved_addr`/`saved_proto`
look non-zero, leaking stale addresses/ports/direction to userspace.

**Step 2.4 — Fix quality**

Record: Fix is obviously correct and minimal. `kmem_cache_zalloc` is the
standard pattern for objects with many partially-initialized fields.
Regression risk is very low; expectations are infrequent and zeroing
cost is negligible.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `kmem_cache_alloc(nf_ct_expect_cachep, GFP_ATOMIC)` dates to
Patrick McHardy (2007). Bug has existed since expectations used a non-
zeroing slab allocator. `nf_ct_expect_init()` has zeroed
`saved_addr`/`saved_proto` since NAT support was added, but never
`exp->dir`.

**Step 3.2 — Fixes: tag**

Record: N/A — no Fixes: tag in this commit.

**Step 3.3 — Related file history**

Record: Related commit already in this tree:
- `929f7a9a7aad9` — “netfilter: ctnetlink: zero expect NAT fields when
  CTA_EXPECT_NAT absent” — targeted partial fix for the ctnetlink
  userspace creation path only, with a concrete reproduction (kernel
  test robot).

This commit generalizes the fix to all allocation paths and removes the
now-redundant ctnetlink `else` branches.

**Step 3.4 — Author context**

Record: Florian Westphal is an active netfilter contributor/maintainer.
Similar leak fix `7e23965d44f06` (“nft_meta_bridge: fix
NFT_META_BRI_IIFPVID stack leak”) is already in this 6.18.y tree.

**Step 3.5 — Dependencies**

Record: Standalone; no series prerequisites. `git apply --check` on
commit `241ccd2fed905` succeeds cleanly against HEAD.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c 241ccd2fed905` found v1 only at
https://patch.msgid.link/20260625001356.16478-1-fw@strlen.de. Lore fetch
blocked by bot protection; no reviewer replies retrieved.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` shows recipients: Florian Westphal, netfilter-
devel@vger.kernel.org. No explicit maintainer Acked-by in commit.

**Step 4.3 — Bug report**

Record: No formal Reported-by in this commit. Related bug in
`929f7a9a7aad9` was Reported-by: kernel test robot with demonstrated
stale `CTA_EXPECT_NAT` emission.

**Step 4.4 — Series context**

Record: Single-patch series (v1 only). Not part of a multi-patch
dependency chain.

**Step 4.5 — Stable list**

Record: Not searched (lore blocked). Similar Westphal leak fix already
accepted into this stable tree.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `nf_ct_expect_alloc()`, `nf_ct_expect_init()`,
`ctnetlink_alloc_expect()`, `ctnetlink_exp_dump_expect()`.

**Step 5.2 — Callers**

Record: `nf_ct_expect_alloc()` called from ~15 sites: protocol helpers
(FTP, SIP, H.323, PPTP, TFTP, IRC, etc.), `nf_conntrack_broadcast.c`,
`ctnetlink_alloc_expect()`, `nft_ct.c`, IPVS. Most call
`nf_ct_expect_init()` afterward; broadcast manually sets fields without
`nf_ct_expect_init()`.

**Step 5.3 — Callees**

Record: `kmem_cache_zalloc`/`kmem_cache_alloc`, `refcount_set`, slab
free via RCU. Dump path reads struct fields into netlink skb.

**Step 5.4 — Reachability**

Record: Leak is reachable when a privileged user dumps expectations via
ctnetlink (`ctnetlink_exp_dump_expect()`). Creating expectations via
broadcast helper (no NAT field init) and then dumping can expose stale
NAT data — path exists in this tree.

**Step 5.5 — Similar patterns**

Record: `929f7a9a7aad9` fixed the same class of bug narrowly in
ctnetlink. `nf_ct_expect_init()` already zeroes most fields on the
packet path but omitted `dir`. Centralized zalloc is the comprehensive
fix.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**

Record: Yes. HEAD is `v6.18.44` on `stable/linux-6.18.y`. Current code
still uses `kmem_cache_alloc` at line 307 of `nf_conntrack_expect.c`.
Commit `241ccd2fed905` is **not** in this tree.

**Step 6.2 — Backport complications**

Record: Clean apply verified. Removes code added by in-tree
`929f7a9a7aad9`; no structural conflicts.

**Step 6.3 — Related fixes already present**

Record: `929f7a9a7aad9` partially fixes ctnetlink NAT-field leak only.
Does **not** cover `nf_conntrack_broadcast.c` and other paths that
allocate without fully initializing NAT fields. This commit still adds
value.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**

Record: netfilter / nf_conntrack / ctnetlink. Criticality: **IMPORTANT**
(networking core subsystem, widely deployed).

**Step 7.2 — Activity**

Record: Actively maintained; multiple recent expectation/ctnetlink fixes
in this tree’s history.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Systems with `CONFIG_NF_CONNTRACK` and ctnetlink users (firewall
managers, `conntrack` tools). Affects administrators/privileged tooling,
not unprivileged users directly.

**Step 8.2 — Trigger conditions**

Record: Allocate expectation without full field initialization (slab
reuse), then dump via ctnetlink. Moderately rare but reproducible
(demonstrated for ctnetlink path in `929f7a9a7aad9`). Requires
`CAP_NET_ADMIN` for dump.

**Step 8.3 — Failure mode**

Record: Kernel heap memory leaked to userspace via netlink attributes.
Severity: **MEDIUM** (security information disclosure, not
crash/corruption).

**Step 8.4 — Risk/benefit**

Record:
- Benefit: Closes remaining leak paths beyond the partial ctnetlink fix;
  defense-in-depth at the central allocator.
- Risk: Very low — 14-line change, standard zalloc pattern, infrequent
  code path.
- Ratio: Favorable for stable inclusion.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR:
- Real kernel memory info leak via ctnetlink
- Partial fix (`929f7a9a7aad9`) already in tree leaves gaps (e.g.,
  `nf_conntrack_broadcast.c` never initializes NAT fields)
- Tiny, obviously correct, applies cleanly
- Same author’s similar leak fixes already in 6.18.y
- Adds missing `exp->dir` init in `nf_ct_expect_init()`

AGAINST:
- Requires privileged access to observe leak
- Expectations are uncommon
- Primary reported case partially addressed by existing stable commit
- No syzbot/formal CVE; “LLM hints” only in this commit message

UNRESOLVED:
- Full lore review thread (bot-blocked)
- No independent Tested-by on this specific commit

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — zalloc is standard; related
   leak class already reproduced in-tree via `929f7a9a7aad9`.
2. Fixes a real bug affecting users? **PASS** — verified stale-data leak
   path; broadcast path still vulnerable without this fix.
3. Important issue? **PASS** — security information leak (medium
   severity).
4. Small and contained? **PASS** — 14 lines, 2 files.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — `git apply --check` succeeded.

**Step 9.3 — Exception category**

Record: N/A (not device ID, quirk, DT, build, or docs fix — standard bug
fix).

**Step 9.4 — Decision rationale**

This tree (6.18.44) still has the underlying allocator bug. While
`929f7a9a7aad9` patched one ctnetlink-specific leak, `kmem_cache_zalloc`
in `nf_ct_expect_alloc()` fixes all allocation paths comprehensively,
including `nf_conntrack_broadcast.c` which never calls
`nf_ct_expect_init()` and does not initialize NAT-related fields. The
change is minimal, low-risk, and consistent with other netfilter leak
fixes already accepted into this stable series.

---

## Verification

- [Phase 1] Parsed commit `241ccd2fed905`: subject, body, only SOB from
  Florian Westphal
- [Phase 2] Diff analysis: 2 files, `kmem_cache_zalloc`, `exp->dir = 0`,
  removed ctnetlink else branches
- [Phase 3] `git describe HEAD`: v6.18.44; tree is stable/linux-6.18.y
- [Phase 3] `git blame`: `kmem_cache_alloc` since 2007
- [Phase 3] `929f7a9a7aad9` confirmed in tree via `git merge-base --is-
  ancestor`
- [Phase 3] `241ccd2fed905` confirmed NOT in tree
- [Phase 3] `git apply --check` on patch: clean apply
- [Phase 4] `b4 dig -c 241ccd2fed905`: found v1 at
  patch.msgid.link/20260625001356.16478-1-fw@strlen.de
- [Phase 4] `b4 dig -w`: netfilter-devel CC'd
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] Lore thread fetch: blocked by Anubis (UNVERIFIED: reviewer
  comments)
- [Phase 5] `grep nf_ct_expect_alloc`: 15+ call sites; broadcast path
  does not call `nf_ct_expect_init()`
- [Phase 5] Read `ctnetlink_exp_dump_expect()`: dumps flags always; NAT
  block when `saved_addr`/`saved_proto` non-zero
- [Phase 5] Read `nf_conntrack_broadcast.c`: does not init
  `saved_addr`/`saved_proto`/`dir`
- [Phase 6] Current code at line 307: still `kmem_cache_alloc`
- [Phase 6] `7e23965d44f06` similar Westphal leak fix present in tree
- [Phase 8] Trigger requires CAP_NET_ADMIN for ctnetlink dump (standard
  nfnetlink permission model)

**YES**

 net/netfilter/nf_conntrack_expect.c  |  3 ++-
 net/netfilter/nf_conntrack_netlink.c | 11 +----------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 8e943efbdf0a5..6266d4d2ffca4 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -304,7 +304,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 {
 	struct nf_conntrack_expect *new;
 
-	new = kmem_cache_alloc(nf_ct_expect_cachep, GFP_ATOMIC);
+	new = kmem_cache_zalloc(nf_ct_expect_cachep, GFP_ATOMIC);
 	if (!new)
 		return NULL;
 
@@ -386,6 +386,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 #if IS_ENABLED(CONFIG_NF_NAT)
 	memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
 	memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
+	exp->dir = 0;
 #endif
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3df7e5fc76c8b..e046281895743 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3559,8 +3559,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (cda[CTA_EXPECT_FLAGS]) {
 		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
 		exp->flags &= ~NF_CT_EXPECT_USERSPACE;
-	} else {
-		exp->flags = 0;
 	}
 	if (cda[CTA_EXPECT_FN]) {
 		const char *name = nla_data(cda[CTA_EXPECT_FN]);
@@ -3572,8 +3570,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 			goto err_out;
 		}
 		exp->expectfn = expfn->expectfn;
-	} else
-		exp->expectfn = NULL;
+	}
 
 	exp->class = class;
 	exp->master = ct;
@@ -3592,12 +3589,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 						 exp, nf_ct_l3num(ct));
 		if (err < 0)
 			goto err_out;
-#if IS_ENABLED(CONFIG_NF_NAT)
-	} else {
-		memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
-		memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
-		exp->dir = 0;
-#endif
 	}
 	return exp;
 err_out:
-- 
2.53.0

