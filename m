Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E411C3524D
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 12:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B3C92082E
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 12:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgBCMQP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 07:16:15 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57956 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727201AbgBCMQO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 07:16:14 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iyaeC-0003z5-L5; Mon, 03 Feb 2020 13:16:12 +0100
Date:   Mon, 3 Feb 2020 13:16:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [Patch nf v2 1/3] xt_hashlimit: avoid OOM for user-controlled
 vmalloc
Message-ID: <20200203121612.GR795@breakpoint.cc>
References: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
 <20200203043053.19192-2-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203043053.19192-2-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> The hashtable size could be controlled by user, so use flags
> GFP_USER | __GFP_NOWARN to avoid OOM warning triggered by user-space.
> 
> Also add __GFP_NORETRY to avoid retrying, as this is just a
> best effort and the failure is already handled gracefully.
> 
> Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/netfilter/xt_hashlimit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> index bccd47cd7190..5d9943b37c42 100644
> --- a/net/netfilter/xt_hashlimit.c
> +++ b/net/netfilter/xt_hashlimit.c
> @@ -293,8 +293,8 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
>  		if (size < 16)
>  			size = 16;
>  	}
> -	/* FIXME: don't use vmalloc() here or anywhere else -HW */
> -	hinfo = vmalloc(struct_size(hinfo, hash, size));
> +	hinfo = __vmalloc(struct_size(hinfo, hash, size),
> +			  GFP_USER | __GFP_NOWARN | __GFP_NORETRY, PAGE_KERNEL);

Sorry for not noticing this earlier: should that be GFP_KERNEL_ACCOUNT
instead of GFP_USER?

