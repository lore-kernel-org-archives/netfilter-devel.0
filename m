Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D92DCD5BC6
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 14:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjISONF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 10:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjISONF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 10:13:05 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3751A9E
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 07:13:00 -0700 (PDT)
Received: from [78.30.34.192] (port=53662 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qibTE-00G52T-6J; Tue, 19 Sep 2023 16:12:58 +0200
Date:   Tue, 19 Sep 2023 16:12:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>, g@calendula
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: fix memory leak when more than
 255 elements expired
Message-ID: <ZQmsZ/LPy+HMYZIo@calendula>
References: <20230919133616.20436-1-fw@strlen.de>
 <20230919135938.GC23945@breakpoint.cc>
 <ZQmsUBdJn2JH5tOt@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZQmsUBdJn2JH5tOt@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 19, 2023 at 04:12:34PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 19, 2023 at 03:59:38PM +0200, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > When more than 255 elements expire we're supposed to switch to a new gc
> > > container structure, but nft_trans_gc_space() always returns false in this
> > 
> > Grrr.  This should read 'always returns true' or 'never returns false',
> > but not *THIS*.  I'll fix this up when applying this, probably tomorrow
> > morning.
> 
> You could amend the fix when applying this.

I mean, this patch description, as you prefer.
