Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959F6555470;
	Mon, 19 Oct 2026 13:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418225; cv=none; b=chqTz0yyhc9rG96hW58YkPPfsIDCjPyoeBYtrv0EORMyX5wliZgM71DebMgO0R3RwNnOBztUWcjls2anZXW4m0BEJ/OpttVN4R1/yx6IlBdp/lN1X2X+smVGtv+rGs94xaySm3b7Fa4lwUxcjlsC+3bIsNCXQEgIc/bUC41/kqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418225; c=relaxed/simple;
	bh=cqRu7aTK5ekNPk/YqtTLqNnHQjvfyCr2SQsLYogN15U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMeyx5pHA0X5fqdMJ7wCeBVXqW/h5yGmeWah6Am8vEYQsBF11zt7FmuxAeSuVK0XTCkGiIT5uSpNSAXK5AOVzy6JEw/RT0X7v/3TOfXXI2TOMEuJMoApSdUeb/JU8NWOdVpXFg1uxtVD3DWm4YVzQRn/34v22uCeSjO4OQF8Y4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3LE11jy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3LE11jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7341F000C5;
	Mon, 19 Oct 2026 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418222;
	bh=+yk4mejZsOHQ1PXvKPrh9FOXwfljT9MoJukQVJod748=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3LE11jyKD0BwdB5nGm4911vgNzfccxz6vAC2dgLxajYgExFjtXPi62GzeqkAKpFH
	 p/aqmSMZ/CMZ4ab+aWFKMDZ5sn+YJkdHuRxUo+an2AX9uFyrsiRCPKXvOSNwn1x9Nm
	 2vJIbBs9XOCO6nOe/fEOm1eJv3m2+Bj6Rueo83kZHOWgGkA/BdYdgKRq1O8H5g97Ye
	 +T3PxxGodK2bduiCY7fiosdRgEjtHi/FlG0rEx0tULdwX2d7bpUx2tlnYokKTi0hZ2
	 F3AeSntXe8eJjdq8/oORJsqhJaJ2VT/9tR2N4PusEGubW4+GZkwGLqS0rSvr3Lofqr
	 ZyG6Q3Im7VfZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Jianjun Chen <jianjun@tsinghua.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets
Date: Mon, 19 Oct 2026 09:46:30 -0400
Message-ID: <20261019135441.1420968-99-sashal@kernel.org>
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

From: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>

[ Upstream commit bf80e6802273a900311b44e47c9b1a59c6d2473c ]

