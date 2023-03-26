Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC49FC74A5B
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Mar 2023 20:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCZUlO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Mar 2023 16:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCZUlO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Mar 2023 16:41:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F82C5FD4
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Mar 2023 13:41:13 -0700 (PDT)
Date:   Sun, 26 Mar 2023 22:41:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <ZCCt5q1TZPJRHVyq@salvia>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZB7Og6wos1oyDiug@orbyte.nwl.cc>
 <20230325111017.GG80565@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230325111017.GG80565@celephais.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 25, 2023 at 11:10:17AM +0000, Jeremy Sowden wrote:
> On 2023-03-25, at 11:35:47 +0100, Phil Sutter wrote:
> > On Fri, Mar 24, 2023 at 11:59:04PM +0100, Florian Westphal wrote:
> > > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > > +ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910/55900;ok
> > > > +ip6 daddr 10::1 tcp dport 55900-55910 dnat ip6 to [::c0:a8:7f:1]:5900-5910/55900;ok
> > >
> > > This syntax is horrible (yes, I know, xtables fault).
> > >
> > > Do you think this series could be changed to grab the offset register from the
> > > left edge of the range rather than requiring the user to specify it a
> > > second time?  Something like:
> > >
> > > ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910
> > >
> > > I'm open to other suggestions of course.
> >
> > Initially, a map came to mind. Something like:
> >
> > | dnat to : tcp dport map { 1000-2000 : 5000-6000 }
> >
> > To my surprise, nft accepts the syntax (listing is broken, though). But
> > IIUC, it means "return 5000-6000 for any port in [1000;2000]" and dnat
> > does round-robin?
> 
> That does ring a bell.  IIRC, when I initially looked into this, I did
> have a look at maps to see if they might already offer analogous func-
> tionality.
> 
> > At least it's not what one would expect. Maybe one could control the
> > lookup behaviour somehow via a flag?
> 
> Thanks for the suggestion.

Yes, one possibility would be to explore a new flag in the NAT engine.

As said in previous email, this really has to work with NAT maps in nftables.
