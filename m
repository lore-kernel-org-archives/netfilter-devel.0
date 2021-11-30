Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D520C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 13:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241858AbhK3N7A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 08:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhK3N67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 08:58:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDF8C061746
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 05:55:38 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ms3bc-0000Tu-Mk; Tue, 30 Nov 2021 14:55:36 +0100
Date:   Tue, 30 Nov 2021 14:55:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/15] Fix netlink debug output on Big Endian
Message-ID: <20211130135536.GE29413@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20211124172251.11539-1-phil@nwl.cc>
 <YaYrhZzHJZQYksx6@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaYrhZzHJZQYksx6@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Nov 30, 2021 at 02:47:49PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 24, 2021 at 06:22:36PM +0100, Phil Sutter wrote:
> > Make use of recent changes to libnftnl and make tests/py testsuite pass
> > on Big Endian systems.
> > 
> > Patches 1, 2 and 3 are more or less unrelated fallout from the actual
> > work but simple enough to not deserve separate submission.
> > 
> > Patches 4-9 fix actual bugs on Big Endian.
> 
> I think up to patch 9 should be good to be merged upstream as these
> are asorted updates + actual Big Endian bugs as you describe.
> 
> Let's discuss patches start 10 and your libnftnl updates separately,
> OK?

Fine with me, thanks for the (quick) review. I'll push patches 1-9, will
get back at your remarks on the libnftnl series later. Then we'll see
what remains from patches 10-15 here.

Thanks, Phil
