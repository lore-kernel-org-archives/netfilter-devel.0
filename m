Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6898C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 15:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiLVPo5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 10:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiLVPoi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 10:44:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE7432BB2
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 07:44:18 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p8Nk1-000708-5T; Thu, 22 Dec 2022 16:44:17 +0100
Date:   Thu, 22 Dec 2022 16:44:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH] nft: Reject tcp/udp extension without proper
 protocol match
Message-ID: <Y6R7USvnqmN76oAr@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <20221222150310.10977-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222150310.10977-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 22, 2022 at 04:03:10PM +0100, Phil Sutter wrote:
> Internally, 'th' expression is used, which works but matches both
> protocols. Since users won't expect '-m tcp --dport 1' to match UDP
> packets, catch missing/wrong '-p' argument.
> 
> Fixes: c034cf31dd1a9 ("nft: prefer native expressions instead of udp match")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
