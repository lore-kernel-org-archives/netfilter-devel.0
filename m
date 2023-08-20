Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C9EEE4996
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Aug 2023 20:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjHTUjI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Aug 2023 16:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjHTUiz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Aug 2023 16:38:55 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3758559B
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Aug 2023 13:36:03 -0700 (PDT)
Received: from [78.30.34.192] (port=44688 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qXp9R-00Aojd-Fm; Sun, 20 Aug 2023 22:36:00 +0200
Date:   Sun, 20 Aug 2023 22:35:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v3 0/3] src: use reentrant
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
Message-ID: <ZOJ5LMyDVJL7hkMf@calendula>
References: <20230818141124.859037-1-thaller@redhat.com>
 <ZN+Yf0rQ/W+zkpI0@calendula>
 <bb3935579c7492373e76f8e71f4a739bcb7fcda4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb3935579c7492373e76f8e71f4a739bcb7fcda4.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 18, 2023 at 07:39:31PM +0200, Thomas Haller wrote:
> On Fri, 2023-08-18 at 18:12 +0200, Pablo Neira Ayuso wrote:
> > On Fri, Aug 18, 2023 at 04:08:18PM +0200, Thomas Haller wrote:
> > > Changes since version 2:
> > > 
> > > - split the patch.
> > > 
> > > - add and use defines NFT_PROTONAME_MAXSIZE, NFT_SERVNAME_MAXSIZE,
> > >   NETDB_BUFSIZE.
> > > 
> > > - add new GPL2+ source file as a place for the wrapper functions.
> > 
> > Series LGTM. I would just collapse patch 1 and 2, I can do that
> > before
> > applying if you like. Or you send v4 as you prefer.
> 
> Hi Pablo,
> 
> if you are OK with applying it (and mangling it first), please go
> ahead.

Applied, thanks.
