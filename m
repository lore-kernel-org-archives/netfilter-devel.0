Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399D9C3F2D7
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 01:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A1E92467B
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 01:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCCBWJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 20:22:09 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54080 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgCCBWJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 20:22:09 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j8wG8-0006Fr-1i; Tue, 03 Mar 2020 02:22:08 +0100
Date:   Tue, 3 Mar 2020 02:22:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/4] nft: cache: Review flush_cache()
Message-ID: <20200303012207.GD5627@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200302175358.27796-1-phil@nwl.cc>
 <20200302175358.27796-5-phil@nwl.cc>
 <20200302192208.3s5omyihan5xuj44@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302192208.3s5omyihan5xuj44@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Mar 02, 2020 at 08:22:08PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Mar 02, 2020 at 06:53:58PM +0100, Phil Sutter wrote:
> > While fixing for iptables-nft-restore under stress, I managed to hit
> > NULL-pointer deref in flush_cache(). Given that nftnl_*_list_free()
> > functions are not NULL-pointer tolerant, better make sure such are not
> > passed by accident.
> 
> Could you explain what sequence is triggering the NULL-pointer
> dereference?

I don't think it is possible to trigger with current upstream code. I
hit it while trying to find a fix for the bug described in patch 1, but
it was different code. So technically, this is fixing for a problem that
doesn't exist. If you therefore consider this change worthless, I'm
absolutely fine with dropping it. My motivation to submit it was that it
makes flush_cache() behave sane even in odd circumstances.

Cheers, Phil
