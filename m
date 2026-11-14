Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622541;
	b=4mKNhmXe7t9cODK6fK70JdNuEZcKof0SSVpqyqaJyvTu2LOmCI6KIxemPLHqIohRkvAx
	 4ZMKpgZloJ8zfj7oxCAdBvO7hUcYnq0AX4R733qZyQMP1X2NVj4A2bQ/eQJz6Fgavql/2
	 wqZFm3IpzSYBv34kmE3LteEMPUK4avAElq4KQhiOk1hB5EfGPioLL3Ycj1LVEXV7n+/8f
	 0lNQZB27eW8hAoSEjXQRCj+dV+y48CUi5Ck7cfbdbT3+MN0Sp73CTZ/uzGLu3cbQH9SnO
	 9JG7UbvH8lR1aiY0dHxFt2lzBCEABfGWwJ+GECGToClFpvFZbWufg+HyoQ3pgVWHC/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622541;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=qjMlW8lVFUbLFa7qUa6mVrFGLqrLBZGEz0jBpfoq7hM=;
	b=R7OPE3P6IkkNIJnSddotU5s/U/K5jVPp2Dazq8Jf7jJTBLmGKGig17JwbqWI1BiMfJwq
	 n8V8CTuiD7M9DxXXPM0PlPLPOTklZWrE9zsiiMPUgsxOsPVMuoNkEEbAd5ZA8aLsinive
	 uKBP4wEZDMANYSEzGC4kRVcpUYn1g0wBjGEUBEs5cAN9PeuxTm0J1v/MFv2PuTpqqrYDh
	 AWs69lpB7ZkzPnSWMJsMljKdfTCXaFNRoVcTn7TixrLEHbnRQQ1qUBiXkQvadwGK+tIsc
	 NU5TqvAqHNEmTxDXSIsrddBYASviICwDpwJq+pIKB8ejn0orPxD1d69zWu9f0wPJL8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ti0hXs6f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8202E606A323;
	Sat, 14 Nov 2026 02:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ti0hXs6f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A743C1F000C4;
	Sat, 14 Nov 2026 02:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622541;
	bh=qjMlW8lVFUbLFa7qUa6mVrFGLqrLBZGEz0jBpfoq7hM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ti0hXs6fVswV9AFwWl/EDFU5/4u6sBVOvFnOuIZjR9MZcY6dfbcCrcsrBWPu7suyM
	 dY6mpeWL+4DWprJ2bGQZMww2al9Q/Yk+xAf9K7zM9cIxafZ0YrMfD/8eD2P+cDnsVy
	 Ukt6LvFvjEFDfzC+MXRcHuYtCzS8RF/F4tQiT6DnosM5mPdLOjsNx074TBZljCs84a
	 A5BHNeoaIf5LWx1tPzMV49MEl1ChaCxjUqx8ObmD4uM3xh0rlCwBC3p5ofpmRq3iZ7
	 hbloNu9Oo0ZSurUV+g3RLHC3twJh0Rn2jb7qeKk+LXy5J3N6rIQ9btJRu9OgusXwfv
	 zCgDxVRjqNwDw==
Subject: Re: [PATCH net 02/15] ipv6: update *offset for non-first fragments in
 ipv6_find_hdr()
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:40 +0000
Message-ID: <179462254022.2199510.15164439972892652624@kernel.org>
In-Reply-To: <20261113011447.2357709-3-pablo@netfilter.org>
References: <20261113011447.2357709-3-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] This patch adds a new success exit to ipv6_find_hdr():
  `*offset = start + sizeof(struct frag_hdr)`, taken for a non-first…
- [Medium] The commit message says "Other target < 0 callers check the
  returned fragment offset or ignore *offset here." That is not true for…
- [Low] The earlier patch in this series, "ipvs: avoid out-of-bounds
  write in ip_vs_nat_icmp_v6", added a compensation block to…

--

ipv6: update *offset for non-first fragments in ipv6_find_hdr()

This commit makes ipv6_find_hdr() set *offset to the byte right after
the Fragment header when it takes the early return for a non-first
fragment with target < 0. Before this, that exit left *offset unchanged,
and IPVS used the initial offset as if it had been updated.

> Other target < 0 callers check the returned fragment offset
> or ignore *offset here.

[Severity: Medium]
Does this hold for every consumer of the offset?

ip6_packet_match() passes &acpar.thoff to ipv6_find_hdr(), and the result
reaches xt targets as par->thoff. nft_set_pktinfo_ipv6() sets pkt->thoff
the same way, and nft_compat forwards it to xt targets.

synproxy_tg6() in ip6t_SYNPROXY.c and nft_synproxy_do_eval() in
nft_synproxy.c do not check par->fragoff or pkt->fragoff:

