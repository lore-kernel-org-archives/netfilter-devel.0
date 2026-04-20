Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704A83AB287;
	Mon, 20 Apr 2026 13:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691952; cv=none; b=szt7dyzV4YYRRCsAkADGjKS56Q8tfALvygLuBBXPiD3Z/hUYncEjH+FqD2Ob38VcnhoWKbC9mLx0CQkJpJF8RHA8qYiQDbn6ELqXtlPG0svx91j16CWsLvLp+H9a1Akte+5thgfEjqeWqHpD37tkgoB2trU0f+pItC0JEV1G/8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691952; c=relaxed/simple;
	bh=FMA63my38RNW107IWuRQRdh0Q1DqYFOwak1lRGCvc3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4HGh/bEmZiKeADy/4J4OxpMYz8F3otqUgRv52V0f2b/lIWRSOyfLhHCm8YNIaT2vZteKE/2eOAQQb5XQTZXKlsp3FNq9fBNoM5C5iTIvi3A7CAarro5u14DRvcBNlz8nPqizuNkYFNRUuo9TdDeGJurlgBg01D2SlKSz7gcfic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8TefFk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8TefFk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC5BC19425;
	Mon, 20 Apr 2026 13:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691952;
	bh=FMA63my38RNW107IWuRQRdh0Q1DqYFOwak1lRGCvc3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8TefFk7FybC5UQQ7qZQb+Ij12KzLnwPq9penp0r3gAB+dTTN91p2V6oLEBSd63Rg
	 R5yJ5BAVT7BQVEvtHoUHyI+piV6KVDDFpLR7axnFFM41FHyBAFM5ERTIiNxkoEvXmd
	 MjNs7jyia8YgYlQeq1Sse3U735QycT9Lro75ZtRoTxj716FxD8+EciR8epsMOrH/M0
	 FYqs24LM58f+0EqQjZRMAJfeqqXeu1wbx+6PGE0bMJ/uTluDq/RgDmxSOIXbBGCKcA
	 oMPdxT7QH+u+xyLXxa62PYdqdQSilMMeWhbyGj+vnvo+iz0m+Wk5nmygC956NbifWg
	 OQ4xiP3Y9aSKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhengchuan Liang <zcliangcn@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Ren Wei <enjou1224z@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] netfilter: require Ethernet MAC header before using eth_hdr()
Date: Mon, 20 Apr 2026 09:21:21 -0400
Message-ID: <20260420132314.1023554-287-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit 62443dc21114c0bbc476fa62973db89743f2f137 ]

`ip6t_eui64`, `xt_mac`, the `bitmap:ip,mac`, `hash:ip,mac`, and
`hash:mac` ipset types, and `nf_log_syslog` access `eth_hdr(skb)`
after either assuming that the skb is associated with an Ethernet
device or checking only that the `ETH_HLEN` bytes at
`skb_mac_header(skb)` lie between `skb->head` and `skb->data`.

Make these paths first verify that the skb is associated with an
Ethernet device, that the MAC header was set, and that it spans at
least a full Ethernet header before accessing `eth_hdr(skb)`.

Suggested-by: Florian Westphal <fw@strlen.de>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

`skb_mac_header_was_set` has been available since 2013, so it's
available in all currently supported stable trees. `skb_mac_header_len`
was introduced in 2017, also available in all supported stable trees
(5.4+).

Now I have all the information needed for the full analysis. Let me
compile it.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: netfilter (multiple files: ip6t_eui64, xt_mac, ipset
  types, nf_log_syslog)
- **Action verb**: "require" (ensuring precondition is met before use)
- **Summary**: Require Ethernet MAC header validation before calling
  `eth_hdr(skb)` across multiple netfilter modules

Record: [netfilter] [require] [validate MAC header is Ethernet and
properly set before accessing eth_hdr(skb)]

### Step 1.2: Tags
- **Suggested-by: Florian Westphal** - the netfilter subsystem co-
  maintainer suggested this broader fix
