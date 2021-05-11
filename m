Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763C7C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 13:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 362B66192A
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 13:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhEKNVf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 May 2021 09:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhEKNVa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 May 2021 09:21:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC9EC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 11 May 2021 06:20:24 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lgSJB-0002jB-OR; Tue, 11 May 2021 15:20:21 +0200
Date:   Tue, 11 May 2021 15:20:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nftables 2/2] src: add set element catch-all support
Message-ID: <20210511132021.GS12403@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20210510165322.130181-1-pablo@netfilter.org>
 <20210510165322.130181-2-pablo@netfilter.org>
 <20210511082441.GN12403@orbyte.nwl.cc>
 <5fd6a58e-7fed-a1e8-c527-fae71873dc34@netfilter.org>
 <20210511104249.GA18952@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511104249.GA18952@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey!

On Tue, May 11, 2021 at 12:42:49PM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 11, 2021 at 10:50:05AM +0200, Arturo Borrero Gonzalez wrote:
> > On 5/11/21 10:24 AM, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Mon, May 10, 2021 at 06:53:21PM +0200, Pablo Neira Ayuso wrote:
> > > > Add a catchall expression (EXPR_SET_ELEM_CATCHALL).
> > > > 
> > > > Use the underscore (_) to represent the catch-all set element, e.g.
> > > 
> > > Why did you choose this over asterisk? We have the latter as wildcard
> > > symbol already (although a bit limited), so I think it would be more
> > > intuitive than underscore.
> 
> I looked at several programming languages, one of them is using it (a
> very trendy one...), so I thought we have to use it / place it at the
> deep core of Netfilter for this reason, even if it absolutely makes no
> sense.

Pablo, this tone is not acceptable: Please keep in mind there are
potential readers with complete lack of humour which could find this
absolutely offensive!

> Actually, the real reason is that I was trying to reduce interactions
> with bash, which most distros tend to use.

I see. From my PoV though, since asterisk *is* used in nft syntax
already, using it in more spots is not making things much worse.

OTOH, trying to avoid conflicts with shell is probably a futile task
unless we reduce the syntax to alphanumeric characters. The curly
braces, for instance, make zsh choke. So I'd just accept it, make the
syntax nice for nft scripts and guide users to enclose nft parameters in
ticks, similar to e.g. 'perl -e' or 'python -c'.

> > Moreover,
> > 
> > instead of a symbol, perhaps an explicit word (string, like "default") may
> > contribute to a more understandable syntax.
> 
> I also considered "default" to reduce interactions with bash, problem is
> that it's likely to be a valid input value as a key, for example, there
> are a few keys in /etc/iproute2/rt_* files that use default, and that
> will clash with it.

Which is another benefit of "reusing" asterisk as there is little chance
for it to clash with something else. Also, there is wildcard_expr
(currently dead code) which may find use again.

> So I'm more inclined to Phil's proposal to use asterisk, even if it
> needs to be escaped in bash, I'll send a v2.

Thanks, Phil
