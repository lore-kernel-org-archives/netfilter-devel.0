Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEECC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 17:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351828AbhLARW0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 12:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351734AbhLARWZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 12:22:25 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FC8C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 09:18:59 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1msTFx-0007WP-1H; Wed, 01 Dec 2021 18:18:57 +0100
Date:   Wed, 1 Dec 2021 18:18:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/5] Reduce cache overhead a bit
Message-ID: <20211201171857.GI29413@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20211201150258.18436-1-phil@nwl.cc>
 <YaenaMa1rcu5BX4U@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaenaMa1rcu5BX4U@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 01, 2021 at 05:48:40PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Wed, Dec 01, 2021 at 04:02:53PM +0100, Phil Sutter wrote:
> > Comparing performance of various commands with equivalent iptables ones
> > I noticed that nftables fetches data from kernel it doesn't need in some
> > cases. For instance, listing one table was slowed down by a large other
> > table.
> > 
> > Since there is already code to filter data added to cache, make use of
> > that and craft GET requests to kernel a bit further so it returns only
> > what is needed.
> 
> Using netlink to filter from kernel space is the optimal solution.

I was basically copying from iptables-nft. :)

> > This series is not entirely complete, e.g. objects are still fetched as
> > before. It rather converts some low hanging fruits.
> 
> Only one thing: It would be good to test this on older kernels,
> because IIRC some of the GET requests during the development, I would
> suggest to give it a test with -stable kernels. Probably all of the
> needed GET commands are already present there.

Good point, thanks. I'll check and report.

> In the nftables 1.0.1 release process, I tested it with 4.9.x and
> tests where running fine, the error reports were coming from missing
> features.

If ENOENT wasn't reported as EINVAL, We could even fall back to plain
NLM_F_DUMP on older kernels. Maybe tackle that first and build upon
that?

Cheers, Phil
