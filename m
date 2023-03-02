Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD36C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 10:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCBKvX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 05:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjCBKvW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 05:51:22 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7106541B50
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2023 02:51:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXgWp-0000VM-DO; Thu, 02 Mar 2023 11:51:15 +0100
Date:   Thu, 2 Mar 2023 11:51:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Ivan Delalande <colona@arista.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctnetlink: revert to dumping mark regardless
 of event type
Message-ID: <20230302105115.GB23204@breakpoint.cc>
References: <20230302022218.GA195225@visor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302022218.GA195225@visor>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ivan Delalande <colona@arista.com> wrote:
> I assume that change was unintentional, we have userspace code that
> needs the mark while listening for events like REPLY, DESTROY, etc.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 1feeae071507 ("netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark")
> Signed-off-by: Ivan Delalande <colona@arista.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index c11dff91d52d..194822f8f1ee 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -831,7 +831,7 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
>  	}
>  
>  #ifdef CONFIG_NF_CONNTRACK_MARK
> -	if (events & (1 << IPCT_MARK) &&
> +	if ((events & (1 << IPCT_MARK) || READ_ONCE(ct->mark)) &&
>  	    ctnetlink_dump_mark(skb, ct) < 0)
>  		goto nla_put_failure;

Probably better to just drop the event bit test?

if (ctnetlink_dump_mark(skb, ct) < 0)
	goto nla_put_failure;
