From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: cttimeout: Refine
 cttimeout_del_timeout
Date: Fri, 14 Apr 2017 00:58:32 +0200
Message-ID: <20170413225832.GA5541@salvia>
References: <1491564336-44483-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53202 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752040AbdDMW6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 18:58:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5A02FBDF67
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:58:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94F09DA80B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:58:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB1ECDA807
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:58:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491564336-44483-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 07, 2017 at 07:25:36PM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> 1. Return one error when try to delete all timeouts and meet one erorr;
> 2. Delete the condition block when fail to delete specified timeout.
> It is more clear that it would stop the loop when find one matched timeout.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nfnetlink_cttimeout.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
> index baa75f3..220847a 100644
> --- a/net/netfilter/nfnetlink_cttimeout.c
> +++ b/net/netfilter/nfnetlink_cttimeout.c
> @@ -361,11 +361,17 @@ static int cttimeout_del_timeout(struct net *net, struct sock *ctnl,
>  	char *name;
>  
>  	if (!cda[CTA_TIMEOUT_NAME]) {
> +		int cur_ret;
> +
> +		ret = 0;
>  		list_for_each_entry_safe(cur, tmp, &net->nfct_timeout_list,
> -					 head)
> -			ctnl_timeout_try_del(net, cur);

This code ignores ctnl_timeout_try_del() on purpose, to implement the
flush operation.
