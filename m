Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C939C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Mar 2022 21:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbiCGVKl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 16:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbiCGVKk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 16:10:40 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3368B69CF8
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2022 13:09:45 -0800 (PST)
Received: from netfilter.org (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7258E63002;
        Mon,  7 Mar 2022 22:07:54 +0100 (CET)
Date:   Mon, 7 Mar 2022 22:09:41 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 1/8] net/sched: act_ct: set 'net' pointer when
 creating new nf_flow_table
Message-ID: <YiZ0lRpxdD8lkO5F@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-2-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222151003.2136934-2-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 05:09:56PM +0200, Vlad Buslov wrote:
> Following patches in series use the pointer to access flow table offload
> debug variables.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  net/sched/act_ct.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 7108e71ce4db..a2624f6c4d92 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -277,7 +277,7 @@ static struct nf_flowtable_type flowtable_ct = {
>  	.owner		= THIS_MODULE,
>  };
>  
> -static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
> +static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
>  {
>  	struct tcf_ct_flow_table *ct_ft;
>  	int err = -ENOMEM;
> @@ -303,6 +303,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>  	err = nf_flow_table_init(&ct_ft->nf_ft);
>  	if (err)
>  		goto err_init;
> +	write_pnet(&ct_ft->nf_ft.net, net);
>  
>  	__module_get(THIS_MODULE);
>  out_unlock:
> @@ -1321,7 +1322,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
>  	if (err)
>  		goto cleanup;
>  
> -	err = tcf_ct_flow_table_get(params);
> +	err = tcf_ct_flow_table_get(net, params);
>  	if (err)
>  		goto cleanup;
>  
> -- 
> 2.31.1
> 
