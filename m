Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFD4C77B73
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 May 2023 13:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjE3NFH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 May 2023 09:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjE3NEv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2023 09:04:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C363192
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2023 06:04:49 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1q3z1r-0004s7-1V; Tue, 30 May 2023 15:04:47 +0200
Date:   Tue, 30 May 2023 15:04:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: fix memory leak in should_load_proto
Message-ID: <ZHX0b8i6sjuuyx5U@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Christian Marangi <ansuelsmth@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20230529171846.10616-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529171846.10616-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Christian,

On Mon, May 29, 2023 at 07:18:46PM +0200, Christian Marangi wrote:
> With the help of a Coverity Scan, it was pointed out that it's present a
> memory leak in the corner case where find_proto is not NULL in the
> function should_load_proto. find_proto return a struct xtables_match
> pointer from xtables_find_match that is allocated but never freed.
> 
> Correctly free the found proto in the corner case where find_proto
> succeed.

We have a '--valgrind' mode in shell testsuite and this has not been
identified yet. So assuming your finding is correct, we lack a proper
test case. Can you provide a reproducer (ideally as shell test-case)?

Also I wonder if we can provide a Fixes: tag. The code in question is
very old, so maybe hard to find.

Thanks, Phil
