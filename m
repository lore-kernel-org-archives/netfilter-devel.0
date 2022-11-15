Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138CDC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Nov 2022 16:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiKOQiJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 11:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiKOQiI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 11:38:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1B5BE25
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2022 08:38:08 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ouywo-0001bg-Gw; Tue, 15 Nov 2022 17:38:06 +0100
Date:   Tue, 15 Nov 2022 17:38:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] nft: replace nftnl_.*_nlmsg_build_hdr() by
 nftnl_nlmsg_build_hdr()
Message-ID: <Y3PAbksl82cJOhfi@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20221114165442.72214-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114165442.72214-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 14, 2022 at 05:54:42PM +0100, Pablo Neira Ayuso wrote:
> Replace alias to real nftnl_nlmsg_build_hdr() function call.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied, thanks!
