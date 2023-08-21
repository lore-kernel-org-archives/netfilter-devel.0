Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B63EE49A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 20:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjHUUGA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjHUUGA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 16:06:00 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42181A8
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 13:05:58 -0700 (PDT)
Received: from [78.30.34.192] (port=38876 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qYB9t-00F0a0-BK; Mon, 21 Aug 2023 22:05:56 +0200
Date:   Mon, 21 Aug 2023 22:05:52 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] INSTALL: provide examples to install python
 bindings
Message-ID: <ZOPDoG4Ow5pcmYnM@calendula>
References: <20230821112840.27221-1-pablo@netfilter.org>
 <20230821175521.GA46797@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230821175521.GA46797@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 21, 2023 at 06:55:21PM +0100, Jeremy Sowden wrote:
> On 2023-08-21, at 13:28:40 +0200, Pablo Neira Ayuso wrote:
> > Provide examples to install python bindings with legacy setup.py and pip
> > with .toml file.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: add Jeremy's feedback.
> > 
> >  INSTALL | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/INSTALL b/INSTALL
> > index 53021e5aafc3..6539ebdd6457 100644
> > --- a/INSTALL
> > +++ b/INSTALL
> > @@ -84,10 +84,14 @@ Installation instructions for nftables
> >   Python support
> >   ==============
> >  
> > - CPython bindings are available for nftables under the py/ folder.
> > + CPython bindings are available for nftables under the py/ folder.  They can be
> > + installed using pip:
> >  
> > - A pyproject.toml config file and legacy setup.py script are provided to install
> > - it.
> > +    python -m pip install py/
> > +
> > + Alternatively, legacy setup.py script is also provided to install it:
> > +
> > +	python setup.py install
> >  
> >   Source code
> >   ===========
> > -- 
> > 2.30.2
> > 
> 
> If you want to retain a reference to setup.py, then how about this
> patch?

Patch is applied here:

http://git.netfilter.org/nftables/commit/?id=97c28c926096950f1646c99b85a31de309429a0c

Thanks for your feedback.
