Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2012FC76191
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01CD62084C
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfGUSuI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 14:50:08 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50142 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfGUSuI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 14:50:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hpGuN-0006ID-2k; Sun, 21 Jul 2019 20:50:07 +0200
Date:   Sun, 21 Jul 2019 20:50:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] src: erec: fall back to internal location if its
 null
Message-ID: <20190721185007.hj5v63fryk6j2qpx@breakpoint.cc>
References: <20190721001406.23785-1-fw@strlen.de>
 <20190721001406.23785-2-fw@strlen.de>
 <20190721184618.pfcmtt34xr5zaqwb@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190721184618.pfcmtt34xr5zaqwb@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jul 21, 2019 at 02:14:05AM +0200, Florian Westphal wrote:
> > This should never happen (we should pass valid locations to the error
> > reporting functions), but in case we screw up we will segfault during
> > error reporting.
> > 
> > cat crash
> > table inet filter {
> > }
> > table inet filter {
> >       chain test {
> >         counter
> >     }
> > }
> > "nft -f crash" Now reports:
> > internal:0:0-0: Error: No such file or directory
> > 
> > ... which is both bogus and useless, but better than crashing.
> 
> This should not ever happen, right?

It happens with current master plus above file.
