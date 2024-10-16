Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E079208D7A;
	Wed, 16 Oct 2024 14:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729089132; cv=none; b=jCZNl9Qr7s7V9vX2AJMt+6EEB4rFfph8tiFnpWogz0rHjHOJN109EdzvRGOzLMoWl1854vWt9d2ujcurw2ypbsdFPn8EPy25tkSpuY0/kFvKonLK1r+WYViqy75yBwgYBoTfw0B/8jxHkn4MRYvoImNeSFeT35WwHVLVGh/a/Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729089132; c=relaxed/simple;
	bh=MUBjfKfvAsRsCJe+7h2NNv4bqINVdYqmH7t/ggr/tQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kCsvBbJm1TuaDu9k5nMwnq/IAIH/a60q7V9JddOsnTmyw8gfui8PslG1wf2bPDOqWPq1Hl3FJ3HyjGL6VRLcIh+gyZaVwhd93KANFKH8l7kVSu2wmJ9IxH8Kb6SZ5PfOxXCtsata8/pm/dVCoMGkhXJvKDgMOZCZX6YeAlfZmaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44964 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t154B-00CEWL-NE; Wed, 16 Oct 2024 16:32:01 +0200
Date: Wed, 16 Oct 2024 16:31:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Rongguang Wei <clementwei90@163.com>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	Rongguang Wei <weirongguang@kylinos.cn>
Subject: Re: [PATCH v1] netfilter: x_tables: fix ordering of get and update
 table private
Message-ID: <Zw_OXzBgfFULaEzs@calendula>
References: <20241016030909.64932-1-clementwei90@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241016030909.64932-1-clementwei90@163.com>
X-Spam-Score: -1.9 (-)

On Wed, Oct 16, 2024 at 11:09:09AM +0800, Rongguang Wei wrote:
> From: Rongguang Wei <weirongguang@kylinos.cn>
> 
> Meet a kernel panic in ipt_do_table:
> PANIC: "Unable to handle kernel paging request at virtual address 00706f746b736564"

This patch is no correct.

> and the stack is:
>      PC: ffff5e1dbecf0750  [ipt_do_table+1432]
>      LR: ffff5e1dbecf04e4  [ipt_do_table+812]
>      SP: ffff8021f7643370  PSTATE: 20400009
>     X29: ffff8021f7643390  X28: ffff802900c3990c  X27: ffffa0405245a000
>     X26: ffff80400ad645a8  X25: ffffa0201c4d8000  X24: ffff5e1dbed00228
>     X23: ffff80400ad64738  X22: 0000000000000000  X21: ffff80400ad64000
>     X20: ffff802114980ae8  X19: ffff8021f7643570  X18: 00000007ea9ec175
>     X17: 0000fffde7b52460  X16: ffff5e1e181e8f20  X15: 0000fffd9a0ae078
>     X14: 610d273b56961dbc  X13: 0a08010100007ecb  X12: f5011880fd874f59
>     X11: ffff5e1dbed10600  X10: ffffa0405245a000   X9: 569b063f004015d5
>      X8: ffff80400ad64738   X7: 0000000000010002   X6: 0000000000000000
>      X5: 0000000000000000   X4: 0000000000000000   X3: 0000000000000000
>      X2: 0000000000000000   X1: 2e706f746b736564   X0: ffff80400ad65850
> [ffff8021f7643390] ipt_do_table at ffff5e1dbecf074c [ip_tables]
> [ffff8021f76434d0] iptable_filter_hook at ffff5e1dbfe700a4 [iptable_filter]
> [ffff8021f76434f0] nf_hook_slow at ffff5e1e18c31c2c
> [ffff8021f7643530] ip_forward at ffff5e1e18c41924
> [ffff8021f76435a0] ip_rcv_finish at ffff5e1e18c3fddc
> [ffff8021f76435d0] ip_rcv at ffff5e1e18c40214
> [ffff8021f7643630] __netif_receive_skb_one_core at ffff5e1e18bbbed4
> [ffff8021f7643670] __netif_receive_skb at ffff5e1e18bbbf3c
> [ffff8021f7643690] process_backlog at ffff5e1e18bbd52c
> [ffff8021f76436f0] __napi_poll at ffff5e1e18bbc464
> [ffff8021f7643730] net_rx_action at ffff5e1e18bbc9a8
> 
> The panic happend in ipt_do_table function:
> 
> 	private = READ_ONCE(table->private);
> 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
> 	[...]
> 	jumpstack[stackid++] = e;	// panic here
> 
> In vmcore, the cpu is 4, I read the private->jumpstack[cpu] is 007365325f6b6365,
> this address between user and kernel address ranges which caused kernel panic.
> Also the kmem shows that the private->jumpstack address is free.
> It looks like we get a UAF address here.
> 
> But in xt_replace_table function:
> 
> 	private = table->private;
> 	[...]
> 	smp_wmb();
> 	table->private = newtable_info;
> 	smp_mb();
> 
> It seems no chance to get a free private member in ipt_do_table.
> May have a ordering error which looks impossible:
> 
> 	smp_wmb();
> 	table->private = newtable_info;
> 	private = table->private;
> 	smp_mb();

Makes no sense to me.

> we get table->private after we set new table->private. After that, the
> private was free in xt_free_table_info and also used in ipt_do_table.
> Here use READ_ONCE to ensure we get private before we set the new one.

You better enable CONFIG_KASAN there and similar instrumentation to
check what really is going on there.

> Signed-off-by: Rongguang Wei <weirongguang@kylinos.cn>
> ---
>  net/netfilter/x_tables.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index da5d929c7c85..1ce7a4f268d6 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1399,7 +1399,7 @@ xt_replace_table(struct xt_table *table,
>  
>  	/* Do the substitution. */
>  	local_bh_disable();
> -	private = table->private;
> +	private = READ_ONCE(table->private);
>  
>  	/* Check inside lock: is the old number correct? */
>  	if (num_counters != private->number) {
> -- 
> 2.25.1
> 
> 
