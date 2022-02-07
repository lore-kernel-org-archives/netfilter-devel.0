Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4CEC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 15:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbiBGPSs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 10:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382735AbiBGPEC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 10:04:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F700C0401C2
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 07:04:01 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nH5Yc-0008M5-P4; Mon, 07 Feb 2022 16:03:58 +0100
Date:   Mon, 7 Feb 2022 16:03:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] json: add flow statement json export + parser
Message-ID: <YgE03kLLLN801Yv8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20220207132816.21129-1-fw@strlen.de>
 <20220207132816.21129-2-fw@strlen.de>
 <20220207132915.GB25000@breakpoint.cc>
 <YgEm4OBHhQ0L+0bD@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgEm4OBHhQ0L+0bD@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Feb 07, 2022 at 03:04:16PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Feb 07, 2022 at 02:29:15PM +0100, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > flow statement has no export, its shown as:
> > > ".. }, "flow add @ft" ] } }"
> > > 
> > > With this patch:
> > > 
> > > ".. }, {"flow": {"op": "add", "flowtable": "@ft"}}]}}"
> > 
> > This is based on the 'set' statement.  If you prefer the @ to
> > be removed let me know.
> 
> Then, it is consistent with the existing syntax. So either we consider
> deprecating the @ on the 'set' statement (while retaining backward
> compatibility) or flowtable also includes it as in your patch.

ACK, we should strive for internal consistency. I admittedly don't
recall why I added the '@' prefix in output, parser even demands it.
Dropping (i.e., omitting in output and accepting non-prefixed input) is
fine with me!

Thanks, Phil
