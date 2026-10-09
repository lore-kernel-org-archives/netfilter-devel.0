Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C093233946
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 00:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506255; cv=none; b=T7BrTztae2qd7oIuS8yGglBKsxnEKVee/uTXnOLKRFbbvdNSGAi88qA2cvYZfqXw6lLYzzAMUJAVyD24zQ+psOgPGsuKMtpWSENz+ANRl0RhGKvw9fnPzWjOS/8IUGR4D9Jpc0eqKLRXDJfQT9lpd371BnBLZE7GQlrkmjWtCm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506255; c=relaxed/simple;
	bh=+RPlELnisSATz68o9tU+UmFjXFwDR5GRiAF211AFrRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6lf91r4QptTKsMZdwU523INLJiY1TYCY2G6kJwQY4TTQOuaBdlPpRDCN2FkoNmD/b51heVYxcOXkove9ATKRqZg/ANotDTiAeKIHGUlYceTGdAv16nnvv29AhtdHPW7TTeQmdnYwRivbL3jPePMPOO2IrOQgC7AwVlbrW/1lls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ctuEIjYC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ctuEIjYC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791506250;
	bh=rvmzA1r963961SdRJznJSaZzJEQnx9hpy+oMoRdGZzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ctuEIjYCZVxsFtmkMWNhRvpX0NYZ3M3ptLX0dhe080QhukIbxkf4CYtM9DXhirrZl
	 Yo6AIyfp7n8QSphWcmuFuSzh/GuNdJyvFsH07jWfvYVy3Rx1qW55NSOlJ2OLsMg95E
	 82lNuHEKXYkQSx01Px6dRVqGYOCrg70oxkul8AD+pHXGrlApwtRHzni6QMyt2HbJv3
	 TwbAqMwthSoUHifuX7yF2IRYYuHO7/yCNmiGsDTvfzuegQf5zwBZoDN2vInJqp2O/d
	 FQrdkWST7S6HjRLnF5iWvSMynwqq47mBnQ7xp7CIhBn9ByutR+zCNfSXLcD3LLVhuV
	 A/8Hj317skEPw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E083F6005E;
	Fri,  9 Oct 2026 02:37:29 +0200 (CEST)
Date: Fri, 9 Oct 2026 02:37:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH nf v3] netfilter: disable br_netfilter in user namespaces
Message-ID: <asg3R0zgnLUICy5w@chamomile>
References: <20260831151107.25269-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260831151107.25269-1-fw@strlen.de>

Hi Florian,

On Mon, Aug 31, 2026 at 05:11:04PM +0200, Florian Westphal wrote:
> br_netfilter has way too many bugs, schedule for removal and disable
> the feature in user namespaces.
> 
> In particular, we get more and more gadgets to have bridge ports escape
> rcu_read_lock() protection, then underlying device gets reconfigured
> (macvlan or something else), then reinject into network stack causes
> crash because net_device is assumed to still have bridge rx data
> associated with it.
> 
> br_netfilter is an ancient kludge that emulates ip stack from within the
> bridge and then calls into ipv4/ipv6 netfilter hooks to have bridged
> frames processed via iptables/ip6tables by setting the 'call-iptables'
> sysctls to 1. It is NOT related to ebtables or nftables 'bridge' family
> at all.
> 
> Note that in addition to call-iptables, sysctls, the bridge also exposes
> call-iptables per bridge device via netlink and sysfs
> ('BROPT_NF_CALL_IPTABLES') toggles.
> 
> Those are still available, the brnet structure is scoped to br_netfilter;
> exposing it bridge-wide is a big no-no.

I agree in all this.

> This relies on brnf_device_event() no longer registering the base
> br_netfilter hooks, so while BROPT_NF_CALL_IPTABLES can be set, it
> has no effect because the hooks that evaluate this feature bit
> are never registered.
> 
> brnf_init_net can no longer depend on CONFIG_SYSCTL, else such builds
> never disable support in user namespaces.

I pick up late on this, given it is late in the -rc, I'd suggest to
take this through nf-next.

Let me know, thanks.

