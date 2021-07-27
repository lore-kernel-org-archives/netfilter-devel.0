Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C152EC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 15:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DEAE61B26
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 15:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhG0PKV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 11:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbhG0PKV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 11:10:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36906C061757;
        Tue, 27 Jul 2021 08:10:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m8Oio-0000Q2-Bl; Tue, 27 Jul 2021 17:10:18 +0200
Date:   Tue, 27 Jul 2021 17:10:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [nft] Regarding `tcp flags` (and a potential bug)
Message-ID: <20210727151018.GA15121@breakpoint.cc>
References: <CAGnHSEkt4xLAO_T9KNw2xGjjvC4y=E0LjX-iAACUktuCy0J7gw@mail.gmail.com>
 <CAGnHSEncHuO2BduzGx1L9eVtAozdGb-XabQyrS7S+CO2swa1dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnHSEncHuO2BduzGx1L9eVtAozdGb-XabQyrS7S+CO2swa1dw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tom Yan <tom.ty89@gmail.com> wrote:
> Just noticed something that is even worse:
> 
> # nft add rule meh tcp_flags 'tcp flags { fin, rst, ack }'
> # nft add rule meh tcp_flags 'tcp flags == { fin, rst, ack }'

These two are identical.

> # nft add rule meh tcp_flags 'tcp flags & ( fin | rst | ack ) != 0'

This matches if any one of fin/rst/ack is set.

> # nft add rule meh tcp_flags 'tcp flags & ( fin | rst | ack ) == 0'

This matches if fin/rst/ack are all 0 (not set).

> # nft list table meh
> table ip meh {
>     chain tcp_flags {
>         tcp flags { fin, rst, ack }
>         tcp flags { fin, rst, ack }
>         tcp flags fin,rst,ack
>         tcp flags ! fin,rst,ack
>     }
> }

Can you elaborate?

This looks correct to me.

> > # nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) ! syn'

Its unfortunate nft accepts this.  The trailing ! syn is nonsensical.

This is equal to tcp flags ! syn.

> > # nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) == syn'
> > # nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) != syn'
> > # nft list table meh
> > table ip meh {
> >     chain tcp_flags {
> >         tcp flags & (fin | syn | rst | ack) syn
> >         tcp flags & (fin | syn | rst | ack) ! syn
> >         tcp flags syn / fin,syn,rst,ack
> >         tcp flags syn / fin,syn,rst,ack
> >     }
> > }
> >
> > I don't suppose the mask in the first two rules would matter. And with
> > `tcp flags syn / fin,syn,rst,ack`, I assume it would be false when
> > "syn is cleared and/or any/all of fin/rst/ack is/are set"?
> >
> > Also, as you can see, for the last two rules, `nft` interpreted them
> > as an identical rule, which I assume to be a bug. These does NOT seem
> > to workaround it either:
> >
> > # nft flush chain meh tcp_flags
> > # nft add rule meh tcp_flags 'tcp flags == syn / fin,syn,rst,ack'
> > # nft add rule meh tcp_flags 'tcp flags != syn / fin,syn,rst,ack'
> > # nft list table meh
> > table ip meh {
> >     chain tcp_flags {
> >         tcp flags syn / fin,syn,rst,ack
> >         tcp flags syn / fin,syn,rst,ack

Seems the reverse translation is broken, the negation is lost.
The rule is added correctly (i.e., flags == syn vs. != syn adds
different rules, see nft --debug=netlink add ..
