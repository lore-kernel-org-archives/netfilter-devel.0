Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A4BC07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 10:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjKOKez (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 05:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbjKOKey (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 05:34:54 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E744DF5
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 02:34:50 -0800 (PST)
Received: from [78.30.43.141] (port=59920 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r3DEN-00BOk2-0Q; Wed, 15 Nov 2023 11:34:48 +0100
Date:   Wed, 15 Nov 2023 11:34:46 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 3/4] tests: shell: skip pipapo set backend in
 transactions/30s-stress
Message-ID: <ZVSexgxBFp3tZluj@calendula>
References: <20231115094231.168870-1-pablo@netfilter.org>
 <20231115094231.168870-4-pablo@netfilter.org>
 <8d3ccdafe00d9e477464e63619bde0e39c6da093.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d3ccdafe00d9e477464e63619bde0e39c6da093.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 15, 2023 at 11:25:44AM +0100, Thomas Haller wrote:
> On Wed, 2023-11-15 at 10:42 +0100, Pablo Neira Ayuso wrote:
> > 
> >  
> > +if [ "$NFT_TEST_HAVE_pipapo" != y ] ;then
> > +	echo "Skipping pipapo set backend, kernel does not support
> > it"
> > +fi
> 
> It's good and useful to run a reduced subset of the test, if some
> kernel feature is missing.
> 
> But in that case, the end of the test should have something like
> 
>   if [ "$NFT_TEST_HAVE_pipapo" = n ] ; then
>       echo "Ran a partial test only, due to NFT_TEST_HAVE_pipapo=n"
>       exit 77
>   fi
> 
> so that it shows up as skipped. In other words, "partially skipped"
> should also show up as skipped.

I don't want this.

This test is very useful in older kernels to catch bugs, I don't want
to see a SKIPPED here.

I prefer the tests autoadapts itself to what the kernel provides.
