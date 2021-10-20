Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96288C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 13:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76965610A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 13:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhJTNQM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 09:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhJTNQM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 09:16:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0ABC06161C
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 06:13:57 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mdBPm-00044y-Us; Wed, 20 Oct 2021 15:13:54 +0200
Date:   Wed, 20 Oct 2021 15:13:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: cover baecd1cf2685 ("segtree: Fix segfault
 when restoring a huge interval set")
Message-ID: <20211020131354.GH1668@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20211020124220.489260-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211020124220.489260-1-snemec@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stepan,

On Wed, Oct 20, 2021 at 02:42:20PM +0200, Štěpán Němec wrote:
> Test inspired by [1] with both the set and stack size reduced by the
> same power of 2, to preserve the (pre-baecd1cf2685) segfault on one
> hand, and make the test successfully complete (post-baecd1cf2685) in a
> few seconds even on weaker hardware on the other.
> 
> (The reason I stopped at 128kB stack size is that with 64kB I was
> getting segfaults even with baecd1cf2685 applied.)
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1908127
> 
> Signed-off-by: Štěpán Němec <snemec@redhat.com>
> Helped-by: Phil Sutter <phil@nwl.cc>

Thanks for the patch, just one remark:

[...]
> +cat >>"$ruleset_file" <<\EOF
                          ~~~
Is this backslash a typo or intentional?

Cheers, Phil
