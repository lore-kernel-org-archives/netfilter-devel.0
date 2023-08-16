Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9411C41513
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 16:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbjHPQRR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 12:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344688AbjHPQRH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 12:17:07 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B962716
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2023 09:17:05 -0700 (PDT)
Received: from [78.30.34.192] (port=53788 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qWJCc-00AoNA-N7; Wed, 16 Aug 2023 18:17:01 +0200
Date:   Wed, 16 Aug 2023 18:16:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH] src: use reentrant
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
Message-ID: <ZNz2emyHGgx6ZtQj@calendula>
References: <20230810123035.3866306-1-thaller@redhat.com>
 <ZNYng8dQBhk48kj9@calendula>
 <c5d1ed7aa26a439314fd26a959fd03b77d7ee7c0.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c5d1ed7aa26a439314fd26a959fd03b77d7ee7c0.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thomas,

Apologies for the late reply.

On Fri, Aug 11, 2023 at 02:58:48PM +0200, Thomas Haller wrote:
> Hi Pablo,
> 
> On Fri, 2023-08-11 at 14:20 +0200, Pablo Neira Ayuso wrote:
> > On Thu, Aug 10, 2023 at 02:30:30PM +0200, Thomas Haller wrote:
> > > If the reentrant versions of the functions are available, use them
> > > so
> > > that libnftables is thread-safe in this regard.
> > 
> > At netlink sequence tracking is not thread-safe, users hit EILSEQ
> > errors when multiple threads recycle the same nft_ctx object. Updates
> > are serialized by mutex per netns, batching is usually the way to go
> > to amortize the cost of ruleset updates.
> 
> The problem already happens when one thread is using libnftables and
> another thread calls one of those libc functions at an unfortunate
> moment. It doesn't require multi-threaded uses of libnftables itself.

Indeed.

> Also, why couldn't you have two threads, handling one netns each, with
> separate nft_ctx objects?

You have to have one nft_ctx per thread, that should be sufficient,
this probably needs to be documented.
