Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C8AC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C84120857
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfCSLG2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:06:28 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:50123 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfCSLG2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 07:06:28 -0400
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h6CZd-0006kI-6S; Tue, 19 Mar 2019 12:06:27 +0100
Date:   Tue, 19 Mar 2019 12:06:24 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190319110624.dy7wqatdtrxy3452@salvia>
References: <20190314201309.iqdyb7icreyyhhke@salvia>
 <20190314200737.erhjrhoaciclapsn@salvia>
 <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
 <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
 <20190318174243.GT4851@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318174243.GT4851@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Mon, Mar 18, 2019 at 06:42:43PM +0100, Phil Sutter wrote:
> On Fri, Mar 15, 2019 at 06:13:28PM +0100, Pablo Neira Ayuso wrote:
[...]
> > * Kernel would need to inconditionally build the OS:version string.
> 
> Yes, exactly. nft_osf.c would return "OS:version:subtype:opt" and
> nft_cmp.c will do the right thing if nft_cmp_expr->len is set to RHS
> length.

Problem are sets. They need a fixed size for the string, or we would
need to adjust the size to the largest string in the set. In case of
dynamic sets, this boils down to the maximum string length since we
don't know what the length of future element would be.

> > * We may need to ask users to break existing osf ruleset so they
> >   explicitly add the wildcard at the end, ie.
> > 
> >         osf name "Windows\*"
> >         osf name "Linux:4.\*"
> 
> Not if cmp expr len is set correctly.

cmp expr len is set correctly using the wildcard.

I think we should aim to make this work fine with sets and maps. The
wildcard cannot be used from there, where exact matches are needed. We
should encourage users to use osf with sets and maps.

> > then, in the future (if ever needed) add subtypes:
> > 
> >         osf subtype "Linux:2.4:cluster"
> 
> IMHO this is still redundant: RHS contains <something>:<something>, user
> wants to match on OS and version. RHS contains <sth>:<sth>:<sth>, user
> wants to match on OS, version and subtype.

This is not possible with dynamic sets, there the set may be empty so
we do not know how many colons will be used :-)
