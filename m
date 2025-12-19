Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D0C221F15;
	Fri, 19 Dec 2025 07:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766130519; cv=none; b=KJLp90wRQ5a6TAOwIsVBCO36lBGaUqSiJvejVMIZu4o61EbXFMxDLdaZw0fdi9GX48CtdIidtVhIps1P+PGhrc6P2TD08BXpElA70qoGVnN0+9KkI0E16QcuZlF7KgT+i7d/EqW9BH5UInYQ+nJ8JSmw8sC1lzMVvCiRdL1MZ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766130519; c=relaxed/simple;
	bh=vq1exl23DZn4zlCEvIq0ovg5Fb2CUvggZ7vSzFMwSZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvwuTR3Y58DNsFogvSQUDfoRlKG+E8HaKIo/NEyk1eWvtnmyJ7gVQ0GmzC1NMsZlAAOxe+QqpDFrFw3dBnLgnXILz5/sn/wUpjWLtI6FD3n67OPodd9+1NSVCN70CdC8jgRafyAPO7HzgEhPc52yMrlhBlExTYaNYxDx7wDuU/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D625260218; Fri, 19 Dec 2025 08:48:27 +0100 (CET)
Date: Fri, 19 Dec 2025 08:48:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Lucas De Marchi <demarchi@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [PATCH] netfilter: replace -EEXIST with -EBUSY
Message-ID: <aUUDRGqMQ_Ss3bDJ@strlen.de>
References: <20251219-dev-module-init-eexists-netfilter-v1-1-efd3f62412dc@samsung.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219-dev-module-init-eexists-netfilter-v1-1-efd3f62412dc@samsung.com>

Daniel Gomez <da.gomez@kernel.org> wrote:
> From: Daniel Gomez <da.gomez@samsung.com>
> 
> The -EEXIST error code is reserved by the module loading infrastructure
> to indicate that a module is already loaded. When a module's init
> function returns -EEXIST, userspace tools like kmod interpret this as
> "module already loaded" and treat the operation as successful, returning
> 0 to the user even though the module initialization actually failed.
>
> This follows the precedent set by commit 54416fd76770 ("netfilter:
> conntrack: helper: Replace -EEXIST by -EBUSY") which fixed the same
> issue in nf_conntrack_helper_register().
> 
> Affected modules:
>   * ebtable_broute ebtable_filter ebtable_nat arptable_filter
>   * ip6table_filter ip6table_mangle ip6table_nat ip6table_raw
>   * ip6table_security iptable_filter iptable_mangle iptable_nat
>   * iptable_raw iptable_security

But this is very different from what 54416fd76770 fixes.

Before 54416fd76770. userspace can make a configuration entry that
prevents and unrelated module from getting loaded but at the same time
it doesn't provide any error to userspace.

All these -EEXIST should not be possible unless the module is
already loaded.

> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index 5697e3949a36..a04fc1757528 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -1299,7 +1299,7 @@ int ebt_register_template(const struct ebt_table *t, int (*table_init)(struct ne
>  	list_for_each_entry(tmpl, &template_tables, list) {
>  		if (WARN_ON_ONCE(strcmp(t->name, tmpl->name) == 0)) {
>  			mutex_unlock(&ebt_mutex);
> -			return -EEXIST;
> +			return -EBUSY;

As you can see from the WARN_ON, this cannot happen unless someone adds a new ebt kernel
table module that tries to register the same name.

> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> index 74cef8bf554c..62cf6a30875e 100644
> --- a/net/netfilter/nf_log.c
> +++ b/net/netfilter/nf_log.c
> @@ -89,7 +89,7 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
>  	if (pf == NFPROTO_UNSPEC) {
>  		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
>  			if (rcu_access_pointer(loggers[i][logger->type])) {
> -				ret = -EEXIST;
> +				ret = -EBUSY;
>  				goto unlock;

I don't see how this can happen, unless someone adds a new kernel module
that claims the same type as an existing kernel module.

> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 90b7630421c4..48105ea3df15 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1764,7 +1764,7 @@ EXPORT_SYMBOL_GPL(xt_hook_ops_alloc);
>  int xt_register_template(const struct xt_table *table,
>  			 int (*table_init)(struct net *net))
>  {
> -	int ret = -EEXIST, af = table->af;
> +	int ret = -EBUSY, af = table->af;
>  	struct xt_template *t;

Same, this requires someone adding a new kernel module with clashing
name.

I'll apply this patch but its not related to 54416fd76770 afaics.
