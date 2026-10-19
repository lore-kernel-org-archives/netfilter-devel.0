Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AC4619B52;
	Mon, 19 Oct 2026 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418661; cv=none; b=spAnL3SAfXw7ZHrCiuNy32pZ3oEDsXOgxPoDIM8esLo5AE3ypVKZn2hM/FZC+hJzu9vZsmQpG8eToWWQxocSNqFy1KWI5VqEUklsulCL8CCP0ADhxK+DMC7nEDn3uWq+VuI72N3fVpu9N7HmAOTC81eSV2sILzTQ5x65941O8JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418661; c=relaxed/simple;
	bh=F0O74A15Hj/PmA4Y+S9XNbNxbJ+L1N6bacmXO1alJYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tVQB5tt3qAIDMA76zAkOxk6nd071nN7HA8RT5vh54zT66jI+ie8AfOgdBB/pdWPtZ2Iyx3r8Eun3huVteloGtk0sVU5JadRk3Bt78Fyeo6zAXGNXhSopTfHUg1co8/Y1/1ZIS0QbdmYWZv3WVKBNMY892x0B2eTpeU+89qEOTKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3e7nqz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3e7nqz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF8A1F000CB;
	Mon, 19 Oct 2026 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418658;
	bh=58OqywC5/wj4SBg5Dvs3gdMF0UUQNJNonHWMD0YlIvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3e7nqz7z+xSSjo9We2cGextq/54FjBdEKJtVJivgnkTjDNJ+6/7Z7n7Nn3gb+PIB
	 3SDEWcz9MFxlWEzTwgqXZEt1vh+PadaAvKwqY6I6UrO4+7OSdJIbVcdOeOtE5YaPId
	 AGskqK4p9iivjsWSs9fzJPr5EyX1m6PAXwLviGEZxQvERj99CGT28/vAcBZj/ad/g1
	 T01uuBdYumKyGMl1yI5sO3CXiGNjx8qjxhEQMYmhvxhdJ80cRS0kNK0hW3N5hT7B4a
	 VcpjjMCnPFh8xx3s2o0lOQze0r3kMKtRjz6zhjzOw3zj7O5dzPFH4P479Ey460mlPy
	 rmewYOZz1dS3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] netfilter: nf_tables: call skb_valid_dst() before skb_dst()
Date: Mon, 19 Oct 2026 09:51:36 -0400
Message-ID: <20261019135441.1420968-405-sashal@kernel.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 689db98e535bf8efb5bc9c36f4fd3de3bd715eb6 ]

When fetching the dst_entry from the skb, check if it valid, ie. this is
not a template dst, for extensions that can be used from the netdev
ingress and egress chains.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The evaluation target is **pending-6.6 (Linux 6.6.157)**. The live
checkout later moved to mainline v7.3-rc4; all 6.6 findings below are
from `refs/heads/pending-6.6` (`p-6.6-3-g04810563abb71`).

