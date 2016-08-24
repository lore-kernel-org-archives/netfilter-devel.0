From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 nf-next 4/7] netfilter: conntrack: add gc worker to
 remove timed-out entries
Date: Wed, 24 Aug 2016 10:40:41 -0700
Message-ID: <1472060441.14381.106.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1472039755-14267-1-git-send-email-fw@strlen.de>
         <1472039755-14267-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35353 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754176AbcHXRks (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 13:40:48 -0400
Received: by mail-pa0-f65.google.com with SMTP id cf3so1535178pad.2
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 10:40:43 -0700 (PDT)
In-Reply-To: <1472039755-14267-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2016-08-24 at 13:55 +0200, Florian Westphal wrote:
> Conntrack gc worker to evict stale entries.


>  static struct nf_conn *
>  __nf_conntrack_alloc(struct net *net,
>  		     const struct nf_conntrack_zone *zone,
> @@ -1527,6 +1597,7 @@ static int untrack_refs(void)
>  
>  void nf_conntrack_cleanup_start(void)
>  {
> +	conntrack_gc_work.exiting = true;
>  	RCU_INIT_POINTER(ip_ct_attach, NULL);
>  }
>  
> @@ -1536,6 +1607,9 @@ void nf_conntrack_cleanup_end(void)
>  	while (untrack_refs() > 0)
>  		schedule();
>  
> +	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
> +	/* can be re-scheduled once */

Are you sure ?

As conntrack_gc_work.exiting = true, I do not see how this can happen ?

> +	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
>  	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_htable_size);
>  
>  	nf_conntrack_proto_fini();
> @@ -1810,6 +1884,10 @@ int nf_conntrack_init_start(void)
>  	}
>  	/*  - and look it like as a confirmed connection */
>  	nf_ct_untracked_status_or(IPS_CONFIRMED | IPS_UNTRACKED);
> +
> +	conntrack_gc_work_init(&conntrack_gc_work);
> +	schedule_delayed_work(&conntrack_gc_work.dwork, GC_INTERVAL);
> +
>  	return 0;
>  
>  err_proto:


