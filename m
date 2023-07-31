Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E35BC001DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jul 2023 12:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjGaMrX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 08:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjGaMrF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 08:47:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E49E1997
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2023 05:46:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qQSIH-0005VR-AD; Mon, 31 Jul 2023 14:46:37 +0200
Date:   Mon, 31 Jul 2023 14:46:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nftables: syntax ambiguity with objref map and ct helper objects
Message-ID: <20230731124637.GA7056@breakpoint.cc>
References: <20230728195614.GA18109@breakpoint.cc>
 <ZMenriLfu+luvh9i@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMenriLfu+luvh9i@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Fri, Jul 28, 2023 at 09:56:14PM +0200, Florian Westphal wrote:
> > Hi,
> > 
> > I wanted to allow creating objref maps that
> > return "ct timeout" or "ct helper" templates.
> > 
> > However:
> >   map .. {
> >     type ipv4_addr : ct timeout
> > 
> >   The above is fine, but this is not:
> > 
> >   map .. {
> >     type ipv4_addr : ct helper
> 
> This is type, not typeof, is it intentional?

Yes, but doesn't matter for this problem.
Same ambiguity with

typeof ip saddr : ct helper

> This works fine with typeof:
> 
> table ip x {
>         map x {
>                 typeof ip saddr : ct helper
>         }
> }

My point is how nft should differentiate between

ct helper "bla" {

rule add ct helper "foo"

In above map declaration.  What does

"typeof ip saddr : ct helper" declare?
As far as I can see its arbitrary 16-byte strings, so the
above doesn't delcare an objref map that maps ip addresses
to conntrack helper templates.
