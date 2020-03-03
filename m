Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBEBC3F2D1
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 01:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E34F21556
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 01:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgCCBP7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 20:15:59 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54066 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgCCBP7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 20:15:59 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j8wA9-00067S-Vv; Tue, 03 Mar 2020 02:15:58 +0100
Date:   Tue, 3 Mar 2020 02:15:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 2/4] nft: cache: Make nft_rebuild_cache()
 respect fake cache
Message-ID: <20200303011557.GC5627@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200302175358.27796-1-phil@nwl.cc>
 <20200302175358.27796-3-phil@nwl.cc>
 <20200302192604.rzhx4ayog4xqq3ut@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302192604.rzhx4ayog4xqq3ut@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Mar 02, 2020 at 08:26:04PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Mar 02, 2020 at 06:53:56PM +0100, Phil Sutter wrote:
> > If transaction needed a refresh in nft_action(), restore with flush
> > would fetch a full cache instead of merely refreshing table list
> > contained in "fake" cache.
> > 
> > To fix this, nft_rebuild_cache() must distinguish between fake cache and
> > full rule cache. Therefore introduce NFT_CL_FAKE to be distinguished
> > from NFT_CL_RULES.
> 
> Please, refresh me: Why do we need this "fake cache" in first place?

In short: It is a middle-ground between needlessly fetching a full cache
and hitting ENOENT because we may not delete a table that doesn't exist.

Long version:

A) Full cache is not needed for iptables-nft-restore without --noflush.
   It is supposed to drop whatever is there and push the rule set it is
   fed with. Yet it shall only affect its "own" tables, so simple 'flush
   ruleset' at start of transaction is not OK.

B) Simple 'delete table' at each '*table' line may cause ENOENT if table
   does not exist, so list of existing tables must be fetched from
   kernel. Since that may change, the whole nft_rebuild_cache() thing
   was created.

At NFWS we discussed 'create'/'destroy' commands as alternatives to
'add'/'delete' which cause errors if existing/missing and change the
latter to not do that. With this in place, iptables-nft-restore could
get by without a cache at all. Another option would be to do a sequence
of add/delete/add for each table line which works because 'add' command
is accepted even if table already exists.

Cheers, Phil
