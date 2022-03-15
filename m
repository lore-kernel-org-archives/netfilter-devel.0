Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5566C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 10:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347176AbiCOKmb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 06:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347169AbiCOKmb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 06:42:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2358D50B18
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 03:41:20 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CE0C0601DB;
        Tue, 15 Mar 2022 11:39:00 +0100 (CET)
Date:   Tue, 15 Mar 2022 11:41:17 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 2/8] netfilter: introduce total count of hw
 offloaded flow table entries
Message-ID: <YjBtTdcYk0lJqsYw@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-3-vladbu@nvidia.com>
 <YiZ/j6kYidLRYkRh@salvia>
 <87fsnnuenw.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87fsnnuenw.fsf@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 12, 2022 at 09:51:45PM +0200, Vlad Buslov wrote:
> 
> On Mon 07 Mar 2022 at 22:56, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Feb 22, 2022 at 05:09:57PM +0200, Vlad Buslov wrote:
> >> To improve hardware offload debuggability and allow capping total amount of
> >> offloaded entries in following patch extend struct netns_nftables with
> >> 'count_hw' counter and expose it to userspace as 'nf_flowtable_count_hw'
> >> sysctl entry. Increment the counter together with setting NF_FLOW_HW flag
> >> when scheduling offload add task on workqueue and decrement it after
> >> successfully scheduling offload del task.
> >> 
> >> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> >> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> >> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> >> ---
> >>  include/net/netns/nftables.h            |  1 +
> >>  net/netfilter/nf_conntrack_standalone.c | 12 ++++++++++++
> >>  net/netfilter/nf_flow_table_core.c      | 12 ++++++++++--
> >>  3 files changed, 23 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
> >> index 8c77832d0240..262b8b3213cb 100644
> >> --- a/include/net/netns/nftables.h
> >> +++ b/include/net/netns/nftables.h
> >> @@ -6,6 +6,7 @@
> >>  
> >>  struct netns_nftables {
> >>  	u8			gencursor;
> >> +	atomic_t		count_hw;
> >
> > In addition to the previous comments: I'd suggest to use
> > register_pernet_subsys() and register the sysctl from the
> > nf_flow_table_offload.c through nf_flow_table_offload_init()
> > file instead of using the conntrack nf_ct_sysctl_table[].
> >
> > That would require a bit more work though.
> 
> I added the new sysctl in ct because there is already similar-ish
> NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD that is also part of ct sysctl
> but is actually used by flow table code. I'll implement dedicated sysctl
> table for nf_flow_table_* code, if you suggest it is warranted for this
> change.

IIRC, that was removed.

commit 4592ee7f525c4683ec9e290381601fdee50ae110
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Aug 4 15:02:15 2021 +0200

    netfilter: conntrack: remove offload_pickup sysctl again

I think it's good if we start having a dedicated sysctl for the
flowtable, yes.

Thanks.
