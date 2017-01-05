From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_tables: Check chain's use
 count before alloc new handle in nf_tables_newrule
Date: Thu, 5 Jan 2017 13:33:26 +0100
Message-ID: <20170105123326.GA6570@salvia>
References: <1482982768-24791-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031950AbdAEMeH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 07:34:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 81EDD6EAE4
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:33:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72873DA3B3
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:33:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC9DEA7DAE
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:33:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1482982768-24791-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 29, 2016 at 11:39:28AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Although current nf_tables_alloc_handle doesn't allocate any actual
> resource, but it should check invalid condition before allocation in
> logic.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_tables_api.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a019a87..ecc516c 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2175,10 +2175,10 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
>  	} else {
>  		if (!create || nlh->nlmsg_flags & NLM_F_REPLACE)
>  			return -EINVAL;
> -		handle = nf_tables_alloc_handle(table);
> -
>  		if (chain->use == UINT_MAX)
>  			return -EOVERFLOW;
> +
> +		handle = nf_tables_alloc_handle(table);

NFTA_RULE_POSITION below may also fail, so the handle becomes unused
there too. I think it's not worth trying given that this may only
happen if we hit a crazy number of rules.