Original commit: `689db98e535bf8efb5bc9c36f4fd3de3bd715eb6` (Pablo Neira
Ayuso, 2026-07-31). It is **not** an ancestor of pending-6.6.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: **[netfilter/nf_tables] [call/check] [require a real routing
  dst, not a metadata template, before using skb_dst()]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - **Fixes:** none (expected for this review)
  - **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
  - **Link:** none in the commit; mailing list found separately
  - **Cc: stable:** none (expected)
  - **Signed-off-by:** Pablo Neira Ayuso (netfilter maintainer). Ignore
    Sasha Levin SOB if present in a candidate wrapper.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** `skb_dst()` is used as if it were a real
    `rtable`/`rt6_info`. Packets on netdev/inet ingress/egress often
    carry a **DST_METADATA** template (tunnels, TC) instead.
  - **Symptom:** nft `rt` / `meta rtclassid` / `xfrm` evaluate a
    template dst; `nf_send_reset`/`nf_send_unreach` skip filling a real
    route and treat the template as an `rtable`.
  - **Version info:** none in the message. Buggy pattern is old; 6.6
    still has it.
  - **Root cause (author):** template dst is not a valid routing dst;
    must use `skb_valid_dst()` first.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: **Not hidden.** It is a real validity check. “Call X before Y”
  is a missing-check fix, not cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record:
  - `net/ipv4/netfilter/nf_reject_ipv4.c` (+4/−2)
  - `net/ipv6/netfilter/nf_reject_ipv6.c` (+6/−2)
  - `net/netfilter/nft_meta.c` (+4/−2)
  - `net/netfilter/nft_rt.c` (+4/−2)
  - `net/netfilter/nft_xfrm.c` (+8/−1)
  - **~26 insertions, 9 deletions, 5 files**
  - Functions: `nf_reject_fill_skb_dst`, `nf_send_reset`,
    `nf_send_unreach`, `nf_reject6_fill_skb_dst`, `nf_send_reset6`,
    `nf_send_unreach6`, `nft_meta_get_eval_rtclassid`,
    `nft_rt_get_eval`, `nft_xfrm_get_eval_out`
  - **Scope:** small, same-subsystem, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - **Reject fill:** `skb_dst_set()` over a possible existing template →
    `skb_dst_drop()` then `skb_dst_set()` of a real route.
  - **Reject send:** `if (!skb_dst()) fill` → `if (!skb_valid_dst())
    fill`. Template dst no longer counts as “already routed.”
  - **nft_meta / nft_rt / nft_xfrm:** `skb_dst()` then NULL check →
    `skb_valid_dst()` then `skb_dst()`. Template dst is treated as
    missing.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record:
  - **Category:** logic/correctness + type confusion (metadata dst used
    as `rtable`/`xfrm_dst`).
  - **Mechanism:** `skb_valid_dst()` is `dst && !(dst->flags &
    DST_METADATA)`. Metadata dst is initialized with `dst_blackhole_ops`
    and **`dev == NULL`**. Using it as `skb_rtable()` reads
    `rt_flags`/`rt_gw*` from the metadata union; `nft_xfrm` would walk
    `((xfrm_dst *)dst)->child` if `dst->xfrm` were set.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record:
  - **Quality:** obviously correct; same helper already used in
    `ip_input`, `ip_tunnel`, wireguard, xfrm.
  - **Minimal:** yes. Include of `net/dst_metadata.h` is required for
    the helper.
  - **Regression risk:** low. `meta rtclassid` on a metadata dst
    currently succeeds with `tclassid == 0`; after the fix it fails
    closed (`NFT_BREAK`). That is stricter and correct.
  - **No API/feature additions.**

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record:
  - Reject `!skb_dst() && fill`: `a0a3ace2a5788` (Florian Westphal,
    2025-08-20) already **in 6.6** — “don’t leak dst refcount for
    loopback packets.” That made “any dst present” skip fill, including
    metadata dst.
  - `nft_rt_get_eval` `skb_dst` check: `2fa841938c648` (2016), present
    since nft_rt was added.
  - **Bug is in 6.6, not new mainline-only code.**

**Step 3.2: FOLLOW THE FIXES TAG**
- Record: **No Fixes: tag.** Not applicable. Introducer of the reject
  skip-fill logic **is** in this tree (`a0a3ace2a5788`).

**Step 3.3: CHECK FILE HISTORY**
- Record: Related 6.6 history includes `a0a3ace2a5788` (reject dst leak)
  and `e64a48c50a1ff` (`nf_conntrack_sip`: validate `skb_dst()` for
  tc/OVS). Same class of bug already accepted into 6.6. This commit is
  standalone, not patch 2/N of a required series (it was 8/9 of an nf-
  next pull, but the diff does not depend on patches 1–7).

