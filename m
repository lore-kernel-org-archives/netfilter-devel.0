Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF30C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 10:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67B1D24125
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 10:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAWK3X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 05:29:23 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43814 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbgAWK3X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 05:29:23 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iuZjl-0006LN-3G; Thu, 23 Jan 2020 11:29:21 +0100
Date:   Thu, 23 Jan 2020 11:29:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sean Tranchetti <stranche@codeaurora.org>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        lucien.xin@gmail.com
Subject: Re: [PATCH nf] Revert "netfilter: unlock xt_table earlier in
 __do_replace"
Message-ID: <20200123102921.GU795@breakpoint.cc>
References: <1579740455-17249-1-git-send-email-stranche@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579740455-17249-1-git-send-email-stranche@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sean Tranchetti <stranche@codeaurora.org> wrote:

[ CC Xin Long ]

> A recently reported crash in the x_tables framework seems to stem from
> a potential race condition between adding rules to a table and having a
> packet traversing the table at the same time.
> 
> In the crash, the jumpstack being used by the table traversal was freed
> by the table replace code. After performing some bisection, it seems that
> commit f31e5f1a891f ("netfilter: unlock xt_table earlier in __do_replace")
> exposed this race condition by unlocking the table before the
> get_old_counters() routine was called to perform the synchronization.

But the packet path doesn't grab the table mutex.

> Call Stack:
> 	Unable to handle kernel paging request at virtual address
> 	006b6b6b6b6b6bc5
> 
> 	pc : ipt_do_table+0x3b8/0x660
> 	lr : ipt_do_table+0x31c/0x660
> 	Call trace:
> 	ipt_do_table+0x3b8/0x660
> 	iptable_mangle_hook+0x58/0xf8
> 	nf_hook_slow+0x48/0xd8
> 	__ip_local_out+0xf4/0x138
> 	__ip_queue_xmit+0x348/0x3a0
> 	ip_queue_xmit+0x10/0x18
> 
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> ---
> @@ -921,8 +921,6 @@ static int __do_replace(struct net *net, const char *name,
>  	    (newinfo->number <= oldinfo->initial_entries))
>  		module_put(t->me);
>  
> -	xt_table_unlock(t);
> -
>  	get_old_counters(oldinfo, counters);
>  
>  	/* Decrease module usage counts and free resource */
> @@ -937,6 +935,7 @@ static int __do_replace(struct net *net, const char *name,
>  		net_warn_ratelimited("arptables: counters copy to user failed while replacing table\n");
>  	}
>  	vfree(counters);
> +	xt_table_unlock(t);

I don't see how this changes anything wrt. packet path.
This disallows another instance of iptables(-restore) to come in
before the counters have been copied/freed and the destructors have run.

But as those have nothing to do with the jumpstack I don't see how this
helps.
