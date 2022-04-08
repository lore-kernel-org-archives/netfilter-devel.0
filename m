Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFB0C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiDHKLR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 06:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiDHKLR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 06:11:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3320B3BA50
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 03:09:14 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 50F8D64398;
        Fri,  8 Apr 2022 12:05:24 +0200 (CEST)
Date:   Fri, 8 Apr 2022 12:09:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 00/16] netfilter: conntrack: remove percpu
 lists
Message-ID: <YlAJxhoncbhpfXzR@salvia>
References: <20220323132214.6700-1-fw@strlen.de>
 <YlAGgQVDv9wBS1+7@salvia>
 <YlAHnE2pGW6qdAeA@salvia>
 <YlAI77bCl/KrzDEA@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YlAI77bCl/KrzDEA@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 08, 2022 at 12:05:38PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 08, 2022 at 11:59:59AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Apr 08, 2022 at 11:56:09AM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 23, 2022 at 02:21:58PM +0100, Florian Westphal wrote:
> > > > This series removes the unconfirmed and dying percpu lists.
> > > > 
> > > > Dying list is replaced by pernet list, only used when reliable event
> > > > delivery mode was requested.
> > > > 
> > > > Unconfirmed list is replaced by a generation id for the conntrack
> > > > extesions, to detect when pointers to external objects (timeout policy,
> > > > helper, ...) has gone stale.
> > > > 
> > > > An alternative to the genid would be to always take references on
> > > > such external objects, let me know if that is the preferred solution.
> > > 
> > > Applied 1, 2, 3, 5, 6 and 8.
> > 
> > Not 6 actually, since it depends on 4.
> > 
> > So I'm taking the preparation patches of this batch.
> 
> Wait. Can we possibly set a dummy event handler instead?
> 
> void nf_conntrack_unregister_notifier(void)
> {
>         rcu_assign_pointer(nf_conntrack_event_cb, nfct_event_null_handler);
> }
> 
> which does nothing?
> 
> It also needs to be set on initially to this null event handler?
> 
> So we can avoid the stash trick in nfnetlink too?

So I'm taking 3, 5 and 8 at this stage.