**Step 3.4: CHECK THE AUTHOR**
- Record: **Pablo Neira Ayuso is the netfilter maintainer.** Nearby work
  is normal nf-next flowtable/conncount material; this hunk is
  independent.

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**
- Record:
  - `skb_valid_dst()` exists in 6.6 `include/net/dst_metadata.h`.
  - No new helpers required.
  - **Can apply standalone** with minor context (see Phase 6).
  - No follow-ups on origin/master after `689db98e535bf`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record:
  - `b4 dig -c 689db98e535bf`: **failed** (lore.kernel.org 503).
  - Fallback: [PATCH net-next 8/9]
    https://lists.openwall.net/netdev/2026/07/31/304
  - Cover: [PATCH net-next 0/9]
    https://lists.openwall.net/netdev/2026/07/31/319
  - Submitted to **nf-next / net-next**, not `net` (fixes). Cover: “Call
    skb_valid_dst() before accessing skb_dst() to ensure dst_entry is
    not a template.”
  - Syzbot CI on the nf-next posting: **passed**
    (https://ci.syzbot.org/series/250b78fc-95ac-4f6f-8746-9f8d8777688b).
    Not a syzbot crash report.
  - No NAK found. No reviewer “Cc: stable” found.

**Step 4.2: CHECK WHO REVIEWED**
- Record: To/Cc: netfilter-devel, davem, kuba, pabeni, edumazet,
  fw@strlen.de, horms. **Florian Westphal (nf core) was CC’d.** Applied
  by Pablo himself. No extra Reviewed-by on the commit.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: **No user/syzbot/bugzilla report.** Author-driven correctness
  fix.

**Step 4.4: RELATED PATCHES AND SERIES**
- Record: Series 1–7 is flowtable/`fill_forward_path` work; patch 9 is
  conntrack TCP timeout. **This patch does not depend on them.** Same-
  class SIP helper fix already in 6.6.

**Step 4.5: STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable fetch returned **403**. **UNVERIFIED**
  whether stable@ discussed this SHA. No evidence it was rejected for
  stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
- Record: listed in 2.1.

**Step 5.2: TRACE CALLERS**
- Record (6.6):
  - `nf_send_unreach` / `nf_send_reset`: `nft_reject_ipv4_eval`,
    `nft_reject_inet_eval`, `ipt_REJECT`.
  - IPv6 equivalents: nft reject ipv6/inet, ip6t_REJECT.
  - **netdev reject does not use these**; it uses `nf_reject_skb_v4_*` /
    `nf_reject_skb_v6_*` (unchanged).
  - `nft_rt_get_eval`: packet path for the `rt` expression; **family
    limited to ipv4/ipv6/inet** (not netdev).
  - `nft_xfrm_get_eval_out`: ipv4/ipv6/inet, OUT hooks only.
  - `nft_meta_get_eval_rtclassid`: **allowed on netdev** (no hook
    restriction for this key).

**Step 5.3: TRACE CALLEES**
- Record: `skb_valid_dst`, `skb_dst_drop`/`skb_dst_set`,
  `nf_ip_route`/`nf_ip6_route`, `skb_rtable`, `icmp_send`/`icmpv6_send`,
  `ip_route_me_harder`.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: Reachable from nftables/iptables **REJECT** and from
  `rt`/`xfrm`/`meta rtclassid` eval. Userspace (`nft`/`iptables`)
  installs the rules. Overlay tunnels (VXLAN/GENEVE collect-md, TC
  tunnel_key) attach metadata dst, then the inner packet hits **inet
  ingress / PRE_ROUTING**. **Yes, reachable.**

**Step 5.5: SIMILAR PATTERNS**
- Record: Same `skb_valid_dst` pattern in `net/ipv4/ip_input.c`,
  `ip_tunnel.c`, `xfrm_input.c`. 6.6 already has `nf_conntrack_sip` dst
  validation for tc/OVS.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE (6.6.157)

**Step 6.1: DOES THE BUGGY CODE EXIST?**
- Record: **Yes.**
  - `nf_reject_ipv4.c`: `if (!skb_dst(oldskb) &&
    nf_reject_fill_skb_dst...)` and no `skb_dst_drop` before
    `skb_dst_set`.
  - Same for IPv6 reject.
  - `nft_rt.c`: `dst = skb_dst(skb); if (!dst) goto err;`
  - `nft_meta.c`: `const struct dst_entry *dst = skb_dst(skb); if (!dst)
    return false;`
  - `nft_xfrm.c`: `const struct dst_entry *dst = skb_dst(pkt->skb);`
    then walk `dst->xfrm`.
  - 6.6 **has** netdev **ingress and egress**
    (`nft_chain_filter_netdev`), **NF_INET_INGRESS** (inet reject
    validates it), and `skb_valid_dst()`.

**Step 6.2: BACKPORT COMPLICATIONS**
- Record: **Minor context, not rework.**
  - 6.6 `nft_rt` uses `(const struct rtable *)dst` not `dst_rtable()`
    (unchanged context).
  - 6.6 `nf_send_reset6` uses `skb_dst(oldskb)->dev` not `skb_dst_dev()`
    (unchanged context). `skb_dst_dev()` exists in 6.6
    `include/net/dst.h` but is not used in this file.
  - Functional hunks match 6.6.

**Step 6.3: RELATED FIXES ALREADY HERE**
- Record: `a0a3ace2a5788` (reject dst leak) and `e64a48c50a1ff` (SIP
  skb_dst). **This metadata-vs-real-dst check is not already applied.**
  `git merge-base --is-ancestor 689db98e535bf pending-6.6` → not
  ancestor.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
- Record: **netfilter / nf_tables + IPv4/IPv6 reject.** **IMPORTANT**
  (firewall/NAT on almost every server/router/container host). Not core
  mm/scheduler, but production-critical networking.

**Step 7.2: SUBSYSTEM ACTIVITY**
- Record: Mature and actively fixed. nft_rt dates to 2016; reject-at-
  prerouting to 2020 (`f53b9b0bdc59`). Long-lived code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
- Record: **Config/driver-specific but common:** `nftables`/`iptables`
  REJECT, `rt`, `meta rtclassid`, `xfrm`, plus overlay/TC metadata dst
  (Kubernetes, OVN, VXLAN/GENEVE collect-md).

**Step 8.2: TRIGGER CONDITIONS**
- Record: Packet carries DST_METADATA **and** hits reject or those
  expressions. Common on inet ingress/PRE_ROUTING of collect-md tunnels.
  Unprivileged users cannot install nft rules (CAP_NET_ADMIN); they
  **can** send traffic that hits existing rules. Timing race: no.

**Step 8.3: FAILURE MODE SEVERITY**
- Record:
  - **Verified:** type confusion (`skb_rtable()` on metadata dst);
    `rt_flags`/`nexthop` taken from the metadata union; reject may skip
    `nf_reject_fill_skb_dst` and feed `icmp_send`/`ip_route_me_harder` a
    template dst.
  - **6.6 `__icmp_send`:** `if (!rt) return` is **not** enough (template
    is non-NULL); `rt->dst.dev` NULL is handled, then `rt->rt_flags` is
    still type-confused.
  - **Not a proven KASAN UAF.** Metadata dst uses `dst_blackhole_ops`,
    so `ops->mtu` is not NULL. `dst->xfrm` is NULL on metadata dst, so
    the xfrm walk typically does not follow a garbage `child`.
  - **Severity: HIGH for firewall correctness** (wrong `rt`/`meta`
    match; REJECT may not emit RST/ICMP). **MEDIUM as a crash**
    (plausible UB/type confusion, not a demonstrated oops). Still a real
    bug in a hot firewall path.

**Step 8.4: RISK-BENEFIT**
- Record:
  - **Benefit:** high for nft/iptables + overlay users; restores
    intended “no real route → lookup or fail closed.”
  - **Risk:** low (26 lines, existing helper, fail closed).
  - **Ratio:** favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**FOR:**
- Real bug: template dst treated as a route.
- Present in 6.6; `skb_valid_dst()` already exists.
- Reject skip-fill was introduced/worsened by a commit **already in
  6.6**.
- Small, maintainer-authored, obviously correct.
- Same class as SIP `skb_dst` validation already in 6.6 stable.
- Realistic trigger: collect-md tunnels + nft/iptables at
  ingress/prerouting.
- No follow-up reverting or rewriting this change.

**AGAINST:**
- Posted as net-next 8/9, not `net`.
- No Fixes/Cc: stable, no crash report.
- netdev-family `reject` does not call `nf_send_*`; `nft_rt`/`nft_xfrm`
  cannot be used on netdev family even in mainline.
- Crash is not as hard as a NULL `ops` deref (blackhole ops).

**UNRESOLVED:**
- lore.kernel.org was 503/403; no full review thread beyond Openwall. No
  stable@ discussion verified.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — helper semantics are clear;
   syzbot CI passed; in mainline since 2026-07.
2. Fixes a real bug that affects users? **PASS** — metadata dst on
   ingress/tunnel paths is real; expressions/reject mishandle it.
3. Important (crash/security/corruption/deadlock)? **PASS** — firewall
   mis-eval and failed REJECT replies on overlay/ingress; type-confused
   `rtable` use. Not a proven panic, but important networking
   correctness.
4. Small and contained? **PASS** — 26/9 lines, five netfilter files.
5. No new features or APIs? **PASS**
6. Can apply to this tree? **PASS** — minor context (`dst_rtable` /
   `skb_dst_dev` in unchanged lines only).

**Step 9.3: EXCEPTION CATEGORIES**
- Record: none (not a device ID/quirk/DT/build/docs exception).
  Qualifies as a normal bugfix.

**Step 9.4: DECISION**
This is a small, correct check that 6.6 needs. The tree has the buggy
`!skb_dst()` reject path, nft `rt`/`meta`/`xfrm` eval, inet ingress, and
netdev ingress/egress. Benefit outweighs risk.

---

### What the commit solves for 6.6 users
Packets with a **metadata/template dst** (VXLAN/GENEVE collect-md, TC)
make `skb_dst()` non-NULL, so reject never installs a real route and
`rt`/`meta rtclassid`/`xfrm` inspect a non-route. Users see wrong nft
matches and missing TCP RST / ICMP unreachable. The fix uses the
existing `skb_valid_dst()` helper and drops any template dst before
attaching a real one.

### Risk vs benefit
Low risk, high correctness value on firewall + overlay hosts. Apply may
need a one-line context tweak in `nft_rt.c` and `nf_reject_ipv6.c`.

### Verification
- **[Phase 1]** Parsed subject/body; tags: only Pablo SOB; no
  Fixes/Reported-by/stable.
- **[Phase 2]** Diff: 5 files, +26/−9; `skb_valid_dst` + `skb_dst_drop`
  before `skb_dst_set`.
- **[Phase 3]** `git describe` of pending-6.6: `p-6.6-3-g04810563abb71`,
  Makefile 6.6.157.
- **[Phase 3]** `git merge-base --is-ancestor 689db98e535bf pending-6.6`
  → not present.
- **[Phase 3]** Blame: reject condition `a0a3ace2a5788` (in 6.6); nft_rt
  `2fa841938c648` (2016).
- **[Phase 3]** `git show pending-6.6:include/net/dst_metadata.h`:
  `skb_valid_dst()` present.
- **[Phase 4]** `b4 dig -c 689db98e535bf`: lore 503, no match.
- **[Phase 4]** Openwall: net-next 8/9 and 0/9 cover; no NAK.
- **[Phase 4]** Syzbot CI series passed; not a syzbot bug report.
- **[Phase 4]** lore.kernel.org/stable: 403, UNVERIFIED.
- **[Phase 5]** Callers verified via `git grep` on pending-6.6:
  ipt_REJECT, nft_reject_ipv4/inet; netdev reject uses `nf_reject_skb_*`
  (not this path).
- **[Phase 5]** `nft_rt_validate` / `nft_xfrm_validate` reject
  NFPROTO_NETDEV in both 6.6 and mainline.
- **[Phase 6]** Buggy `!skb_dst()` / raw `skb_dst()` still in
  pending-6.6 sources.
- **[Phase 6]** Context drift: `dst_rtable` and `skb_dst_dev` not used
  in 6.6 versions of those unchanged lines.
- **[Phase 7]** nf_tables + reject; important.
- **[Phase 8]** `__icmp_send` in 6.6 handles NULL `dst->dev` but still
  reads `rt->rt_flags` from a metadata object.
- **[Phase 8]** Metadata dst: `dst_init(..., NULL, ...)` +
  `DST_METADATA` + `dst_blackhole_ops`; `xfrm == NULL`.
- **UNVERIFIED:** full lore review replies (503); stable@ archive (403).

**YES**

 net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++++--
 net/ipv6/netfilter/nf_reject_ipv6.c | 8 ++++++--
 net/netfilter/nft_meta.c            | 6 ++++--
 net/netfilter/nft_rt.c              | 6 ++++--
 net/netfilter/nft_xfrm.c            | 9 ++++++++-
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 4626dc46808f3..59ec465a9df98 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -8,6 +8,7 @@
 #include <net/tcp.h>
 #include <net/route.h>
 #include <net/dst.h>
+#include <net/dst_metadata.h>
 #include <net/netfilter/ipv4/nf_reject.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
@@ -263,6 +264,7 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 	if (!dst)
 		return -1;
 
+	skb_dst_drop(skb_in);
 	skb_dst_set(skb_in, dst);
 	return 0;
 }
