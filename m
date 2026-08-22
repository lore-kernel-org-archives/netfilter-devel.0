Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C41A25B0BD;
	Sat, 22 Aug 2026 19:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787428350; cv=none; b=ulYGIlpOktKXWhKzr0aPqiw4B0NA2KAKQWRMS3BIH3uWteCn70daSQCP45YNQs2RaS3pHAgR0mJMUFUcFSqd2LuEULboYngOynA/pf+hYcdRwVN9YLHx5Ufhyypzsx37jhMpfA3SSlZfyeurgWW6D3DddIFJIdz15bBemjTjU6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787428350; c=relaxed/simple;
	bh=dqkm2Y2Z8oZLWCfTlui6iUTnoqJ8cOctOSikVSw+MKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpPQQFHSvniE5Ht0AxckYc1SNe778Krdnaa2vQFSOKgwoyQd9Gsed3V9DjkxufL5suqEsS5LeaXyFBx+tSWqFe3y68weDvRk7ra0IZE4QCjzUr6TkevI7hfxcIStgqvJKwU5ORZyV8gyzZw6lYWS7SYU5xmG7bK+4/t/Ozb/Rf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLDaTgr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLDaTgr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419FB1F000E9;
	Sat, 22 Aug 2026 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787428348;
	bh=SYXxYr+BNHKYI7TPucTk2nxUl/C/7LIZvT7oCJghudA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLDaTgr+VHAK5jYxNFwodn4uQBhNDZY0ULLkga18tMYXg/0Z2oOAAY8Jew9y0Wz5u
	 mJ10bp6XdAFhSQwe9Mb9uif5yYYMpt35B5reuuM1Bz3b+C3XxeZmdhpCBtEEMRhGAK
	 mgJVrr9+0fJrAcICilCnIXo6dInrT2iy8ThdekCQZCYMpDTRSh8UksQBfh3CZyf3K1
	 LhyPP7CRnzJAt48myznOfdgUZA0cEJNjCUtRkYx0XCBJXEEJSeCvCAkJ58EbOJSDCR
	 2tcGbEhPe8FereZOB5pOt6Gp4qVF+6N33rJphyz8FZrmnUQTGT3Z6lnegf803+B8W6
	 P1o5t9SHwEWwA==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 05/10] netfilter: x_tables: remove pr_debug
Date: Sat, 22 Aug 2026 12:52:27 -0700
Message-ID: <20260822195227.2202694-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821153833.245589-6-pablo@netfilter.org>
References: <20260821153833.245589-6-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: x_tables: remove pr_debug

This drops the pr_debug() calls from a set of xtables matches and
targets, and converts the ones in the .check paths into
pr_info_ratelimited() so that legacy iptables users get a hint in dmesg
when a rule is rejected.

A few observations below.

> diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
> index 6d1a5d2026a67..37c207d3152a4 100644
> --- a/net/ipv6/netfilter/ip6t_hbh.c
> +++ b/net/ipv6/netfilter/ip6t_hbh.c

[ ... ]

> @@ -166,16 +144,16 @@ static int hbh_mt6_check(const struct xt_mtchk_param *par)
>  	const struct ip6t_opts *optsinfo = par->matchinfo;
>  
>  	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
> -		pr_debug("unknown flags %X\n", optsinfo->invflags);
> +		pr_info_ratelimited("unknown flags %X\n", optsinfo->invflags);
>  		return -EINVAL;
>  	}
>  	if (optsinfo->optsnr > IP6T_OPTS_OPTSNR) {
> -		pr_debug("too many supported opts specified\n");
> +		pr_info_ratelimited("too many supported opts specified\n");
>  		return -EINVAL;
>  	}
>  
>  	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
> -		pr_debug("Not strict - not implemented");
> +		pr_info_ratelimited("Not strict - not implemented");
>  		return -EINVAL;
>  	}

[Severity: Low]
Should this string get a trailing newline like its two siblings in
hbh_mt6_check()?

The missing '\n' was harmless while this was pr_debug() (compiled out or
dynamic-debug gated), but as an unconditional pr_info_ratelimited() the
record is left open for continuation:

