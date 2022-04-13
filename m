Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC79C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 00:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiDMAEg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 20:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiDMAEe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 20:04:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341FA193E8
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 17:02:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1neQSa-0003Q4-5L; Wed, 13 Apr 2022 02:02:12 +0200
Date:   Wed, 13 Apr 2022 02:02:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 0/9] nftables: add support for wildcard string
 as set keys
Message-ID: <20220413000212.GH10279@breakpoint.cc>
References: <20220409135832.17401-1-fw@strlen.de>
 <YlX6gfgq4SFPTU+B@salvia>
 <20220412224335.GB10279@breakpoint.cc>
 <YlYGXSrxnspdBzr5@salvia>
 <20220412233023.GF10279@breakpoint.cc>
 <YlYOHUwlic4fNzAD@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlYOHUwlic4fNzAD@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> OK, then move on.
> 
> Sorry, I read you cover letter and I thought there were pending
> issues.

Ok great, thanks!

Sorry for the confusion.  I meant to say that only "key ifname; flags
inerval" will work after this patchset, and that thinks like
"eth0-eth4" or "key ifname . ipv4_addr" do not.

I plan to work on that too at some point. I will let you know when I
start to work on it.
