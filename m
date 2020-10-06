Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DEEC41604
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 09:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A78E206B5
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 09:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFJ35 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFJ35 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 05:29:57 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01782C061755
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 02:29:56 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kPjIB-0007Jr-FD; Tue, 06 Oct 2020 11:29:55 +0200
Date:   Tue, 6 Oct 2020 11:29:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: Re: [iptables PATCH 3/3] libxtables: Register multiple extensions in
 ascending order
Message-ID: <20201006092955.GK29050@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
References: <20200922225341.8976-1-phil@nwl.cc>
 <20200922225341.8976-4-phil@nwl.cc>
 <20201005234121.GA14242@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005234121.GA14242@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 06, 2020 at 01:41:21AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 23, 2020 at 12:53:41AM +0200, Phil Sutter wrote:
> > The newly introduced ordered insert algorithm in
> > xtables_register_{match,target}() works best if extensions of same name
> > are passed in ascending revisions. Since this is the case in about all
> > extensions' arrays, iterate over them from beginning to end.
> 
> This patch should come first in the series, my understanding is that
> 1/3 assumes that extensions are registered from lower to higher
> revision number.

No, the algorithm is supposed to work with arbitrary input. This is
merely an optimization given how extension arrays are typically ordered.

Cheers, Phil
