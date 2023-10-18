Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4C9CDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 10:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjJRKAX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 06:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjJRKAV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 06:00:21 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760B5B0;
        Wed, 18 Oct 2023 03:00:19 -0700 (PDT)
Received: from [78.30.34.192] (port=38694 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qt3Lb-00CBce-4V; Wed, 18 Oct 2023 12:00:17 +0200
Date:   Wed, 18 Oct 2023 12:00:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "U.Mutlu" <um@mutluit.com>
Cc:     imnozi@gmail.com, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
Subject: Re: [nftables/nft] nft equivalent of "ipset test"
Message-ID: <ZS+srsBsJSynJ7Tm@calendula>
References: <652EC034.7090501@mutluit.com>
 <20231017213507.GD5770@breakpoint.cc>
 <652F02EC.2050807@mutluit.com>
 <20231017220539.GE5770@breakpoint.cc>
 <652F0C75.8010006@mutluit.com>
 <20231017200057.57cfce21@playground>
 <ZS+nJS/4dolCsIk8@calendula>
 <652FAB56.5060200@mutluit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <652FAB56.5060200@mutluit.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 18, 2023 at 11:54:30AM +0200, U.Mutlu wrote:
> Pablo Neira Ayuso wrote on 10/18/23 11:36:
> > On Tue, Oct 17, 2023 at 08:00:57PM -0400, imnozi@gmail.com wrote:
> > > On Wed, 18 Oct 2023 00:36:37 +0200
> > > "U.Mutlu" <um@mutluit.com> wrote:
> > > 
> > > > ...
> > > > Actualy I need to do this monster:   :-)
> > > > 
> > > > IP="1.2.3.4"
> > > > ! nft "get element inet mytable myset  { $IP }" > /dev/null 2>&1 && \
> > > > ! nft "get element inet mytable myset2 { $IP }" > /dev/null 2>&1 && \
> > > >     nft "add element inet mytable myset  { $IP }"
> > > 
> > > Try using '||', akin to:
> > 
> > Please, use 'nft create' for this, no need for an explicit test and
> > then add from command line.
> > 
> > The idiom above is an antipattern, because it is not atomic, the
> > 'create' command provides a way to first test if the element exists
> > (if so it fails) then add it.
> 
> Pablo, unfortunately your solution with 'create' cannot be used
> in my above said special use-case of testing first in BOTH sets...

'ipset test' also requires a set to be specified.

> I just don't understand why the author cannot simply add a real 'test'
> function to the nft tool...

I just don't understand your usecase :-), why do you need this atomic
check on two different sets?

Could you explain your ruleset in more detail?

> The logic is already in 'get element' and also in your 'create' method.