- **Tested-by: Ren Wei** - fix was tested
- **Signed-off-by: Florian Westphal** - the netfilter maintainer signed
  off and merged it
- No Fixes: tag (expected - this is a broader hardening patch)
- No Cc: stable tag (expected)

Record: Florian Westphal (netfilter maintainer) suggested and signed off
on this patch. Tested.

### Step 1.3: Commit Body
The commit explains that multiple netfilter modules access
`eth_hdr(skb)` after either:
1. Assuming the skb is associated with an Ethernet device, OR
2. Only checking that ETH_HLEN bytes at `skb_mac_header(skb)` lie
   between `skb->head` and `skb->data` (raw pointer arithmetic)

The fix adds three-part validation: (1) device is Ethernet
(`ARPHRD_ETHER`), (2) MAC header was set (`skb_mac_header_was_set`), (3)
MAC header spans a full Ethernet header (`skb_mac_header_len >=
ETH_HLEN`).

Record: Bug: `eth_hdr(skb)` accessed without proper validation that skb
has a valid Ethernet MAC header. Can lead to out-of-bounds reads. Root
cause: inadequate validation before dereferencing the MAC header.

### Step 1.4: Hidden Bug Fix Detection
This IS a memory safety fix. The commit message says "require...before
using" which means the existing code accesses `eth_hdr()` without proper
guards. Confirmed by KASAN report mentioned in the v2 changelog of patch
1/2. Florian Westphal explicitly identified the other files as
"suspicious spots."

Record: Yes, this is a genuine memory safety bug fix - prevents out-of-
bounds access on the MAC header.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **net/ipv6/netfilter/ip6t_eui64.c**: +5/-2 lines (adds ARPHRD_ETHER
  check, uses `skb_mac_header_was_set`/`skb_mac_header_len`)
- **net/netfilter/ipset/ip_set_bitmap_ipmac.c**: +3/-2 lines
- **net/netfilter/ipset/ip_set_hash_ipmac.c**: +5/-4 lines (two
  functions)
- **net/netfilter/ipset/ip_set_hash_mac.c**: +3/-2 lines
- **net/netfilter/nf_log_syslog.c**: +6/-1 lines (two functions)
- **net/netfilter/xt_mac.c**: +1/-3 lines

Total: ~23 lines added, ~14 removed. Six files, all in netfilter
subsystem.

Record: Multi-file but mechanical/repetitive change. Each file gets the
same validation pattern. Scope: contained to netfilter MAC header
access.

### Step 2.2: Code Flow Changes
Each hunk follows the same pattern:
- **Before**: Raw pointer arithmetic `skb_mac_header(skb) < skb->head ||
  skb_mac_header(skb) + ETH_HLEN > skb->data`, or NO check at all
- **After**: Proper three-part check: `!skb->dev || skb->dev->type !=
  ARPHRD_ETHER || !skb_mac_header_was_set(skb) ||
  skb_mac_header_len(skb) < ETH_HLEN`

### Step 2.3: Bug Mechanism
**Category**: Memory safety (out-of-bounds read / invalid memory access)

The old checks were insufficient:
1. **ip6t_eui64.c**: Only checked pointer bounds, not device type
2. **ipset files**: Only checked pointer bounds, not device type or
   `skb_mac_header_was_set`
3. **nf_log_syslog.c dump_arp_packet**: NO check at all before
   `eth_hdr(skb)`
4. **nf_log_syslog.c dump_mac_header**: Checked device type via switch
   but not MAC header validity
5. **xt_mac.c**: Already had ARPHRD_ETHER check but used raw pointer
   comparison instead of proper API

Without proper validation, if the MAC header isn't set or isn't
Ethernet, `eth_hdr(skb)` returns a pointer to potentially uninitialized
or out-of-bounds memory.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes. The pattern is simple and repeated
  mechanically.
- **Minimal/surgical**: Yes. Only replaces old check with new one; no
  logic changes.
- **Regression risk**: Very low. Adding validation before access can
  only make the code safer. If device isn't Ethernet, these functions
  should return early anyway.

