Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B520C636D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Feb 2023 09:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbjBWJY6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Feb 2023 04:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbjBWJY5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2023 04:24:57 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33494FCA7
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2023 01:24:55 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pV7qO-0001be-O2; Thu, 23 Feb 2023 10:24:52 +0100
Date:   Thu, 23 Feb 2023 10:24:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Devoogdt <thomas@devoogdt.com>
Subject: Re: [iptables PATCH] include: Add missing linux/netfilter/xt_LOG.h
Message-ID: <Y/cw5P/nJvYhr5R0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Devoogdt <thomas@devoogdt.com>
References: <20230222155601.31645-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222155601.31645-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 22, 2023 at 04:56:01PM +0100, Phil Sutter wrote:
> When merging IP-version-specific LOG extensions, a dependency to that
> header was introduced without caching it. Fix this and drop the now
> unused ip{,6}t_LOG.h files.
> 
> Reported-by: Thomas Devoogdt <thomas@devoogdt.com>
> Fixes: 87e4f1bf0b87b ("extensions: libip*t_LOG: Merge extensions")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
