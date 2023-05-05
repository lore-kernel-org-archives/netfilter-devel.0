Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8634C7EE24
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 14:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjEEOOj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 10:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbjEEOOf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 10:14:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D728E16345
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 07:14:27 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1puwCY-0001ef-8z; Fri, 05 May 2023 16:14:26 +0200
Date:   Fri, 5 May 2023 16:14:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nf_tables: reject loads from
 uninitialized registers
Message-ID: <ZFUPQv6IrFKz42sS@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20230505111656.32238-1-fw@strlen.de>
 <ZFUBusxUvWw//ENx@orbyte.nwl.cc>
 <20230505134655.GC6126@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505134655.GC6126@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 05, 2023 at 03:46:55PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Fri, May 05, 2023 at 01:16:53PM +0200, Florian Westphal wrote:
> > > Keep a per-rule bitmask that tracks registers that have seen a store,
> > > then reject loads when the accessed registers haven't been flagged.
> > > 
> > > This changes uabi contract, because we previously allowed this.
> > > Neither nftables nor iptables-nft create such rules.
> > 
> > Did you consider keeping this bitmask on a per base-chain level? One had
> > to perform this for each base chain of a table upon each rule change and
> > traverse the tree of chains jumped to from there. I guess the huge
> > overhead disqualifies this, though.
> 
> Yes, but its very hard task, because in that case we also need to prove
> that a write *WILL* happen, rather than *might happen*.
> 
> Consider:
> 
> rule1:
> ip protocol tcp iifname "eth0" ...
> reg1 := ip protocol
> cmp reg1
> reg2 := meta iifname
> 
> rule2:
> iifname "eth1" ...
> cmp reg2 "eth0"
> 
> rule 2 has to be rejected because reg2 might be unitialized for != tcp.
> 
> Even if we can handle this some way, we now also need to revalidate the
> ruleset on deletes, because we'd have to detect when a register write
> we depend on goes away.

Ah, right. I forgot about "partial" rule execution again. Same thing
which broke expression reduction for us.

Maybe one could introduce a "chain optimizer" creating an initial
meta-rule which just populates registers with packet/meta data rules
may need. Not something I would want to rely upon regarding kernel info
leaks, though.

Cheers, Phil