Record: High quality fix. Uses proper kernel APIs instead of raw pointer
arithmetic.

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
- The buggy code in ipset files dates from their initial introduction
- `xt_mac.c` buggy check from 2010 (Jan Engelhardt, commit
  1d1c397db95f1c)
- `ip6t_eui64.c` dates back to Linux 2.6.12 (2005)
- `nf_log_syslog.c` `dump_arp_packet` and `dump_mac_header` from the
  nf_log consolidation era

Record: Bugs present since the code was written. Affects all stable
trees.

### Step 3.2: Fixes tag
No Fixes: tag on this commit. Patch 1/2 has `Fixes: 1da177e4c3f41`
("Linux-2.6.12-rc2").

### Step 3.3: Prerequisites
This commit (2/2) depends on commit fdce0b3590f72 (1/2) for the
`ip6t_eui64.c` changes only. The other 5 files are independent.

Record: `ip6t_eui64.c` hunk requires patch 1/2 first. Other files:
standalone.

### Step 3.4: Author
Written by Zhengchuan Liang, **suggested by and signed off by Florian
Westphal** (netfilter maintainer). Very high confidence in the fix.

### Step 3.5: Dependencies
`skb_mac_header_was_set()` available since 2013. `skb_mac_header_len()`
available since 2017. Both available in all supported stable trees.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.4: Patch Discussion
- **v1** (March 31, 2026): Single-patch fixing only `ip6t_eui64.c`
- Florian Westphal (netfilter maintainer) reviewed v1 and:
  - Asked "why is net/netfilter/xt_mac.c safe?" - implying it isn't
  - Suggested using `skb_mac_header_len()` instead of raw pointer checks
  - Suggested adding `ARPHRD_ETHER` device type check
  - Identified "other suspicious spots" in `nf_log_syslog.c` and ipset
  - Asked the author to make a patch covering all of them
- **v2** (April 4, 2026): Split into 2 patches. Patch 1/2 is the focused
  eui64 fix, patch 2/2 (this commit) is the broader hardening suggested
  by Florian.

Record: This patch was directly suggested and shaped by the netfilter
subsystem maintainer. Strong endorsement.

### Step 4.5: Stable Discussion
The v2 changelog mentions "KASAN report" with a PoC, indicating this is
a confirmed memory safety issue, not theoretical.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Function Analysis
- `eui64_mt6()`: Called from netfilter match evaluation (PRE_ROUTING,
  LOCAL_IN, FORWARD hooks)
- `bitmap_ipmac_kadt()`, `hash_ipmac4_kadt()`, `hash_ipmac6_kadt()`,
  `hash_mac4_kadt()`: Called from ipset kernel-side operations
- `dump_arp_packet()`, `dump_mac_header()`: Called from nf_log_syslog
  packet logging
- All are reachable from packet processing paths triggered by network
  traffic

Record: All affected functions are on hot packet processing paths,
triggered by normal network traffic with appropriate netfilter rules
configured.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence
- `xt_mac.c`: Unchanged since v5.4+ (will apply cleanly)
- ipset files: Unchanged since v5.15+ (will apply cleanly)
- `nf_log_syslog.c`: Has some churn but the relevant functions exist in
  v5.15+
- `ip6t_eui64.c`: Needs patch 1/2 as prerequisite

### Step 6.2: Backport Complications
For `ip6t_eui64.c`, patch 1/2 (fdce0b3590f72) must also be backported.
Other files: clean apply expected.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: Netfilter (net/netfilter/, net/ipv6/netfilter/)
- **Criticality**: IMPORTANT - netfilter is the Linux firewall
  subsystem, used by nearly all networked systems

### Step 7.2: Activity
Active subsystem with regular maintenance.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Anyone using netfilter with MAC-address matching rules (iptables -m mac,
ip6tables eui64 match, ipset with mac types) or logging with MACDECODE
flag.

### Step 8.2: Trigger Conditions
- KASAN-confirmed: a PoC exists
- Triggered by network traffic matching rules that use MAC header access
- Could be triggered by non-Ethernet packets reaching netfilter rules
  that assume Ethernet