kernel/printk/printk.c:printk_sprint() {
	/* Mark and strip a trailing newline. */
	if (text_len && text[text_len - 1] == '\n') {
		text_len--;
		*flags |= LOG_NEWLINE;
	}
}

kernel/printk/printk.c:vprintk_store() {
	/* A message without a trailing newline can be continued. */
	if (!(flags & LOG_NEWLINE))
		prb_commit(&e);
	else
		prb_final_commit(&e);
}

So an iptables-legacy rule with IP6T_OPTS_NSTRICT set produces a dmesg
line that gets glued to whatever is printed next, which works against the
"hint via dmesg" goal in the changelog.

The same missing '\n' appears in three more of the converted strings, noted
below.

> diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
> index 278b52752f364..0c01ac2746d1f 100644
> --- a/net/ipv6/netfilter/ip6t_rt.c
> +++ b/net/ipv6/netfilter/ip6t_rt.c
> @@ -155,18 +155,18 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
>  	const struct ip6t_rt *rtinfo = par->matchinfo;
>  
>  	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
> -		pr_debug("unknown flags %X\n", rtinfo->invflags);
> +		pr_info_ratelimited("unknown flags %X\n", rtinfo->invflags);
>  		return -EINVAL;
>  	}
>  	if (rtinfo->addrnr > IP6T_RT_HOPS) {
> -		pr_debug("too many addresses specified\n");
> +		pr_info_ratelimited("too many addresses specified\n");
>  		return -EINVAL;
>  	}
>  	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
>  	    (!(rtinfo->flags & IP6T_RT_TYP) ||
>  	     (rtinfo->rt_type != 0) ||
>  	     (rtinfo->invflags & IP6T_RT_INV_TYP))) {
> -		pr_debug("`--rt-type 0' required before `--rt-0-*'");
> +		pr_info_ratelimited("`--rt-type 0' required before `--rt-0-*'");
>  		return -EINVAL;
>  	}

[Severity: Low]
Same question here in rt_mt6_check(): the two messages above it end in
'\n' but this one does not, so a rule with IP6T_RT_RES or IP6T_RT_FST_MASK
and rt_type != 0 leaves the record un-terminated.

> diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
> index bfcf2d44e93db..15b698ea98aa6 100644
> --- a/net/netfilter/xt_IDLETIMER.c
> +++ b/net/netfilter/xt_IDLETIMER.c

[ ... ]

> @@ -171,7 +168,7 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
>  
>  	ret = sysfs_create_file(idletimer_tg_kobj, &info->timer->attr.attr);
>  	if (ret < 0) {
> -		pr_debug("couldn't add file to sysfs");
> +		pr_info_ratelimited("couldn't add file to sysfs");
>  		goto out_free_attr;
>  	}

[Severity: Low]
Would it be worth adding the '\n' here in idletimer_tg_create() too?  This
one is reached from idletimer_tg_checkentry() when sysfs_create_file()
fails, and the other strings converted in this file
("timeout value is zero\n", "label is empty or not nul-terminated\n") are
newline terminated.

> @@ -220,7 +217,7 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
>  
>  	ret = sysfs_create_file(idletimer_tg_kobj, &info->timer->attr.attr);
>  	if (ret < 0) {
> -		pr_debug("couldn't add file to sysfs");
> +		pr_info_ratelimited("couldn't add file to sysfs");
>  		goto out_free_attr;
>  	}

[Severity: Low]
And the second copy of the same string, in idletimer_tg_create_v1(),
reached from idletimer_tg_checkentry_v1().

[ ... ]

