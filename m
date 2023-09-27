Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC02BE82CCA
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 19:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjI0Tx0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjI0TxZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 15:53:25 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56343114
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:53:23 -0700 (PDT)
Received: from [78.30.34.192] (port=46954 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlab1-00ETKn-Dn; Wed, 27 Sep 2023 21:53:21 +0200
Date:   Wed, 27 Sep 2023 21:53:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: fix spurious errors in
 sets/0036add_set_element_expiration_0
Message-ID: <ZRSILkF7E1X5OzAP@calendula>
References: <20230927144803.138869-1-pablo@netfilter.org>
 <ZRRD7B/dvuCwgfvD@orbyte.nwl.cc>
 <ZRRLCywy5pSEoD/i@calendula>
 <ZRROjFi/koe7KHq0@calendula>
 <20230927155317.GB17767@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230927155317.GB17767@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 05:53:17PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230927152514.473765-1-pablo@netfilter.org/
> > 
> > Ouch, still fails. Damn, I don't get a proper fix for this script.
> 
> What about restoring an expire value of 3s, then check there is *one*
> element, wait 4s, check element is gone?
> 
> Tests are parallelized, so this won't cause noticeable slowdown.

:) I have been running tests for a while and it seems no more spurious
errors show with:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230927163937.757167-1-pablo@netfilter.org/

Not related, next one to look at is:

W: [DUMP FAIL]   31/378 testcases/sets/0062set_connlimit

which occasionally fails. This is because this adds an element:

table ip x {
        set est-connlimit {
                type ipv4_addr
                size 65535
                flags dynamic
                elements = { 84.245.120.167 ct count over 20 }
        }
}

the conncount list is empty, then GC might win race to delete this
element with no entries (GC removes empty conncount lists).

I added this test to make sure this restores fine, even if GC removes
all elements that has been restored as soon as it gets a chance to
run, because the conncount list is empty.

For this one, I can set a larger gc-interval, so GC takes longer time
to release it, and still parser coverage for this restoration remains
in place.
