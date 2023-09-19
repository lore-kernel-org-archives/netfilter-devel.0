Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500F3CE79A9
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 16:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjISQUS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 12:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjISQUR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 12:20:17 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EEC92
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 09:20:11 -0700 (PDT)
Received: from [78.30.34.192] (port=55276 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qidSI-00GZ4L-Pw; Tue, 19 Sep 2023 18:20:09 +0200
Date:   Tue, 19 Sep 2023 18:20:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/1] datatype: explicitly set missing datatypes for
 TYPE_CT_LABEL,TYPE_CT_EVENTBIT
Message-ID: <ZQnKNVCgwbmRTMaD@calendula>
References: <20230919112811.2752909-1-thaller@redhat.com>
 <ZQmRoKljTJJWEGx1@calendula>
 <38547bfa61da64801d1cb79f757b40ca1e0c44f4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <38547bfa61da64801d1cb79f757b40ca1e0c44f4.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 19, 2023 at 02:30:38PM +0200, Thomas Haller wrote:
> On Tue, 2023-09-19 at 14:18 +0200, Pablo Neira Ayuso wrote:
> > Hi Thomas,
> > 
> > On Tue, Sep 19, 2023 at 01:28:03PM +0200, Thomas Haller wrote:
> > > It's not obvious that two enum values are missing (or why).
> > > Explicitly
> > > set the values to NULL, so we can see this more easily.
> > 
> > I think this is uncovering a bug with these selectors.
> > 
> > When concatenations are used, IIRC the delinerize path needs this.
> > 
> > TYPE_CT_EVENTBIT does not need this, because this is a statement to
> > globally filter ctnetlink events events.
> > 
> > But TYPE_CT_LABEL is likely not working fine with concatenations.
> > 
> > Let me take a closer look.
> 
> Hi Pablo,
> 
> Thank you.
> 
> FYI, I have a patch with a unit test that performs some consistency
> checks of the "datatypes" array. Only TYPE_CT_LABEL + TYPE_CT_EVENTBIT
> are missing.
>
> You don't need to write a test about that. The test is however on top
> of  "no recursive make" patches, which I will resent at a later time.

Thanks, I posted the fixes without unit tests:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230919161254.640998-1-pablo@netfilter.org/
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230919161825.643827-1-pablo@netfilter.org/

