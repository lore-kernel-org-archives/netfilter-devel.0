Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4C2E7F154
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 10:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjI2K4V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 06:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbjI2K4V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 06:56:21 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FB311F
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 03:56:19 -0700 (PDT)
Received: from [78.30.34.192] (port=37532 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qmBAO-008oAL-9x; Fri, 29 Sep 2023 12:56:18 +0200
Date:   Fri, 29 Sep 2023 12:56:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 7/8] netfilter: nf_tables: Pass reset bit in
 nft_set_dump_ctx
Message-ID: <ZRatT4q729r7MPBO@calendula>
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-8-phil@nwl.cc>
 <ZRXLlwkeCBWgXqGZ@calendula>
 <ZRaiEjg2g6UuLPpS@orbyte.nwl.cc>
 <ZRajtFQ1dtMokDUM@calendula>
 <ZRakdAbR39fS3thz@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRakdAbR39fS3thz@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 29, 2023 at 12:18:28PM +0200, Phil Sutter wrote:
> On Fri, Sep 29, 2023 at 12:15:16PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Sep 29, 2023 at 12:08:18PM +0200, Phil Sutter wrote:
> > > On Thu, Sep 28, 2023 at 08:53:11PM +0200, Pablo Neira Ayuso wrote:
> > > > On Thu, Sep 28, 2023 at 06:52:43PM +0200, Phil Sutter wrote:
> > > > > Relieve the dump callback from having to check nlmsg_type upon each
> > > > > call. Prep work for set element reset locking.
> > > > 
> > > > Maybe add this as a preparation patch first place in this series,
> > > > rather making this cleanup at this late stage of the batch.
> > > 
> > > Sure, no problem. I extracted it from v1 of patch 8 and so they are
> > > closely related.
> > > 
> > > Maybe I should split the series up in per-callback ones? I'd start with
> > > the getsetelem_reset one as that is most cumbersome it seems.
> > 
> > Thanks.
> > 
> > Side note: I also read a comment from Florian regarding the use of
> > ctx.table. You have to be very careful with what you cache in the dump
> > context area, since such pointer might just go away.
> > 
> > So far this code caches was "careful" to cache only to check if the
> > table was still there, but iterating over the table list again
> > (another safer approach could be to use the table handle which is
> > unique).
> > 
> > All this is also related to the chunked nature of netlink dumps
> > (in other words, userspace retrieves part of it in every
> > netlink_recvmsg() call).
> 
> Good point. I think we may reduce all this to 'strdup(table->name)' and
> not care what happens in other CPUs. The only requirement is to cache
> table->family for audit logging also (IIRC). I'll give this a try.

table handle is u64 and you don't need to clone, right? Handle
allocation is monotonic.
