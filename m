Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BBFEB64DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jul 2023 16:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjGQQXs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jul 2023 12:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjGQQXr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2023 12:23:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4987B130
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2023 09:23:45 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qLR0g-0005ti-M8; Mon, 17 Jul 2023 18:23:42 +0200
Date:   Mon, 17 Jul 2023 18:23:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        igor@gooddata.com
Subject: Re: [iptables PATCH 1/3] extensions: libebt_among: Fix for false
 positive match comparison
Message-ID: <ZLVrDhAlRx7A0Fd2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        igor@gooddata.com
References: <20230715125928.18395-1-phil@nwl.cc>
 <20230715125928.18395-2-phil@nwl.cc>
 <ZLUg97WtqnWR6aqT@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLUg97WtqnWR6aqT@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 17, 2023 at 01:07:35PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Sat, Jul 15, 2023 at 02:59:26PM +0200, Phil Sutter wrote:
> > When comparing matches for equality, trailing data in among match is not
> > considered. Therefore two matches with identical pairs count may be
> > treated as identical when the pairs actually differ.
> 
> By "trailing data", you mean the right-hand side of this?
> 
>         fe:ed:ba:be:00:01=10.0.0.1

I mean field "pairs" in struct nft_among_data:

| struct nft_among_data {
|         struct {
|                 size_t cnt;
|                 bool inv;
|                 bool ip;
|         } src, dst; 
|         uint32_t pairs_hash;
|         /* first source, then dest pairs */
|         struct nft_among_pair pairs[0];
| };

So basically all pairs are being ignored. As long as the number and type (with
IP or not) of pairs and the invert flag matches, match data was considered
identical.

> > Matches' parsing callbacks have no access to the xtables_match itself,
> > so can't update userspacesize field as needed.
> > 
> > To fix this, extend struct nft_among_data by a hash field to contain a
> > DJB hash of the trailing data.
> 
> Is this DJB hash use subject to collisions?

Could be. I considered it "good enough", but didn't try how easy it is
to cause a collision. Are you suggesting to use a more secure algorithm?

Thanks, Phil
