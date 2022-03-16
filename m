Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFB0C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Mar 2022 19:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiCPTMb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 15:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiCPTMb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 15:12:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658623F8BC
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2022 12:11:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nUZ39-0007mR-3D; Wed, 16 Mar 2022 20:11:11 +0100
Date:   Wed, 16 Mar 2022 20:11:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/3] nft: Reject standard targets as chain names
 when restoring
Message-ID: <20220316191111.GE9936@breakpoint.cc>
References: <20220316174443.1930-1-phil@nwl.cc>
 <20220316174443.1930-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316174443.1930-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Reuse parse_chain() called from do_parse() for '-N' and rename it for a
> better description of what it does.
> 
> Note that by itself, this patch will likely kill iptables-restore
> performance for big rulesets due to the extra extension lookup for chain
> lines. A following patch announcing those chains to libxtables will
> alleviate that.

Reviewed-by: Florian Westphal <fw@strlen.de>
