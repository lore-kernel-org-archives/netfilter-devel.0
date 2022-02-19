Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3AFC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242349AbiBSNmU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:42:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiBSNmU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:42:20 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740AA6557
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:42:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nLPzr-0007ae-QK; Sat, 19 Feb 2022 14:41:59 +0100
Date:   Sat, 19 Feb 2022 14:41:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: conntrack: Relax helper
 auto-assignment warning for nftables
Message-ID: <20220219134159.GB27537@breakpoint.cc>
References: <20220219132024.29328-1-phil@nwl.cc>
 <20220219132547.GA27537@breakpoint.cc>
 <YhDxiXjhNrPLW9Oc@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhDxiXjhNrPLW9Oc@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> I tried, but nf_ct_pernet() is not usable from module context, or
> actually symbol nf_conntrack_net_id. So I had to introduce a routine to
> set the value. On the other hand I didn't like the fact that it would
> permanently disable the warning even after 'nft flush ruleset'
> (nit-picking).
> I can recover that approach and send a v2 if you think (re-)using refcnt
> is a bad idea here.

I think its a good idea to add a helper function disable the warning.

We can also call it from xt_CT.c.
