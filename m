Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1840C6FA9D
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Mar 2023 19:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCATQY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Mar 2023 14:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCATQX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2023 14:16:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5EC4DBC8
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2023 11:16:22 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pXRw3-0001kn-PM; Wed, 01 Mar 2023 20:16:19 +0100
Date:   Wed, 1 Mar 2023 20:16:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Garver <eric@garver.life>
Subject: Re: [iptables PATCH] nft-restore: Fix for deletion of new,
 referenced rule
Message-ID: <Y/+kgw1Crwh+3TqB@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
References: <20230228171549.28483-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228171549.28483-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 28, 2023 at 06:15:49PM +0100, Phil Sutter wrote:
> Combining multiple corner-cases here:
> 
> * Insert a rule before another new one which is not the first. Triggers
>   NFTNL_RULE_ID assignment of the latter.
> 
> * Delete the referenced new rule in the same batch again. Causes
>   overwriting of the previously assigned RULE_ID.
> 
> Consequently, iptables-nft-restore fails during *insert*, because the
> reference is dangling.
> 
> Reported-by: Eric Garver <eric@garver.life>
> Fixes: 760b35b46e4cc ("nft: Fix for add and delete of same rule in single batch")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
