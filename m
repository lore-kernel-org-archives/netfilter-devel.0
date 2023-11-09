Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99787C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 11:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjKILJe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 06:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjKILJd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 06:09:33 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D312D44
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 03:09:31 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r12ue-0000h6-IW; Thu, 09 Nov 2023 12:09:28 +0100
Date:   Thu, 9 Nov 2023 12:09:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC] netfilter: nf_tables: add flowtable map for xdp
 offload
Message-ID: <20231109110928.GB26681@breakpoint.cc>
References: <20231019202507.16439-1-fw@strlen.de>
 <20231102083042.GB6174@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102083042.GB6174@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:

Pablo, I am going to make changes to the flowtable infra, it would
be nice if you could nack/ack the following approach before I start to
spend cycles on this:

> Florian Westphal <fw@strlen.de> wrote:
> This is fine or at least can be made to work.
> 
> > +	case FLOW_BLOCK_UNBIND:
> > +		nf_flowtable_by_dev_remove(dev);
> 
> This is broken.  UNBIND comes too late when things are torn down.
> 
> I only see two solutions:
> 
> 1. add a new nf_flow_offload_unbind_prepare() that does this
> 2. Decouple nf_flowtable from nft_flowtable and make nf_flowtable
>    refcounted.  As-is, the UNBIND will result in UAF because the
>    underlying structures will be free'd immediately after this,
>    without any synchronize_rcu().

I'll go with 2).  Rough Plan is:

1. Do not embed nf_flowtable into nft_flowtable or the act_ct struct,
   make this a pointer, which is allocated/freed via kmalloc/kfree.

2. add a refcount_t to nf_flowtable, so the nf_flowtable can have
   its reference incremented for as long as an XDP program might
   be using this.

3. Change nf_flowtable_free so that it will honor the reference count.
   Last _put will queue destruction to rcu worker, so the teardown of
   the rhashtable and other items passes through another
   synchronize_rcu().  This will also move kfree() of nf_flowtable into
   nf_flowtable_free.

4. Refactor the nf_flowtable init function so it will allocate and
   return the flowtable structure.

Only alternative I see is to rework both act_ct and nf_tables_api.c
to perform UNBINDs *before* synchronize_rcu (and the flowtable
teardown).

Doing that means that the xdp prog will not be able to 'pin' the
underlying nf_flowtable (as its embedded in another data structure,
either tcf_ct_flow_table or nft_flowtable), and would have to rely
on the callers to prevent the kfunc from every returning an nf_flowtable
that has already been free'd.

Not a problem now, but would be a problem in case bpf would gain
the ability to expose struct nf_flowtable as a refcounted kptr.
