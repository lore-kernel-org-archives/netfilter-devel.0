Return-Path: <SRS0=U5qg=5O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC16C43331
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 13:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 662EC2073B
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 13:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgC2Noq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 09:44:46 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50406 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727903AbgC2Nop (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 09:44:45 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jIYEu-0005xA-4f; Sun, 29 Mar 2020 15:44:36 +0200
Date:   Sun, 29 Mar 2020 15:44:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Sergey Marinkevich <sergey.marinkevich@eltex-co.ru>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_exthdr: fix endianness of tcp option
 cast
Message-ID: <20200329134436.GA23604@breakpoint.cc>
References: <20200329121914.GA7748@GRayJob>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329121914.GA7748@GRayJob>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sergey Marinkevich <sergey.marinkevich@eltex-co.ru> wrote:
> I got a problem on MIPS with Big-Endian is turned on: every time when
> NF trying to change TCP MSS it returns because of new.v16 was greater
> than old.v16. But real MSS was 1460 and my rule was like this:
> 
> 	add rule table chain tcp option maxseg size set 1400
> 
> And 1400 is lesser that 1460, not greater.
> 
> Later I founded that main causer is cast from u32 to __be16.

LGTM.

Acked-by: Florian Westphal <fw@strlen.de>
