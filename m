Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCB8C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 21:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D3EB20818
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 21:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLV75 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:59:57 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:48826 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbfKLV75 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 16:59:57 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iUeCZ-0002FS-Nh; Tue, 12 Nov 2019 22:59:55 +0100
Date:   Tue, 12 Nov 2019 22:59:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        a@juaristi.eus
Subject: Re: [PATCH nft 3/4] tests: add meta time test cases
Message-ID: <20191112215955.GA8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        a@juaristi.eus
References: <20190829140904.3858-1-fw@strlen.de>
 <20190829140904.3858-4-fw@strlen.de>
 <20191112184439.GB11663@orbyte.nwl.cc>
 <20191112193557.GG19558@breakpoint.cc>
 <20191112211957.GC11663@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112211957.GC11663@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 12, 2019 at 10:19:57PM +0100, Phil Sutter wrote:
> On Tue, Nov 12, 2019 at 08:35:57PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > Hi,
> > > 
> > > On Thu, Aug 29, 2019 at 04:09:03PM +0200, Florian Westphal wrote:
> > > [...]
> > > > diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
> > > > index 1d8426de9632..402caae5cad8 100644
> > > > --- a/tests/py/any/meta.t.payload
> > > > +++ b/tests/py/any/meta.t.payload
> > > [...]
> > > > +# meta hour "17:00" drop
> > > > +ip test-ip4 input
> > > > +  [ meta load hour => reg 1 ]
> > > > +  [ cmp eq reg 1 0x0000d2f0 ]
> > > > +  [ immediate reg 0 drop ]
> > > 
> > > Does this pass for you? I'm getting such warnings:
> > > 
> > > | 7: WARNING: line 3: 'add rule ip test-ip4 input meta hour "17:00" drop':
> > > | '[ cmp eq reg 1 0x0000d2f0 ]' mismatches '[ cmp eq reg 1 0x0000e100 ]'
> > > 
> > > On my system, "17:00" consistently translates into 0xe100.
> > 
> > Argh, DST :-(
> > 
> > We will need to add change the test so nft-test.py runs with a fixed
> > time zone.
> 
> Isn't this thing translating to UTC before submitting to kernel? I would
> assume netlink debug output to be consistent between different
> timezones.

Timezones and DST obviously exceed my abilities. It just took a while
for me to realize that "17:00" in DST means a different point in time
than the same value in non-DST. Anyway, this seems to work:

| diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
| index ce42b5ddb1cca..1b1db7aa596f3 100755
| --- a/tests/py/nft-test.py
| +++ b/tests/py/nft-test.py
| @@ -24,6 +24,7 @@ import tempfile
|  
|  TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
|  sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
| +os.environ['TZ'] = 'UTC-2'
|  
|  from nftables import Nftables
|  

Choosing UTC-2 fixes most of the warnings. Not all of them, who knows
why. (Choosing the right offset was already challenging enough.)

Cheers, Phil
