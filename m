Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0879ECAAD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Aug 2022 11:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiH3Lmm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Aug 2022 07:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiH3LmK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2022 07:42:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A9AA1D59
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2022 04:40:31 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oSzbY-0003VM-Cf; Tue, 30 Aug 2022 13:40:28 +0200
Date:   Tue, 30 Aug 2022 13:40:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Extend limit statement's burst value info
Message-ID: <Yw33LIfkSd4rEQHI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220826131431.19696-1-phil@nwl.cc>
 <Yw32VzsENzRJ0kpn@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw32VzsENzRJ0kpn@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 30, 2022 at 01:36:55PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 26, 2022 at 03:14:31PM +0200, Phil Sutter wrote:
> > Describe how the burst value influences the kernel module's token
> > bucket in each of the two modes.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Looking at the code, maybe one should make byte-based limit burst
> > default to either zero or four times the rate value instead of the
> > seemingly arbitrary 5 bytes.
> 
> This is a bug, let me have a look and then you follow up to update the
> manpage, OK?

ACK, thanks!

Cheers, Phil
