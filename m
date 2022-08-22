Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D937C28D13
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiHVUx7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiHVUx5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 16:53:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7D97183A1;
        Mon, 22 Aug 2022 13:53:55 -0700 (PDT)
Date:   Mon, 22 Aug 2022 22:53:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Amish <anon.amish@gmail.com>
Cc:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Optimization works only on specific syntax? (was [ANNOUNCE]
 nftables 1.0.5 release)
Message-ID: <YwPs3eBF/7IOhlHS@salvia>
References: <YvK7fkPf6P52MV+w@salvia>
 <fff1fe66-9bad-a732-12ad-133bd9c40218@gmail.com>
 <71eda095-f021-3d00-7ad8-568b934ac194@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71eda095-f021-3d00-7ad8-568b934ac194@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Aug 22, 2022 at 08:53:39PM +0530, Amish wrote:
> On 15/08/22 06:30, Amish wrote:
> > On 10/08/22 01:24, Pablo Neira Ayuso wrote:
> > > - Fixes for the -o/--optimize, run this --optimize option to
> > > automagically
> > >    compact your ruleset using sets, maps and concatenations, eg.
> > > 
> > >       # cat ruleset.nft
> > >       table ip x {
> > >              chain y {
> > >                      type nat hook postrouting priority srcnat;
> > > policy drop;
> > >                      ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
> > >                      ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
> > >              }
> > >       }
> > > 
> > >       # nft -o -c -f ruleset.nft
> > >       Merging:
> > >       ruleset.nft:4:3-52:                ip saddr 1.1.1.1 tcp dport
> > > 8000 snat to 4.4.4.4:80
> > >       ruleset.nft:5:3-52:                ip saddr 2.2.2.2 tcp dport
> > > 8001 snat to 5.5.5.5:90
> > >       into:
> > >              snat to ip saddr . tcp dport map { 1.1.1.1 . 8000 :
> > > 4.4.4.4 . 80, 2.2.2.2 . 8001 : 5.5.5.5 . 90 }
> > 
> > This optimization seems to be working only on specific syntax.
> > 
> > If I mention same thing with alternative syntax, there is no suggestion
> > to optimize.
> > 
> > # cat ruleset.nft
> > add table ip x
> > add chain ip x y { type nat hook postrouting priority srcnat; policy
> > drop; }
> > add rule ip x y ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
> > add rule ip x y ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
> > 
> > # nft -o -c -f ruleset.nft
> > <no output with exit code 0>
> > 
> > Which means that no optimization is suggested but check passed
> > successfully.
> > 
> > I was expecting that it will reply with:
> > 
> > Merging:
> >  ...
> > into:
> >     add rule ip x y snat to ip saddr . tcp dport map { 1.1.1.1 . 8000 :
> > 4.4.4.4 . 80, 2.2.2.2 . 8001 : 5.5.5.5 . 90 }
> > 
> > OR if it can not translate to exact syntax then atleast it should
> > mention that there is possibility to optimize the rules.
> > 
> > Is there any reason? Am I doing something wrong?

The plain syntax is not supported yet, that's all, it needs a bit of work.
