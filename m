Return-Path: <SRS0=yEJZ=DP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425D5C433E7
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 17:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB28720578
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 17:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgJHRCr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 13:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgJHRCr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 13:02:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7A5C061755
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 10:02:47 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kQZJV-0007fP-CV; Thu, 08 Oct 2020 19:02:45 +0200
Date:   Thu, 8 Oct 2020 19:02:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Gopal Yadav <gopunop@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] Solves Bug 1462 - `nft -j list set` does not show
 counters
Message-ID: <20201008170245.GC13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Gopal Yadav <gopunop@gmail.com>, netfilter-devel@vger.kernel.org
References: <20201007140337.21218-1-gopunop@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007140337.21218-1-gopunop@gmail.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 07, 2020 at 07:33:37PM +0530, Gopal Yadav wrote:
> Solves Bug 1462 - `nft -j list set` does not show counters
> 
> Signed-off-by: Gopal Yadav <gopunop@gmail.com>

Added a comment about potential clashes (json_object_update_missing()
hides those) and replaced the duplicate subject line by a commit
message, then applied the result.

Thanks, Phil