### Step 8.3: Severity
- **Out-of-bounds read on MAC header**: Can cause kernel crash (oops),
  potential info leak
- **KASAN-confirmed**: Severity HIGH

### Step 8.4: Risk-Benefit
- **Benefit**: HIGH - prevents memory safety bugs across 6 netfilter
  modules
- **Risk**: VERY LOW - mechanical replacement of validation checks, each
  change is 1-3 lines, obviously correct
- **Ratio**: Strongly favorable

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- KASAN-confirmed memory safety bug with PoC
- Suggested and signed off by netfilter maintainer Florian Westphal
- Tested
- Small, mechanical, obviously correct changes
- Uses proper kernel APIs
- Affects widely-used netfilter modules
- Buggy code present in all stable trees
- Functions available since kernel 4.x/5.x

**AGAINST backporting:**
- Part of a 2-patch series (ip6t_eui64.c hunk depends on patch 1/2)
- No explicit Cc: stable (expected)
- Touches 6 files (but all changes are identical pattern)

### Step 9.2: Stable Rules Checklist
1. Obviously correct? **YES** - mechanical pattern replacement,
   maintainer-suggested
2. Fixes real bug? **YES** - KASAN-confirmed out-of-bounds access
3. Important issue? **YES** - memory safety / potential crash / info
   leak
4. Small and contained? **YES** - ~37 lines total across 6 files, all
   same pattern
5. No new features? **YES** - only tightens validation
6. Can apply to stable? **YES** (with patch 1/2 for ip6t_eui64.c)

### Step 9.3: Exception Categories
Not an exception category - this is a straightforward bug fix.

### Step 9.4: Decision
This is a clear YES. Memory safety fix in the netfilter subsystem,
KASAN-confirmed, suggested by the maintainer, obviously correct, small
scope.

## Verification

- [Phase 1] Parsed tags: Suggested-by and Signed-off-by Florian Westphal
  (netfilter maintainer), Tested-by Ren Wei
- [Phase 2] Diff analysis: 6 files modified, each replacing inadequate
  MAC header validation with proper 3-part check (device type + header
  set + header length)
- [Phase 2] Confirmed `nf_log_syslog.c:dump_arp_packet()` had NO
  validation before `eth_hdr(skb)` access (line 81-83 in current tree)
- [Phase 2] Confirmed `nf_log_syslog.c:dump_mac_header()` entered
  ARPHRD_ETHER case without MAC header validity check (line 791-793)
- [Phase 3] git blame: buggy code in ip6t_eui64.c from Linux 2.6.12
  (2005), xt_mac.c from 2010, ipset from initial introduction
- [Phase 3] Confirmed patch 2/2 depends on patch 1/2 (fdce0b3590f72) for
  ip6t_eui64.c hunk only
- [Phase 3] Confirmed `skb_mac_header_was_set` available since 2013,
  `skb_mac_header_len` since 2017 - both in all supported stable trees
- [Phase 4] b4 dig found series at lore: v1->v2 evolution, v2 is [PATCH
  nf v2 2/2]
- [Phase 4] Mailing list: Florian Westphal explicitly asked for broader
  fix covering nf_log_syslog.c and ipset
- [Phase 4] v2 changelog mentions "KASAN report" with PoC confirming
  real vulnerability
- [Phase 5] All affected functions on packet processing paths (netfilter
  hooks, ipset kadt, nf_log)
- [Phase 6] xt_mac.c unchanged since v5.4, ipset files unchanged since
  v5.15 - clean apply expected
- [Phase 6] nf_log_syslog.c has more churn but relevant code sections
  exist in v5.15+
- [Phase 8] Failure mode: out-of-bounds memory read -> kernel oops or
  info leak, severity HIGH
- UNVERIFIED: Exact applicability to v5.10.y and v5.4.y for
  nf_log_syslog.c (nf_log consolidation happened around v5.12) - does
  not affect decision since most files apply cleanly

