Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAAFC64ED6
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjB0Hf7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Feb 2023 02:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB0Hf7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2023 02:35:59 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9E0F1ABC7
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 23:35:57 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id B5B5A60CBF;
        Mon, 27 Feb 2023 09:35:55 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 111D260CBA;
        Mon, 27 Feb 2023 09:35:54 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 914F43C0325;
        Mon, 27 Feb 2023 09:35:53 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 31R7ZpuT006312;
        Mon, 27 Feb 2023 09:35:52 +0200
Date:   Mon, 27 Feb 2023 09:35:51 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>
cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        abdelrahmanhesham94@gmail.com
Subject: Re: [PATCH v3] netfilter: nf_flow_table: count offloaded flows
In-Reply-To: <20230226183412.6pvt7town4jsuem7@Svens-MacBookPro.local>
Message-ID: <88eb7163-9eb-507a-9ed0-d090294132f8@ssi.bg>
References: <20230226183412.6pvt7town4jsuem7@Svens-MacBookPro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Sun, 26 Feb 2023, Sven Auhagen wrote:

> Add a counter per namespace so we know the total offloaded
> flows.
> 
> Change from v2:
> 	* Add remove proc entry on nf_flow_table_fini_proc
> 	* Syntax fixes
> 
> Change from v1:
> 	* Cleanup proc entries in case of an error
> 
> Signed-off-by: Abdelrahman Morsy <abdelrahman.morsy@voleatech.de>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

	Thanks! I have no other complains for the init/exit parts

Reviewed-by: Julian Anastasov <ja@ssi.bg>

> diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_table.h
> index 1c5fc657e267..235847a9b480 100644
> --- a/include/net/netns/flow_table.h
> +++ b/include/net/netns/flow_table.h
> @@ -10,5 +10,6 @@ struct nf_flow_table_stat {
>  
>  struct netns_ft {
>  	struct nf_flow_table_stat __percpu *stat;
> +	atomic64_t count_flowoffload;
>  };
>  #endif
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 81c26a96c30b..267f5bd192a2 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -282,6 +282,7 @@ unsigned long flow_offload_get_timeout(struct flow_offload *flow)
>  
>  int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>  {
> +	struct net *net;
>  	int err;
>  
>  	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
> @@ -304,6 +305,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>  
>  	nf_ct_offload_timeout(flow->ct);
>  
> +	net = read_pnet(&flow_table->net);
> +	atomic64_inc(&net->ft.count_flowoffload);
> +
>  	if (nf_flowtable_hw_offload(flow_table)) {
>  		__set_bit(NF_FLOW_HW, &flow->flags);
>  		nf_flow_offload_add(flow_table, flow);
> @@ -339,6 +343,8 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
>  static void flow_offload_del(struct nf_flowtable *flow_table,
>  			     struct flow_offload *flow)
>  {
> +	struct net *net = read_pnet(&flow_table->net);
> +
>  	rhashtable_remove_fast(&flow_table->rhashtable,
>  			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
>  			       nf_flow_offload_rhash_params);
> @@ -346,6 +352,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>  			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
>  			       nf_flow_offload_rhash_params);
>  	flow_offload_free(flow);
> +
> +	atomic64_dec(&net->ft.count_flowoffload);
>  }
>  
>  void flow_offload_teardown(struct flow_offload *flow)
> @@ -616,6 +624,7 @@ EXPORT_SYMBOL_GPL(nf_flow_table_free);
>  
>  static int nf_flow_table_init_net(struct net *net)
>  {
> +	atomic64_set(&net->ft.count_flowoffload, 0);
>  	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
>  	return net->ft.stat ? 0 : -ENOMEM;
>  }
> diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
> index 159b033a43e6..124ddf9ec6c7 100644
> --- a/net/netfilter/nf_flow_table_procfs.c
> +++ b/net/netfilter/nf_flow_table_procfs.c
> @@ -64,17 +64,36 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
>  	.show	= nf_flow_table_cpu_seq_show,
>  };
>  
> +static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
> +{
> +	struct net *net = seq_file_net(seq);
> +
> +	seq_printf(seq, "%lld\n",
> +		   atomic64_read(&net->ft.count_flowoffload)
> +		);
> +	return 0;
> +}
> +
>  int nf_flow_table_init_proc(struct net *net)
>  {
> -	struct proc_dir_entry *pde;
> +	if (!proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
> +			     &nf_flow_table_cpu_seq_ops, sizeof(struct seq_net_private)))
> +		goto err;
> +
> +	if (!proc_create_net_single("nf_flowtable_counter", 0444,
> +				    net->proc_net, nf_flow_table_counter_show, NULL))
> +		goto err_net;
>  
> -	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
> -			      &nf_flow_table_cpu_seq_ops,
> -			      sizeof(struct seq_net_private));
> -	return pde ? 0 : -ENOMEM;
> +	return 0;
> +
> +err_net:
> +	remove_proc_entry("nf_flowtable", net->proc_net_stat);
> +err:
> +	return -ENOMEM;
>  }
>  
>  void nf_flow_table_fini_proc(struct net *net)
>  {
>  	remove_proc_entry("nf_flowtable", net->proc_net_stat);
> +	remove_proc_entry("nf_flowtable_counter", net->proc_net);
>  }
> -- 
> 2.33.1

Regards

--
Julian Anastasov <ja@ssi.bg>

