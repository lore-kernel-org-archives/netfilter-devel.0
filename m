Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C4BC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 May 2022 20:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244718AbiESUly (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 May 2022 16:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244702AbiESUlx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 May 2022 16:41:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79255393EE
        for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2022 13:41:52 -0700 (PDT)
Date:   Thu, 19 May 2022 22:41:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next v3 0/3] Conntrack offload debuggability
 improvements
Message-ID: <YoarjVnP26f9WBvB@salvia>
References: <20220517165909.505010-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220517165909.505010-1-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 17, 2022 at 07:59:06PM +0300, Vlad Buslov wrote:
> Current conntrack offload implementation doesn't provide much visibility
> and control over offload code. The code just tries to offload new flows,
> even if current amount of flows is beyond what can be reasonably
> processed by target hardware. On top of that there is no way to
> determine current load on workqueues that process the offload tasks
> which makes it hard to debug the cases where offload is significantly
> delayed due to rate of new connections being higher than driver or
> hardware offload rate.
> 
> Improve the debuggability situation by implementing following new
> functionality:
> 
> - Sysctls for current total count of offloaded flow and
>   user-configurable maximum. Capping the amount of offloaded flows can
>   be useful for the allocations of hardware resources. Note that the
>   flow can still be offloaded afterwards via 'refresh' mechanism if
>   total hardware count.
> 
> - Procfs for current total of workqueue tasks for nf_ft_offload_add,
>   nf_ft_offload_del and nf_ft_offload_stats queues. This allows
>   visibility for flow offload delay due to system scheduling offload
>   tasks faster than driver/hardware can process them.

Series applied, thanks!
