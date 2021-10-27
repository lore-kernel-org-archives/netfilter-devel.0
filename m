Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12473C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 13:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E678760F6F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 13:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhJ0Nbh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 09:31:37 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48276 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbhJ0Nbh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 09:31:37 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 966E863F04;
        Wed, 27 Oct 2021 15:27:22 +0200 (CEST)
Date:   Wed, 27 Oct 2021 15:29:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: Support netdev egress hook
Message-ID: <YXlUIuoRaI8WmbZT@salvia>
References: <20211027101715.47905-1-pablo@netfilter.org>
 <20211027121442.GA20375@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211027121442.GA20375@wunner.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 27, 2021 at 02:14:42PM +0200, Lukas Wunner wrote:
> On Wed, Oct 27, 2021 at 12:17:15PM +0200, Pablo Neira Ayuso wrote:
> > Hi Lukas,
> > 
> > This is the rebase I'm using here locally for testing, let me know if
> > you have more pending updates on your side.
> 
> I'm using the attached two patches.  The first one moves Python tests
> dup.t and fwd.t to the netdev directory, the second one adds nft egress
> support.
> 
> Phil and Florian noted back in January that the payload dumps should
> contain "oiftype" instead of "iiftype".  That's the only remaining
> issue not yet addressed in the attached patches:
> 
> https://lore.kernel.org/all/20210125133405.GR19605@breakpoint.cc/

See:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20211025134329.1030333-1-pablo@netfilter.org/

to generalize the iftype.

I still have to post a patch to update libnftnl, then update all
dumps to refer to iftype instead of iiftype.

> The difference between the patch you've posted here and the attached ones
> are primarily more extensive docs.  Also, the following two issues are
> not present in my version:
> 
> 
> > +All packets leaving the system are processed by this hook. It is invoked after
> > +layer 3 protocol handlers and after *tc* egress. It can be used for late
>                                  ^^^^^
> 				 before
> 
> > --- a/tests/py/inet/ah.t
> > +++ b/tests/py/inet/ah.t
> > @@ -1,10 +1,12 @@
> >  :input;type filter hook input priority 0
> >  :ingress;type filter hook ingress device lo priority 0
> > +:egress;type filter hook ingress device lo priority 0
>                             ^^^^^^^
> 			    egress

I'll apply these two patches if you are fine with their state.

I'd just would like to have this in the tree for easier testing,
I have to switch over several local branches here, one less makes it
slightly easier for me. And to include this in the next release.

Thanks.
