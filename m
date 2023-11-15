Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42073C47074
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 11:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbjKOLq6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 06:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbjKOLq6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 06:46:58 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA83BCC
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 03:46:53 -0800 (PST)
Received: from [78.30.43.141] (port=58146 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r3EM6-00BenY-8b
        for netfilter-devel@vger.kernel.org; Wed, 15 Nov 2023 12:46:52 +0100
Date:   Wed, 15 Nov 2023 12:46:49 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: libnfnetlink dependency elimination (doc)
Message-ID: <ZVSvqR0cfw5zfVnd@calendula>
References: <20231112065922.3414-1-duncan_roe@optusnet.com.au>
 <ZVORGxjxolo3vnz1@calendula>
 <ZVP9D9KPgMkxLiB/@slk15.local.net>
 <ZVSPBsJOILgw3c0m@calendula>
 <ZVSu+NTsJKP6YgQ1@slk15.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZVSu+NTsJKP6YgQ1@slk15.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 15, 2023 at 10:43:52PM +1100, Duncan Roe wrote:
> On Wed, Nov 15, 2023 at 10:27:34AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Nov 15, 2023 at 10:04:47AM +1100, Duncan Roe wrote:
> > > Hi Pablo,
> > >
> > > On Tue, Nov 14, 2023 at 04:24:11PM +0100, Pablo Neira Ayuso wrote:
> > > > On Sun, Nov 12, 2023 at 05:59:21PM +1100, Duncan Roe wrote:
> > > > > Some of these documented changes haven't happened yet.
> > > >
> > > > Then we have to start by changes first, not the other way around.
> > >
> > > Yes I know that, obviously:)
> > >
> > > The point here is that nfnl_rcvbufsiz() has been advertised in the main page of
> > > libnetfilter_queue HTML for a long time and there are likely a number of systems
> > > out there that use it. When libnfnetlink is removed, libnetfilter_queue will
> > > have to provide nfnl_rcvbufsiz() or those systems will start failing.
> >
> > There is nfq_fd() and setsockopt() that you can use:
> >
> >         setsockopt(fd, SOL_SOCKET, SO_RCVBUFFORCE, &size, socklen);
> >         setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &size, socklen);
> 
> Yes
> >
> > libnfnetlink is **deprecated** and it will be removed at some point,
> > the git log shows that it has less and less users.
> 
> Good to know
> >
> > main libnfnetlink users are the libnetfilter_* libraries.
> 
> Yes
> >
> > No new application should be using libnfnetlink in 2023.
> 
> Yes
> 
> But please see thread starting
> > [PATCH libnetfilter_queue] utils: Add example of setting socket buffer size
> I meant to send my reply to that email, not this one.
> 
> Again sorry for the confusion I've caused.

Apologies, I got lost. Huge burden here.

I suggest to restart from scratch and only one submission and thread at a time :)

Thanks.
