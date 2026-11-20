Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173052;
	b=n/p74he5uiz35KAGG+YUDvOx+UVmUzEKnxKTcGovgszclchWcoueS4QOMiMnrwoXmxXg
	 OvUtiP7r2IwvszD4o0zTTF2lYuJjVrcOEXLpMZxqpN5/EeCyls/FaRoJcukpaOou+asK+
	 IAwU8l3AT6GFjUK4CoLj2thJY2CjjyuAh6lHCGzFGqI8EWIxfT0f/0FHCQamXvOJTCGdk
	 fxv8gPAggg5sHGtHhdj1Zeg3GpkmBbtPD/Q4EFYPHEDkGqa5VcImUHVoHTxlYp1QigAKM
	 0DGwCdHpI+otI9RZHfLx7qomeLpfy7QHjxu+KFRTPU0mqMxpLVbxQv+51fBdPzqsi4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173052;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=OjQ3KTookU9b8nB1FsPKUZ7d491idzwEmHx59C7R6BM=;
	b=vZVDGXeeMSe3GIbEpjZ8TNnC6IZhAuEec8s974Nh3zk888MvtXRVo9cIM1ZlaR0D7Gn6
	 kcLAgiDW+qdtPxGHfOWc0YxLMF/dUK2vHP+Eu+4fpQG3YHB8rPc6PLDspJTLAk3wLMtUJ
	 HBbtczlE/nRg3VlxtL+bKL0YqdPrXiX8KaNpvuLNk0CD905p0wZqLUvbmFHdUJP7FoJsG
	 GKOel+69ZSazTxmmWKiYY33aSFOPLURJ2Z7+xWg+BkU+bxOHvsaBfUy2VkJY9isBlTIt3
	 LSI8Tn1CRWEA53wvti4lt1uTNOSFz8gmrLdZM3ZFbxEuApNF16Nb4yn+hVcuK9DlS4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLDTG8QU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD6E606A33B;
	Fri, 20 Nov 2026 11:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLDTG8QU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD811F000C4;
	Fri, 20 Nov 2026 11:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173052;
	bh=OjQ3KTookU9b8nB1FsPKUZ7d491idzwEmHx59C7R6BM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BLDTG8QUIZwPZtvB3To/8I1CRem2qx6oo5aVCAgbdiE3Sq8PdeeY8vnPjGOkAhS6z
	 GZsK7P2ZKvlsBHzaXlr18ZwB2vmRL8b95js7W6vhnRxrGX7lRCr7MJulMiKLCITQ9M
	 LjaxjdHsZ2rHpq7rvI54T+z7ribxMWaGzgReEL8XcO7UCxITOE/7vCQV7FmGRf4WEe
	 FDfKz2RL1H8vJ2fwr3wIzVsNEmnYpm4RGbNRRihTpPIIjQ9B7EfTToczGed4fNP8Fj
	 z0mIct1XAsZLfAtMjsZ5WHi8fX7Z8APyByqNeMSjgZT5fCG3TPkqIDWCiZFs7ELVph
	 P2DM1RSYQ0TgA==
Subject:
 Re: [PATCH net v4 1/2] ipv6: Honor suppress_prefixlength in fib6_lookup()
From: netdev-bot+sashiko@kernel.org
To: leonard@lausen.nl
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 shuah@kernel.org, daniel@iogearbox.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 20 Nov 2026 11:10:50 +0000
Message-ID: <179517305064.3136.1004033364873817896@kernel.org>
In-Reply-To: <20261117110813.9894-3-leonard@lausen.nl>
References: <20261117110813.9894-3-leonard@lausen.nl>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new RTF_REJECT exemption in fib6_rule_suppress() is
  justified in the commit message by "Do not suppress such routes so…
- [Low] The commit message names only the nftables FIB expression as
  affected.

--

ipv6: Honor suppress_prefixlength in fib6_lookup()

This patch makes fib6_rule_suppress() check suppress_prefixlength against
the prefix length of the FIB entry when the lookup goes through
fib6_lookup(). On that path res->rt6 is not populated. Routes with
RTF_REJECT set in the result are not suppressed, so they still end the
lookup.

Link: https://github.com/firewalld/firewalld/issues/1600

> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index 0ffd7b47a0460..7efb0515b5c8b 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -286,6 +286,12 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
>  	struct rt6_info *rt = res->rt6;
>  	struct net_device *dev = NULL;
>  
> +	if (arg->lookup_ptr == fib6_table_lookup) {

[Severity: Low]

The commit message only mentions the nftables FIB expression. However,
every fib6_lookup() caller takes this branch once
net->ipv6.fib6_has_custom_rules is set. Should the changelog also mention
the other callers whose results change?

For example, bpf_ipv6_fib_lookup() in net/core/filter.c calls
fib6_lookup() when BPF_FIB_LOOKUP_DIRECT is not set:

    err = fib6_lookup(net, oif, &fl6, &res, strict);

So XDP and tc programs that call bpf_fib_lookup() for AF_INET6 will now
get the route from a later table, not the suppressed default route in the
main table.

Gateway validation in ip6_route_check_nh() in net/ipv6/route.c also goes
through fib6_lookup():

    err = fib6_lookup(net, cfg->fc_ifindex, &fl6, &res, flags);

This path is used for IPv6 nexthop objects. Outside a VRF,
nh_create_ipv6() sets fc_table from l3mdev_fib_table(dev), which is 0. It
is also used for route adds when the gateway is not found in
cfg->fc_table.

A gateway that used to resolve through a no-gateway route such as
"default dev X" can now resolve to a different device once that route is
suppressed. If no later rule finds a route on the requested device, the
add fails with -EHOSTUNREACH.

This probably brings IPv6 closer to the ip6_route_output() and IPv4
fib4_rule_suppress() behaviour, which is likely what you want. Since the
Fixes: tag will take this to stable, could the changelog mention the
user-visible changes to bpf_fib_lookup() and to route and nexthop
validation?

> +		/* fib6_table_lookup() returns 0 for reject routes. */
> +		return !(res->fib6_flags & RTF_REJECT) &&
> +		       res->f6i->fib6_dst.plen <= rule->suppress_prefixlen;

[Severity: Medium]

Does the RTF_REJECT exemption also catch RTN_THROW routes?

The commit message says:

    Do not suppress such routes so that they continue to terminate the
    lookup, as with ip6_route_output() and IPv4.

But rtm_to_fib6_config() sets RTF_REJECT for throw routes as well:

    if (rtm->rtm_type == RTN_UNREACHABLE ||
        rtm->rtm_type == RTN_BLACKHOLE ||
        rtm->rtm_type == RTN_PROHIBIT ||
        rtm->rtm_type == RTN_THROW)
            cfg->fc_flags |= RTF_REJECT;

On the fib6_lookup() path, fib6_rule_action_alt() returns 0 for any
matched entry other than fib6_null_entry:

    err = fib6_table_lookup(net, table, *oif, flp6, res, flags);
    if (!err && res->f6i != net->ipv6.fib6_null_entry)
            err = fib6_rule_saddr(net, rule, flags, flp6,
                                  res->nh->fib_nh_dev);
    else
            err = -EAGAIN;

So fib_rules_lookup() calls fib6_rule_suppress(). This branch returns
false because RTF_REJECT is set, and the rule walk stops with an
RTN_THROW result.

On the ip6_route_output() path, __fib6_rule_action() returns
rt->dst.error, which comes from fib6_prop[RTN_THROW] = -EAGAIN. IPv4
fib_table_lookup() returns fib_props[RTN_THROW].error = -EAGAIN. In both
cases fib_rules_lookup() goes on to the next rule, so a throw route never
ends the lookup there.

For example, take "throw default" in the main table with a "table main
suppress_prefixlength 0" rule. ip6_route_output() would continue to the
next rule, but fib6_lookup() stops at the throw route.

nft_fib6_eval_type() then reports RTN_THROW, and nft_fib6_eval() returns
no oif:

    if (ret || res.fib6_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
            return;

That can lead to strict RPF drops. bpf_ipv6_fib_lookup() also returns
BPF_FIB_LKUP_RET_NOT_FWDED even though a later rule would match.

The throw handling in fib6_rule_action_alt() predates this patch.
However, before 1c32b24c234b the nft code used ip6_route_lookup() and
nf_ip6_route(), which handled throw routes correctly. The reject-route
checks described in the notes seem to cover only blackhole, unreachable
and prohibit routes.

Could fib6_rule_action_alt() return -EAGAIN when res->fib6_type ==
RTN_THROW? The RTF_REJECT exemption here would then cover only routes
that really end the lookup.

> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117110813.9894-2-leonard%40lausen.nl
