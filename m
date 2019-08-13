Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39922C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 174972067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfHMTel (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:34:41 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57450 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725923AbfHMTel (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 15:34:41 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hxcZ5-0003wp-Ob; Tue, 13 Aug 2019 21:34:39 +0200
Date:   Tue, 13 Aug 2019 21:34:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 1/4] src: fix jumps on bigendian arches
Message-ID: <20190813193439.domojznfkzp3g7ih@breakpoint.cc>
References: <20190813184409.10757-1-fw@strlen.de>
 <20190813184409.10757-2-fw@strlen.de>
 <20190813192049.enr7yczyngth4s4o@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813192049.enr7yczyngth4s4o@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  	char chain[NFT_CHAIN_MAXNAMELEN];
> 
> Probably:
> 
>         chat chain[NFT_CHAIN_MAXNAMELEN + 1] = {};


> to ensure space for \0.

Not sure thats needed, the policy is:

[NFTA_CHAIN_NAME] = { .type = NLA_STRING,
		      .len = NFT_CHAIN_MAXNAMELEN - 1 },

> > +	unsigned int len;
> > +
> > +	memset(chain, 0, sizeof(chain));
> 
> remove this memset then.
> 
> > +	len = e->len / BITS_PER_BYTE;
> 
>         div_round_up() ?

Do we have strings that are not divisible by BITS_PER_BYTE?

> > +	if (len >= sizeof(chain))
> > +		len = sizeof(chain) - 1;
> 
> Probably BUG() here instead if e->len > NFT_CHAIN_MAXNAMELEN? This
> should not happen.

Yes, I can change this.
