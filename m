Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984DAC64ED6
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 12:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjBZM2Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 07:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZM2Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 07:28:24 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D47D7DA6
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 04:28:23 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 60B0386CA2;
        Sun, 26 Feb 2023 14:28:21 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id E571B86C9D;
        Sun, 26 Feb 2023 14:28:19 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 911D23C0325;
        Sun, 26 Feb 2023 14:28:19 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 31QCSHdQ038465;
        Sun, 26 Feb 2023 14:28:19 +0200
Date:   Sun, 26 Feb 2023 14:28:17 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        abdelrahmanhesham94@gmail.com
Subject: Re: [PATCH] netfilter: nf_flow_table: count offloaded flows
In-Reply-To: <20230226094048.zpxmsb4ljrjlfdwo@Svens-MacBookPro.local>
Message-ID: <5ab636c-d52b-6aaa-6ebc-9a8f52a88844@ssi.bg>
References: <20230226064436.hr4obihsi5o4hiqk@Svens-MacBookPro.local> <afee3af4-c85d-4daf-1f91-2017eaeaae5@ssi.bg> <20230226094048.zpxmsb4ljrjlfdwo@Svens-MacBookPro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Sun, 26 Feb 2023, Sven Auhagen wrote:

> On Sun, Feb 26, 2023 at 10:53:58AM +0200, Julian Anastasov wrote:
> > 
> > > diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
> > > index 159b033a43e6..cff9ad58c7c9 100644
> > > --- a/net/netfilter/nf_flow_table_procfs.c
> > > +++ b/net/netfilter/nf_flow_table_procfs.c
> > > @@ -64,6 +64,16 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
> > >  	.show	= nf_flow_table_cpu_seq_show,
> > >  };
> > >  
> > > +static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
> > > +{
> > > +	struct net *net = seq_file_net(seq);
> > > +
> > > +	seq_printf(seq, "%lld\n",
> > > +		   atomic64_read(&net->ft.count_flowoffload)
> > > +		);
> > > +	return 0;
> > > +}
> > > +
> > >  int nf_flow_table_init_proc(struct net *net)
> > >  {
> > >  	struct proc_dir_entry *pde;
> > > @@ -71,6 +81,9 @@ int nf_flow_table_init_proc(struct net *net)
> > >  	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
> > >  			      &nf_flow_table_cpu_seq_ops,
> > >  			      sizeof(struct seq_net_private));
> > 
> > 	Result should be checked, pde is not needed:
> > 
> 
> pde is needed to free the per cpu stat structure in nf_flow_table_fini_net

	Nothing is needed to add in nf_flow_table_fini_net(),
only in nf_flow_table_fini_proc() which is called by
nf_flow_table_pernet_exit().

> in the error case. This was implemented before this patch though.
> I understand that some kind of error check would be good.
> Since there is no consequence when this does not work I did not implement one
> and let the old error checking go along.

	The checking tools will warn for such leaks, so
every module should cleanup everything on init error.

> Do you have any ideas how to solve the problem more?

	Nothing more is needed except the missing
remove_proc_entry("nf_flowtable_counter", net->proc_net_stat);
in nf_flow_table_fini_proc(). The var 'pde' is not needed.
On error in nf_flow_table_init_proc() it should free everything
allocated there and nf_flow_table_fini_proc() should free
everything that is allocated in nf_flow_table_init_proc().

> Best
> Sven
> 
> > 	if (!proc_create_net())
> > 		goto err;
> > 
> > > +	proc_create_net_single("nf_flowtable_counter", 0444,
> > > +			net->proc_net, nf_flow_table_counter_show, NULL);
> > 
> > 	if (!proc_create_net_single())
> > 		goto err_net;
> > 	return 0;
> > 
> > err_net:
> > 	remove_proc_entry("nf_flowtable", net->proc_net_stat);
> > 
> > err:
> > 	return -ENOMEM;
> > 
> > > +
> > >  	return pde ? 0 : -ENOMEM;
> > >  }

Regards

--
Julian Anastasov <ja@ssi.bg>

