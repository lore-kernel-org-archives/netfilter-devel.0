Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BC7C43331
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D0064EC0
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhCDAEb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:04:31 -0500
Received: from correo.us.es ([193.147.175.20]:50670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233096AbhCCQNx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 11:13:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 39E011C4422
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 17:11:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 286A1DA78A
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 17:11:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1D096DA72F; Wed,  3 Mar 2021 17:11:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A093EDA72F;
        Wed,  3 Mar 2021 17:11:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Mar 2021 17:11:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8244242DF561;
        Wed,  3 Mar 2021 17:11:47 +0100 (CET)
Date:   Wed, 3 Mar 2021 17:11:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] netfilter: flowtable: separate replace, destroy
 and stats to different workqueues
Message-ID: <20210303161147.GA17082@salvia>
References: <20210303125953.11911-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210303125953.11911-1-ozsh@nvidia.com>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Mar 03, 2021 at 02:59:53PM +0200, Oz Shlomo wrote:
> Currently the flow table offload replace, destroy and stats work items are
> executed on a single workqueue. As such, DESTROY and STATS commands may
> be backloged after a burst of REPLACE work items. This scenario can bloat
> up memory and may cause active connections to age.
> 
> Instatiate add, del and stats workqueues to avoid backlogs of non-dependent
> actions. Provide sysfs control over the workqueue attributes, allowing
> userspace applications to control the workqueue cpumask.

Probably it would be good to place REPLACE and DESTROY in one single
queue so workqueues don't race? In case connections are quickly
created and destroyed, we might get an out of order execution, instead
of:

  REPLACE -> DESTROY -> REPLACE

events could be reordered to:

  REPLACE -> REPLACE -> DESTROY

So would it work for you if REPLACE and DESTROY go into one single
workqueue and stats go into another?

Or probably make the cookie unique is sufficient? The cookie refers to
the memory address but memory can be recycled very quickly. If the
cookie helps to catch the reorder scenario, then the conntrack id
could be used instead of the memory address as cookie.

Regarding exposing sysfs toogles, what kind of tuning are you
expecting from users?  I'd prefer that the workqueue subsystem selects
for me what is best (autotuning). I'm not a fan of exposing toggles to
userspace that I don't know what users would do with it.

Let me know, thanks.

> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---
>  net/netfilter/nf_flow_table_offload.c | 44 ++++++++++++++++++++++++++++-------
>  1 file changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 2a6993fa40d7..1b979c8b3ba0 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -13,7 +13,9 @@
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack_tuple.h>
>  
> -static struct workqueue_struct *nf_flow_offload_wq;
> +static struct workqueue_struct *nf_flow_offload_add_wq;
> +static struct workqueue_struct *nf_flow_offload_del_wq;
> +static struct workqueue_struct *nf_flow_offload_stats_wq;
>  
>  struct flow_offload_work {
>  	struct list_head	list;
> @@ -826,7 +828,12 @@ static void flow_offload_work_handler(struct work_struct *work)
>  
>  static void flow_offload_queue_work(struct flow_offload_work *offload)
>  {
> -	queue_work(nf_flow_offload_wq, &offload->work);
> +	if (offload->cmd == FLOW_CLS_REPLACE)
> +		queue_work(nf_flow_offload_add_wq, &offload->work);
> +	else if (offload->cmd == FLOW_CLS_DESTROY)
> +		queue_work(nf_flow_offload_del_wq, &offload->work);
> +	else
> +		queue_work(nf_flow_offload_stats_wq, &offload->work);
>  }
>  
>  static struct flow_offload_work *
> @@ -898,8 +905,11 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
>  
>  void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
>  {
> -	if (nf_flowtable_hw_offload(flowtable))
> -		flush_workqueue(nf_flow_offload_wq);
> +	if (nf_flowtable_hw_offload(flowtable)) {
> +		flush_workqueue(nf_flow_offload_add_wq);
> +		flush_workqueue(nf_flow_offload_del_wq);
> +		flush_workqueue(nf_flow_offload_stats_wq);
> +	}
>  }
>  
>  static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
> @@ -1011,15 +1021,33 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
>  
>  int nf_flow_table_offload_init(void)
>  {
> -	nf_flow_offload_wq  = alloc_workqueue("nf_flow_table_offload",
> -					      WQ_UNBOUND, 0);
> -	if (!nf_flow_offload_wq)
> +	nf_flow_offload_add_wq  = alloc_workqueue("nf_ft_offload_add",
> +						  WQ_UNBOUND | WQ_SYSFS, 0);
> +	if (!nf_flow_offload_add_wq)
>  		return -ENOMEM;
>  
> +	nf_flow_offload_del_wq  = alloc_workqueue("nf_ft_offload_del",
> +						  WQ_UNBOUND | WQ_SYSFS, 0);
> +	if (!nf_flow_offload_del_wq)
> +		goto err_del_wq;
> +
> +	nf_flow_offload_stats_wq  = alloc_workqueue("nf_ft_offload_stats",
> +						    WQ_UNBOUND | WQ_SYSFS, 0);
> +	if (!nf_flow_offload_stats_wq)
> +		goto err_stats_wq;
> +
>  	return 0;
> +
> +err_stats_wq:
> +	destroy_workqueue(nf_flow_offload_del_wq);
> +err_del_wq:
> +	destroy_workqueue(nf_flow_offload_add_wq);
> +	return -ENOMEM;
>  }
>  
>  void nf_flow_table_offload_exit(void)
>  {
> -	destroy_workqueue(nf_flow_offload_wq);
> +	destroy_workqueue(nf_flow_offload_add_wq);
> +	destroy_workqueue(nf_flow_offload_del_wq);
> +	destroy_workqueue(nf_flow_offload_stats_wq);
>  }
> -- 
> 1.8.3.1
> 
