Return-Path: <SRS0=RCn+=2A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F5FC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 01:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 410F92073D
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 01:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfLJBZq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 20:25:46 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43080 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbfLJBZp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 20:25:45 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ieUHW-0005Vg-O9; Tue, 10 Dec 2019 02:25:42 +0100
Date:   Tue, 10 Dec 2019 02:25:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [RFC PATCH nf-next] netfilter: conntrack: add support for
 storing DiffServ code-point as CT mark.
Message-ID: <20191210012542.GJ795@breakpoint.cc>
References: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191209214208.852229-1-jeremy@azazel.net>
 <20191209224710.GI795@breakpoint.cc>
 <20191209232339.GA655861@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209232339.GA655861@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> > I have older patches that adds a 'typeof' keyword for set definitions,
> > maybe it could be used for this casting too.
> 
> These?
> 
>   https://lore.kernel.org/netfilter-devel/20190816144241.11469-1-fw@strlen.de/

Yes, still did not yet have time to catch up and implement what Pablo
suggested though.
