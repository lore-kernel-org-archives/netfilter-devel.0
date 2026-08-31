Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D644B270D;
	Mon, 31 Aug 2026 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184290; cv=none; b=cemgsCqNwamPGHqG2qZ0XlutNEmDsfWZzUOlSR4gEJQsCV/GVPtKLQ17EdmVahZFYguVEQbxsyq36s3ixEs1vyR64ggikmfZLgFIzh+kLHikVwvn08EvECFgRzqfM9HmV50WKVYrEChOsNLC+PitdHh3dJEuI5vAC30hIgOVE5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184290; c=relaxed/simple;
	bh=4I1T4IkiZFyzlg+b2fsA4mXunk7EqSNP4qXNQxKxb0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KVPzRlBLUuMyd/QCzDZgQ16rbr/di3c9cs/fTpA4YPeEPoDjrSRXXZgqTVwSfhcg3JN/OyidOL5pA5pf1Szrx3HIrR4Ta2YLVUdR+x3PDLvaxrRHP680idTbpMFVVTgXNyrkQOJ2EFF/BX1Qm1glxAcoljHFM8exdxMskootF8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnfLGql9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnfLGql9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191D51F00A3F;
	Mon, 31 Aug 2026 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184286;
	bh=Jc96r2kipm502LoiSjzQi2ZERDgZ5U3UbwJMjrtntN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnfLGql9+8W91F12RQPUNtbkfotby7RzYsHTRhAIaV0rL90moQzbtW/92VFNipM59
	 1JRruVAgZvIuSlBr99HE5HT1NC7W/ayU1kRAm4BIVORQOdhrey7RslF+gHALgpONmG
	 nyy0Nxmh/KoHTQGHHhDJLp9HJE9z5pByPLy29XmvpRmHt29Talc1jnfoZqF6nNVwpE
	 +k4+CrWkMxCYIKrwt+ueXgMy+M2zM3hLUgvN6mK3YoCLz+bBQRvbpghDXCZcHdOn3a
	 28W9batK4Wnzle/L+A52hFopDrHGo0IHJW9WLozUSOTGV7+rh6o6NmiB8FwFB9H2GZ
	 Ypr6b4I4r0pJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
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
Subject: [PATCH AUTOSEL 6.18-5.10] netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()
Date: Mon, 31 Aug 2026 09:30:30 -0400
Message-ID: <20260831133314.4125787-602-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit d3bf9eae486490832bd08fd62ab0ac601f346bd4 ]

The timestamp-only fast path dereferences the option stream as
*(__be32 *)ptr, which assumes 4-byte alignment that the TCP option
stream does not guarantee. Use get_unaligned_be32() instead, which
reads the value safely and already returns host byte order, so the
htonl() on the comparison constant can be dropped.

This matches the existing get_unaligned_be32() use later in the same
function.

