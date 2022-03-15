Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7BDC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 10:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347078AbiCOKaz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 06:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345266AbiCOKay (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 06:30:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9DE949C95
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 03:29:42 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9EE9160196;
        Tue, 15 Mar 2022 11:27:22 +0100 (CET)
Date:   Tue, 15 Mar 2022 11:29:38 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 8/8] netfilter: flowtable: add hardware offload
 tracepoints
Message-ID: <YjBqkv6YTyxd/VFy@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-9-vladbu@nvidia.com>
 <YiaL5a8akGHoIXLE@salvia>
 <877d8zue2n.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <877d8zue2n.fsf@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 12, 2022 at 10:05:55PM +0200, Vlad Buslov wrote:
> 
> On Mon 07 Mar 2022 at 23:49, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Feb 22, 2022 at 05:10:03PM +0200, Vlad Buslov wrote:
> >> Add tracepoints to trace creation and start of execution of flowtable
> >> hardware offload 'add', 'del' and 'stats' tasks. Move struct
> >> flow_offload_work from source into header file to allow access to structure
> >> fields from tracepoint code.
> >
> > This patch, I would prefer to keep it back and explore exposing trace
> > infrastructure for the flowtable through netlink.
> >
> 
> What approach do you have in mind with netlink? I used tracepoints here
> because they are:
> 
> - Incur no performance penalty when disabled.
> 
> - Handy to attach BPF programs to.
> 
> According to my experience with optimizing TC control path parsing
> Netlink is CPU-intensive. I am also not aware of mechanisms to leverage
> it to attach BPF.

Sure, no question tracing and introspection is useful.

But could you use the generic workqueue trace points instead?

This is adding tracing infrastructure for a very specific purpose, to
inspect the workqueue behaviour for the flowtable.

And I am not sure how you use this yet other than observing that the
workqueue is coping with the workload?
