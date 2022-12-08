Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C78C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 13:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLHNTu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 08:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLHNTt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 08:19:49 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B36443AD5
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 05:19:48 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p3GoU-0004Kw-Aa; Thu, 08 Dec 2022 14:19:46 +0100
Date:   Thu, 8 Dec 2022 14:19:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 4/7] nft: Fix match generator for '! -i +'
Message-ID: <Y5HkcrTQwRPTL4L8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20221201163916.30808-1-phil@nwl.cc>
 <20221201163916.30808-5-phil@nwl.cc>
 <Y5HXXN4c4NpRDI4+@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5HXXN4c4NpRDI4+@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 08, 2022 at 01:23:56PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Dec 01, 2022 at 05:39:13PM +0100, Phil Sutter wrote:
> > It's actually nonsense since it will never match, but iptables accepts
> > it and the resulting nftables rule must behave identically. Reuse the
> > solution implemented into xtables-translate (by commit e179e87a1179e)
> > and turn the above match into 'iifname INVAL/D'.
> 
> Maybe starting bailing out in iptables-nft when ! -i + is used at
> ruleset load time?
> 
> As you mentioned, this rule is really useless / never matching.

Are you fine with doing it in legacy, too?

Cheers, Phil
