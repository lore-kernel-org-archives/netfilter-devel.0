Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B93FE75434
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Oct 2023 08:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjJCIWo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Oct 2023 04:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjJCIWn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Oct 2023 04:22:43 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9A4A1
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Oct 2023 01:22:40 -0700 (PDT)
Received: from [78.30.34.192] (port=37006 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qnafs-002Cdf-9t; Tue, 03 Oct 2023 10:22:38 +0200
Date:   Tue, 3 Oct 2023 10:22:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: update element timeout support [was Re: [PATCH nf 1/2]
 netfilter: nft_set_rbtree: move sync GC from insert path to
 set->ops->commit]
Message-ID: <ZRvPSw5PGFyt7S10@calendula>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
 <ZRq6oP2/hns1qoaq@calendula>
 <20231002135838.GB30843@breakpoint.cc>
 <20231002142141.GA7339@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231002142141.GA7339@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

I am collecting here your comments for the model we are defining for
set elements:

https://people.netfilter.org/pablo/setelems-timeout.txt

Let me know if you have more possible scenarios that you think that
might not be address by this model:

- Annotate current time at the beginning of the transaction, use it
  in _expired() check (=> timeout is not a moving target anymore).
- Annotate element timeout update in transaction, update timeout from
  _commit() path not to refresh it.

Thanks.
