Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18A2C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 11:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADEB561157
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 11:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbhEFLTZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 May 2021 07:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbhEFLTX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 May 2021 07:19:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6126EC061574
        for <netfilter-devel@vger.kernel.org>; Thu,  6 May 2021 04:18:25 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lec1O-0003MS-6N; Thu, 06 May 2021 13:18:22 +0200
Date:   Thu, 6 May 2021 13:18:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        PetrB <petr.boltik@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] segtree: Fix range_mask_len() for subnet ranges
 exceeding unsigned int
Message-ID: <20210506111822.GH12403@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        PetrB <petr.boltik@gmail.com>, netfilter-devel@vger.kernel.org
References: <cover.1620252768.git.sbrivio@redhat.com>
 <5ff3ceab3d3a547ab23144adbfa2000f1604c39f.1620252768.git.sbrivio@redhat.com>
 <20210506091814.GG12403@orbyte.nwl.cc>
 <20210506120021.1bd82275@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506120021.1bd82275@elisabeth>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 06, 2021 at 12:00:21PM +0200, Stefano Brivio wrote:
> On Thu, 6 May 2021 11:18:14 +0200
> Phil Sutter <phil@nwl.cc> wrote:
> 
> > On Thu, May 06, 2021 at 12:23:13AM +0200, Stefano Brivio wrote:
[...]
> > > diff --git a/src/segtree.c b/src/segtree.c
> > > index ad199355532e..353a0053ebc0 100644
> > > --- a/src/segtree.c
> > > +++ b/src/segtree.c
> > > @@ -838,8 +838,8 @@ static int range_mask_len(const mpz_t start, const mpz_t end, unsigned int len)
> > >  	mpz_t tmp_start, tmp_end;
> > >  	int ret;
> > >  
> > > -	mpz_init_set_ui(tmp_start, mpz_get_ui(start));
> > > -	mpz_init_set_ui(tmp_end, mpz_get_ui(end));
> > > +	mpz_init_set(tmp_start, start);
> > > +	mpz_init_set(tmp_end, end);  
> > 
> > The old code is a bit funny, was there a specific reason why you
> > exported the values into a C variable intermediately?
> 
> Laziness, ultimately: I didn't remember the name of gmp_printf(),
> didn't look it up, and used a fprintf() instead to check 'start' and
> 'end'... and then whoops, I left the mpz_get_ui() calls there.

OK, so this patch not just fixes a bug but also streamlines the code for
performance (and something with refactoring, too). ;)

Cheers, Phil
