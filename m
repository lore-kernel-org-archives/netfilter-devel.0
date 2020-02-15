Return-Path: <SRS0=bjic=4D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD512C352A3
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Feb 2020 22:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 937DC2083B
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Feb 2020 22:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgBOW65 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Feb 2020 17:58:57 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:43626 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgBOW65 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Feb 2020 17:58:57 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j36Ol-0003XA-JN; Sat, 15 Feb 2020 23:58:55 +0100
Date:   Sat, 15 Feb 2020 23:58:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] src: Fix nftnl_assert() on data_len
Message-ID: <20200215225855.GU20005@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200214172417.11217-1-phil@nwl.cc>
 <20200214173247.2wbrvcqilqfmcqq5@salvia>
 <20200214173450.GR20005@orbyte.nwl.cc>
 <20200214174200.4xrvnlb72qebtvnb@salvia>
 <20200215004311.GS20005@orbyte.nwl.cc>
 <20200215131713.5gwn4ayk2udjff33@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200215131713.5gwn4ayk2udjff33@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sat, Feb 15, 2020 at 02:17:13PM +0100, Pablo Neira Ayuso wrote:
> On Sat, Feb 15, 2020 at 01:43:11AM +0100, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Fri, Feb 14, 2020 at 06:42:00PM +0100, Pablo Neira Ayuso wrote:
> > > On Fri, Feb 14, 2020 at 06:34:50PM +0100, Phil Sutter wrote:
> > > > On Fri, Feb 14, 2020 at 06:32:47PM +0100, Pablo Neira Ayuso wrote:
> > > > > On Fri, Feb 14, 2020 at 06:24:17PM +0100, Phil Sutter wrote:
> > > > > > Typical idiom for *_get_u*() getters is to call *_get_data() and make
> > > > > > sure data_len matches what each of them is returning. Yet they shouldn't
> > > > > > trust *_get_data() to write into passed pointer to data_len since for
> > > > > > chains and NFTNL_CHAIN_DEVICES attribute, it does not. Make sure these
> > > > > > assert() calls trigger in those cases.
> > > > > 
> > > > > The intention to catch for unset attributes through the assertion,
> > > > > right?
> > > > 
> > > > No, this is about making sure that no wrong getter is called, e.g.
> > > > nftnl_chain_get_u64() with e.g. NFTNL_CHAIN_HOOKNUM attribute which is
> > > > only 32bits.
> > > 
> > > I think it will also catch the case I'm asking. If attribute is unset,
> > > then nftnl_chain_get_data() returns NULL and the assertion checks
> > > data_len, which has not been properly initialized.
> > 
> > With nftnl_assert() being (shortened):
> > 
> > | #define nftnl_assert(val, attr, expr) \
> > |  ((!val || expr) ? \
> > |  (void)0 : __nftnl_assert_fail(attr, __FILE__, __LINE__))
> > 
> > Check for 'expr' (which is passed as 'data_len == sizeof(<something>)')
> > will only happen if 'val' is not NULL. Callers then return like so:
> > 
> > | return val ? *val : 0;
> > 
> > This means that if you pass an unset attribute to the getter, it will
> > simply return 0.
> 
> Thanks for explaining, Phil. If the problem is just
> NFTNL_CHAIN_DEVICES and NFTNL_FLOWTABLE_DEVICES, probably this is just
> fine? So zero data-length is reversed for arrays and update
> nftnl_assert() to skip data_len == 0, ie.
> 
> > | #define nftnl_assert(val, attr, expr) \
> > |  ((!val || data_len == 0 || expr) ? \
> > |  (void)0 : __nftnl_assert_fail(attr, __FILE__, __LINE__))

Your proposed patch would allow to call e.g.:

| nftnl_chain_get_u32(c, NFTNL_CHAIN_DEVICES)

This would return (uint32_t)*(&c->dev_array[0]), I highly doubt we
should allow this. Unless I miss something, it is certainly a
programming error if someone calls any of the nftnl_chain_get_{u,s}*
getters on NFTNL_CHAIN_DEVICES attribute. So aborting with error message
in nftnl_assert() is not only OK but actually helpful, no?

Cheers, Phil
