Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAD553D571;
	Mon, 19 Oct 2026 14:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418711; cv=none; b=K6J8XbI95ujNK/nqedw0HykNJF44sRLPG7oNRXIgHNPJFUtRhRsR0jeXjxWiEM9UGp6qJDGC3MP+jOj7zxTkQ1bbwEo+yA4YEFmHKPuLsTQSQOUGEfcRB8iVyHWJWocMgFb/v4oLhD97RxBda2uqYH/aNS2cpX+0X1FkThrdiIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418711; c=relaxed/simple;
	bh=KOswoNjEcV8ovVzEKJvJY+RaXH0B+Z4iDE3cex5hL9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nj6kaTFPO2rtxWdy61dJiBWGtUO90VhO62ZswqHP23BCizvOBNUkbOfkpHoeYBvER7Bb0NePirhAlfWmbA1KusNi/yy2JH+dFkgEZcMrnyGVZOatlimF64YIVjZoB5v7jOWsdDZMnNvBmyZCmYWAipFHZiIzBcJSzNPGs/NvDcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBOVmxvu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBOVmxvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEA71F000CA;
	Mon, 19 Oct 2026 14:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418709;
	bh=1atrWMidy/mqUqIpPrKw3eieFv9QQz6XVuDdor/tV+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBOVmxvuuzlVI7nx4UrO4WVGIdWt3t4o8PvVBOrQFkvcBrTx9oGTKWIFhrqHsSMjI
	 3ja39q2LqBpKX26nSlUQX9g71EulyIjmFmPzFq+B2NGfi7G1Ft1QZkl2H+7LJnMJE9
	 zcgkqqlR6MShhrvlbe9Wf+mee64TRzmGYWpR/uVqSUnAvBf5fGnUQZS9wyJtpDVyhy
	 BgJX0XNXMh1veMjZnn7AI85hruEe8VglQ7anIp94ksfXoA5acg1sEOV2oeQN05S3wl
	 hk16PpBZE5odZFcEjibgZi/DlEseiJWsJyXu3ROSQEE+kYOiRC9GnU7Cs9AmwqpiMu
	 IGF/al+q7Fc4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
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
Subject: [PATCH AUTOSEL 6.18-6.1] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
Date: Mon, 19 Oct 2026 09:52:11 -0400
Message-ID: <20261019135441.1420968-440-sashal@kernel.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 1f0391aea883e99d402d0f77ba3530e4e879350d ]

Replace WARN_ON calls with DEBUG_NET_WARN_ON_ONCE in the default switch
blocks of nf_tproxy_get_sock_v4 and v6. Unsupported transport protocols
are already safely handled by returning a NULL socket pointer. This
prevents unnecessary system panics when panic_on_warn=1 is enabled in
production systems.

Link: https://patch.msgid.link/cover.1786968834.git.zhilinz@nebusec.ai/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a two-line datapath `WARN_ON` demotion in netfilter tproxy. The
`WARN_ON(1)` is present in this 6.12 tree, `DEBUG_NET_WARN_ON_ONCE`
already exists here, and Pablo later took the change into `-net` because
that warning is reachable and can panic under `panic_on_warn=1`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [netfilter / tproxy] [use] [replace `WARN_ON` with
`DEBUG_NET_WARN_ON_ONCE` on unsupported-protocol fallbacks in IPv4/IPv6
tproxy socket lookup]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Link:
  https://patch.msgid.link/cover.1786968834.git.zhilinz@nebusec.ai/
  (cover from Zhiling Zou / nebusec.ai, 2026-08-17)
- Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de> (author)
- Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org> (netfilter
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence expected)
- Ignore any pipeline "Upstream commit" / Sasha Levin SOB if present

Notable: the msgid points at an external bug-finding series, not at
Fernando’s original June nf-next cover. Pablo later described a concrete
datapath reachability bug.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `WARN_ON(1)` in the default arm of the L4 protocol switch in
  `nf_tproxy_get_sock_v4` / `nf_tproxy_get_sock_v6`.
