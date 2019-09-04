Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B9AC3A5A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 06:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50DAE22CED
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 06:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfIDGx6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:53:58 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:49912 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfIDGx5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 02:53:57 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1i5PAy-0004bn-Do; Wed, 04 Sep 2019 08:53:56 +0200
Date:   Wed, 4 Sep 2019 08:53:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] conntrack: Fix CIDR to mask conversion
 on Big Endian
Message-ID: <20190904065356.GF25650@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190902164431.18398-1-phil@nwl.cc>
 <20190903203447.saqplkgbbxlajkqr@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903203447.saqplkgbbxlajkqr@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 03, 2019 at 10:34:47PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 02, 2019 at 06:44:31PM +0200, Phil Sutter wrote:
> > Code assumed host architecture to be Little Endian. Instead produce a
> > proper mask by pushing the set bits into most significant position and
> > apply htonl() on the result.
> > 
> > Fixes: 3f6a2e90936bb ("conntrack: add support for CIDR notation")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/conntrack.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/src/conntrack.c b/src/conntrack.c
> > index c980a13f33d2c..baafcbd869c12 100644
> > --- a/src/conntrack.c
> > +++ b/src/conntrack.c
> > @@ -2210,7 +2210,7 @@ nfct_build_netmask(uint32_t *dst, int b, int n)
> >  			dst[i] = 0xffffffff;
> >  			b -= 32;
> >  		} else if (b > 0) {
> > -			dst[i] = (1 << b) - 1;
> > +			dst[i] = htonl(((1 << b) - 1) << (32 - b));
> 
> Simply this instead?
> 
>                         dst[i] = htonl(((1 << b) - 1);

You got me confused, so I played with different options. To see the
results, I used:

| union {
|         uint32_t i;
|         char b[4];
| } u;

What we need in b is 'ff ff ff 00' for a prefix length of 24. Your
suggested alternative does not compile, so I tried both options for the
closing brace:

| htonl((1 << 24) - 1)

This turns into '00 ff ff ff' for both LE and BE, the opposite of what
we need.

| htonl((1 << 24)) - 1

This turns into '00 00 00 00' on LE and '00 ff ff ff' on BE.

My code leads to correct result on either architecture and I don't see a
simpler way of doing it.

Cheers, Phil
