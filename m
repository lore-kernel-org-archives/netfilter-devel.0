Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C91C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 14:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E7F20730
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 14:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfKTONs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 09:13:48 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:38816 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbfKTONs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 09:13:48 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXQjq-00019E-0y; Wed, 20 Nov 2019 15:13:46 +0100
Date:   Wed, 20 Nov 2019 15:13:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH libnftnl] set: Add support for NFTA_SET_SUBKEY attributes
Message-ID: <20191120141345.GL8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
References: <20191119010723.39368-1-sbrivio@redhat.com>
 <20191120112448.GI8016@orbyte.nwl.cc>
 <20191120130152.7d4d3ca8@redhat.com>
 <20191120131256.4f17cdf1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120131256.4f17cdf1@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 20, 2019 at 01:12:56PM +0100, Stefano Brivio wrote:
> On Wed, 20 Nov 2019 13:01:52 +0100
> Stefano Brivio <sbrivio@redhat.com> wrote:
> 
> > On Wed, 20 Nov 2019 12:24:48 +0100
> > Phil Sutter <phil@nwl.cc> wrote:
> >
> > [...]
> >
> > > > +		if (!*l)
> > > > +			break;
> > > > +		v = *l;
> > > > +		mnl_attr_put_u32(nlh, NFTA_SET_SUBKEY_LEN, htonl(v));    
> > > 
> > > I guess you're copying the value here because how htonl() is declared,
> > > but may it change the input value non-temporarily? I mean, libnftnl is
> > > in control over the array so from my point of view it should be OK to
> > > directly pass it to htonl().  
> > 
> > It won't change the input value at all, but that's not the point: I'm
> > reading from an array of 8-bit values and attributes are 32 bits. If I
> > htonl() directly on the input array, it's going to use 24 bits around
> > those 8 bits.
> 
> Err, wait, never mind :) I'm just passing the value, not the reference
> there -- no need to copy anything of course. I'll drop this copy in v2.

I wondered if htonl() may be implemented as a macro and therefore
side-effects are indeed possible. In fact, the opposite is the case
(declared with const attribute).

Cheers, Phil
