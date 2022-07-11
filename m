Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E641C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Jul 2022 14:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiGKOgy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGKOgx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 10:36:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5583565D7C
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 07:36:53 -0700 (PDT)
Date:   Mon, 11 Jul 2022 16:36:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next v4 0/2] Conntrack offload debuggability
 improvements
Message-ID: <Ysw1grKWm/OUO0qx@salvia>
References: <20220615104355.391249-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220615104355.391249-1-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 15, 2022 at 12:43:53PM +0200, Vlad Buslov wrote:
> Current conntrack offload implementation doesn't provide much visibility
> and control over offload code. There is no way to determine current load
> on workqueues that process the offload tasks which makes it hard to
> debug the cases where offload is significantly delayed due to rate of
> new connections being higher than driver or hardware offload rate.
> 
> Improve the debuggability by introducing procfs for current total of
> workqueue tasks for nf_ft_offload_add, nf_ft_offload_del and
> nf_ft_offload_stats queues. This allows visibility for flow offload
> delay due to system scheduling offload tasks faster than driver/hardware
> can process them.

Series applied, thanks
