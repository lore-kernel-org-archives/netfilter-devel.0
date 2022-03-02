Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFBAC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 20:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242976AbiCBUSA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 15:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237884AbiCBUR7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 15:17:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F8DCD5EA
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 12:17:15 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nPVPL-0006DV-Df; Wed, 02 Mar 2022 21:17:11 +0100
Date:   Wed, 2 Mar 2022 21:17:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/2] Improve error messages for unsupported
 extensions
Message-ID: <Yh/Qx5XRVdOcHsaI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220211171211.26484-1-phil@nwl.cc>
 <Yh+ErK+pGFu4I+3U@orbyte.nwl.cc>
 <20220302150616.GC8249@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302150616.GC8249@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

On Wed, Mar 02, 2022 at 04:06:16PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > *bump*
> 
> Looks good to me.  Feel free to push this if it passes the tests on
> a normal distro kernel.

Thanks for the review. Just tested on Fedora 35. All tests pass after
changing the SELinux context string in libxt_SECMARK.t - a known
problem.

Cheers, Phil
