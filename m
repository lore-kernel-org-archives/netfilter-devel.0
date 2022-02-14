Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B16C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Feb 2022 10:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244914AbiBNKfB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Feb 2022 05:35:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348047AbiBNKed (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Feb 2022 05:34:33 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40030CD0
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Feb 2022 02:01:16 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nJYAT-0007HX-JI; Mon, 14 Feb 2022 11:01:13 +0100
Date:   Mon, 14 Feb 2022 11:01:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [iptables PATCH 2/4] tests: add `NOMATCH` test result
Message-ID: <YgooaU4M6ju9++Cy@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20220212165832.2452695-1-jeremy@azazel.net>
 <20220212165832.2452695-3-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220212165832.2452695-3-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Sat, Feb 12, 2022 at 04:58:30PM +0000, Jeremy Sowden wrote:
> Currently, there are two supported test results: `OK` and `FAIL`.  It is
> expected that either the iptables command fails, or it succeeds and
> dumping the rule has the correct output.  However, it is possible that
> the command may succeed but the output may not be correct.  Add a
> `NOMATCH` result to cover this outcome.

Hmm. Wouldn't it make sense to extend the scope of LEGACY/NFT keywords
to output checks as well instead of introducing a new one? I think we
could cover expected output that way by duplicating the test case with
different expected output instead of marking it as unspecific "may
produce garbage".

Cheers, Phil
