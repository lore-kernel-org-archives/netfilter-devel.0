Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622540;
	b=xQ5tIBQHUIPLBDegKnQ7OSLn2hKekQLbwHWJcw+/JR1+e2kDSPCaZV+wsZyFP1+UVlrj
	 ZzeSSm+/QbO7e1zL7I8CYQQUrgqbTXeqnnjGzJtaQ/k6KKNJjB1Z8l1gpPteh3ZcRTNAc
	 JQs4skdiOpC4yx+Kdj8TQ6Dz1jZ2Mv4kD8KUQU+0xGhSH1hmFSSJK9MnQdhtJfM36j1Yz
	 v9UhFxdUMfdGjiwL4vfg8PL9Mwt9X8MqU5xlWU04TkL/G2BRNBrt+uXn8GD3kVJfpTDB+
	 TYeU3iwk+C+D9z2Y+O+eIvaQiZZ3cjNpQHFxPgvp60t0HflW0iBUW4B6gnETTAxo7sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622540;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=EqQXRsyfObfIra+HPLhLXSrqab8hQOhQc1sQ/2Aja7A=;
	b=TPt9j2qFu0qZDr2ZMunGQ4P/nNQwsQ4eRn3s5vVbvitsXJJBLxdcUeXMXPMHW9d3cAfb
	 MaUouSDhGAv/PclRwMFxJNrITqjvxrMQ6+3sxbRNVxilpfSOq4gqxv3GoyK7YWw5OyOM/
	 4Bt7mHFOJo0gbaMUZa6E3DH1JvUbBSRtlqLQOBo5IAU1dNRnpw2Tml52XiF0AItQMalsJ
	 L7axiSgR8U+GltGNIYawWunkPTtHC1tNXOnZEsRRje1chGOGA5oiqMOilSEjfPToTXAn3
	 OOzZFjzTkA7eIERCv1xltoVN0Y9cbO8LG4XGRvPQiNc+qeEa1ubmQuuS6VxqJQoVeyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoM9Nd29;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B39606A329;
	Sat, 14 Nov 2026 02:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoM9Nd29
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAD41F000C4;
	Sat, 14 Nov 2026 02:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622540;
	bh=EqQXRsyfObfIra+HPLhLXSrqab8hQOhQc1sQ/2Aja7A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hoM9Nd292rttjdCd/xHHyKEFJ4D1q7Aspk84gdlLJNqDYZIWC3VtznlsQYuuT20eV
	 tqBnE2I5STLI7CqF42kC8sYyLYWpTK79df/djMXtVa2U5amzL5wUqUIQw8nXd2SVy6
	 5ek+7dJMMy8ALB3qWcRlitLaU1hg0iR0BK5KilicuvVzonNzDxWtVyww63m0FhYcJP
	 wr15IarDsvLzp6eDmPOufhDn1hJDIE82htwnlk4xI6jyETZQtl3rNXNnR1Hu95iLA9
	 g1Vc3myLz9a1pT397Mjxo65ybGCJefjH+ZierWyzKHWwsuMZqVRvk56ek0ujofrg9V
	 M0HlIrMEpQArg==
Subject:
 Re: [PATCH net 01/15] ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:39 +0000
Message-ID: <179462253904.2199510.6723175642724870986@kernel.org>
In-Reply-To: <20261113011447.2357709-2-pablo@netfilter.org>
References: <20261113011447.2357709-2-pablo@netfilter.org>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Commit "ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6" has
  only `Fixes: 63dca2c0b0e7`.
- [Low] The commit message says "This fix does not depend on patch 2".

--

ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6

This patch changes both ICMPv6 handlers in IPVS. When ipv6_find_hdr()
stops at a non-first fragment and leaves ciph.len == ciph.off, the
embedded IPv6 header is now added to ciph.len. The skb_ensure_writable()
range used by the NAT paths then covers the addresses that
ip_vs_nat_icmp_v6() rewrites.

> This fix does not depend on patch 2. Stable kernels without commit
> 342e24a339b9 ("ipvs: do not mangle ICMP replies for non-first fragments")
> also need that commit to handle incoming ICMPv6 errors quoting
> non-first ESP fragments.
>
> Fixes: 63dca2c0b0e7 ("ipvs: Fix faulty IPv6 extension header handling in IPVS")

[Severity: Low]
The incoming half of this bug only seems to have become reachable with
342e24a339b9. That path is
ip_vs_in_icmp_v6()->ip_vs_icmp_xmit_v6()->ip_vs_nat_icmp_v6().

Before that commit, ip_vs_in_icmp_v6() had:

	if (ciph.fragoffs)
		return NF_ACCEPT;

342e24a339b9 changed it to:

	if (ciph.fragoffs && !pp->dont_defrag)
		return NF_ACCEPT;

ESP sets .dont_defrag = 1 in ip_vs_proto_ah_esp.c, so non-first ESP
fragments now reach ip_vs_icmp_xmit_v6(). There, wlen = ciph->len sizes
skb_ensure_writable(), and without this fix ciph->len equals ciph->off.
ip_vs_nat_icmp_v6() then writes the embedded addresses past that range.

The paragraph above reads as if 342e24a339b9 is only a functional
prerequisite. Should it say that 342e24a339b9 exposed the incoming-path
write, and add a second Fixes: 342e24a339b9 tag? The existing
Fixes: 63dca2c0b0e7 tag plus Cc: stable already covers backports, so
this is mostly about traceability.

> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 8a3c880fdb266..76213159404f0 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1206,6 +1206,13 @@ static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  				     true, &ciph))
>  		return NF_ACCEPT; /* The packet looks wrong, ignore */
>  
> +	/* ipv6_find_hdr() does not include the embedded header for
> +	 * non-first fragments, add it so that ESP can pass and the
> +	 * NAT writable checks cover the rewritten addresses
> +	 */
> +	if (ciph.len == ciph.off)
> +		ciph.len += sizeof(struct ipv6hdr);

[Severity: Low]
This isn't a bug, but is "so that ESP can pass" accurate for the IPv6
paths? A len vs off comparison only exists on the IPv4 side, for example
in ip_vs_nat_icmp():

	if (cih->ihl * 4 != ciph->len - ciph->off)
		return false;

None of these compare ciph.len with ciph.off:

- ip_vs_out_icmp_v6()
- ip_vs_in_icmp_v6()
- handle_response_icmp()
- ip_vs_icmp_xmit_v6()
- ip_vs_nat_icmp_v6()
- the AH/ESP conn_in_get/conn_out_get handlers

So the only effect seems to be the larger skb_ensure_writable() range.

Later in the series, "ipv6: update *offset for non-first fragments in
ipv6_find_hdr()" makes ipv6_find_hdr() do this for non-first fragments:

	*offset = start + sizeof(struct frag_hdr);

After that change, the first clause of this comment is no longer true.
The ciph.len == ciph.off check also can't fire any more, here or in the
copy added to ip_vs_in_icmp_v6().

Separately, the commit message says "This fix does not depend on patch
2." Once merged, "patch 2" won't point to anything in git history. Could
it name "ipv6: update *offset for non-first fragments in ipv6_find_hdr()"
instead?

> +
>  	pp = ip_vs_proto_get(ciph.protocol);
>  	if (!pp)
>  		return NF_ACCEPT;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
