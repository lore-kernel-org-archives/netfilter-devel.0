Return-Path: <SRS0=aLv2=BJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF20C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jul 2020 22:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F22E92083E
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jul 2020 22:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgG3W2N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jul 2020 18:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730397AbgG3W2N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jul 2020 18:28:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B43C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2020 15:28:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k1H20-0004Y0-2L; Fri, 31 Jul 2020 00:28:08 +0200
Date:   Fri, 31 Jul 2020 00:28:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Michael Zhou <mzhou@cse.unsw.edu.au>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: TEST Re: [PATCH] net/ipv6/netfilter/ip6t_NPT: rewrite addresses
 in ICMPv6 original packet
Message-ID: <20200730222808.GF5271@breakpoint.cc>
References: <20200720131701.17941-1-mzhou@cse.unsw.edu.au>
 <20200729204323.GA11285@salvia>
 <20200730141503.3eb212db@dvsy1.host.maki.stream>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730141503.3eb212db@dvsy1.host.maki.stream>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Michael Zhou <mzhou@cse.unsw.edu.au> wrote:
> Thanks for the comments.
> 
> On Wed, 29 Jul 2020 22:43:23 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > This ICMPv6 header might fall withing the non-linear data of the
> > skbuff.
> 
> Might you be able to point me to an example of how to handle and test
> this? So far in my testing it has always been in the linear data.

Look at skb_header_pointer() function and other users of it.

> > BTW, does rfc6296 describes what to do with icmp traffic?
> 
> Unfortunately not. Do you think this functionality should be an
> optional flag or be part of a different target to maintain conformance
> with the RFC?

Handling it automatically seems sane to me.
