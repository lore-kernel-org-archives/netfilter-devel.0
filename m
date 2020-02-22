Return-Path: <SRS0=8vd7=4K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA74C35669
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 01:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3D442071E
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 01:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBVBTf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 20:19:35 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58138 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgBVBTf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 20:19:35 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j5JS9-0001UZ-E2; Sat, 22 Feb 2020 02:19:33 +0100
Date:   Sat, 22 Feb 2020 02:19:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling entries
 in mapping table
Message-ID: <20200222011933.GO20005@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <cover.1582250437.git.sbrivio@redhat.com>
 <20200221211704.GM20005@orbyte.nwl.cc>
 <20200221232218.2157d72b@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221232218.2157d72b@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Fri, Feb 21, 2020 at 11:22:18PM +0100, Stefano Brivio wrote:
> On Fri, 21 Feb 2020 22:17:04 +0100
> Phil Sutter <phil@nwl.cc> wrote:
> 
> > Hi Stefano,
> > 
> > On Fri, Feb 21, 2020 at 03:04:20AM +0100, Stefano Brivio wrote:
> > > Patch 1/2 fixes the issue recently reported by Phil on a sequence of
> > > add/flush/add operations, and patch 2/2 introduces a test case
> > > covering that.  
> > 
> > This fixes my test case, thanks!
> > 
> > I found another problem, but it's maybe on user space side (and not a
> > crash this time ;):
> > 
> > | # nft add table t
> > | # nft add set t s '{ type inet_service . inet_service ; flags interval ; }
> > | # nft add element t s '{ 20-30 . 40, 25-35 . 40 }'
> > | # nft list ruleset
> > | table ip t {
> > | 	set s {
> > | 		type inet_service . inet_service
> > | 		flags interval
> > | 		elements = { 20-30 . 40 }
> > | 	}
> > | }
> > 
> > As you see, the second element disappears. It happens only if ranges
> > overlap and non-range parts are identical.
> >
> > Looking at do_add_setelems(), set_to_intervals() should not be called
> > for concatenated ranges, although I *think* range merging happens only
> > there. So user space should cover for that already?!
> 
> Yes. I didn't consider the need for this kind of specification, given
> that you can obtain the same result by simply adding two elements:
> separate, partially overlapping elements can be inserted (which is, if I
> recall correctly, not the case for rbtree).
> 
> If I recall correctly, we had a short discussion with Florian about
> this, but I don't remember the conclusion.
> 
> However, I see the ugliness, and how this breaks probably legitimate
> expectations. I guess we could call set_to_intervals() in this case,
> that function might need some minor adjustments.
> 
> An alternative, and I'm not sure which one is the most desirable, would
> be to refuse that kind of insertion.

I don't think having concatenated ranges not merge even if possible is a
problem. It's just a "nice feature" with some controversial aspects.

The bug I'm reporting is that Above 'add element' command passes two
elements to nftables but only the first one makes it into the set. If
overlapping elements are fine in pipapo, they should both be there. If
not (or otherwise unwanted), we better error out instead of silently
dropping the second one.

Cheers, Phil
