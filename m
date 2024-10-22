Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7EA139580;
	Tue, 22 Oct 2024 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729611212; cv=none; b=uFM6ixBhN91++tkjfEtCtL/E+sDb74naWN8p7TxgkWfcUb5sPevQl98uqVxgNwdLQKQhFnKfYxUv/Q8U6gt5w9JsKn4I1zQb6Nx6J459fO6OBoNTpmTGh5Gv3VwHNc6uy3VrWUoSa7g+iyHAybLDneTtvP4ja5zTtWJKqXtqtgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729611212; c=relaxed/simple;
	bh=JAcUXImlGaxQw1VcdDVM5id5Wu8GNV5AfGianwvJiz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxPhCbNy5RH/MZG3Rgf5m2KuGy3BH0kSLNZmQBXBYSmy2mTU/E3lgvs+MPXkZWHPbtTBC3Tq2L4jC6JeywK6XQQ7T/GI4ETC/JUbSy/RXBI1UFAIVW9e2KL3SpkHsYIQGKl3kMIzYrpOtFb46cM8S+RLxLLcl0WqYuE/vDIeiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMddI/nX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMddI/nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E5EC4CEC3;
	Tue, 22 Oct 2024 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729611212;
	bh=JAcUXImlGaxQw1VcdDVM5id5Wu8GNV5AfGianwvJiz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oMddI/nXQBS+kSD25XSrV9C9kQe2pfPAiUJ9y9JGejSkUpO1fE+YpNsQ7eyhad8vg
	 TRhYCOR45ldF4pR5p380ozJNXGnfr+Eki6FAESbCmZU4rByH3446XyPzP3lIKa6ZYx
	 PMXGbCLWfnE9qP1Lb/TQ/1UNDtk8Oqh5Xbe+aOX/SOsZYg6dffnLqZUpL2ysF+flF0
	 ibvOTeU7Ibdio/xlT3qDiXeqquEJp6UubLp/7sCkgcnLngZ7abd89k0w50qRKCK1WE
	 HGvrnSTMhdMM6DAQzjjszYCNnITocIE20Y2iZejumjoAhC2TBiGmj54EYuL3XonyXD
	 2nJqMh3Nm1CAg==
Date: Tue, 22 Oct 2024 16:33:27 +0100
From: Simon Horman <horms@kernel.org>
To: Dong Chenchen <dongchenchen2@huawei.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de, kuniyu@amazon.com, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, yuehaibing@huawei.com
Subject: Re: [PATCH net] net: netfilter: Fix use-after-free in get_info()
Message-ID: <20241022153327.GW402847@kernel.org>
References: <20241022085753.2069639-1-dongchenchen2@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022085753.2069639-1-dongchenchen2@huawei.com>

On Tue, Oct 22, 2024 at 04:57:53PM +0800, Dong Chenchen wrote:
> ip6table_nat module unload has refcnt warning for UAF. call trace is:
> 
> WARNING: CPU: 1 PID: 379 at kernel/module/main.c:853 module_put+0x6f/0x80
> Modules linked in: ip6table_nat(-)
> CPU: 1 UID: 0 PID: 379 Comm: ip6tables Not tainted 6.12.0-rc4-00047-gc2ee9f594da8-dirty #205
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> RIP: 0010:module_put+0x6f/0x80
> Call Trace:
>  <TASK>
>  get_info+0x128/0x180
>  do_ip6t_get_ctl+0x6a/0x430
>  nf_getsockopt+0x46/0x80
>  ipv6_getsockopt+0xb9/0x100
>  rawv6_getsockopt+0x42/0x190
>  do_sock_getsockopt+0xaa/0x180
>  __sys_getsockopt+0x70/0xc0
>  __x64_sys_getsockopt+0x20/0x30
>  do_syscall_64+0xa2/0x1a0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Concurrent execution of module unload and get_info() trigered the warning.
> The root cause is as follows:
> 
> cpu0				      cpu1
> module_exit
> //mod->state = MODULE_STATE_GOING
>   ip6table_nat_exit
>     xt_unregister_template
>     //remove table from templ list
> 				      getinfo()
> 					  t = xt_find_table_lock
> 						list_for_each_entry(tmpl, &xt_templates[af]...)
> 							if (strcmp(tmpl->name, name))
> 								continue;  //table not found
> 							try_module_get
> 						list_for_each_entry(t, &xt_net->tables[af]...)
> 							return t;  //not get refcnt
> 					  module_put(t->me) //uaf
>     unregister_pernet_subsys
>     //remove table from xt_net list
> 
> While xt_table module was going away and has been removed from
> xt_templates list, we couldnt get refcnt of xt_table->me. Skip
> the re-traversal of xt_net->tables list to fix it.
> 
> Fixes: c22921df777d ("netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().")
> Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
> ---
>  net/netfilter/x_tables.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index da5d929c7c85..359c880ecb07 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1239,6 +1239,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  	struct module *owner = NULL;
>  	struct xt_template *tmpl;
>  	struct xt_table *t;
> +	int err = -ENOENT;
>  
>  	mutex_lock(&xt[af].mutex);
>  	list_for_each_entry(t, &xt_net->tables[af], list)
> @@ -1247,8 +1248,6 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  
>  	/* Table doesn't exist in this netns, check larval list */
>  	list_for_each_entry(tmpl, &xt_templates[af], list) {
> -		int err;
> -
>  		if (strcmp(tmpl->name, name))
>  			continue;
>  		if (!try_module_get(tmpl->me))
> @@ -1267,6 +1266,9 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  		break;
>  	}
>  
> +	if (err < 0)
> +		goto out;
> +
>  	/* and once again: */
>  	list_for_each_entry(t, &xt_net->tables[af], list)
>  		if (strcmp(t->name, name) == 0)
> @@ -1275,7 +1277,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  	module_put(owner);

Hi Dong Chenchen,

I'm unsure if this can happen in practice, although I guess so else the
module_put() call above is never reached. In any case, previously if we got
to this line then the function would return ERR_PTR(-ENOENT).  But now it
will return ERR_PTR(0). Which although valid often indicates a bug.

Flagged by Smatch.

>   out:
>  	mutex_unlock(&xt[af].mutex);
> -	return ERR_PTR(-ENOENT);
> +	return ERR_PTR(err);
>  }
>  EXPORT_SYMBOL_GPL(xt_find_table_lock);
>  
> -- 
> 2.25.1
> 
> 
