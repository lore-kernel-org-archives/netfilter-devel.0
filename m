Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB19EDE9A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 10:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjINKdp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 06:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbjINKdo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 06:33:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF2B1BEB
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 03:33:39 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qgjfF-00033w-MX; Thu, 14 Sep 2023 12:33:37 +0200
Date:   Thu, 14 Sep 2023 12:33:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH] Revert --compat option related commits
Message-ID: <ZQLhgeKAXY0hAaLq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <20230815160807.4033-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815160807.4033-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 15, 2023 at 06:08:07PM +0200, Phil Sutter wrote:
> This reverts the following commits:
> 
> b14c971db6db0 ("tests: Test compat mode")
> 11c464ed015b5 ("Add --compat option to *tables-nft and *-nft-restore commands")
> ca709b5784c98 ("nft: Introduce and use bool nft_handle::compat")
> 402b9b3c07c81 ("nft: Pass nft_handle to add_{target,action}()")
> 
> This implementation of a compatibility mode implements rules using
> xtables extensions if possible and thus relies upon existence of those
> in kernel space. Assuming no viable replacement for the internal
> mechanics of this mode will be found in foreseeable future, it will
> effectively block attempts at deprecating and removing of these xtables
> extensions in favor of nftables expressions and thus hinder upstream's
> future plans for iptables.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