@@ -279,7 +281,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (!oth)
 		return;
 
-	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
+	if (!skb_valid_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
 		return;
 
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
@@ -352,7 +354,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
+	if (!skb_valid_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
 	if (skb_csum_unnecessary(skb_in) ||
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index ef5b7e85cffa8..07cdaa10da0d0 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -8,6 +8,7 @@
 #include <net/ip6_route.h>
 #include <net/ip6_fib.h>
 #include <net/ip6_checksum.h>
+#include <net/dst_metadata.h>
 #include <net/netfilter/ipv6/nf_reject.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
@@ -304,6 +305,7 @@ static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
 	if (!dst)
 		return -1;
 
+	skb_dst_drop(skb_in);
 	skb_dst_set(skb_in, dst);
 	return 0;
 }
@@ -336,10 +338,12 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
 
-	if (!skb_dst(oldskb)) {
+	if (!skb_valid_dst(oldskb)) {
 		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
 		if (!dst)
 			return;
+
+		skb_dst_drop(oldskb);
 		skb_dst_set(oldskb, dst);
 	}
 
@@ -440,7 +444,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
-	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
+	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 19e6d1c2436af..f3c7b7edb10c0 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -20,6 +20,7 @@
 #include <net/dst.h>
 #include <net/ip.h>
 #include <net/sock.h>
+#include <net/dst_metadata.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -274,11 +275,12 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 static noinline bool
 nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
 {
-	const struct dst_entry *dst = skb_dst(skb);
+	const struct dst_entry *dst;
 
-	if (!dst)
+	if (!skb_valid_dst(skb))
 		return false;
 
+	dst = skb_dst(skb);
 	*dest = dst->tclassid;
 	return true;
 }
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index ad527f3596c03..cb7dff336bbdc 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -8,6 +8,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/dst.h>
+#include <net/dst_metadata.h>
 #include <net/ip6_route.h>
 #include <net/route.h>
 #include <net/netfilter/nf_tables.h>
@@ -59,10 +60,11 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 	u32 *dest = &regs->data[priv->dreg];
 	const struct dst_entry *dst;
 
-	dst = skb_dst(skb);
-	if (!dst)
+	if (!skb_valid_dst(skb))
 		goto err;
 
+	dst = skb_dst(skb);
+
 	switch (priv->key) {
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_RT_CLASSID:
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 7ffe6a2690d13..9c9ac27122ad9 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -12,6 +12,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/dst_metadata.h>
 #include <linux/in.h>
 #include <net/xfrm.h>
 
@@ -177,9 +178,15 @@ static void nft_xfrm_get_eval_out(const struct nft_xfrm *priv,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
 {
-	const struct dst_entry *dst = skb_dst(pkt->skb);
+	const struct dst_entry *dst;
 	int i;
 
+	if (!skb_valid_dst(pkt->skb)) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	dst = skb_dst(pkt->skb);
 	for (i = 0; dst && dst->xfrm;
 	     dst = ((const struct xfrm_dst *)dst)->child, i++) {
 		if (i < priv->spnum)
-- 
2.53.0

