Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8C0E82CAA
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 16:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjI0QCt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 12:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjI0QCe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 12:02:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC11196
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 08:53:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qlWqj-0006HY-Rt; Wed, 27 Sep 2023 17:53:17 +0200
Date:   Wed, 27 Sep 2023 17:53:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: fix spurious errors in
 sets/0036add_set_element_expiration_0
Message-ID: <20230927155317.GB17767@breakpoint.cc>
References: <20230927144803.138869-1-pablo@netfilter.org>
 <ZRRD7B/dvuCwgfvD@orbyte.nwl.cc>
 <ZRRLCywy5pSEoD/i@calendula>
 <ZRROjFi/koe7KHq0@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRROjFi/koe7KHq0@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230927152514.473765-1-pablo@netfilter.org/
> 
> Ouch, still fails. Damn, I don't get a proper fix for this script.

What about restoring an expire value of 3s, then check there is *one*
element, wait 4s, check element is gone?

Tests are parallelized, so this won't cause noticeable slowdown.