net/ipv6/netfilter/ip6t_SYNPROXY.c:synproxy_tg6() {
    ...
	if (nf_ip6_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
		return NF_DROP;

	th = skb_header_pointer(skb, par->thoff, sizeof(_th), &_th);
	...
	if (th->syn && !(th->ack || th->fin || th->rst)) {
		/* Initial SYN from client */
    ...
}

Before this patch, thoff stayed at 0 for non-first fragments, so these
targets parsed the IPv6 header as a TCP header. That was also wrong, but
a sender had little control over it.

With this change, thoff points at the fragment payload, and the sender
controls all of it. Could SYNPROXY now treat a non-first fragment that
carries a forged TCP SYN or ACK with a valid checksum as a real segment?
It would then answer with a SYN-cookie SYN-ACK, or send a SYN to the
server.

Earlier port-filtering matches (tcp, multiport, payload) skip these
fragments because they check fragoff. To reach SYNPROXY, the fragment has
to get past nf_defrag_ipv6 without being reassembled. One way is notrack
before defrag, which makes ipv6_defrag() return NF_ACCEPT for
IP_CT_UNTRACKED.

xt_ecn match_tcp() and xt_tcpmss tcpmss_mt() do check par->fragoff and
are not affected. The missing fragoff check in SYNPROXY is older than
this patch.

> diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
> index 764c694fb417a..12908d8ca370f 100644
> --- a/net/ipv6/exthdrs_core.c
> +++ b/net/ipv6/exthdrs_core.c

[ ... ]

> @@ -262,6 +265,7 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
>  				     hp->nexthdr == NEXTHDR_NONE)) {
>  					if (fragoff)
>  						*fragoff = _frag_off;
> +					*offset = start + sizeof(struct frag_hdr);

[Severity: Medium]
Can this set *offset past the end of the skb?

At this point only the first 4 bytes of the 8-byte Fragment header have
been bounds checked. hp reads 2 bytes at start, and fp reads the 2-byte
frag_off at start + 2. Nothing checks that the Identification field is
inside the packet.

Every other success exit runs this check before start advances:

		if (!found) {
			if (skb->len - start < hdrlen)
				return -EBADMSG;

Take a packet that ends 4 to 7 bytes into the Fragment header, for
example with payload_len = 4. This path now returns success with *offset
up to 4 bytes past skb->len. Before the patch, *offset kept its input
value here.

Remote input can reach this. ip6_rcv_core() only parses hop-by-hop
options. PRE_ROUTING hooks see such packets when nf_defrag_ipv6 is not
loaded, when a chain runs before defrag (priority < -400), or when the
packet is marked notrack before defrag.

nft_set_pktinfo_ipv6() only rejects thoff > U16_MAX. It therefore stores
a pkt->thoff larger than skb->len and sets NFT_PKTINFO_L4PROTO. The
subtraction in nf_trace_fill_pkt_info() then underflows:

		len = min_t(unsigned int, skb->len - nft_thoff(pkt),
			    NFT_TRACETYPE_TRANSPORT_HSIZE);

skb_copy_bits() then fails and nft_trace_notify() jumps to
nla_put_failure. That path hits DEBUG_NET_WARN_ON_ONCE(1) and drops the
trace event.

synproxy_tg6() and nft_synproxy_do_eval() also pass this thoff to
nf_ip6_checksum() and nf_checksum(). For CHECKSUM_NONE and
CHECKSUM_COMPLETE, these call skb_checksum(skb, 0, dataoff, 0) with a
length past skb->len, which hits the DEBUG_NET_WARN_ON_ONCE(1) in
skb_checksum(). They also pass skb->len - dataoff to csum_ipv6_magic(),
and that value underflows.

Would it be better to require the whole Fragment header before setting
*offset? For example:

	if (skb->len - start < sizeof(struct frag_hdr))
		return -EBADMSG;

[Severity: Low]
The earlier patch in this series, "ipvs: avoid out-of-bounds write in
ip_vs_nat_icmp_v6", added a compensation block to ip_vs_out_icmp_v6()
and ip_vs_in_icmp_v6(). Does this change make that block dead code?

net/netfilter/ipvs/ip_vs_core.c:ip_vs_out_icmp_v6() {
    ...
	/* ipv6_find_hdr() does not include the embedded header for
	 * non-first fragments, add it so that ESP can pass and the
	 * NAT writable checks cover the rewritten addresses
	 */
	if (ciph.len == ciph.off)
		ciph.len += sizeof(struct ipv6hdr);
    ...
}

ip_vs_fill_iph_skb_off() sets iphdr->len = offset, which is nonzero.
ipv6_find_hdr() therefore starts at *offset + sizeof(struct ipv6hdr).
Flags start at 0 and target is -1, so every success exit now sets
*offset to at least ciph.off + 40. As a result, ciph.len == ciph.off can
no longer be true.

The comment at both sites also describes behaviour that ipv6_find_hdr()
no longer has, and it contradicts the kernel-doc added by this patch.
Both copies are still there, unchanged, at the end of the series.

For ESP non-first fragments, ciph.len now also covers the extension
headers and the full 8-byte Fragment header, not just off + 40.

Should the block and its comment be removed or updated in both functions?

>  					return hp->nexthdr;
>  				}
>  				if (!found)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
