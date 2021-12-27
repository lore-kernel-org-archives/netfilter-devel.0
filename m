Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE8FC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Dec 2021 14:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237159AbhL0O2Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Dec 2021 09:28:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47268 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbhL0O2W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Dec 2021 09:28:22 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 34A6962BDB;
        Mon, 27 Dec 2021 15:25:42 +0100 (CET)
Date:   Mon, 27 Dec 2021 15:28:16 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: exthdr: add support for tcp option
 removal
Message-ID: <YcnNgMtCPSeUQbIi@salvia>
References: <20211220143247.554667-1-fw@strlen.de>
 <YcO5tQz5ImOxtZLx@salvia>
 <20211227141121.GB21386@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211227141121.GB21386@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 27, 2021 at 03:11:21PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Dec 20, 2021 at 03:32:47PM +0100, Florian Westphal wrote:
> > > This allows to replace a tcp option with nop padding to selectively disable
> > > a particular tcp option.
> > > 
> > > Optstrip mode is chosen when userspace passes the exthdr expression with
> > > neither a source nor a destination register attribute.
> > > 
> > > This is identical to xtables TCPOPTSTRIP extension.
> > 
> > Is it worth to retain the bitmap approach?
> 
> I don't think so.  For TCPOPTSTRIP it makes sense because
> you can't use multiple targets in one rule.
> 
> I'd rework this to not set BREAK if the option wasn't present
> in the first place, so you could do
> 
> delete tcp option sack-perm delete tcp option timestamp ...
> 
> and so on.
> 
> Let me know if you disagree.

It's OK if you prefer this way. I can see references on the web to
reseting multiple options, not sure if it is actually useful in
practise, in such you can to parse the packet several times.

> I could also rework it so that option comes from sreg instead
> of imm, but i could not find a use-case where having the option number
> coming from a map lookup would make sense.
> 
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > ---
> > >  proposed userspace syntax is:
> > > 
> > >  nft add rule f in delete tcp option sack-perm
> > 
> >    nft add rule f in tcp option reset sack-perm,...
> 
> Why 'reset'?  My initial version had 'remove' but 'delete'
> already exists as a token so it was simpler.

'reset' also exists as a token. This is setting to nop, I just though
reset might make more sense, there might be a nice to really remove
TCP options in the future (costful but paranoid scenario, an observer
can spot options that have been nop)
