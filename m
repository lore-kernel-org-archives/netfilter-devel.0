Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFE0C28CC3
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 08:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E54124A9B
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 08:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfFAIxi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 04:53:38 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35842 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbfFAIxi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 04:53:38 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hWzlf-0001Va-Q3; Sat, 01 Jun 2019 10:53:36 +0200
Date:   Sat, 1 Jun 2019 10:53:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190601085335.axjlmtl23py6i4jo@breakpoint.cc>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
 <20190601002230.bo6dhdf3lhlkknqq@salvia>
 <20190601082732.fpgrqtcj7i7g6wek@breakpoint.cc>
 <20190601084025.rheeejbn3clpgsmu@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601084025.rheeejbn3clpgsmu@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >         if (skb->protocol != htons(ETH_P_IP))
> > >                 goto err;
> > 
> > Wouldn't it be preferable to just use nft_pf() != NFPROTO_IPV4?
> 
> Then IPv4 options extension won't work from bridge and netdev families
> too, right?

Ah, right.
