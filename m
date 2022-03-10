Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692F0C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 23:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbiCJX3c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 18:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238980AbiCJX3c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 18:29:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 999F150452
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 15:28:30 -0800 (PST)
Received: from netfilter.org (unknown [46.222.150.172])
        by mail.netfilter.org (Postfix) with ESMTPSA id E18B462FFE;
        Fri, 11 Mar 2022 00:26:27 +0100 (CET)
Date:   Fri, 11 Mar 2022 00:28:24 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 0/3] add description infrastructure
Message-ID: <YiqJmBGoIr89w92s@salvia>
References: <20220120000402.916332-1-pablo@netfilter.org>
 <YininWZnQ8gAY+cw@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YininWZnQ8gAY+cw@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 10, 2022 at 12:35:57PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Jan 20, 2022 at 01:03:59AM +0100, Pablo Neira Ayuso wrote:
> > This is my proposal to address the snprintf data printing depending on
> > the arch. The idea is to add description objects that can be used to
> > build the userdata area as well as to parse the userdata to create the
> > description object.
> 
> I tried to integrate this into nftables, but failed to understand how
> this all is supposed to come together: In nftables, concat is treated
> like any other expression. Your series seems to require special
> treatment?

The idea is that you build the nftnl description object either from
the set typeof expression or the set datatype (depending on how the
user has defined the set).

> At least there are separate "desc" data structures for each.
> It seems like one can't just replace build_udata callbacks to populate
> an nftnl_expr_desc object?

You can use the description object in two ways:

- build_udata is called when setting the libnftnl set udata
  field, to build it.

- you pass the description object to snprintf.

The existing code to build the userdata TLV that resides in nftables
should go away and use this new infrastructure, I'm basically moving
to libnftnl the existing nftables code to build the set userdata area.
