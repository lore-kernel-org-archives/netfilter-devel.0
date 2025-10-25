Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1347331D744;
	Sat, 25 Oct 2025 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409727; cv=none; b=shvWQfWLVOZyhCFY4VXlK5P4kvXe+XAURpGz5c77L9SN/sMBb02GVMCVzgoijmGC77sU0jX1KLxWxChFvRPVqsRh3JV06I7aeV8wHbeL0ph9F4BM5csXyNTZHWxfn8p+MPCT3HH8LS9/eHHryjg+OAerCmajrpjTtKiyFCHQncM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409727; c=relaxed/simple;
	bh=17O5g3jJRZcmsijLPe835GHX+Lc2PbTVFEh67rV6z34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fsn2I+cdCKqOXyOvLsGa9a7z1Ev1ANxl8KmpZMl5Y+bd1cho9qqolwfWc/3OP4EdKatVie2fnmUUTd8LHs4O+hgmiUtwsrTB1nNl+ckA4bVYKwM8aEn+LnIGnvWDt+wJJZoJvq2F73qGSBvkXCODTpgY1CbobyUskBlO/Ngzm+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zs5K/t0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zs5K/t0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7C0C4CEF5;
	Sat, 25 Oct 2025 16:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409727;
	bh=17O5g3jJRZcmsijLPe835GHX+Lc2PbTVFEh67rV6z34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zs5K/t0WysiJ+eigNB0GUT2cqQw6biFfvCNL5jZSt/iyeXSLqk12ftgLNl4tRn55X
	 dNbIfS09tobo0BZd+JDRL+Ek3Jl6bQXB2QCzVeGXurz/TXOnhUonph6vO760M88IPj
	 TzlaUxbahzUUYlcWTT6qcL7JBEmMufiCYUHOEKGsrUgwJT++r1jKHXImZNOfuNSoon
	 0n/kTkjZkhZHVMjJ2zkKwk0wGWh8Z44m1QnOYMdLRjYP5uXb9KF89tDjqM0lRNXJxL
	 b/q4ycPUHk6JnBhzcbs3nP1D+hUrZ+uDAdtrIYamURldo8AaHfH8q+EPhWYqJSLvDn
	 Npr50JjdBFViQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH AUTOSEL 6.17-5.15] netfilter: nf_reject: don't reply to icmp error messages
Date: Sat, 25 Oct 2025 12:01:09 -0400
Message-ID: <20251025160905.3857885-438-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit db99b2f2b3e2cd8227ac9990ca4a8a31a1e95e56 ]

tcp reject code won't reply to a tcp reset.

But the icmp reject 'netdev' family versions will reply to icmp
dst-unreach errors, unlike icmp_send() and icmp6_send() which are used
by the inet family implementation (and internally by the REJECT target).

Check for the icmp(6) type and do not respond if its an unreachable error.

Without this, something like 'ip protocol icmp reject', when used
in a netdev chain attached to 'lo', cause a packet loop.

Same for two hosts that both use such a rule: each error packet
will be replied to.

Such situation persist until the (bogus) rule is amended to ratelimit or
checks the icmp type before the reject statement.

As the inet versions don't do this make the netdev ones follow along.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents ICMP error storms/loops when REJECT is used in
    netdev/bridge chains. Example from the commit: an “ip protocol icmp
    reject” rule on `lo` will reply to the ICMP error it just generated,
    causing a loop. Same problem occurs between two hosts with such
    rules (each error elicits another error).
  - Aligns netdev/bridge behavior with inet-family REJECT, which already
    does not reply to ICMP errors (per RFC guidance).

- IPv4 change (small, contained)
  - Adds ICMP type check helper: only treat the packet as ICMP
    unreachable if its type is `ICMP_DEST_UNREACH`.
    - net/ipv4/netfilter/nf_reject_ipv4.c:83
  - Suppresses generating an ICMP unreachable in response to an ICMP
    unreachable:
    - Early return when input is ICMP unreachable:
      net/ipv4/netfilter/nf_reject_ipv4.c:124
  - The rest of the function remains unchanged (length limit 536,
    checksums, header build), so behavior is identical except for
    skipping replies to ICMP unreachable.
  - Symmetry with TCP RST path already present (no RST in response to
    RST): net/ipv4/netfilter/nf_reject_ipv4.c:179

- IPv6 change (small, contained)
  - Adds ICMPv6 type check helper using `ipv6_skip_exthdr()` and
    `skb_header_pointer()`; only treat as ICMPv6 unreachable if
    `icmp6_type` is `ICMPV6_DEST_UNREACH`:
    - net/ipv6/netfilter/nf_reject_ipv6.c:107
  - Suppresses generating an ICMPv6 unreachable in response to an ICMPv6
    unreachable:
    - Early return when input is ICMPv6 unreachable:
      net/ipv6/netfilter/nf_reject_ipv6.c:146
  - Rest of path (length cap ≈ minimum IPv6 MTU, checksum, header build)
    is unchanged.

