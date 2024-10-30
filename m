Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F631E3DF7;
	Wed, 30 Oct 2024 11:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730289209; cv=none; b=CPl2dRwJlwp59sJEoJeYOaSOwBxLkiXpuSbvA6sA18e7tyiehUrhk5AcD+EfxDXB9FeTwiWavrZC807gn1bDn5n+OjSqefSwDP2aWt3eayCStOnZEDFkwYW0gY/nXAiYGTxTCe4k0g++Qx17heO3rKs7TObo6xMNUDOi1bWS8Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730289209; c=relaxed/simple;
	bh=EyfUkNK1Hymwcs4wedWp2TTgq/yABRnCSExQ3A12iAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HPaqzuFTAH0f3Ns/Tk7QNegdAGw/4Xuu4Dh3HW4S0JsS76Usq9MhCSwVb6D+RUaNulNuk3WykoHamCfEgjBKR+b8pM+u+7IpW0yyCb8slpOtgc/J6PequWHK8cdTtqXIaMgPh6tXI9uDmM9RWBNRE5B9wHRqWz/4rOo+FbMwilE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34058 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t67GI-00B8aE-67; Wed, 30 Oct 2024 12:53:21 +0100
Date: Wed, 30 Oct 2024 12:53:17 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Dong Chenchen <dongchenchen2@huawei.com>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, fw@strlen.de, kuniyu@amazon.com,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	yuehaibing@huawei.com
Subject: Re: [PATCH net v2] net: netfilter: Fix use-after-free in get_info()
Message-ID: <ZyIeLSCsFotNBLa1@calendula>
References: <20241024014701.2086286-1-dongchenchen2@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241024014701.2086286-1-dongchenchen2@huawei.com>
X-Spam-Score: -1.8 (-)

On Thu, Oct 24, 2024 at 09:47:01AM +0800, Dong Chenchen wrote:
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
> 	kfree(t)
> 	//removed from templ_list
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
> xt_templates list, we couldnt get refcnt of xt_table->me. Check
> module in xt_net->tables list re-traversal to fix it.

Applied, thanks
