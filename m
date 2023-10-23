Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64885C001E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 11:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbjJWLRB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 07:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbjJWLRB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 07:17:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427E7C1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 04:16:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qusvX-000859-Pn; Mon, 23 Oct 2023 13:16:55 +0200
Date:   Mon, 23 Oct 2023 13:16:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC] netfilter: nf_tables: add flowtable map for xdp
 offload
Message-ID: <20231023111655.GA31012@breakpoint.cc>
References: <20231019202507.16439-1-fw@strlen.de>
 <ZTZL3jpvunApjcTE@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTZL3jpvunApjcTE@lore-desk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> thx for working on this, I tested this patch with the flowtable lookup kfunc
> I am working on (code is available here [0]) and it works properly.

Thanks!

> > 
> > Do we need to support dev-in-multiple flowtables?  I would like to
> > avoid this, this likely means the future "xdp" flag in nftables would
> > be restricted to "inet" family.  Alternative would be to change the key to
> > 'device address plus protocol family', the xdp prog could derive that from the
> > packet data.
> > 
> > Timeout handling.  Should the XDP program even bother to refresh the
> > flowtable timeout?
> 
> I was assuming the flowtable lookup kfunc can take care of it.

I'm worried about stale neigh cache, resp. making sure that it
gets renewed.

> > +struct nf_flowtable *nf_flowtable_by_dev(const struct net_device *dev)
> > +{
> 
> I think this routine needs to be added to some include file (e.g.
> include/net/netfilter/nf_flow_table.h)

Right.