- Symptom: kernel warning splat; with `panic_on_warn=1`, a full panic.
- Failure mode: “unnecessary system panics when panic_on_warn=1”.
- Root cause (author): unsupported transport protocols are already
  handled by returning `sk = NULL`; the `WARN_ON` is not needed for
  correctness.
- Version info in the message: none.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup in the sense of a leak/UAF. It is a real
defensive fix: a reachable `WARN_ON` in the packet path that can panic
production/hardened kernels. Originally patch 6/9 of an nf-next “replace
raw warnings” series; Pablo later moved this specific change to `-net`
because the warning is reachable.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- `net/ipv4/netfilter/nf_tproxy_ipv4.c`: 1 line changed (`WARN_ON(1)` →
  `DEBUG_NET_WARN_ON_ONCE(1)`)
- `net/ipv6/netfilter/nf_tproxy_ipv6.c`: same 1-line change
- Functions: `nf_tproxy_get_sock_v4`, `nf_tproxy_get_sock_v6`
- Scope: single-function surgical fix, two files, +0/−0 net (2
  modifications)

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: protocol switch handles TCP and UDP; any other protocol hits
  `default: WARN_ON(1); sk = NULL;` then returns NULL.
- After: same NULL return; warning only if `CONFIG_DEBUG_NET=y`, and
  only once.
- Path: packet/socket-lookup path for TPROXY, not init. Already a
  handled fallback, not a crash-without-WARN bug.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic/correctness of assertions in the datapath (WARN-in-
  packet-path / panic_on_warn DoS), not UAF/leak/race.
- Mechanism: `WARN_ON(1)` treats “non-TCP/UDP protocol in tproxy lookup”
  as a kernel bug. Callers can still pass a non-TCP/UDP protocol. The
  function already returns NULL and callers drop/break. The WARN is the
  harmful part under `panic_on_warn`.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: fallback already returns NULL; only the assertion
  changes.
- Minimal: two identical one-line edits.
- Regression risk: very low. Production kernels (`CONFIG_DEBUG_NET=n`)
  compile this to `BUILD_BUG_ON_INVALID(1)`, a compile-time sizeof no-op
  (`include/linux/build_bug.h`). Debug kernels still warn once.
- No API, locking, or structure changes.
- Red flag that does not block backport: this does not fix checkentry
  itself; it makes the already-safe fallback non-fatal.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Introduced by `45ca4e0cf2734` (“netfilter: Libify xt_TPROXY”, Máté
  Eckl, 2018-06-01).
- `git merge-base --is-ancestor 45ca4e0cf2734 HEAD` succeeded. Present
  since the tproxy libification, long before 6.12.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. Upstream applied commit is
