Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F041EE14A9
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 23:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjIFXBx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 19:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244782AbjIFXBx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 19:01:53 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D738019B2;
        Wed,  6 Sep 2023 16:01:46 -0700 (PDT)
Received: from [78.30.34.192] (port=59294 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qe1Wn-00290M-ST; Thu, 07 Sep 2023 01:01:45 +0200
Date:   Thu, 7 Sep 2023 01:01:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
Message-ID: <ZPkE1VyCX1BNc76q@calendula>
References: <20230906094202.1712-1-pablo@netfilter.org>
 <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
 <ZPhm1mf0GaeQUr0e@calendula>
 <ZPiyGC+TfRgyOabJ@orbyte.nwl.cc>
 <ZPjJAicFFam5AFIq@calendula>
 <CAHC9VhQ0n8Ezef8wYC7uV-MHccqHobYxoB3VYoC9TaGiFm9noQ@mail.gmail.com>
 <ZPjxnSg3/gDy25r0@orbyte.nwl.cc>
 <ZPj7cbtvF5SdaWrx@calendula>
 <CAHC9VhR5Mq76TQj-zKn4Y2=ehrsmoXUvq=zaM=zY7E9S-tu3Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhR5Mq76TQj-zKn4Y2=ehrsmoXUvq=zaM=zY7E9S-tu3Ug@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 06, 2023 at 06:41:13PM -0400, Paul Moore wrote:
> On Wed, Sep 6, 2023 at 6:21 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Sep 06, 2023 at 11:39:41PM +0200, Phil Sutter wrote:
> > > On Wed, Sep 06, 2023 at 03:56:41PM -0400, Paul Moore wrote:
> > [...]
> > > > If it is a bug, please submit a fix for this as soon as possible Pablo.
> > >
> > > Thanks for your support, but I can take over, too. The number of
> > > notifications emitted even for a small ruleset is not ideal, also. It's
> > > just a bit sad that I ACKed the patch already and so it went out the
> > > door. Florian, can we still put a veto there?
> >
> > Phil, kernel was crashing after your patch, this was resulting in a
> > kernel panic when running tests here. I had to revert your patches
> > locally to keep running tests.
> >
> > Please, just send an incremental fix to adjust the idx, revert will
> > leave things in worse state.
> 
> If we can get a fix out soon then I'm fine with that, if we can't get
> a fix out soon then a revert may be wise.

I believe it should be possible to fix this in the next -rc, which
should be quick. If Phil is busy I will jump on this and I will keep
you on Cc so you and Richard can review.

I apologize for forgetting to Cc you in first place.

> > Audit does not show chains either, which is not very useful to locate
> > what where exactly the rules have been reset, but that can probably
> > discussed in net-next. Richard provided a way to extend this if audit
> > maintainer find it useful too.
> 
> Richard was correct in saying that new fields must be added to the end
> of the record.  The only correction I would make to Richard's comments
> is that we tend to prefer that if a field is present in a record, it
> is always present in a record; if there is no useful information to
> log in that field, a "?" can be substituted for the value (e.g.
> "nftfield=?").

Thanks for clarification, hopefully this will help to explore
extensions to include chain information in the logs. I think that
might help users to understand better the kind of updated that
happened in the Netfilter subsystem.
