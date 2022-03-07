Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDC7C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Mar 2022 21:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbiCGV5a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 16:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbiCGV53 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 16:57:29 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A69C37EDA1
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2022 13:56:34 -0800 (PST)
Received: from netfilter.org (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id BA0F563001;
        Mon,  7 Mar 2022 22:54:43 +0100 (CET)
Date:   Mon, 7 Mar 2022 22:56:31 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 2/8] netfilter: introduce total count of hw
 offloaded flow table entries
Message-ID: <YiZ/j6kYidLRYkRh@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-3-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222151003.2136934-3-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 05:09:57PM +0200, Vlad Buslov wrote:
> To improve hardware offload debuggability and allow capping total amount of
> offloaded entries in following patch extend struct netns_nftables with
> 'count_hw' counter and expose it to userspace as 'nf_flowtable_count_hw'
> sysctl entry. Increment the counter together with setting NF_FLOW_HW flag
> when scheduling offload add task on workqueue and decrement it after
> successfully scheduling offload del task.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---
>  include/net/netns/nftables.h            |  1 +
>  net/netfilter/nf_conntrack_standalone.c | 12 ++++++++++++
>  net/netfilter/nf_flow_table_core.c      | 12 ++++++++++--
>  3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
> index 8c77832d0240..262b8b3213cb 100644
> --- a/include/net/netns/nftables.h
> +++ b/include/net/netns/nftables.h
> @@ -6,6 +6,7 @@
>  
>  struct netns_nftables {
>  	u8			gencursor;
> +	atomic_t		count_hw;

In addition to the previous comments: I'd suggest to use
register_pernet_subsys() and register the sysctl from the
nf_flow_table_offload.c through nf_flow_table_offload_init()
file instead of using the conntrack nf_ct_sysctl_table[].

That would require a bit more work though.
