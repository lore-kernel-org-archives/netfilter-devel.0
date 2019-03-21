Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4228C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 16:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D2BE21902
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 16:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfCUQ5P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 12:57:15 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:44285 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfCUQ5P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 12:57:15 -0400
Received: from 148.160.broadband14.iol.cz ([90.181.160.148] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h710B-0000zU-UX; Thu, 21 Mar 2019 17:57:13 +0100
Date:   Thu, 21 Mar 2019 17:57:11 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190321165711.is2jcq3b4yzty6fy@salvia>
References: <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
 <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
 <20190318174243.GT4851@orbyte.nwl.cc>
 <20190319110624.dy7wqatdtrxy3452@salvia>
 <20190320134654.GD4851@orbyte.nwl.cc>
 <20190321083245.lndl3sjq47pajaza@salvia>
 <20190321111515.GJ4851@orbyte.nwl.cc>
 <20190321111818.uqmioy5jk4kbamru@salvia>
 <20190321140656.GL4851@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321140656.GL4851@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, Mar 21, 2019 at 03:06:56PM +0100, Phil Sutter wrote:
[...]
> I was talking about the "osf name . osf version" part. If not optimized,
> each osf expression would perform a database lookup and return different
> parts of the fingerprint.
> 
> Or did I miss your point?

Oops, sorry. I misunderstood.

I don't think we should split this in two separated selectors.
Matching on 'osf version' alone itself does not make sense to me.

I think it's useful to match on:

* genre
* genre:version
* genre:version:subtype

anything else for this, I don't have a use case.

We can achieve something similar to what you suggest in your 'osf name
. osf version' example via:

        osf version {  "Linux:2.4", "Windows\*" }

Thanks!
