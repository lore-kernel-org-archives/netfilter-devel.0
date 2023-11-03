Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CEAC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 15:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjKCPPx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 11:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjKCPPv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 11:15:51 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85290D47
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 08:15:46 -0700 (PDT)
Received: from [78.30.35.151] (port=35950 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyvtc-00FXFq-Fz; Fri, 03 Nov 2023 16:15:42 +0100
Date:   Fri, 3 Nov 2023 16:15:39 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZUUOm1cpAyMTr30n@calendula>
References: <ZTFJ4yXd7nZxjAJz@orbyte.nwl.cc>
 <ZUOJNnKJRKwj379J@calendula>
 <ZUOVrlIgCSIM8Ule@orbyte.nwl.cc>
 <ZUQTWSEXbw2paJ3v@calendula>
 <ZUTEfXMw2e5kMJ5A@orbyte.nwl.cc>
 <ZUTPG3XsdIFu8RRb@orbyte.nwl.cc>
 <ZUTQOqAS9EvI6/jV@calendula>
 <ZUTR9EAJZGhNfDa6@orbyte.nwl.cc>
 <ZUTZiB8xC1pVn+mn@calendula>
 <ZUULhhY2E4H16IAd@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZUULhhY2E4H16IAd@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 04:02:30PM +0100, Phil Sutter wrote:
> On Fri, Nov 03, 2023 at 12:29:12PM +0100, Pablo Neira Ayuso wrote:
> > These two below, I don't find in my tree (script woes!):
> > 
> > > e4c9f9f7e0d1f83be18f6c4a418da503e9021b24

Taken.

This means that we are going to include fixes that are not yet in any
release other than the git HEAD. There are a few more like this.

> > > d392ddf243dcbf8a34726c777d2c669b1e8bfa85

This needs a backport, a recent rework depends on this.

Thanks.
