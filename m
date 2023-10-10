Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0C1CD8CA6
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 16:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjJJQMn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 12:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjJJQMn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 12:12:43 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4152CF
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 09:12:40 -0700 (PDT)
Received: from [78.30.34.192] (port=46842 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qqFLW-005H8G-8r; Tue, 10 Oct 2023 18:12:36 +0200
Date:   Tue, 10 Oct 2023 18:12:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: remove references to timeout in reset command
Message-ID: <ZSV38X531Aypinaq@calendula>
References: <20231010142704.54741-1-pablo@netfilter.org>
 <ZSVgOhTI8mWeeNIp@orbyte.nwl.cc>
 <20231010144813.GA1407@breakpoint.cc>
 <ZSVmjCI7mPy44lIT@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZSVmjCI7mPy44lIT@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 10, 2023 at 04:58:20PM +0200, Phil Sutter wrote:
> On Tue, Oct 10, 2023 at 04:48:13PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > On Tue, Oct 10, 2023 at 04:27:04PM +0200, Pablo Neira Ayuso wrote:
> > > > After Linux kernel's patch ("netfilter: nf_tables: do not refresh
> > > > timeout when resetting element") timers are not reset anymore, update
> > > > documentation to keep this in sync.
> > > 
> > > How is limit statement being reset? The dump callbacks in nft_limit.c
> > > ignore the 'bool reset' parameter.
> > 
> > Was that deliberate?  I don't see why it would be exempt?
> 
> One could reset internal tokens and last values, indeed. I don't see a
> patch pending to do that, though.

It should be easy to fix from kernel side, right? I can step so
remaining NFT_EXPR_STATEFUL also implement this. I mean, otherwise we
might have to document that some kernels do not support reset, some
kernel support reset of counter and quota only and some kernels fully
support all of the stateful objects :)

> BTW: nft also does not support for 'reset limit(s)'.

This can be done later from userspace. The reset for limit is a bit
special, because it currently does not exposed state information from
the listing side.
