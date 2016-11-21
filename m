From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 3/3] netfilter: x_tables: pack percpu counter
 allocations
Date: Mon, 21 Nov 2016 07:53:16 -0800
Message-ID: <1479743596.8455.409.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1479736654-2359-1-git-send-email-fw@strlen.de>
         <1479736654-2359-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35873 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754238AbcKUPxS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2016 10:53:18 -0500
Received: by mail-pf0-f193.google.com with SMTP id c4so15979147pfb.3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2016 07:53:18 -0800 (PST)
In-Reply-To: <1479736654-2359-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2016-11-21 at 14:57 +0100, Florian Westphal wrote:

...

>  #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
> +#define XT_PCPU_BLOCK_SIZE 4096
>  
>  struct compat_delta {
>  	unsigned int offset; /* offset in kernel */
> @@ -1618,6 +1619,7 @@ EXPORT_SYMBOL_GPL(xt_proto_fini);
>  /**
>   * xt_percpu_counter_alloc - allocate x_tables rule counter
>   *
> + * @state: pointer to xt_percpu allocation state
>   * @counter: pointer to counter struct inside the ip(6)/arpt_entry struct
>   *
>   * On SMP, the packet counter [ ip(6)t_entry->counters.pcnt ] will then
> @@ -1626,20 +1628,33 @@ EXPORT_SYMBOL_GPL(xt_proto_fini);
>   * Rule evaluation needs to use xt_get_this_cpu_counter() helper
>   * to fetch the real percpu counter.
>   *
> + * To speed up allocation and improve data locality, an entire
> + * page is allocated.

    * To speed up allocation and improve data locality, a 4KB bloc
    * is allocated.

> + *
> + * xt_percpu_counter_alloc_state contains the base address of the
> + * allocated page and the current sub-offset.
> + *
>   * returns false on error.
>   */
> -bool xt_percpu_counter_alloc(struct xt_counters *counter)
> +bool xt_percpu_counter_alloc(struct xt_percpu_counter_alloc_state *state,
> +			     struct xt_counters *counter)
>  {
> -	void __percpu *res;
> +	BUILD_BUG_ON(XT_PCPU_BLOCK_SIZE < (sizeof(*counter) * 2));
>  
> -	if (nr_cpu_ids > 1) {
> -		res = __alloc_percpu(sizeof(struct xt_counters),
> -				     sizeof(struct xt_counters));
> +	if (nr_cpu_ids <= 1)
> +		return true;
>  
> -		if (!res)
> +	if (state->mem == NULL) {

	if (!state->mem) {

> +		state->mem = __alloc_percpu(XT_PCPU_BLOCK_SIZE, XT_PCPU_BLOCK_SIZE);
> +		if (!state->mem)
   (to be consistent with this test )

>  			return false;
>  	}
> -	counter->pcnt = (__force unsigned long)res;
> +	counter->pcnt = (__force unsigned long)(state->mem + state->off);
> +	state->off += sizeof(*counter);
> +	if (state->off > (XT_PCPU_BLOCK_SIZE - sizeof(*counter))) {
> +		state->mem = NULL;
> +		state->off = 0;
> +	}




