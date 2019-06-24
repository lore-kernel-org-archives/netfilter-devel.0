Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E5FC43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 16:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5102A204EC
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 16:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732237AbfFXQto (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 12:49:44 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55624 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728651AbfFXQtn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 12:49:43 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hfSA1-0002yR-Gf; Mon, 24 Jun 2019 18:49:41 +0200
Date:   Mon, 24 Jun 2019 18:49:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] files: Move netdev-ingress.nft to /etc/nftables as
 well
Message-ID: <20190624164941.dhcm57r35km3azbg@breakpoint.cc>
References: <20190624151238.4869-1-phil@nwl.cc>
 <20190624151446.2umdf4bzem4h7yqj@breakpoint.cc>
 <20190624162406.GB9218@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624162406.GB9218@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> > Right.  Do you think we should also add in inet-nat.nft example,
> > or even replace the ipvX- ones?
> 
> Having an inet family nat example would be wonderful! Can inet NAT
> replace IPvX-ones completely or are there any limitations as to what is
> possible in rules?

I'm not aware of any limitations.
