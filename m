Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84593EE14D0
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244996AbjIFWVt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 18:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238543AbjIFWVt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 18:21:49 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8A510F7;
        Wed,  6 Sep 2023 15:21:45 -0700 (PDT)
Received: from [78.30.34.192] (port=40176 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qe0u2-0020hG-Kg; Thu, 07 Sep 2023 00:21:42 +0200
Date:   Thu, 7 Sep 2023 00:21:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Paul Moore <paul@paul-moore.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
Message-ID: <ZPj7cbtvF5SdaWrx@calendula>
References: <20230906094202.1712-1-pablo@netfilter.org>
 <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
 <ZPhm1mf0GaeQUr0e@calendula>
 <ZPiyGC+TfRgyOabJ@orbyte.nwl.cc>
 <ZPjJAicFFam5AFIq@calendula>
 <CAHC9VhQ0n8Ezef8wYC7uV-MHccqHobYxoB3VYoC9TaGiFm9noQ@mail.gmail.com>
 <ZPjxnSg3/gDy25r0@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZPjxnSg3/gDy25r0@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 06, 2023 at 11:39:41PM +0200, Phil Sutter wrote:
> On Wed, Sep 06, 2023 at 03:56:41PM -0400, Paul Moore wrote:
[...]
> > If it is a bug, please submit a fix for this as soon as possible Pablo.
> 
> Thanks for your support, but I can take over, too. The number of
> notifications emitted even for a small ruleset is not ideal, also. It's
> just a bit sad that I ACKed the patch already and so it went out the
> door. Florian, can we still put a veto there?

Phil, kernel was crashing after your patch, this was resulting in a
kernel panic when running tests here. I had to revert your patches
locally to keep running tests.

Please, just send an incremental fix to adjust the idx, revert will
leave things in worse state.

Audit does not show chains either, which is not very useful to locate
what where exactly the rules have been reset, but that can probably
discussed in net-next. Richard provided a way to extend this if audit
maintainer find it useful too.

Thanks.
