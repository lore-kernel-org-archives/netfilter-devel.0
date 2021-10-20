Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4AFC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 13:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 119EF61260
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 13:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhJTNzy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 09:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhJTNzy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 09:55:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DD9C06161C
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 06:53:39 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mdC2E-0004Qm-3a; Wed, 20 Oct 2021 15:53:38 +0200
Date:   Wed, 20 Oct 2021 15:53:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: cover baecd1cf2685 ("segtree: Fix segfault
 when restoring a huge interval set")
Message-ID: <20211020135338.GI1668@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20211020124220.489260-1-snemec@redhat.com>
 <20211020131354.GH1668@orbyte.nwl.cc>
 <20211020153801+0200.908737-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211020153801+0200.908737-snemec@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 20, 2021 at 03:38:01PM +0200, Štěpán Němec wrote:
> On Wed, 20 Oct 2021 15:13:54 +0200
> Phil Sutter wrote:
> 
> > Thanks for the patch, just one remark:
> >
> > [...]
> >> +cat >>"$ruleset_file" <<\EOF
> >                           ~~~
> > Is this backslash a typo or intentional?
> 
> It instructs the shell not to perform expansion on the heredoc lines
> (which would include interpreting '$big_set' as a shell variable).

Ah, I missed the part about quoting parts of 'word'. :)

Patch applied, thanks!

Cheers, Phil
