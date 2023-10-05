Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F94E92719
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Oct 2023 16:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbjJEQNa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Oct 2023 12:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240938AbjJEQMS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Oct 2023 12:12:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FF583FA
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Oct 2023 01:02:08 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qoJJ7-0007M7-Ew; Thu, 05 Oct 2023 10:02:05 +0200
Date:   Thu, 5 Oct 2023 10:02:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 0/5] nf_tables: nft_rule_dump_ctx fits into
 netlink_callback
Message-ID: <20231005080205.GA11420@breakpoint.cc>
References: <20230929191922.6230-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929191922.6230-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Struct netlink_callback has a 48byte scratch area for use by dump
> callbacks to keep personal stuff.
> 
> In rule dumps set up by nf_tables_getrule(), this is used only to store
> a cursor into the list of rules being dumped. Other data is allocated
> and the pointer value assigned to struct netlink_callback::data.
> 
> Since the allocated data structure is small and fits into the scratch
> area even after adding some more fields, move it there.
> 
> Patch 1 "simplifies" nf_tables_dump_rules_start() a bit, but actually
> exists only to reduce patch 5's size.
> 
> Patch 2 is more or less fallout: The memset would mess things up after
> this series, but it was pointless in the first place.
> 
> Patches 3 and 4 extend struct nft_rule_dump_ctx and make
> struct netlink_callback's scratch area unused.
> 
> Patch 5 then finally eliminates the allocation.
> 
> All this is early preparation for reset command locking but unrelated
> enough to go alone.

LGTM, I've applied this to nf-next:testing to have the buildbots
check it out.
