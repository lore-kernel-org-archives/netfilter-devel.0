Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4148BC4167B
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 10:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjKCK46 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 06:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjKCK46 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 06:56:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF21D7
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 03:56:55 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qyrrA-0000lF-OC; Fri, 03 Nov 2023 11:56:52 +0100
Date:   Fri, 3 Nov 2023 11:56:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZUTR9EAJZGhNfDa6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
References: <ZSa+h18/ZNRxLpzq@orbyte.nwl.cc>
 <ZSbD9fPv2Ltx8Cx2@calendula>
 <ZTE8xaZfFJoQRhjY@calendula>
 <ZTFJ4yXd7nZxjAJz@orbyte.nwl.cc>
 <ZUOJNnKJRKwj379J@calendula>
 <ZUOVrlIgCSIM8Ule@orbyte.nwl.cc>
 <ZUQTWSEXbw2paJ3v@calendula>
 <ZUTEfXMw2e5kMJ5A@orbyte.nwl.cc>
 <ZUTPG3XsdIFu8RRb@orbyte.nwl.cc>
 <ZUTQOqAS9EvI6/jV@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUTQOqAS9EvI6/jV@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 11:49:30AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 03, 2023 at 11:44:43AM +0100, Phil Sutter wrote:
> > On Fri, Nov 03, 2023 at 10:59:25AM +0100, Phil Sutter wrote:
> > [...]
> > > One would have to change it to work based on *.y branches and the actual
> > > commits in there. I'll give it a quick try, shouldn't be too hard
> > > indeed.
> > 
> > Please kindly find attached a "stable branch fork" of
> > collect_backports.sh. I was too lazy to check its output for missing
> > commits, but the ones it returns seem entirely valid.
> 
> Would you mind to post the list of missing commits in 1.0.6.y?
> 
> I am too lazy to run it.
> 

eac68b84227a3fc46572f3bae1113eaa91d13f24
8519ab031d8022999603a69ee9f18e8cfb06645d
4e8aa050312822400124260bf6b630c3c05cb04d
f65b2d12236174d477c55e96c4027cd51185ba5e
122dce6b35205a3df419a5cae9acfd6e83e8725a
e4c9f9f7e0d1f83be18f6c4a418da503e9021b24
d392ddf243dcbf8a34726c777d2c669b1e8bfa85

Cheers, Phil
