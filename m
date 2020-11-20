Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65579C2D0E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 19:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15E1022264
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 19:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgKTThZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 14:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgKTThZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 14:37:25 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F9BC0613CF
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 11:37:25 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kgCDj-0008S1-Nl; Fri, 20 Nov 2020 20:37:23 +0100
Date:   Fri, 20 Nov 2020 20:37:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: shell: Stabilize
 nft-only/0009-needless-bitwise_0
Message-ID: <20201120193723.GN11766@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20201120175757.8063-1-phil@nwl.cc>
 <20201120185000.GA17769@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120185000.GA17769@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Nov 20, 2020 at 07:50:00PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 20, 2020 at 06:57:57PM +0100, Phil Sutter wrote:
> > Netlink debug output varies depending on host's endianness and therefore
> > the test fails on Big Endian machines. Since for the sake of asserting
> > no needless bitwise expressions in output the actual data values are not
> > relevant, simply crop the output to just the expression names.
> 
> Probably we can fix this in libnftnl before we apply patches like this
> to nft as well?

You're right, ignoring the problems in nft testsuite is pretty
inconsistent. OTOH this is the first test that breaks iptables testsuite
on Big Endian while nft testsuite is entirely broken. ;)

I had a look at libnftnl and it seems like even kernel support is needed
to carry the endianness info from input to output. IMHO data should be
in a consistent format in netlink messages, but I fear we can't change
this anymore. I tried to print the data byte-by-byte, but we obviously
still get problems with any data in host byte order. Do you see an
easier way to fix this than adding extra info to all expressions
containing data?

Thanks, Phil
