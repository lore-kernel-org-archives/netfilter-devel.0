Return-Path: <SRS0=mfO0=CN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BE9C433E2
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Sep 2020 22:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 020ED2083B
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Sep 2020 22:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgIDWE3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Sep 2020 18:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbgIDWE3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Sep 2020 18:04:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07297C061244
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2020 15:04:27 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kEJoc-0003eS-5a; Sat, 05 Sep 2020 00:04:14 +0200
Date:   Sat, 5 Sep 2020 00:04:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_meta: use socket user_ns to retrieve
 skuid and skgid
Message-ID: <20200904220414.GH19674@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200904152532.2320-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904152532.2320-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 04, 2020 at 05:25:32PM +0200, Pablo Neira Ayuso wrote:
> ... instead of using init_user_ns.
> 
> Fixes: 96518518cc41 ("netfilter: add nftables")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Phil Sutter <phil@nwl.cc>

Thanks!