> @@ -534,7 +490,7 @@ static int __init idletimer_tg_init(void)
>  	idletimer_tg_class = class_create("xt_idletimer");
>  	err = PTR_ERR(idletimer_tg_class);
>  	if (IS_ERR(idletimer_tg_class)) {
> -		pr_debug("couldn't register device class\n");
> +		pr_info_ratelimited("couldn't register device class\n");
>  		goto out;
>  	}
>  
> @@ -542,7 +498,7 @@ static int __init idletimer_tg_init(void)
>  					    MKDEV(0, 0), NULL, "timers");
>  	err = PTR_ERR(idletimer_tg_device);
>  	if (IS_ERR(idletimer_tg_device)) {
> -		pr_debug("couldn't register system device\n");
> +		pr_info_ratelimited("couldn't register system device\n");
>  		goto out_class;
>  	}
>  
> @@ -551,7 +507,7 @@ static int __init idletimer_tg_init(void)
>  	err = xt_register_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));
>  
>  	if (err < 0) {
> -		pr_debug("couldn't register xt target\n");
> +		pr_info_ratelimited("couldn't register xt target\n");
>  		goto out_dev;
>  	}

[Severity: Low]
The changelog says:

    Still, turn pr_debug() into pr_info_ratelimited() in the .check
    path since this helps provide a hint via dmesg in legacy iptables.

These three conversions are in idletimer_tg_init(), which is __init and not
an xtables checkentry callback, so they fall outside the ".check path"
described above.

Were these intended?  Ratelimiting can never trigger on a one-shot module
init failure, and pr_err() would be the usual level for class_create(),
device_create() and xt_register_targets() failing.

> diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
> index cb2ee80d84fa8..8c86d9a43373a 100644
> --- a/net/netfilter/xt_NETMAP.c
> +++ b/net/netfilter/xt_NETMAP.c
> @@ -106,11 +106,11 @@ static int netmap_tg4_check(const struct xt_tgchk_param *par)
>  	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
>  
>  	if (!(mr->range[0].flags & NF_NAT_RANGE_MAP_IPS)) {
> -		pr_debug("bad MAP_IPS.\n");
> +		pr_info_ratelimited("bad MAP_IPS.\n");
>  		return -EINVAL;
>  	}
>  	if (mr->rangesize != 1) {
> -		pr_debug("bad rangesize %u.\n", mr->rangesize);
> +		pr_info_ratelimited("bad rangesize %u.\n", mr->rangesize);
>  		return -EINVAL;
>  	}
>  	return nf_ct_netns_get(par->net, par->family);

[Severity: Low]
Do these new messages need a pr_fmt() in this file to be identifiable?

xt_NETMAP.c and xt_REDIRECT.c do not define pr_fmt(), so the fallback in
include/linux/printk.h applies:

	#define pr_fmt(fmt) fmt

while the peer site does define one:

net/netfilter/xt_MASQUERADE.c:
	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

and prints the byte-identical strings "bad MAP_IPS." and
"bad rangesize %u".  The result is that MASQUERADE reports
"xt_MASQUERADE: bad MAP_IPS." while NETMAP and REDIRECT report a bare
"bad MAP_IPS.", so dmesg no longer says which target rejected the rule.
With pr_debug() the dynamic debug machinery supplied module, file and
function, so this did not matter before.

> diff --git a/net/netfilter/xt_REDIRECT.c b/net/netfilter/xt_REDIRECT.c
> index ff66b56a3f97d..27bc0545c4f74 100644
> --- a/net/netfilter/xt_REDIRECT.c
> +++ b/net/netfilter/xt_REDIRECT.c
> @@ -51,11 +51,11 @@ static int redirect_tg4_check(const struct xt_tgchk_param *par)
>  	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
>  
>  	if (mr->range[0].flags & NF_NAT_RANGE_MAP_IPS) {
> -		pr_debug("bad MAP_IPS.\n");
> +		pr_info_ratelimited("bad MAP_IPS.\n");
>  		return -EINVAL;
>  	}
>  	if (mr->rangesize != 1) {
> -		pr_debug("bad rangesize %u.\n", mr->rangesize);
> +		pr_info_ratelimited("bad rangesize %u.\n", mr->rangesize);
>  		return -EINVAL;
>  	}
>  	return nf_ct_netns_get(par->net, par->family);

[Severity: Low]
Same for redirect_tg4_check() in xt_REDIRECT.c, which also has no pr_fmt()
definition.