**YES**

 net/ipv6/netfilter/ip6t_eui64.c           | 7 +++++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 5 +++--
 net/netfilter/ipset/ip_set_hash_ipmac.c   | 9 +++++----
 net/netfilter/ipset/ip_set_hash_mac.c     | 5 +++--
 net/netfilter/nf_log_syslog.c             | 8 +++++++-
 net/netfilter/xt_mac.c                    | 4 +---
 6 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index da69a27e8332c..bbb684f9964c0 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 
 #include <linux/netfilter/x_tables.h>
@@ -21,8 +22,10 @@ eui64_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	unsigned char eui64[8];
 
-	if (!(skb_mac_header(skb) >= skb->head &&
-	      skb_mac_header(skb) + ETH_HLEN <= skb->data)) {
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER)
+		return false;
+
+	if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN) {
 		par->hotdrop = true;
 		return false;
 	}
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 2c625e0f49ec0..752f59ef87442 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -11,6 +11,7 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/netlink.h>
 #include <linux/jiffies.h>
@@ -220,8 +221,8 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 		return -IPSET_ERR_BITMAP_RANGE;
 
 	/* Backward compatibility: we don't check the second flag */
-	if (skb_mac_header(skb) < skb->head ||
-	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER ||
+	    !skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return -EINVAL;
 
 	e.id = ip_to_id(map, ip);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index 467c59a83c0ab..b9a2681e24888 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -11,6 +11,7 @@
 #include <linux/skbuff.h>
 #include <linux/errno.h>
 #include <linux/random.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
@@ -89,8 +90,8 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_ipmac4_elem e = { .ip = 0, { .foo[0] = 0, .foo[1] = 0 } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	if (skb_mac_header(skb) < skb->head ||
-	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER ||
+	    !skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return -EINVAL;
 
 	if (opt->flags & IPSET_DIM_TWO_SRC)
@@ -205,8 +206,8 @@ hash_ipmac6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	if (skb_mac_header(skb) < skb->head ||
-	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER ||
+	    !skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return -EINVAL;
 
 	if (opt->flags & IPSET_DIM_TWO_SRC)
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 718814730acf6..41a122591fe24 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <net/netlink.h>
 
@@ -77,8 +78,8 @@ hash_mac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_mac4_elem e = { { .foo[0] = 0, .foo[1] = 0 } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	if (skb_mac_header(skb) < skb->head ||
-	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER ||
+	    !skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return -EINVAL;
 
 	if (opt->flags & IPSET_DIM_ONE_SRC)
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 41503847d9d7f..98d2b9db16efe 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -78,7 +78,10 @@ dump_arp_packet(struct nf_log_buf *m,
 	else
 		logflags = NF_LOG_DEFAULT_MASK;
 
-	if (logflags & NF_LOG_MACDECODE) {
+	if ((logflags & NF_LOG_MACDECODE) &&
+	    skb->dev && skb->dev->type == ARPHRD_ETHER &&
+	    skb_mac_header_was_set(skb) &&
+	    skb_mac_header_len(skb) >= ETH_HLEN) {
 		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
 			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
 		nf_log_dump_vlan(m, skb);
@@ -789,6 +792,9 @@ static void dump_mac_header(struct nf_log_buf *m,
 
 	switch (dev->type) {
 	case ARPHRD_ETHER:
+		if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
+			return;
+
 		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
 			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
 		nf_log_dump_vlan(m, skb);
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 81649da57ba5d..4798cd2ca26ed 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -29,9 +29,7 @@ static bool mac_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	if (skb->dev == NULL || skb->dev->type != ARPHRD_ETHER)
 		return false;
-	if (skb_mac_header(skb) < skb->head)
-		return false;
-	if (skb_mac_header(skb) + ETH_HLEN > skb->data)
+	if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return false;
 	ret  = ether_addr_equal(eth_hdr(skb)->h_source, info->srcaddr);
 	ret ^= info->invert;
-- 
2.53.0