Assisted-by: Claude:Opus-4.7
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[netfilter: nf_conntrack]` `[use]` — replace unsafe aligned
  32-bit dereference in `tcp_sack()` timestamp fast path with
  `get_unaligned_be32()`.

**Step 1.2 — Tags**
- Record:
  - `Assisted-by: Claude:Opus-4.7`
  - `Signed-off-by: Rosen Penev <rosenp@gmail.com>`
  - `Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>`
  - `Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>` (subsystem
    maintainer)
  - No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or
    `Link:` tags
  - Notable: maintainer review and commit; reviewer independently
    spotted the same issue

**Step 1.3 — Body**
- Record:
  - **Bug:** `*(__be32 *)ptr` in the timestamp-only fast path assumes
    4-byte alignment of the TCP option stream
  - **Symptom:** Unaligned memory access on architectures that require
    alignment (kernel trap/oops); undefined behavior elsewhere
  - **Root cause:** TCP options are not guaranteed 4-byte aligned;
    `skb_header_pointer()` often returns a pointer directly into skb
    linear data at a misaligned offset
  - **Fix:** Use `get_unaligned_be32()`, matching the existing SACK
    parsing code in the same function

**Step 1.4 — Hidden bug fix?**
- Record: Yes — despite not using "fix" in the subject, this is a
  correctness/memory-safety bug fix, not cleanup or optimization.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record:
  - 1 file: `net/netfilter/nf_conntrack_proto_tcp.c` (+5/-5 lines)
  - Function: `tcp_sack()`
  - Scope: Single-file, surgical fix

**Step 2.2 — Code flow**
- Record:
  - **Before:** Fast path for timestamp-only TCP options used `*(__be32
    *)ptr == htonl(...)` — aligned 32-bit read
  - **After:** Uses `get_unaligned_be32(ptr) == (...)` — safe unaligned
    read; `htonl()` dropped because `get_unaligned_be32()` returns host
    byte order
  - **Path:** Hot path in `tcp_sack()` when `length ==
    TCPOLEN_TSTAMP_ALIGNED` (12 bytes = NOP/NOP/TIMESTAMP option only)

**Step 2.3 — Bug mechanism**
- Record:
  - **Category:** Memory safety / unaligned access (same class as commit
    `534f81a506879` from 2009 in the same function)
  - **Mechanism:** `ptr` from `skb_header_pointer()` points at
    `skb->data + dataoff + sizeof(tcphdr)`. For typical Ethernet+IPv4,
    options start at offset 54 (54 % 4 = 2), so `*(__be32 *)ptr` is an
    unaligned access when skb data is linear

**Step 2.4 — Fix quality**
- Record:
  - Obviously correct: mirrors the existing `get_unaligned_be32()` use
    at line 442 in the same function
  - Minimal, no unrelated changes
  - Low regression risk: `get_unaligned_be32()` is already included via
    `<linux/unaligned.h>` and used in this file
  - Byte-order handling is correct (constant built in host order,
    compared to host-order return value)

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record:
  - Fast path introduced in `9fb9cbb1082d6` (Nov 2005, nf_conntrack
    subsystem creation)
  - Aligned dereference `*(__be32 *)ptr` from `8f05ce91c8b801` (Mar
    2007)
  - Bug has been present since 2007 in this code path

**Step 3.2 — Fixes: tag**
- Record: N/A — no `Fixes:` tag in commit message

**Step 3.3 — Related file history**
- Record:
  - `534f81a506879` (Mar 2009): fixed unaligned access in SACK option
    parsing loop in the same `tcp_sack()` function (SPARC64 kernel
    unaligned access reports) — fast path was missed
  - `bb9fc37358ffa` (Aug 2011): fixed `TCPOLEN_TSTAMP_ALIGNED*4` typo so
    the fast path actually runs
  - Standalone single-patch series (v1 only); no prerequisites

**Step 3.4 — Author context**
- Record: Rosen Penev is a regular netfilter contributor; patch
  committed by Pablo Neira Ayuso (netfilter maintainer)

**Step 3.5 — Dependencies**
- Record: None. `get_unaligned_be32()` and `<linux/unaligned.h>` already
  present in this tree's version of the file.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record:
  - Lore URL:
    https://patch.msgid.link/20260525215840.93217-1-rosenp@gmail.com
  - Single v1 patch, no revisions
  - Fernando Fernandez Mancera: independently spotted the same issue; "I
    think this is for correctness too"; `Reviewed-by`
  - Pablo Neira Ayuso: committed with humorous "Missing
    put_unaligned_be32(), BTW." (read path only)
  - No NAKs or objections

**Step 4.2 — Reviewers**
- Record: CC'd to netfilter-devel, netdev, Pablo Neira, Florian
  Westphal, David S. Miller, Eric Dumazet, Jakub Kicinski, Paolo Abeni —
  appropriate maintainers included

**Step 4.3 — Bug report**
- Record: No syzbot or user bug report for this specific fast-path
  issue. Historical precedent: `534f81a506879` documented real SPARC64
  unaligned-access kernel messages from the same function's SACK path.

**Step 4.4 — Related patches**
- Record: Reviewer noted more unaligned-access audits may be needed
  elsewhere; this patch is self-contained

**Step 4.5 — Stable list**
- Record: Could not search lore stable archive (bot protection). No
  stable nomination found in the patch thread.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `tcp_sack()` modified; callers unchanged

**Step 5.2 — Callers**
- Record:
  - `tcp_sack()` called from `tcp_in_window()` when `receiver->flags &
    IP_CT_TCP_FLAG_SACK_PERM`
  - `tcp_in_window()` called from `nf_conntrack_tcp_packet()` (line
    1254)
  - `nf_conntrack_tcp_packet()` is the main TCP conntrack packet handler
    — invoked on every tracked TCP packet through netfilter hooks

**Step 5.3 — Callees**
- Record: `skb_header_pointer()`, `get_unaligned_be32()` — standard
  skb/conntrack helpers

**Step 5.4 — Reachability**
- Record:
  - Reachable from all netfilter conntrack TCP traffic (routers,
    firewalls, NAT gateways, any `CONFIG_NF_CONNTRACK` system)
  - Fast path triggers on timestamp-only TCP options (`length == 12`) —
    very common on modern TCP stacks
  - Requires SACK negotiation (`IP_CT_TCP_FLAG_SACK_PERM`) — also common
  - Userspace can trigger via normal TCP connections through conntrack-
    enabled systems

**Step 5.5 — Similar patterns**
- Record: Same function already uses `get_unaligned_be32()` at line 442
  for SACK blocks (fixed in 2009). The fast path was the remaining
  unaligned dereference.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code in tree**
- Record:
  - Local tree: **v6.18.44** (`git describe HEAD`)
  - Buggy code **present** at lines 408–412 of
    `net/netfilter/nf_conntrack_proto_tcp.c`
  - Bug present since 2007; not introduced after 6.18 branch point

**Step 6.2 — Backport complications**
- Record: `git apply --check` and `git cherry-pick --no-commit` both
  succeed — clean apply expected

**Step 6.3 — Related fixes already present**
- Record:
  - 2009 SACK-path unaligned fix (`534f81a506879`) is in tree
  - This specific fast-path fix (`d3bf9eae48649`) is **not** in tree
    (only on master)

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**
- Record: `net/netfilter` — nf_conntrack TCP tracker. Criticality:
  **CORE/IMPORTANT** (widely deployed on servers, routers, embedded
  systems with `CONFIG_NF_CONNTRACK`)

**Step 7.2 — Activity**
- Record: Actively maintained subsystem with frequent stable fixes in
  this tree

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Systems with `CONFIG_NF_CONNTRACK` processing TCP traffic —
  routers, firewalls, NAT, containers/VMs using conntrack. Not universal
  (config-dependent), but very common in production networking.

**Step 8.2 — Trigger conditions**
- Record:
  - Linear skb (common) where TCP options start at non-4-byte-aligned
    offset
  - Typical Ethernet+IPv4: options at offset 54 (mod 4 = 2) — verified
    by calculation
  - Timestamp-only option layout (length 12)
  - SACK negotiated on connection
  - **Likelihood:** High on affected architectures for normal TCP
    traffic

**Step 8.3 — Failure mode**
- Record:
  - Strict-alignment architectures (SPARC, some ARM/MIPS): kernel
    unaligned-access trap — severity **CRITICAL** (documented precedent
    in same function, 2009)
  - x86: usually tolerates unaligned access but technically undefined
    behavior
  - No data corruption path identified; primarily crash/trap risk

**Step 8.4 — Risk-benefit**
- Record:
  - **Benefit:** HIGH — prevents kernel faults on common TCP fast path
    in widely deployed code
  - **Risk:** VERY LOW — 5-line change, matches existing pattern in same
    function, reviewed by subsystem developer and maintainer
  - **Ratio:** Strong benefit, minimal risk

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR backport:
- Real unaligned memory access bug in hot conntrack path
- Present since 2007; same function had identical-class fix in 2009 for
  SACK path
- Typical packet layouts place TCP options at 2-mod-4 offsets (verified)
- Small, surgical, obviously correct fix
- Reviewed by Fernando Fernandez Mancera; committed by netfilter
  maintainer Pablo Neira
- Applies cleanly to v6.18.44
- No new APIs or features

AGAINST backport:
- No syzbot report or user crash report for this specific fast path
- Only affects `CONFIG_NF_CONNTRACK` systems
- Most severe on strict-alignment architectures (smaller user base than
  x86)
- Impact on x86 is lower (unaligned access usually works)

UNRESOLVED:
- No explicit stable nomination in mailing list thread
- Lore stable archive search blocked

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — matches existing in-function
   pattern; reviewed and committed by maintainers
2. Fixes a real bug? **PASS** — unaligned dereference on non-guaranteed-
   aligned data
3. Important issue? **PASS** — kernel trap/oops on strict-alignment
   arch; hot networking path
4. Small and contained? **PASS** — 1 file, ~5 lines changed
5. No new features/APIs? **PASS** — correctness fix only
6. Can apply to local tree? **PASS** — verified clean apply to v6.18.44

**Step 9.3 — Exception category**
- Record: Not a device-ID/quirk/DT/docs exception; qualifies as a core
  correctness/memory-safety fix

**Step 9.4 — Decision rationale**

This commit completes the unaligned-access fix started in 2009 for
`tcp_sack()`. The timestamp-only fast path — hit on very common TCP
packets — still uses an aligned `*(__be32 *)` dereference on data that
is typically 2-byte-aligned in standard Ethernet+IPv4 layouts. On
strict-alignment architectures this can cause kernel faults; the same
failure mode was already documented and fixed for the SACK parsing loop
in this exact function. The fix is minimal, follows an established
pattern already in the file, applies cleanly to the v6.18.44 tree, and
has maintainer review.

---

## Verification

- [Phase 1] Parsed commit message and tags from `git show d3bf9eae48649`
- [Phase 2] Diff analysis: 5-line change in `tcp_sack()` fast path
- [Phase 3] `git blame -L 407,413`: aligned dereference from 2007
  (`8f05ce91c8b801`)
- [Phase 3] `git show 534f81a506879`: prior SACK-path unaligned fix in
  same function (SPARC64)
- [Phase 3] `git show bb9fc37358ffa`: fast path length fix (2011)
- [Phase 3] `git log --grep`: no duplicate fix for this fast path in
  stable tree
- [Phase 4] `b4 dig -c d3bf9eae48649`: lore thread found
- [Phase 4] `b4 dig -w`: netdev/netfilter maintainers CC'd
- [Phase 4] `b4 dig -a`: single v1 patch
- [Phase 4] Mbox review: Reviewed-by from Fernando Fernandez Mancera;
  maintainer commit
- [Phase 5] `grep tcp_sack`: called from `tcp_in_window()` →
  `nf_conntrack_tcp_packet()`
- [Phase 5] Read `skb_header_pointer()` in `include/linux/skbuff.h`:
  returns direct skb pointer when linear
- [Phase 5] Python alignment calc: eth+ipv4 opts at offset 54 (mod 4 =
  2)
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Read current file lines 408–412: buggy code still present
- [Phase 6] `git apply --check` on patch: applies cleanly
- [Phase 6] `git cherry-pick --no-commit d3bf9eae48649`: auto-merge
  succeeds
- [Phase 6] `get_unaligned_be32` already at line 442; `#include
  <linux/unaligned.h>` at line 17
- [Phase 8] Failure mode: unaligned access trap on strict-alignment arch
  — CRITICAL severity class

**YES**

 net/netfilter/nf_conntrack_proto_tcp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index e99ab1e88e9f8..4a23edf7107a5 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -405,11 +405,11 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 		return;
 
 	/* Fast path for timestamp-only option */
-	if (length == TCPOLEN_TSTAMP_ALIGNED
-	    && *(__be32 *)ptr == htonl((TCPOPT_NOP << 24)
-				       | (TCPOPT_NOP << 16)
-				       | (TCPOPT_TIMESTAMP << 8)
-				       | TCPOLEN_TIMESTAMP))
+	if (length == TCPOLEN_TSTAMP_ALIGNED &&
+	    get_unaligned_be32(ptr) == ((TCPOPT_NOP << 24) |
+					(TCPOPT_NOP << 16) |
+					(TCPOPT_TIMESTAMP << 8) |
+					TCPOLEN_TIMESTAMP))
 		return;
 
 	while (length > 0) {
-- 
2.53.0