Commit be0502a3f2e9 ("netfilter: conntrack: tcp: only close if RST
matches exact sequence") keeps an established conntrack entry in
ESTABLISHED when an in-window RST does not match the expected sequence
number exactly, so the endpoint can validate the RST with a challenge
ACK.

The timeout selection nevertheless uses the CLOSE timeout for every RST
packet.  The bug is that timeout selection is based on the packet type,
not on the state transition result: even when RST validation keeps
new_state in ESTABLISHED, the timeout is still forced to
TCP_CONNTRACK_CLOSE.

Linux TCP independently rate limits challenge ACKs per socket.  A second
non-exact RST can therefore arrive after the first challenge ACK has
restored the timeout but before the rate limit expires.  The second RST
lowers the timeout to 10 seconds again while the endpoint suppresses the
second challenge ACK, allowing the conntrack entry to expire while both
TCP endpoints remain established.

Using the ESTABLISHED timeout for such RSTs would avoid this short
expiration window, but it could also retain stale entries for the
five-day default because conntrack cannot reliably match the endpoint's
exact TCP state.

Use the UNACK timeout for RST packets that leave the conntrack entry in
TCP_CONNTRACK_ESTABLISHED.  Exact-match RSTs and accepted RST packet
trains still fall through to timeouts[new_state], which preserves the
CLOSE timeout when conntrack accepts the RST as closing the flow.

This avoids the aggressive 10-second expiration window for non-exact
RSTs while preserving the short timeout for RSTs that conntrack accepts
as closing the flow.

Suggested-by: Florian Westphal <fw@strlen.de>
Reported-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Reported-by: Jianjun Chen <jianjun@tsinghua.edu.cn>
Signed-off-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The evaluation is for the **6.6.y** tree this session opened on
(`pending-6.6` / 6.6.157). The bug is present there; the patch is a
small, real conntrack timeout fix.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: **[netfilter/conntrack/tcp] [use] use UNACK timeout for non-
  closing RST packets**
- Subsystem: `netfilter: conntrack: tcp:`
- Verb: “use” here is a timeout-policy correction after RST validation
  already keeps the entry ESTABLISHED.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - **Suggested-by:** Florian Westphal `<fw@strlen.de>` (conntrack
    maintainer)
  - **Reported-by:** Minghao Zhang `<zhangmh25@mails.tsinghua.edu.cn>`
  - **Reported-by:** Jianjun Chen `<jianjun@tsinghua.edu.cn>` (two
    reporters)
  - **Signed-off-by:** Minghao Zhang; Pablo Neira Ayuso (netfilter
    maintainer)
  - **No Fixes: / Cc: stable in the committed text** (expected for this
    review queue)
  - **v1 and v2 on the list both had** `Fixes: be0502a3f2e9 ("netfilter:
    conntrack: tcp: only close if RST matches exact sequence")`. That
    tag was dropped when the patch was folded into an nf-next pull.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** After `be0502a3f2e9`, an in-window RST that does not match
    `td_maxack` leaves conntrack in ESTABLISHED so the peer can
    challenge-ACK. Timeout selection still keys off packet type
    (`TCP_RST_SET`) and always applies **CLOSE (10s)**.
  - **Symptom:** A second non-exact RST can land after the first
    challenge ACK restored the timer, but while Linux still rate-limits
    challenge ACKs. The second RST drops the timer to 10s again; the
    suppressed challenge ACK never refreshes it; the conntrack entry
    expires while both TCP endpoints stay established. NAT/firewall then
    drop a live flow.
  - **Root cause:** Timeout is chosen from the RST flag, not from the
    resulting state.
  - **Fix:** RST that leaves `new_state == TCP_CONNTRACK_ESTABLISHED`
    uses **UNACK (5 min)**. Exact-match / RST-train RSTs still fall
    through to `timeouts[new_state]` (CLOSE).
  - **Version info:** Tied to `be0502a3f2e9` (2019-03-01), which is in
    this 6.6 tree.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: **Not hidden.** It is a real timeout/state mismatch. v1/v2
  called the 10s window **“exploitable”**. Pablo’s nf-next cover letter
  softened that to “more conservative timeout”; the failure mode is
  still live-session teardown through conntrack/NAT.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record: **one file**, `net/netfilter/nf_conntrack_proto_tcp.c`; **~3
  lines** in `nf_conntrack_tcp_packet()`. Surgical single-file logic
  fix.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record: After window validation, timeout selection:
  - **Before:** any `index == TCP_RST_SET` →
    `timeouts[TCP_CONNTRACK_CLOSE]` (10s), even if `new_state` was
    forced back to ESTABLISHED (`new_state = old_state` at the non-exact
    RST path).
  - **After:** only RST **and** `new_state == TCP_CONNTRACK_ESTABLISHED`
    → UNACK (5 min). Closing RSTs (`tcp_conntracks[][]` maps
    ESTABLISHED+RST → CLOSE, exact-seq / RST-train `break` without
    restoring ESTABLISHED) still get CLOSE.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: **[Logic / correctness]** plus a **security-relevant NAT
  teardown window**. Timeout no longer contradicts the RFC 5961 “stay
  ESTABLISHED for challenge ACK” path from `be0502a3f2e9`.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: **Obviously correct** for defaults (ESTABLISHED=5 days,
  UNACK=5 min, CLOSE=10s). Minimal. Regression risk is low:
  - Dead flows after a bogus RST linger **5 min instead of 10s** (same
    UNACK used for unacked data / out-of-window FIN|RST).
  - If sysctl sets ESTABLISHED **below** UNACK (e.g. 120s NAT boxes),
    this commit can **extend** the timer. Follow-up `73df81b38cb7f`
    (`timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK]`) closes that.
    Pablo: “Not a big deal… only affect timeout configurations where
    unack timeout is longer than established.” Defaults on 6.6 are fine.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: The unconditional RST→CLOSE timeout was added in
  **`be0502a3f2e9`** (Florian Westphal, 2019-03-01, v5.1 era). It is an
  ancestor of `pending-6.6`. Long-lived 6.6 code, not a new-mainline-
  only bug.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: Committed message has **no Fixes:**. Submissions targeted
  **`be0502a3f2e9`**, which **is** in this tree (`git merge-base --is-
  ancestor be0502a3f2e9 pending-6.6` → YES). That commit documented
  CLOSE timeout for non-exact RSTs as intentional; this patch revises
  that because challenge-ACK rate limiting makes the 10s window drop
  live flows.

**Step 3.3: CHECK FILE HISTORY**
- Record (on `pending-6.6`): related RST work includes `2bb6d82b586ea`
  (invalid-seq RST direction check) and `628d694344a02` (UNACK for out-
  of-window FIN/RST). **Standalone** timeout change; not patch 2/N.
  Follow-up `73df81b38cb7f` is **not** in `pending-6.6` and should ride
  along once this is applied (it has `Fixes: bf80e6802273`).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Minghao Zhang / Jianjun Chen (Tsinghua) —
  reporters/researchers, not netfilter maintainers. Weight comes from
  **Suggested-by Florian** and **SOB Pablo**. No other Minghao commits
  on this file in 6.6.

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**
- Record: Needs the `be0502` non-exact-RST ESTABLISHED path (present).
  Uses existing `TCP_CONNTRACK_UNACK`. **Applies standalone** on 6.6.
  Optional follow-up for inverted sysctl timeouts.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record:
  - `b4 dig -c bf80e6802273a` → v2: https://patch.msgid.link/20260729154
    654.3599616-1-zhangmh25@mails.tsinghua.edu.cn
  - **v1** (2026-07-29): explicit CLOSE branch + UNACK fallback;
    **Fixes:** + “exploitable 10-second expiration window”
  - **v2:** Pablo/Florian simplification; UNACK only if `new_state ==
    ESTABLISHED`
  - Florian (https://patch.msgid.link/amoXj6UGRW8SQXBT@strlen.de): asked
    to drop redundant CLOSE assignment and test a narrower condition.
    Author tested ESTABLISHED-only UNACK and sent v2.
  - **No NAK.** Queued in Pablo’s nf-next pull (patch 9/9), 2026-07-31:
    https://lists.openwall.net/netdev/2026/07/31/313
  - Jakub forwarded an AI review
    (https://lists.openwall.net/netdev/2026/08/05/12): should have
    Fixes:; CLOSE-for-inexact-RST was intentional in 2019; missing “only
    lower, never extend” guard; closing-RST CLOSE timeout not preserved
    for some non-default sysctls. The **extend** issue is exactly what
    `73df81b38cb7f` later fixed.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record (`b4 dig -w`): To/Cc **netfilter-devel**,
  **pablo@netfilter.org**, **fw@strlen.de**, Jianjun Chen. Right
  maintainers. Florian reviewed v1; Pablo merged.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: Dual Reported-by from Tsinghua. v1/v2 text: **exploitable**
  10s window via RST + challenge-ACK rate limit. Concrete trigger, not
  syzbot. Syzbot CI on the series: **passed**
  (https://ci.syzbot.org/series/36445e46-2abc-4e64-93d2-bb558ec1f53b).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Standalone nf-next patch (not a 9-patch dependency; the other
  8 were unrelated flowtable/conncount work). Follow-up: `73df81b38cb7f`
  / https://lists.openwall.net/netdev/2026/08/10/387 — “Reported by
  sashiko”.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: **No useful stable-list discussion found** for this subject
  (lore.kernel.org/stable search did not surface this patch). Not
  previously rejected for 6.6.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
- Record: **`nf_conntrack_tcp_packet()`** only.

**Step 5.2: TRACE CALLERS**
- Record: `pending-6.6:net/netfilter/nf_conntrack_core.c:1897` — every
  tracked TCP packet. Softirq/hook path, not init-only.

**Step 5.3: TRACE CALLEES**
- Record: `nf_ct_timeout_lookup()`, `tn->timeouts[]`, later
  `nf_ct_refresh_acct()`. Writes entry expiry.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: Userspace/network reachable whenever `CONFIG_NF_CONNTRACK`
  tracks TCP (iptables/nftables/NAT, Docker, Kubernetes, firewalls).
  **High impact.** An on-path or in-window RST injector can hit it.
  Unprivileged remote: needs in-window (not exact) SEQ; that is the RFC
  5961 threat model.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Sibling branches already only **lower** timeout
  (RETRANS/UNACK/zero-window). This RST branch was the odd one-out.
  `nf_tcp_handle_invalid()` also uses UNACK for out-of-window FIN/RST
  (`628d694`).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: **Yes on `pending-6.6` / 6.6.157:**

```
else if (unlikely(index == TCP_RST_SET))
    timeout = timeouts[TCP_CONNTRACK_CLOSE];
```

at `nf_conntrack_proto_tcp.c` ~1327–1328. Non-exact RST still does
`new_state = old_state` (~1260). `be0502a3f2e9` is an ancestor.
Candidate **`bf80e6802273a` is not** an ancestor of `pending-6.6`.
Introduced with `be0502` (2019), present for the whole 6.6 lifetime.

*(HEAD later detached at `v7.3-rc4-70` during this session; that
mainline tree already contains the fix. The stable tree this review is
for remains 6.6.157 / `pending-6.6`, where the bug is still open.)*

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: **Clean apply.** Exact before-image on `pending-6.6`. No
  refactor of this hunk vs the candidate.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: `2bb6d82b586ea` is a **different** RST CLOSE issue (SYN/RST
  direction). It does **not** change RST timeout selection. No earlier
  UNACK-for-non-closing-RST fix in 6.6.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
- Record: **netfilter conntrack TCP** — **IMPORTANT**. Core firewall/NAT
  path on virtually every router, distro firewall, and container host.

**Step 7.2: SUBSYSTEM ACTIVITY**
- Record: Mature tracker; this file still gets targeted RST/timeout
  fixes. Bug is old (`be0502`), not churn from a new subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
- Record: **Conntrack/NAT users** (`CONFIG_NF_CONNTRACK`) — default on
  most distro kernels. Not arch-specific.

**Step 8.2: TRIGGER CONDITIONS**
- Record: In-window, non-exact RST on an ESTABLISHED tracked flow. 6.6
  still **per-socket** rate-limits challenge ACKs via
  `__tcp_oow_rate_limited()` and `sysctl_tcp_invalid_ratelimit = HZ/2`
  (500ms), even with global `tcp_challenge_ack_limit = INT_MAX`. A
  second RST inside that window matches the commit’s scenario. Also:
  single RST + lost/unseen challenge ACK (asymmetric routing) leaves a
  10s expiry. **On-path attacker or sequence-in-window injection.**

**Step 8.3: FAILURE MODE SEVERITY**
- Record: **Live TCP dropped through NAT/firewall** after ~10s;
  endpoints stay ESTABLISHED. Not a panic. **HIGH** (session disruption
  / DoS on middleboxes). Authors called it **exploitable**.

**Step 8.4: RISK-BENEFIT RATIO**
- Record: **Benefit high** (stops silent NAT teardown of established
  sessions). **Risk low** (3-line, default UNACK < ESTABLISHED).
  Residual risk: short ESTABLISHED sysctl vs longer UNACK — mitigated by
  a one-line follow-up, not a reason to skip this fix.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**FOR:**
- Real, user-visible bug: conntrack expires while TCP stays up.
- Security-relevant (in-window RST + challenge-ACK throttle); v1/v2 said
  “exploitable”; had `Fixes: be0502a3f2e9`.
- `be0502` and the buggy CLOSE timeout are in 6.6.
- Challenge-ACK **per-socket** throttle exists in 6.6 (`HZ/2`).
- Tiny, obviously correct for default timeouts; Florian suggested, Pablo
  merged, author tested v2.
- Applies cleanly to `pending-6.6`.

**AGAINST:**
- Merged via **nf-next**, not nf; committed text dropped Fixes: and
  “exploitable”.
- `be0502` originally **meant** CLOSE timeout for non-exact RSTs (policy
  shift 10s → 5 min).
- Follow-up needed for ESTABLISHED < UNACK sysctl.
- Not a crash/corruption/deadlock.

**UNRESOLVED:** Full lore.kernel.org HTML was 403 (used `b4` + openwall
+ local mbox instead). No CVE number found.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — v2 tested by author;
   Florian/Pablo; syzbot CI passed.
2. Fixes a real bug that affects users? **PASS** — NAT/firewall drop of
   live TCP.
3. Important (crash/security/corruption/deadlock)? **PASS** —
   exploitable middlebox teardown / DoS, not a panic.
4. Small and contained? **PASS** — ~3 lines, one function.
5. No new features or APIs? **PASS** — existing UNACK timeout.
6. Can apply to this tree? **PASS** — exact match on `pending-6.6`.

**Step 9.3: EXCEPTION CATEGORIES**
- Record: None (not a device ID/quirk/DT/build/doc exception). Ordinary
  netfilter bugfix.

**Step 9.4: DECISION**
Backport. 6.6 has the 2019 RST-validation change **and** the 10s CLOSE
timeout that undermines it. The 5-minute UNACK value is the same
compromise already used for other “conntrack and endpoints disagree”
cases. Take follow-up `73df81b38cb7f` with it when possible; this commit
is still right on default 6.6 timeouts without it.

---

## What the commit solves for stable users

On 6.6 firewalls/NAT, an in-window RST that is **not** the exact next
SEQ leaves conntrack ESTABLISHED (RFC 5961) but still arms a **10s**
timer. Linux then rate-limits challenge ACKs (~500ms per socket). A
second such RST re-arms 10s with no refresh ACK, so conntrack deletes a
flow that both endpoints still consider established. That is a real
production failure and a plausible DoS on NAT.

## Stable rules / risk vs benefit

Meets the rules: small, tested, no new API, applies cleanly, fixes an
important conntrack bug. Benefit is high for a common config; regression
risk is a slightly longer hold of *stale* entries (5 min vs 10s), which
is acceptable.

## Concerns

- Pair with `73df81b38cb7f` so sysctl ESTABLISHED < UNACK cannot extend
  lifetime.
- Behavior change vs 2019 “intentional CLOSE timeout” is the point of
  the fix, not a blocker.

---

## Verification
- **[Phase 1]** Tags: Suggested-by Florian, two Reported-by, Pablo SOB;
  committed text has no Fixes:/Cc:stable; v1/v2 mbox **did** include
  `Fixes: be0502a3f2e9` and “exploitable”.
- **[Phase 2]** Diff: 3-line change in `nf_conntrack_tcp_packet()` RST
  timeout arm; CLOSE preserved when `new_state != ESTABLISHED`.
- **[Phase 3]** `be0502a3f2e9` is ancestor of `pending-6.6`; candidate
  is not. Blame: CLOSE-on-every-RST from `be0502`. Follow-up
  `73df81b38cb7f` not in 6.6.
- **[Phase 3]** `git show
  pending-6.6:net/netfilter/nf_conntrack_proto_tcp.c` lines 1327–1328:
  buggy `index == TCP_RST_SET` → CLOSE.
- **[Phase 4]** `b4 dig -c bf80e6802273a`: v1+v2; Florian review
  `amoXj6UGRW8SQXBT@strlen.de`; Pablo nf-next 9/9; Jakub AI review
  2026-08-05; follow-up 2026-08-10 “Reported by sashiko”.
- **[Phase 4]** `b4 dig -w`: netfilter-devel, pablo, fw. `b4 dig -a`:
  v1→v2 only.
- **[Phase 4]** lore.kernel.org WebFetch: **403**; used b4 mbox +
  openwall. Stable list: no hit on this subject.
- **[Phase 5]** Caller: `nf_conntrack_core.c:1897` on every tracked TCP
  packet.
- **[Phase 6]** First probe: `pending-6.6`, `make kernelversion`
  6.6.157. Later HEAD detached at `v7.3-rc4-70` (mainline already has
  the fix). Re-checked **`pending-6.6`**: VERSION 6.6.157, buggy timeout
  present, exact before-image, candidate not ancestor.
- **[Phase 6]** 6.6 challenge ACK: `__tcp_oow_rate_limited` +
  `sysctl_tcp_invalid_ratelimit = HZ/2`; global limit INT_MAX does
  **not** disable per-socket limit.
- **[Phase 6]** Defaults on 6.6: ESTABLISHED 5 days, UNACK 5 min, CLOSE
  10s.
- **[Phase 8]** Failure: NAT/conntrack drop of live TCP; severity HIGH /
  security-relevant.
- **UNVERIFIED:** CVE id (none found). Could not fetch lore HTML
  directly.

**YES**

 net/netfilter/nf_conntrack_proto_tcp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 91da35e2b0d8d..456721e40ed0c 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1325,8 +1325,9 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
-	else if (unlikely(index == TCP_RST_SET))
-		timeout = timeouts[TCP_CONNTRACK_CLOSE];
+	else if (unlikely(index == TCP_RST_SET &&
+			  new_state == TCP_CONNTRACK_ESTABLISHED))
+		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
 		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
-- 
2.53.0

