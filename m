Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083DFC6FD1E
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 11:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjCJLq6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjCJLqw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 06:46:52 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A3E112595
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 03:46:46 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pabCv-0001al-Bq; Fri, 10 Mar 2023 12:46:45 +0100
Date:   Fri, 10 Mar 2023 12:46:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] xt: Fix fallback printing for extensions matching
 keywords
Message-ID: <ZAsYpctpm13XEBx4@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230309134350.9803-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309134350.9803-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 09, 2023 at 02:43:50PM +0100, Phil Sutter wrote:
> Yet another Bison workaround: Instead of the fancy error message, an
> incomprehensible syntax error is emitted:
> 
> | # iptables-nft -A FORWARD -p tcp -m osf --genre linux
> | # nft list ruleset | nft -f -
> | # Warning: table ip filter is managed by iptables-nft, do not touch!
> | /dev/stdin:4:29-31: Error: syntax error, unexpected osf, expecting string
> | 		meta l4proto tcp xt match osf counter packets 0 bytes 0
> | 		                          ^^^
> 
> Avoid this by quoting the extension name when printing:
> 
> | # nft list ruleset | sudo ./src/nft -f -
> | # Warning: table ip filter is managed by iptables-nft, do not touch!
> | /dev/stdin:4:20-33: Error: unsupported xtables compat expression, use iptables-nft with this ruleset
> | 		meta l4proto tcp xt match "osf" counter packets 0 bytes 0
> | 		                 ^^^^^^^^^^^^^^
> 
> Fixes: 79195a8cc9e9d ("xt: Rewrite unsupported compat expression dumping")
> Fixes: e41c53ca5b043 ("xt: Fall back to generic printing from translation")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
