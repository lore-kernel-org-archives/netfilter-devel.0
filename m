Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1E7C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 12:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241282AbiEQM0x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 08:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346064AbiEQM0u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 08:26:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF68013DC9
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 05:26:48 -0700 (PDT)
Date:   Tue, 17 May 2022 14:26:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next v2 3/3] netfilter: nf_flow_table: count pending
 offload workqueue tasks
Message-ID: <YoOUhKnNvLNudyjr@salvia>
References: <20220516191032.340243-1-vladbu@nvidia.com>
 <20220516191032.340243-4-vladbu@nvidia.com>
 <YoOFA1Tz68/rQDR3@salvia>
 <87mtfg76ex.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87mtfg76ex.fsf@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 17, 2022 at 02:16:04PM +0300, Vlad Buslov wrote:
> 
> On Tue 17 May 2022 at 13:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, May 16, 2022 at 10:10:32PM +0300, Vlad Buslov wrote:
> > [...]
> >> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> >> index ddc54b6d18ee..c8fc5c7ef04a 100644
> >> --- a/net/netfilter/Kconfig
> >> +++ b/net/netfilter/Kconfig
> >> @@ -734,6 +734,14 @@ config NF_FLOW_TABLE
> >>  
> >>  	  To compile it as a module, choose M here.
> >>  
> >> +config NF_FLOW_TABLE_PROCFS
> >> +	bool "Supply flow table statistics in procfs"
> >> +	default y
> >> +	depends on PROC_FS
> >> +	help
> >> +	  This option enables for the flow table offload statistics
> >> +	  to be shown in procfs under net/netfilter/nf_flowtable.
> >
> > This belongs to patch 2/3.
> >
> > Then, use NF_FLOW_TABLE_PROCFS to conditionally add it to
> > nf_flow_table if this is enabled in .config? To honor this new Kconfig
> > toggle.
> >
> > I mean instead of:
> >
> > obj-$(CONFIG_NF_FLOW_TABLE)    += nf_flow_table.o
> >  nf_flow_table-objs             := nf_flow_table_core.o nf_flow_table_ip.o \
> > -                                  nf_flow_table_offload.o
> > +                                  nf_flow_table_offload.o \
> > +                                  nf_flow_table_sysctl.o
> >
> > this?
> >
> > nf_flow_table-$(CONFIG_NF_FLOW_TABLE_SYSCTL)    += nf_flow_table_sysctl.o
> 
> In V2 I have both sysctl and procfs implementations in single file.
> As I replied for previous patch in series: Should I split those in two
> separate files (nf_flow_table_sysctl.c and nf_flow_table_procfs.c) that
> both could be conditionally compiled depending on their respective
> configs?

Same file is fine.

Probably instead ?

nf_flow_table-$(CONFIG_SYSCTL)    += nf_flow_table_sysctl.o

so the #ifdef CONFIG_SYSCTL in nf_flow_table_sysctl.c can go away.

you would need to move:

        unsigned int nf_ft_hw_max __read_mostly;

to nf_flow_table_offload.c

Make sense?

> >>  config NETFILTER_XTABLES
> >>  	tristate "Netfilter Xtables support (required for ip_tables)"
> >>  	default m if NETFILTER_ADVANCED=n
> >> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> >> index e2598f98017c..c86dd627ef42 100644
> >> --- a/net/netfilter/nf_flow_table_core.c
> >> +++ b/net/netfilter/nf_flow_table_core.c
> >> @@ -662,17 +662,51 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
> >>  }
> >>  EXPORT_SYMBOL_GPL(nf_flow_table_free);
> >>  
> >> +static int nf_flow_table_init_net(struct net *net)
> >> +{
> >> +	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
> >
> > Missing check for NULL in case alloc_percpu() fails?
> >
> 
> I might be missing something, but why isn't NULL check in following line
> sufficient?

I overlook the return is check for NULL, sorry for the noise.

> >> +	return net->ft.stat ? 0 : -ENOMEM;
> >> +}
> 