> Cc: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  v3: also update Documentation, correct changelog: toggle is
>  per bridge device, not per bridge port (Nik)
> 
>  Documentation/networking/bridge.rst |  5 +++--
>  net/bridge/br_netfilter_hooks.c     | 33 ++++++++++++++++++++---------
>  2 files changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/networking/bridge.rst b/Documentation/networking/bridge.rst
> index c1e6ea52c9e5..dded1a6edd60 100644
> --- a/Documentation/networking/bridge.rst
> +++ b/Documentation/networking/bridge.rst
> @@ -277,8 +277,9 @@ Netfilter
>  =========
>  
>  The bridge netfilter module is a legacy feature that allows to filter bridged
> -packets with iptables and ip6tables. Its use is discouraged. Users should
> -consider using nftables for packet filtering.
> +packets with iptables and ip6tables. This feature is scheduled for removal and
> +not available in user namespaces. Consider using nftables for packet filtering
> +instead.
>  
>  The older ebtables tool is more feature-limited compared to nftables, but
>  just like nftables it doesn't need this module either to function.
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 0a394e5f4391..e15355ff215a 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -54,6 +54,7 @@ static unsigned int brnf_net_id __read_mostly;
>  
>  struct brnf_net {
>  	bool enabled;
> +	bool in_userns;
>  
>  #ifdef CONFIG_SYSCTL
>  	struct ctl_table_header *ctl_hdr;
> @@ -1100,7 +1101,7 @@ static int brnf_device_event(struct notifier_block *unused, unsigned long event,
>  
>  	net = dev_net(dev);
>  	brnet = net_generic(net, brnf_net_id);
> -	if (brnet->enabled)
> +	if (brnet->enabled || brnet->in_userns)
>  		return NOTIFY_OK;
>  
>  	ret = nf_register_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
> @@ -1229,9 +1230,11 @@ static inline void br_netfilter_sysctl_default(struct brnf_net *brnf)
>  	brnf->filter_pppoe_tagged = 0;
>  	brnf->pass_vlan_indev = 0;
>  }
> +#endif
>  
>  static int br_netfilter_sysctl_init_net(struct net *net)
>  {
> +#ifdef CONFIG_SYSCTL
>  	struct ctl_table *table = brnf_table;
>  	struct brnf_net *brnet;
>  
> @@ -1259,25 +1262,39 @@ static int br_netfilter_sysctl_init_net(struct net *net)
>  
>  		return -ENOMEM;
>  	}
> -
> +#endif
>  	return 0;
>  }
>  
>  static void br_netfilter_sysctl_exit_net(struct net *net,
>  					 struct brnf_net *brnet)
>  {
> -	const struct ctl_table *table = brnet->ctl_hdr->ctl_table_arg;
> +#ifdef CONFIG_SYSCTL
> +	struct ctl_table_header *header = brnet->ctl_hdr;
> +	const struct ctl_table *table;
>  
> -	unregister_net_sysctl_table(brnet->ctl_hdr);
> +	if (!header)
> +		return;
> +
> +	table = header->ctl_table_arg;
> +	unregister_net_sysctl_table(header);
>  	if (!net_eq(net, &init_net))
>  		kfree(table);
> +#endif
>  }
>  
>  static int __net_init brnf_init_net(struct net *net)
>  {
> +	if (net->user_ns != &init_user_ns) {
> +		struct brnf_net *brnet = net_generic(net, brnf_net_id);
> +
> +		brnet->in_userns = true;
> +		pr_warn_once("br_netfilter no longer supported in user namespaces\n");
> +		return 0;
> +	}
> +
>  	return br_netfilter_sysctl_init_net(net);
>  }
> -#endif
>  
>  static void __net_exit brnf_exit_net(struct net *net)
>  {
> @@ -1289,15 +1306,11 @@ static void __net_exit brnf_exit_net(struct net *net)
>  		brnet->enabled = false;
>  	}
>  
> -#ifdef CONFIG_SYSCTL
>  	br_netfilter_sysctl_exit_net(net, brnet);
> -#endif
>  }
>  
>  static struct pernet_operations brnf_net_ops __read_mostly = {
> -#ifdef CONFIG_SYSCTL
>  	.init = brnf_init_net,
> -#endif
>  	.exit = brnf_exit_net,
>  	.id   = &brnf_net_id,
>  	.size = sizeof(struct brnf_net),
> @@ -1318,7 +1331,7 @@ static int __init br_netfilter_init(void)
>  	}
>  
>  	RCU_INIT_POINTER(nf_br_ops, &br_ops);
> -	printk(KERN_NOTICE "Bridge firewalling registered\n");
> +	pr_warn("br_netfilter is slated for removal in 2027.\n");
>  	return 0;
>  }
>  
> -- 
> 2.55.0
> 
> 