- Scope and impact
  - Affects only the nf_reject helpers used by netdev/bridge REJECT
    expressions:
    - net/netfilter/nft_reject_netdev.c calls into
      `nf_reject_skb_v4_unreach()` and `nf_reject_skb_v6_unreach()`
      (e.g., net/netfilter/nft_reject_netdev.c:48,
      net/netfilter/nft_reject_netdev.c:77).
    - net/bridge/netfilter/nft_reject_bridge.c likewise uses the same
      helpers (e.g., net/bridge/netfilter/nft_reject_bridge.c:68,
      net/bridge/netfilter/nft_reject_bridge.c:101).
  - Inet-family REJECT is unchanged and already uses stack helpers that
    refuse to reply to ICMP errors:
    - IPv4 inet path uses `icmp_send()`
      (net/ipv4/netfilter/nf_reject_ipv4.c:346), which already avoids
      generating errors in response to errors.
    - IPv6 inet path uses `icmpv6_send()`
      (net/ipv6/netfilter/nf_reject_ipv6.c:446) with similar behavior.
  - No ABI or architectural changes; only introduces small static
    helpers and early returns. The behavior change is to refrain from
    sending an error in response to an error, which is RFC-compliant and
    reduces risk of loops and traffic amplification.

- Risk assessment for stable
  - Minimal regression risk: change is narrowly targeted and only
    suppresses replies for ICMP/ICMPv6 unreachable error packets.
  - Fixes a real user-facing bug (loops on `lo`, cross-host error
    storms) without adding features.
  - Matches existing inet behavior, improving consistency across
    families.

Given the clear bug fix, small and contained change, alignment with inet
behavior and RFC guidance, and low regression risk, this is a good
candidate for backporting to stable trees.

 net/ipv4/netfilter/nf_reject_ipv4.c | 25 ++++++++++++++++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 30 +++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 0d3cb2ba6fc84..a7a3439fe7800 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -71,6 +71,27 @@ struct sk_buff *nf_reject_skb_v4_tcp_reset(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_reject_skb_v4_tcp_reset);
 
+static bool nf_skb_is_icmp_unreach(const struct sk_buff *skb)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	u8 *tp, _type;
+	int thoff;
+
+	if (iph->protocol != IPPROTO_ICMP)
+		return false;
+
+	thoff = skb_network_offset(skb) + sizeof(*iph);
+
+	tp = skb_header_pointer(skb,
+				thoff + offsetof(struct icmphdr, type),
+				sizeof(_type), &_type);
+
+	if (!tp)
+		return false;
+
+	return *tp == ICMP_DEST_UNREACH;
+}
+
 struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 					 struct sk_buff *oldskb,
 					 const struct net_device *dev,
@@ -91,6 +112,10 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
 		return NULL;
 
+	/* don't reply to ICMP_DEST_UNREACH with ICMP_DEST_UNREACH. */
+	if (nf_skb_is_icmp_unreach(oldskb))
+		return NULL;
+
 	/* RFC says return as much as we can without exceeding 576 bytes. */
 	len = min_t(unsigned int, 536, oldskb->len);
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index cb2d38e80de9a..3c56e94e6943b 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -91,6 +91,32 @@ struct sk_buff *nf_reject_skb_v6_tcp_reset(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_reject_skb_v6_tcp_reset);
 
+static bool nf_skb_is_icmp6_unreach(const struct sk_buff *skb)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	u8 proto = ip6h->nexthdr;
+	u8 _type, *tp;
+	int thoff;
+	__be16 fo;
+
+	thoff = ipv6_skip_exthdr(skb, ((u8 *)(ip6h + 1) - skb->data), &proto, &fo);
+
+	if (thoff < 0 || thoff >= skb->len || fo != 0)
+		return false;
+
+	if (proto != IPPROTO_ICMPV6)
+		return false;
+
+	tp = skb_header_pointer(skb,
+				thoff + offsetof(struct icmp6hdr, icmp6_type),
+				sizeof(_type), &_type);
+
+	if (!tp)
+		return false;
+
+	return *tp == ICMPV6_DEST_UNREACH;
+}
+
 struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
 					 struct sk_buff *oldskb,
 					 const struct net_device *dev,
@@ -104,6 +130,10 @@ struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
 	if (!nf_reject_ip6hdr_validate(oldskb))
 		return NULL;
 
+	/* Don't reply to ICMPV6_DEST_UNREACH with ICMPV6_DEST_UNREACH */
+	if (nf_skb_is_icmp6_unreach(oldskb))
+		return NULL;
+
 	/* Include "As much of invoking packet as possible without the ICMPv6
 	 * packet exceeding the minimum IPv6 MTU" in the ICMP payload.
 	 */
-- 
2.51.0

