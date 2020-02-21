Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1A6C35669
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 21:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D1EC207FD
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 21:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgBUVRG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 16:17:06 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:57744 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgBUVRG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 16:17:06 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j5FfU-0006ly-97; Fri, 21 Feb 2020 22:17:04 +0100
Date:   Fri, 21 Feb 2020 22:17:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling entries
 in mapping table
Message-ID: <20200221211704.GM20005@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <cover.1582250437.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1582250437.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Fri, Feb 21, 2020 at 03:04:20AM +0100, Stefano Brivio wrote:
> Patch 1/2 fixes the issue recently reported by Phil on a sequence of
> add/flush/add operations, and patch 2/2 introduces a test case
> covering that.

This fixes my test case, thanks!

I found another problem, but it's maybe on user space side (and not a
crash this time ;):

| # nft add table t
| # nft add set t s '{ type inet_service . inet_service ; flags interval ; }
| # nft add element t s '{ 20-30 . 40, 25-35 . 40 }'
| # nft list ruleset
| table ip t {
| 	set s {
| 		type inet_service . inet_service
| 		flags interval
| 		elements = { 20-30 . 40 }
| 	}
| }

As you see, the second element disappears. It happens only if ranges
overlap and non-range parts are identical.

Looking at do_add_setelems(), set_to_intervals() should not be called
for concatenated ranges, although I *think* range merging happens only
there. So user space should cover for that already?! Still, it doesn't
work.

Cheers, Phil
