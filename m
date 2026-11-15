Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785349;
	b=GI6RU0xuZ1uSRqjhzAkIOcFw6Sp3BE7HlcAQBu60He3ha7brWmuQSg6CWKPRb6BNFZCJ
	 GI9c40iCv2xvl6k6xAdTz3528HvqbMIMtBj0x43IzpVyuZWbAXJZ0I+ZBTrM32ynTOe8d
	 BaZKNfKurXmCvhBnFUsDsozhwHMLrxTmR8O1kTq4tsC04DluLnXZaJJvjE9BzIJtuWgxb
	 2z1jWpFMZm7cPqYLk29yaGApOIvIRYLRSsP9si1MTMFIYL9YvMIbpVpB88KyEZlkbJAvM
	 yw+E8TrXwSm1ijwDogp8u41BoNDNSlG2rggRkkRQGB5CnUEdbjhH1oyXTlpc8grS3sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785349;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=fs7kj0ONqleklOE9zYkQRimp2I3526y5esIq7JZRVXY=;
	b=f/uL/U03PjTShlnXEYk7sEwoiYQpjcr8mNY8RYB+G6QdwzyaPVixhZTMfV5jTrrVAN/Y
	 981yTFD52MYKXEWJDsCWHn5jfxWr+FVAKc02A76hOBgoydr5bIXd5mQr2Ajg8xStfnJAg
	 0+EDpzWc8r19wMXYJIOSExn5o9IQiS/eiRbc3TOKLrD+XWOafeaEJ0XJeRoHkd3kjxwN4
	 cwgTky0PV2Novqzx92x0jwN7+amWp3cCc8emkjHzF5uTHEfHZ+qw4J0nuwTN4KmIBMc+q
	 qZx16SMT9nkkKor/tJAq96W9If2oDeLXUktx88u5TRanhNRo36mK1LINU1Rr90WHgEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gRCT2UPj;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2E45A606A31F;
	Sun, 15 Nov 2026 23:29:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E45A606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gRCT2UPj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794785346;
	bh=fs7kj0ONqleklOE9zYkQRimp2I3526y5esIq7JZRVXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gRCT2UPjMUU5JzqcnW10aRhI2/WBaoLeMuzeh+UmkJVGgki975Ji4uFU7bFpmee1c
	 lo43EjsZD3vA1z3OqWniruXoeHvDeV4M6mdWgvmOQbRogKRx05AEeYQNnabwvtIBzS
	 XrOBlGrzLt+xvuvXfBrAd92Ka6ix0Z3wuTVuPGkIWwhZSLkwuMf564RJbbvQdkUr8n
	 KaTCnjgQeU4tDYvwhErJqNitzquN1ndfVSYIUsf6KU/E6HrY+/+fE3ceSyOUPieSTs
	 /Q6w7BzUanJAdG6Npc7v0qEmvx2EIsJalqq77ak5GkylYUKb95unRlBeE6Clpe7Q+9
	 ZI6MsDXncTOTQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A93CF602A5;
	Mon, 16 Nov 2026 00:29:06 +0100 (CET)
Date: Mon, 16 Nov 2026 00:29:04 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 08/15] netfilter: lwtunnel: expose read-only
 sysctl nf_hooks_lwtunnel for non init-netns
Message-ID: <avpAQDC_eXLe72NR@chamomile>
References: <20261113031251.2437074-9-pablo@netfilter.org>
 <179462662676.2199510.16804675187126889146@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179462662676.2199510.16804675187126889146@kernel.org>

