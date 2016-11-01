From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf] netfilter: conntrack: refine gc worker heuristics
Date: Tue, 01 Nov 2016 13:56:51 -0700
Message-ID: <1478033811.7065.357.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1478030500-28981-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, nicolas.dichtel@6wind.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33576 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbcKAU4y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 16:56:54 -0400
Received: by mail-pf0-f196.google.com with SMTP id a136so9165644pfa.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Nov 2016 13:56:54 -0700 (PDT)
In-Reply-To: <1478030500-28981-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2016-11-01 at 21:01 +0100, Florian Westphal wrote:
>  	schedule_delayed_work(&gc_work->dwork, next_run);


> @@ -993,6 +1029,7 @@ static void gc_worker(struct work_struct *work)
>  static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
>  {
>  	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
> +	gc_work->next_gc_run = GC_INTERVAL_MAX;
>  	gc_work->exiting = false;
>  }
>  
> @@ -1885,7 +1922,7 @@ int nf_conntrack_init_start(void)
>  	nf_ct_untracked_status_or(IPS_CONFIRMED | IPS_UNTRACKED);
>  
>  	conntrack_gc_work_init(&conntrack_gc_work);
> -	schedule_delayed_work(&conntrack_gc_work.dwork, GC_INTERVAL);
> +	schedule_delayed_work(&conntrack_gc_work.dwork, GC_INTERVAL_MAX);
>  
>  	return 0;
>  


We might use system_long_wq instead of system_wq ?

queue_delayed_work(system_long_wq, ...)



