Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834FAC35673
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 618A320675
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgBWWe1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 17:34:27 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45768 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbgBWWe1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 17:34:27 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j5zpQ-0004Fa-Kj; Sun, 23 Feb 2020 23:34:24 +0100
Date:   Sun, 23 Feb 2020 23:34:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evaluate: don't eval unary arguments.
Message-ID: <20200223223424.GZ19559@breakpoint.cc>
References: <20200128184918.d663llqkrmaxyusl@salvia>
 <20200223221411.GA121279@azazel.net>
 <20200223222321.kjfsxjl6ftbcrink@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223222321.kjfsxjl6ftbcrink@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Feb 23, 2020 at 10:14:11PM +0000, Jeremy Sowden wrote:
> > After giving this some thought, it occurred to me that this could be
> > fixed by extending bitwise boolean operations to support a variable
> > righthand operand (IIRC, before Christmas Florian suggested something
> > along these lines to me in another, related context), so I've gone down
> > that route.  Patches to follow shortly.
> 
> Would this require a new kernel extensions? What's the idea behind
> this?

Something like this:
nft ... ct mark set ct mark & 0xffff0000 | meta mark & 0xffff
