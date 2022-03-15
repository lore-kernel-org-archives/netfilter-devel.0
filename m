Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BE1C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 10:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345367AbiCOKYd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 06:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347006AbiCOKYc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 06:24:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B88E32612C
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 03:23:19 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 249686300F;
        Tue, 15 Mar 2022 11:21:00 +0100 (CET)
Date:   Tue, 15 Mar 2022 11:23:16 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 2/8] netfilter: introduce total count of hw
 offloaded flow table entries
Message-ID: <YjBpFDc+rOqhSPrW@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-3-vladbu@nvidia.com>
 <YiZ9fQ8oMSOn5Su2@salvia>
 <87o82bug3d.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87o82bug3d.fsf@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 12, 2022 at 08:56:49PM +0200, Vlad Buslov wrote:
[...]
> Hi Pablo,
> 
> Thanks for reviewing my code and sorry for the late reply.
> 
> We explored the approach you propose and found several issues with it.
> First, the nice benefit of implementation in this patch is that having
> counter increment in flow_offload_add() (and test in following patch)
> completely avoids spamming the workqueue when the limit is reached which
> is an important concern for slower embedded DPU cores. Second, it is not
> possible to change it when IPS_HW_OFFLOAD_BIT is set at the very end of
> flow_offload_work_add() function because in following patch we need to
> verify that counter is in user-specified limit before attempting
> offload. Third, changing the counter in wq tasks makes it hard to
> balance correctly. Consider following cases:
> 
> - flow_offload_work_add() can be called arbitrary amount of times per
>   flow due to refresh logic. However, any such flow is still deleted
>   only once.
> 
> - flow_offload_work_del() can be called for flows that were never
>   actually offloaded (it is called for flows that have NF_FLOW_HW bit
>   that is unconditionally set before attempting to schedule offload task
>   on wq).
>
> Counter balancing issues could maybe be solved by carefully
> conditionally changing it based on current value IPS_HW_OFFLOAD_BIT, but
> spamming the workqueue can't be prevented for such design.
>
> > That also moves the atomic would be away from the packet path.
> 
> I understand your concern. However, note that this atomic is normally
> changed once for adding offloaded flow and once for removing it. The
> code path is only executed per-packet in error cases where flow has
> failed to offload and refresh is called repeatedly for same flow.

Thanks for explaining.

There used to be in the code a list of pending flows to be offloaded.

I think it would be possible to restore such list and make it per-cpu,
the idea is to add a new field to the flow_offload structure to
annotate the cpu that needs to deal with this flow (same cpu deals
with add/del/stats). The cpu field is set at flow creation time.

Once there is one item, add work to the workqueue to that cpu.
Meanwhile the workqueue does not have a chance, we keep adding more
items to the workqueue.

The workqueue handler then zaps the list of pending flows to be
offloaded, it might have more than one single item in the list.

So instead of three workqueues, we only have one. Scalability is
achieved by fanning out flows over CPUs.
