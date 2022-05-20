Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DBAC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 May 2022 22:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345089AbiETWRk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 May 2022 18:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245429AbiETWRh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 May 2022 18:17:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EC81166D4E;
        Fri, 20 May 2022 15:17:36 -0700 (PDT)
Date:   Sat, 21 May 2022 00:17:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Felix Fietkau <nbd@nbd.name>, Oz Shlomo <ozsh@nvidia.com>,
        paulb@nvidia.com, vladbu@nvidia.com
Subject: Re: [PATCH net-next 06/11] netfilter: nf_flow_table: count and limit
 hw offloaded entries
Message-ID: <YogTfOYGwY5IVhGn@salvia>
References: <20220519220206.722153-1-pablo@netfilter.org>
 <20220519220206.722153-7-pablo@netfilter.org>
 <20220519161136.32fdba19@kernel.org>
 <YodG+REOiDa2PMUl@salvia>
 <20220520105606.15fd5133@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220520105606.15fd5133@kernel.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 20, 2022 at 10:56:06AM -0700, Jakub Kicinski wrote:
> On Fri, 20 May 2022 09:44:57 +0200 Pablo Neira Ayuso wrote:
> > > Why a sysctl and not a netlink attr per table or per device?  
> > 
> > Per-device is not an option, because the flowtable represents a
> > compound of devices.
> > 
> > Moreover, in tc ct act the flowtable is not bound to a device, while
> > in netfilter/nf_tables it is.
> > 
> > tc ct act does not expose flowtables to userspace in any way, they
> > internally allocate one flowtable per zone. I assume there os no good
> > netlink interface for them.
> > 
> > For netfilter/nftables, it should be possible to add per-flowtable
> > netlink attributes, my plan is to extend the flowtable netlink
> > attribute to add a flowtable maximum size.
> > 
> > This sysctl count and limit hw will just work as a global limit (which
> > is optional), my plan is that the upcoming per-flowtable limit will
> > just override this global limit.
> > 
> > I think it is a reasonable tradeoff for the different requirements of
> > the flowtable infrastructure users given there are two clients
> > currently for this code.
> 
> net namespace is a software administrative unit, setting HW offload
> limits on it does not compute for me. It's worse than a module param.
> 
> Can we go back to the problem statement? It sounds like the device
> has limited but unknown capacity and the sysctl is supposed to be set
> by the user magically to the right size, preventing HW flow table from
> filling up? Did I get it right? If so some form of request flow control
> seems like a better idea...

Policy can also throttle down the maximum number of entries in the
hardware, but policy is complementary to the hard cap.

Once the hw cap is reached, the implementation falls back to the
software flowtable datapath.

Regarding the "magic number", it would be good if devices can expose
these properties through interface, maybe FLOW_BLOCK_PROBE to fetch
device properties and capabilities.

In general, I would also prefer a netlink interface for this, but for
tc ct, this would need to expose the existing flowtable objects via a
new netlink command. Then, I assume such cap would be per ct zone
(there is internally one flowtable per conntrack zone).

BTW, Cc'ing Oz, Paul and Vlad.

Meanwhile, what do you want me to do, toss this patchset?
