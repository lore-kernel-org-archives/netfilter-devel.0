From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 2/6] netfilter: conntrack: get rid of conntrack
 timer
Date: Fri, 19 Aug 2016 07:37:45 -0700
Message-ID: <1471617465.29842.102.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1471606575-2197-1-git-send-email-fw@strlen.de>
         <1471606575-2197-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36378 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753952AbcHSOj2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 10:39:28 -0400
Received: by mail-pa0-f65.google.com with SMTP id ez1so3534248pab.3
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Aug 2016 07:37:47 -0700 (PDT)
In-Reply-To: <1471606575-2197-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2016-08-19 at 13:36 +0200, Florian Westphal wrote:
> With stats enabled this eats 80 bytes on x86_64 per nf_conn entry.
> 
> Remove it and use a 32bit jiffies value containing timestamp until
> entry is valid.

Great work !

...

> +/* caller must hold rcu readlock and none of the nf_conntrack_locks */
> +static void nf_ct_gc_expired(struct nf_conn *ct)
> +{
> +	if (!atomic_inc_not_zero(&ct->ct_general.use))
> +		return;
> +
> +	if (nf_ct_should_gc(ct))
> +		nf_ct_kill(ct);
> +
> +	nf_ct_put(ct);
> +}
> +
>  /*
>   * Warning :
>   * - Caller must take a reference on returned object
> @@ -499,6 +505,17 @@ begin:
>  	bucket = reciprocal_scale(hash, hsize);
>  
>  	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[bucket], hnnode) {
> +		struct nf_conn *ct;
> +
> +		ct = nf_ct_tuplehash_to_ctrack(h);
> +		if (nf_ct_is_expired(ct)) {
> +			nf_ct_gc_expired(ct);
> +			continue;
> +		}
> +
> +		if (nf_ct_is_dying(ct))
> +			continue;
> +
>  		if (nf_ct_key_equal(h, tuple, zone, net)) {
>  			NF_CT_STAT_INC_ATOMIC(net, found);
>  			return h;

Florian, I do not see how this part is safe against concurrent lookups
and deletes ?

At least the hlist_nulls_for_each_entry_rcu() looks buggy, since
fetching the next pointer would trigger a use after free ?

Thanks !



