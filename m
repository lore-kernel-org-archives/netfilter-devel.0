Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626628;
	b=D/6AqFtHpkC5n3u1Mh7K9A832U3EULs238hOc/PF7mE0b60E+kJUrz79ehS3jaX5KHuM
	 CglErTvfJseK/ozDy9wDfiJ22LLgFrMGARI4jVhSR3wgZWoiNq21G7+2OdZFeDso+PFqX
	 UNLM8cqEl5hETKPDP8gYNNm3rdcnLqQtT4hW2Vzw51mKJnF6mw6rpelPtqsZDauN/JHSW
	 ROpA+dfI4ot31FUt0CfKXiYrp2w5/rXcBjriWI7AnXA6V9C/9U3OAcrKilC0dzywk802z
	 9y952+GeB7QkkbaWJ0ajzsGNV0EUA/jgGOctt+hFULB4jCbmiXjdJvtmD32hH75pX7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626628;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=dY5PKsK5J19Th8+Fm7xUFkkD+sSQ56nEk4CE9XaBMtk=;
	b=IDLoOWoUGcRrCA9GRl389vUdlA5rgfkcrQHqPwKpVprmnMLl8PlX/snAZnUVhEctX5Pf
	 oVzDmzb43qesxYk2MD1PqwICoFHYrIn124W7EhZKjldOn0PufdlJ1bO9t/Rrjf4/4iID5
	 9L1GijzXEc3Iog5a6Nvmn2u8WUMIk126IWKlbzlub1sxMSeVtnvDKAOlc9/EMc7LShT9p
	 pw3BnAHhpntL9Z79TR1cbE1LGC/O7RpC9HYEWobwohNgDy6fmd33acqvm51BxMMpYzxz+
	 ajLjAyfGCuqx/oKvxBJBhig/MCZu5uvFVBHlWnRw9nURezl7ruxCd6fUrSR98ujBsVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Kuz/70jq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A6660A2603;
	Sat, 14 Nov 2026 03:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kuz/70jq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DC01F000C9;
	Sat, 14 Nov 2026 03:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626627;
	bh=dY5PKsK5J19Th8+Fm7xUFkkD+sSQ56nEk4CE9XaBMtk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Kuz/70jqck+5ctD4Heff1oMkImRe04SygmZFqp3VQzdNB0gr79UC9S3GlYUgJDt7q
	 7kQaMFOjRhrx7JVcTiySF0I3S0U4Plby/2/a5WID9Atqcf4Lrqv1eEbJNpdT5WLKve
	 OQfYlM71m4btZrX5BqiiahUgbBbl7rGS4dlwKklcr7hQPlYNJldoXtWXXgBKFjL8Yo
	 l7eFtzwYXHryigN0ceiLUm3f1uzHwQXM0Trt856lP8UjSUICtIJb9gkFXi9/AFIcaO
	 RCol05Z7J0XAb2DpKP5M/TTOyT/dArz7r+qtbfMSHH0k0zA3kQjLca4OPqcYcaLNb+
	 yw77EimEMkrZA==
Subject: Re: [PATCH net-next 08/15] netfilter: lwtunnel: expose read-only
 sysctl nf_hooks_lwtunnel for non init-netns
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:46 +0000
Message-ID: <179462662676.2199510.16804675187126889146@kernel.org>
In-Reply-To: <20261113031251.2437074-9-pablo@netfilter.org>
References: <20261113031251.2437074-9-pablo@netfilter.org>
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

- [Medium] The patch sets the per-netns copy of
  net.netfilter.nf_hooks_lwtunnel to mode 0444 in nf_lwtunnel_net_init()…
- [Low] The nf_hooks_lwtunnel entry in
  Documentation/networking/nf_conntrack-sysctl.rst (lines 212-217)…

--

netfilter: lwtunnel: expose read-only sysctl nf_hooks_lwtunnel for non init-netns

The commit registers the per-netns copy of the nf_hooks_lwtunnel sysctl
with mode 0444 instead of 0644 in every netns except init_net. This stops
unprivileged users from flipping the global nf_hooks_lwtunnel_enabled
static key from inside a user namespace.

> diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
> index 40c6fce14a63f..7e2ee8677f1fc 100644
> --- a/net/netfilter/nf_hooks_lwtunnel.c
> +++ b/net/netfilter/nf_hooks_lwtunnel.c
> @@ -68,14 +68,18 @@ static int __net_init nf_lwtunnel_net_init(struct net *net)

[ ... ]

>  	if (!net_eq(net, &init_net)) {
> -		table = kmemdup(nf_lwtunnel_sysctl_table,
> -				sizeof(nf_lwtunnel_sysctl_table),
> -				GFP_KERNEL_ACCOUNT);
> -		if (!table)
> +		dup = kmemdup(nf_lwtunnel_sysctl_table,
> +			      sizeof(nf_lwtunnel_sysctl_table),
> +			      GFP_KERNEL_ACCOUNT);
> +		if (!dup)
>  			goto err_alloc;
> +
> +		dup->mode = 0444;
> +		table = dup;

[Severity: Medium]
Should the SRv6 netfilter selftests be updated along with this change?

With 0444, nobody can write the knob from a child netns, including global
root with CAP_NET_ADMIN. net_ctl_permissions() copies only the owner bits:

net/sysctl_net.c:net_ctl_permissions() {
    ...
	if (ns_capable_noaudit(net->user_ns, CAP_NET_ADMIN)) {
		int mode = (table->mode >> 6) & 7;
		return (mode << 6) | (mode << 3) | mode;
	}
    ...
}

test_perm() in fs/proc/proc_sysctl.c does not let root override this, so
the write returns -EACCES.

Both tools/testing/selftests/net/srv6_end_dx4_netfilter_test.sh and
srv6_end_dx6_netfilter_test.sh write the knob from the rt-N netns in
setup_rt_netfilter():

	ip netns exec ${nsname} sysctl -wq net.netfilter.nf_hooks_lwtunnel=1

The scripts don't check the exit status, so the failure goes unnoticed.
nf_hooks_lwtunnel_enabled then stays off, and decapsulated SRv6 packets
never reach the NF_HOOK(NF_INET_PRE_ROUTING) calls in seg6_local.c.

router_netfilter_tests() only checks ping connectivity:

	setup_rt_netfilter 1
	setup_rt_netfilter 2

	check_and_log_hs_connectivity 1 2 100

Plain SRv6 forwarding works without the hooks, so the "netfilter enabled
in routers" tests would still pass without running the netfilter path at
all.

Userspace sees the same change: a privileged container manager that used
to enable this knob as real root from inside a pod netns will now get
EACCES and has to write it in init_net instead.

The restriction itself matches other global netfilter sysctls, such as
those in nf_conntrack_standalone.c and ipvs. The concern is only that the
dependent selftests stay as they are. As of 3e59905baa0f, both scripts
still write the sysctl from rt-N.

[Severity: Low]
This isn't a bug, but should the nf_hooks_lwtunnel entry in
Documentation/networking/nf_conntrack-sysctl.rst mention the new
restriction?

The entry currently reads:

	nf_hooks_lwtunnel - BOOLEAN
		- 0 - disabled (default)
		- not 0 - enabled

		If this option is enabled, the lightweight tunnel netfilter hooks are
		enabled. This option cannot be disabled once it is enabled.

The same document already has this note for nf_conntrack_buckets:

	This sysctl is only writeable in the initial net namespace.

A similar note here would explain the EACCES that users now get when they
write the knob from a child netns. As of 3e59905baa0f, the entry is
unchanged.

>  	}
>  
>  	hdr = register_net_sysctl_sz(net, "net/netfilter", table,

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
