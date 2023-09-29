Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DCFCE7B1F
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 10:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbjI2KIV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 06:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjI2KIV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 06:08:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112F9199
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 03:08:20 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qmAPy-0007EV-37; Fri, 29 Sep 2023 12:08:18 +0200
Date:   Fri, 29 Sep 2023 12:08:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 7/8] netfilter: nf_tables: Pass reset bit in
 nft_set_dump_ctx
Message-ID: <ZRaiEjg2g6UuLPpS@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-8-phil@nwl.cc>
 <ZRXLlwkeCBWgXqGZ@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRXLlwkeCBWgXqGZ@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 28, 2023 at 08:53:11PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 28, 2023 at 06:52:43PM +0200, Phil Sutter wrote:
> > Relieve the dump callback from having to check nlmsg_type upon each
> > call. Prep work for set element reset locking.
> 
> Maybe add this as a preparation patch first place in this series,
> rather making this cleanup at this late stage of the batch.

Sure, no problem. I extracted it from v1 of patch 8 and so they are
closely related.

Maybe I should split the series up in per-callback ones? I'd start with
the getsetelem_reset one as that is most cumbersome it seems.

Cheers, Phil
