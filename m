Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05310C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Dec 2021 14:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhL0OLY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Dec 2021 09:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237033AbhL0OLY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Dec 2021 09:11:24 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57504C06173E
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Dec 2021 06:11:23 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n1qif-00008V-Pz; Mon, 27 Dec 2021 15:11:21 +0100
Date:   Mon, 27 Dec 2021 15:11:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: exthdr: add support for tcp option
 removal
Message-ID: <20211227141121.GB21386@breakpoint.cc>
References: <20211220143247.554667-1-fw@strlen.de>
 <YcO5tQz5ImOxtZLx@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcO5tQz5ImOxtZLx@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Dec 20, 2021 at 03:32:47PM +0100, Florian Westphal wrote:
> > This allows to replace a tcp option with nop padding to selectively disable
> > a particular tcp option.
> > 
> > Optstrip mode is chosen when userspace passes the exthdr expression with
> > neither a source nor a destination register attribute.
> > 
> > This is identical to xtables TCPOPTSTRIP extension.
> 
> Is it worth to retain the bitmap approach?

I don't think so.  For TCPOPTSTRIP it makes sense because
you can't use multiple targets in one rule.

I'd rework this to not set BREAK if the option wasn't present
in the first place, so you could do

delete tcp option sack-perm delete tcp option timestamp ...

and so on.

Let me know if you disagree.

I could also rework it so that option comes from sreg instead
of imm, but i could not find a use-case where having the option number
coming from a map lookup would make sense.

> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  proposed userspace syntax is:
> > 
> >  nft add rule f in delete tcp option sack-perm
> 
>    nft add rule f in tcp option reset sack-perm,...

Why 'reset'?  My initial version had 'remove' but 'delete'
already exists as a token so it was simpler.