`1f0391aea883` (netdev `-net`); `git merge-base --is-ancestor
1f0391aea883 HEAD` failed, so this tree does not already contain the
fix.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent local history on these files: `21a673bddc8fd` (NULL
indev), `4a02426787bf0` (BH deadlock), hashinfo via net. No competing
tproxy WARN change. Standalone; not patch 2/3 of a required series for
this tree.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Fernando Fernandez Mancera is a regular netfilter contributor in
this tree (conncount, synproxy, osf, NFQUEUE). Pablo signed off as
maintainer. Original June 2026 series was a broad WARN→DEBUG_NET
conversion; only tproxy (and separately conncount) were later taken into
`-net`.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Depends only on `DEBUG_NET_WARN_ON_ONCE` in
`include/net/net_debug.h`, present in this tree. Both files include
`linux/skbuff.h` (IPv4 directly; IPv6 via `nf_tproxy.h` → `net/tcp.h` →
`skbuff.h`), and `skbuff.h` includes `net/net_debug.h`. Applies
standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c` not usable: candidate SHA is not in this checkout.
- lore.kernel.org fetches returned 403.
- Original submission: [PATCH 6/9 nf-next] 2026-06-01, cover “replace
  raw warnings with DEBUG_NET_WARN_ON_ONCE”
  (https://ratatoskr.run/netfilter-devel/2026/06/17074549 and 17074557).
  Intent: nf-next hardening.
- Re-posted as [PATCH net 01/10] then [PATCH net,v2 1/9] by Pablo,
  2026-08-21 / 2026-08-27:
  https://lists.openwall.net/netdev/2026/08/21/202 and
  https://lists.openwall.net/netdev/2026/08/27/160
- Pablo’s cover: “a recent bug found a way to reach WARN_ON from
  datapath due to insufficient validation of xt_TPROTO checkentry.”
- Applied to netdev `-net` as `1f0391aea883`; included in the v7.3-rc1
  networking pull.
- No NAK found. Florian commented on other patches in the June series,
  not a NAK of this tproxy hunk.
- Commit Link cover.1786968834.git.zhilinz@nebusec.ai is dated
  2026-08-17 (same reporter class as the sch_cake WARN backport already
  in this tree).

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients on Pablo’s net posting: netfilter-devel, davem, kuba,
pabeni, edumazet, horms, fw@strlen.de (Florian Westphal), ja@ssi.bg.
Pablo applied it. No separate Reviewed-by on the commit.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: Direct zhilinz cover fetch from lore 403’d. Independent
maintainer statement in the `-net` cover is the verified evidence of
datapath reachability. Same reporter’s analogous `WARN_ON` panic_on_warn
issue was already backported here as `2504a76e5c069` (“sch_cake: drop
WARN_ON(1) for malformed packets”).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: June 9-patch nf-next series is bulk hardening. Pablo cherry-
picked tproxy into `-net` because it was shown reachable; conncount in
the same `-net` pull was explicitly “not known issue”. This tproxy
commit does not need the rest of that series.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search 403. UNVERIFIED whether anyone
already requested/rejected this on stable@. No evidence in-tree that it
was already applied.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `nf_tproxy_get_sock_v4`, `nf_tproxy_get_sock_v6`.

Step 5.2: TRACE CALLERS
Record (from grep in this tree):
- `net/netfilter/xt_TPROXY.c`: `tproxy_tg4`, `tproxy_tg6_v1` (mangle
  PREROUTING)
- `net/netfilter/nft_tproxy.c`: `nft_tproxy_eval_v4`,
  `nft_tproxy_eval_v6`
- Re-entered from `nf_tproxy_handle_time_wait4` / v6 for TIME_WAIT
  reopen
- Exported (`EXPORT_SYMBOL_GPL`)

xt_TPROXY checkentry (`tproxy_tg4_check` / `tproxy_tg6_check`) rejects
rules that are not `-p tcp`/`-p udp`. Native nft_tproxy returns
`NFT_BREAK` unless `pkt->tprot` is TCP or UDP. TPROXY target has no
`.proto` in the `xt_target` struct; protocol restriction is only
checkentry + nft eval. Pablo’s cover says that checkentry validation is
insufficient, so the default arm can still run.

Step 5.3: TRACE CALLEES
Record: TCP/UDP hash lookups (`inet_lookup_listener`, `udp4_lib_lookup`,
IPv6 equivalents), `sock_put` on mismatch. Default arm only sets `sk =
NULL`. No alloc/lock in the changed path.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable from netfilter PREROUTING when TPROXY/nft tproxy is
loaded. Not a syscall on every box, but it is a packet path. With user
namespaces + CAP_NET_ADMIN in a netns, and with syzbot-style fuzzing of
iptables/nft compat, it is userspace-reachable once the module is
present. Native nft IPv4 sets `pkt->tprot = ip->protocol` then checks
tprot, so that path is consistent; xt_TPROXY uses `iph->protocol` /
`ipv6_find_hdr()` after a checkentry that Pablo says can be bypassed.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same files still `BUG()` on invalid `lookup_type` (kernel enum,
not packet proto). Unrelated. Networking policy is to use
`DEBUG_NET_WARN_ON_ONCE` on datapath asserts (`include/net/net_debug.h`,
`CONFIG_DEBUG_NET`). This tree already backported a sibling pattern in
sch_cake.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes.
- Tree: `pending-6.12`, `git describe` p-6.12-3-gc504cf0baa3d8, `make
  kernelversion` 6.12.111 (Makefile 6.12.111).
- `WARN_ON(1)` at `nf_tproxy_ipv4.c:141` and `nf_tproxy_ipv6.c:140`.
- Bug introduced 2018 (`45ca4e0cf2734`), present in this branch.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Surrounding code matches the submitted diff context exactly.
Expected apply: clean. `DEBUG_NET_WARN_ON_ONCE` already defined. No
extra include needed.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Upstream `1f0391aea883` is not an ancestor. No other commit on
these files replaces this `WARN_ON`. sch_cake WARN demotion is a
precedent, not a substitute.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: netfilter tproxy (`net/ipv4/netfilter`, `net/ipv6/netfilter`,
used by xt_TPROXY / NFT_TPROXY). Criticality: IMPORTANT (transparent
proxy / service-mesh / squid / k8s-style TPROXY), not core mm/VFS, not
staging.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature. TPROXY lookup logic has been stable for years; recent
commits are bugfixes (NULL indev, BH deadlock), not refactors. Fits “old
assertion, newly shown reachable.”

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Config-specific: `NF_TPROXY_IPV4`/`IPV6`,
`NETFILTER_XT_TARGET_TPROXY`, `NFT_TPROXY`. Production transparent-proxy
users, and fuzzers/hardened kernels that load those modules with
`panic_on_warn=1`.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Packet hits tproxy lookup with protocol ≠ TCP/UDP. Native
nft_tproxy tries to gate on tprot; xt_TPROXY checkentry tries to require
`-p tcp|udp`. Pablo stated checkentry is insufficient, so the default
arm is reachable from the datapath. Not every boot; requires TPROXY in
the ruleset (or a checkentry bypass). Unprivileged trigger: not from raw
packets alone without a TPROXY rule; with a loaded rule or netns admin,
yes. Syzbot-class environments typically have both.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Default: `WARN_ON` splat in dmesg, lookup returns NULL, packet
  dropped/broken — MEDIUM.
- `panic_on_warn=1` (syzbot, some hardened/Android/debug distros): panic
  — HIGH/CRITICAL for those users.
- Not data corruption or UAF.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium-high for TPROXY + panic_on_warn; prevents a panic on a
  path that already handles the case. Low-medium for default 6.12
  (warning only).
- Risk: very low (2 lines, no-op when `CONFIG_DEBUG_NET=n`).
- Ratio: favorable. Same class as the sch_cake WARN removal already in
  this 6.12 tree.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- `WARN_ON(1)` is in this 6.12 tree since 2018; fix is not.
- Maintainer placed this in `-net` because the warning is reachable from
  the datapath.
- Fallback already returns NULL; the WARN is the only dangerous part
  under `panic_on_warn`.
- Two lines, clean apply, `DEBUG_NET_WARN_ON_ONCE` already exists.
- Same reporter/class as sch_cake WARN backport `2504a76e5c069` already
  in this tree.
- TPROXY is a real production feature, not staging.

AGAINST:
- Started as nf-next bulk hardening, not a one-off crash fix.
- Does not repair checkentry; only demotes the assertion.
- Default kernels do not panic on WARN.
- Affects only TPROXY users / fuzzers, not all 6.12 systems.

UNRESOLVED:
- Exact zhilinz reproducer (lore 403). Relied on Pablo’s `-net` cover
  instead.
- Whether stable@ already discussed this (lore stable 403).
- Precise checkentry-bypass mechanics in 6.12 (nft_compat proto vs
  actual matches is a plausible hole; not fully reproduced here).
  Decision does not depend on re-deriving that hole because the
  maintainer already stated reachability and the fallback is already
  correct.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — two-line assert demotion; Pablo
   merged to `-net`.
2. Fixes a real bug that affects users? PASS — reachable datapath WARN;
   panic with `panic_on_warn=1`.
3. Important issue? PASS — panic/DoS on hardened and fuzzer configs;
   warning noise otherwise. Severity HIGH with `panic_on_warn`, MEDIUM
   without.
4. Small and contained? PASS — 2 lines, 2 files.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — buggy code present, macro
   present, context matches.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
bugfix.

Step 9.4: MAKE YOUR DECISION
The local tree is 6.12.111. The bug exists here. The fix is a minimal,
obviously correct datapath change that stops a handled protocol fallback
from taking down `panic_on_warn` systems. That matches stable policy and
an existing 6.12 precedent for the same WARN class.

What it solves for stable users: a tproxy socket lookup for an
unsupported L4 protocol currently fires `WARN_ON(1)` even though it
already returns NULL. On kernels with `panic_on_warn=1` that is a panic;
otherwise a splat. Backporting only changes the assertion, not lookup
behavior.

Risk vs benefit: benefit is avoiding a panic/warning on a real packet
path; risk is negligible (`CONFIG_DEBUG_NET=n` compiles to a no-op). No
prerequisites missing in 6.12.

===============================================================
Verification:
- [Phase 1] Tags: Link to zhilinz cover (2026-08-17), SOB Fernando +
  Pablo; no Fixes/syzbot/Cc:stable
- [Phase 2] Diff: 2 files, `WARN_ON(1)` → `DEBUG_NET_WARN_ON_ONCE(1)` in
  `nf_tproxy_get_sock_v4/v6` default arms; `sk = NULL` unchanged
- [Phase 2] Confirmed current 6.12 code still has `WARN_ON(1)` at
  ipv4:141 and ipv6:140
- [Phase 3] `git blame`: 45ca4e0cf2734 (2018 Libify xt_TPROXY); ancestor
  of HEAD
- [Phase 3] `git merge-base --is-ancestor 1f0391aea883 HEAD`: not in
  this tree
- [Phase 3] `DEBUG_NET_WARN_ON_ONCE` in `include/net/net_debug.h` gated
  on `CONFIG_DEBUG_NET`; `BUILD_BUG_ON_INVALID` is sizeof no-op
- [Phase 3] `linux/skbuff.h` includes `net/net_debug.h`; both tproxy
  files get that include
- [Phase 4] lore/b4: lore 403; used openwall + ratatoskr. Original: nf-
  next 6/9 2026-06-01; Pablo `-net` 2026-08-21/27 stating datapath
  reachability via weak xt protocol checkentry
- [Phase 4] No NAK found; applied as 1f0391aea883 in netdev `-net`
- [Phase 4] UNVERIFIED: full zhilinz thread body; stable@ discussion
- [Phase 5] Callers: xt_TPROXY, nft_tproxy, timewait helpers; xt
  checkentry requires TCP/UDP; nft eval checks tprot; TPROXY `xt_target`
  has no `.proto`
- [Phase 6] `git describe`/Makefile: pending-6.12 / 6.12.111; context
  matches patch; clean apply
- [Phase 6] Precedent in this tree: 2504a76e5c069 sch_cake WARN_ON drop,
  Reported-by Zhiling Zou, panic_on_warn
- [Phase 7] netfilter tproxy, IMPORTANT, mature
- [Phase 8] Failure: WARN splat or panic_on_warn panic; not
  UAF/corruption
- UNVERIFIED: exact checkentry-bypass PoC in 6.12; not used as the sole
  driver (maintainer statement + existing WARN + safe NULL return are
  verified)

The change is small, already handled correctly aside from the warning,
and belongs on this 6.12 tree.

**YES**

 net/ipv4/netfilter/nf_tproxy_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 041c3f37f237b..5eab7a2dc8ef2 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -137,7 +137,7 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index b2f59ed9d7cc0..12ec36a6be2e1 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -136,7 +136,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
-- 
2.53.0

