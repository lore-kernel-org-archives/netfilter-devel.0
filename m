Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D805C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 21:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiLHVVG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 16:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHVVF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 16:21:05 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 369B010DC
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 13:21:05 -0800 (PST)
Date:   Thu, 8 Dec 2022 22:21:02 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 1/4] xt: Delay libxtables access until translation
Message-ID: <Y5JVPqq30gcoYT9X@salvia>
References: <20221124165641.26921-1-phil@nwl.cc>
 <20221124165641.26921-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221124165641.26921-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, Nov 24, 2022 at 05:56:38PM +0100, Phil Sutter wrote:
> There is no point in spending efforts setting up the xt match/target
> when it is not printed afterwards. So just store the statement data from
> libnftnl in struct xt_stmt and perform the extension lookup from
> xt_stmt_xlate() instead.

There is nft -i and nft monitor which keep a ruleset cache. Both are
sort of incomplete: nft -i resorts to cleaning up the cache based on
the generation number and nft monitor still needs to be updated to
keep track of incremental ruleset updates via netlink events. Sooner
or later these two will get better support for incremental ruleset
updates.

I mean, in those two cases, every call to print the translation will
trigger the allocation of the xt structures, fill them and then call
.xlate. I agree it is a bit more work, I guess this won't case any
noticeable penalty, but it might be work that needs to be done over
and over again when ruleset uses xt match / target.
