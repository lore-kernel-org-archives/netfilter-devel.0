Return-Path: <SRS0=bPAQ=64=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49906C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 13:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6CF206DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 13:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgENNJ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 May 2020 09:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbgENNJ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 May 2020 09:09:57 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699BFC061A0C
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 06:09:57 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jZDcZ-0000b5-Rf; Thu, 14 May 2020 15:09:55 +0200
Date:   Thu, 14 May 2020 15:09:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/3] Fix SECMARK target comparison
Message-ID: <20200514130955.GP17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200512171018.16871-1-phil@nwl.cc>
 <20200514122328.GA24661@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514122328.GA24661@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, May 14, 2020 at 02:23:28PM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 12, 2020 at 07:10:15PM +0200, Phil Sutter wrote:
> > The kernel sets struct secmark_target_info->secid, so target comparison
> > in user space failed every time. Given that target data comparison
> > happens in libiptc, fixing this is a bit harder than just adding a cmp()
> > callback to struct xtables_target. Instead, allow for targets to write
> > the matchmask bits for their private data themselves and account for
> > that in both legacy and nft code. Then make use of the new
> > infrastructure to fix libxt_SECMARK.
> 
> Hm, -D and -C with SECMARK are broken since the beginning.

Yes, sadly.

> Another possible would be to fix the kernel to update the layout, to
> get it aligned with other existing extensions.

You mean using 'usersize' just like e.g. xt_bpf.c?

One advantage of my fix is it works with old kernels as well.

Cheers, Phil