On Sat, Nov 14, 2026 at 03:23:46AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The patch sets the per-netns copy of
>   net.netfilter.nf_hooks_lwtunnel to mode 0444 in nf_lwtunnel_net_init()…
> - [Low] The nf_hooks_lwtunnel entry in
>   Documentation/networking/nf_conntrack-sysctl.rst (lines 212-217)…
> 
> --
> 
> netfilter: lwtunnel: expose read-only sysctl nf_hooks_lwtunnel for non init-netns
> 
> The commit registers the per-netns copy of the nf_hooks_lwtunnel sysctl
> with mode 0444 instead of 0644 in every netns except init_net. This stops
> unprivileged users from flipping the global nf_hooks_lwtunnel_enabled
> static key from inside a user namespace.
> 
> > diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
> > index 40c6fce14a63f..7e2ee8677f1fc 100644
> > --- a/net/netfilter/nf_hooks_lwtunnel.c
> > +++ b/net/netfilter/nf_hooks_lwtunnel.c
> > @@ -68,14 +68,18 @@ static int __net_init nf_lwtunnel_net_init(struct net *net)
> 
> [ ... ]
> 
> >  	if (!net_eq(net, &init_net)) {
> > -		table = kmemdup(nf_lwtunnel_sysctl_table,
> > -				sizeof(nf_lwtunnel_sysctl_table),
> > -				GFP_KERNEL_ACCOUNT);
> > -		if (!table)
> > +		dup = kmemdup(nf_lwtunnel_sysctl_table,
> > +			      sizeof(nf_lwtunnel_sysctl_table),
> > +			      GFP_KERNEL_ACCOUNT);
> > +		if (!dup)
> >  			goto err_alloc;
> > +
> > +		dup->mode = 0444;
> > +		table = dup;
> 
> [Severity: Medium]
> Should the SRv6 netfilter selftests be updated along with this change?

That test needs an update yes, I'd prefer to address this in a follow
up patch.

> With 0444, nobody can write the knob from a child netns, including global
> root with CAP_NET_ADMIN. net_ctl_permissions() copies only the owner bits:
> 
> net/sysctl_net.c:net_ctl_permissions() {
>     ...
> 	if (ns_capable_noaudit(net->user_ns, CAP_NET_ADMIN)) {
> 		int mode = (table->mode >> 6) & 7;
> 		return (mode << 6) | (mode << 3) | mode;
> 	}
>     ...
> }
> 
> test_perm() in fs/proc/proc_sysctl.c does not let root override this, so
> the write returns -EACCES.
> 
> Both tools/testing/selftests/net/srv6_end_dx4_netfilter_test.sh and
> srv6_end_dx6_netfilter_test.sh write the knob from the rt-N netns in
> setup_rt_netfilter():
> 
> 	ip netns exec ${nsname} sysctl -wq net.netfilter.nf_hooks_lwtunnel=1
> 
> The scripts don't check the exit status, so the failure goes unnoticed.
> nf_hooks_lwtunnel_enabled then stays off, and decapsulated SRv6 packets
> never reach the NF_HOOK(NF_INET_PRE_ROUTING) calls in seg6_local.c.
> 
> router_netfilter_tests() only checks ping connectivity:
> 
> 	setup_rt_netfilter 1
> 	setup_rt_netfilter 2
> 
> 	check_and_log_hs_connectivity 1 2 100
> 
> Plain SRv6 forwarding works without the hooks, so the "netfilter enabled
> in routers" tests would still pass without running the netfilter path at
> all.
> 
> Userspace sees the same change: a privileged container manager that used
> to enable this knob as real root from inside a pod netns will now get
> EACCES and has to write it in init_net instead.
> 
> The restriction itself matches other global netfilter sysctls, such as
> those in nf_conntrack_standalone.c and ipvs. The concern is only that the
> dependent selftests stay as they are. As of 3e59905baa0f, both scripts
> still write the sysctl from rt-N.
> 
> [Severity: Low]
> This isn't a bug, but should the nf_hooks_lwtunnel entry in
> Documentation/networking/nf_conntrack-sysctl.rst mention the new
> restriction?
> 
> The entry currently reads:
> 
> 	nf_hooks_lwtunnel - BOOLEAN
> 		- 0 - disabled (default)
> 		- not 0 - enabled
> 
> 		If this option is enabled, the lightweight tunnel netfilter hooks are
> 		enabled. This option cannot be disabled once it is enabled.
> 
> The same document already has this note for nf_conntrack_buckets:
> 
> 	This sysctl is only writeable in the initial net namespace.
> 
> A similar note here would explain the EACCES that users now get when they
> write the knob from a child netns. As of 3e59905baa0f, the entry is
> unchanged.
> 
> >  	}
> >  
> >  	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
