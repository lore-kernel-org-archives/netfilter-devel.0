From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nf_tables: Make sure the uniform
 style of condition blocks in nf_tables_newrule
Date: Thu, 5 Jan 2017 13:34:26 +0100
Message-ID: <20170105123426.GB6570@salvia>
References: <1482982798-24914-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53580 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031968AbdAEMep (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 07:34:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34C7F6EAE0
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:34:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 260ABA7DB4
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:34:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA82147A
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:34:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1482982798-24914-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 29, 2016 at 11:39:58AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There is one different brace style of condtion blocks in
> nf_tables_newrule. Now just make it uniform.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_tables_api.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index ecc516c..7ac2b2e 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2261,12 +2261,12 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
>  			err = -ENOENT;
>  			goto err2;
>  		}
> -	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
> +	} else if (nlh->nlmsg_flags & NLM_F_APPEND) {
>  		if (old_rule)
>  			list_add_rcu(&rule->list, &old_rule->list);
>  		else
>  			list_add_tail_rcu(&rule->list, &chain->rules);
> -	else {
> +	} else {

Thanks for the cleanup. But I have patch revisiting this logic still
cooking, so I'll add these braces there so we can skip this cleanup patch.
