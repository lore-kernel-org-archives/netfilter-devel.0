Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FFBC001DE
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 09:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjHDJPx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 05:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjHDJPb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 05:15:31 -0400
Received: from Chamillionaire.breakpoint.cc (unknown [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F4949C9
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Aug 2023 02:13:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qRqrX-0003jb-E6; Fri, 04 Aug 2023 11:12:47 +0200
Date:   Fri, 4 Aug 2023 11:12:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nftables: syntax ambiguity with objref map and ct helper objects
Message-ID: <20230804091247.GK30550@breakpoint.cc>
References: <20230728195614.GA18109@breakpoint.cc>
 <ZMenriLfu+luvh9i@calendula>
 <20230731124637.GA7056@breakpoint.cc>
 <ZMfT97SbKBov4UzD@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMfT97SbKBov4UzD@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jul 31, 2023 at 02:46:37PM +0200, Florian Westphal wrote:
> [...]
> > My point is how nft should differentiate between
> > 
> > ct helper "bla" {
> > 
> > rule add ct helper "foo"
> > 
> > In above map declaration.  What does
> > 
> > "typeof ip saddr : ct helper" declare?
> > As far as I can see its arbitrary 16-byte strings, so the
> > above doesn't delcare an objref map that maps ip addresses
> > to conntrack helper templates.
> 
> Oh, indeed. Selector semantics are overloaded, I proposed kernel
> patches that have remained behind:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210309210134.13620-2-pablo@netfilter.org/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210309210134.13620-3-pablo@netfilter.org/

Even if we had those two patches in tree, we would still need
a different userspace syntax for the two cases.

We can't go for

"typeof ip saddr : ct helpername"

because we need to continue to support
ct helper "foo"

So maybe

typeof ip saddr : objref ct helper

Or:

typeof ip saddr : ct helper
flags objref

(Might be able to make this work by internally mangling
 the type after the "objref" flag is found).

> I also proposed change to have two selectors, one for the helper type
> and another for the user-defined helper name. I still have to update
> libnftnl and nftables.

Did not recall that.
