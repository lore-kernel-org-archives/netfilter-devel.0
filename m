Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B79C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 11:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiBILzP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiBILzN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 06:55:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF44C004582
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 02:47:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nHkV1-0002YM-Db; Wed, 09 Feb 2022 11:46:59 +0100
Date:   Wed, 9 Feb 2022 11:46:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: use dump structure instead
 of raw args
Message-ID: <20220209104659.GF25000@breakpoint.cc>
References: <20220204121145.3471-1-fw@strlen.de>
 <YgOawS6I8ldRk72Z@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgOawS6I8ldRk72Z@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  static int ctnetlink_done_list(struct netlink_callback *cb)
> >  {
> > -	if (cb->args[1])
> > -		nf_ct_put((struct nf_conn *)cb->args[1]);
> > +	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
> 
> Where is cb->ctx initialized?

Its zeroed in __netlink_dump_start, cb->ctx and cb->args are aliased
via union inside netlink_callback struct.
