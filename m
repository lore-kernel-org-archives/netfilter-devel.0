Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D34C41604
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 09:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28991206B5
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 09:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgJFJhp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgJFJhp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 05:37:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C28DC061755
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 02:37:45 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kPjPk-0007RV-6g; Tue, 06 Oct 2020 11:37:44 +0200
Date:   Tue, 6 Oct 2020 11:37:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Optimize class-based IP prefix matches
Message-ID: <20201006093744.GL29050@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20201002090334.29788-1-phil@nwl.cc>
 <20201006085621.GA16275@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006085621.GA16275@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 06, 2020 at 10:56:21AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 02, 2020 at 11:03:34AM +0200, Phil Sutter wrote:
> > Payload expression works on byte-boundaries, leverage this with suitable
> > prefix lengths.
> 
> Interesing. But it kicks in the raw payload expression in nftables.
> 
> # nft list ruleset
> table ip filter {
>         chain INPUT {
>                 type filter hook input priority filter; policy accept;
>                 @nh,96,24 8323072 counter packets 0 bytes 0
>         }
> 
> Would you send a patch for nftables too? There is already approximate
> offset matching in the tree, it should not be too hard to amend.

I had a quick look but it didn't seem trivial to me. It is in
payload_expr_complete() where a template lookup happens based on
expression offset and length which fails due to the unexpected length.
Is this the right place to adjust or am I wrong?

Strictly speaking, this is just a lack of feature in nftables and
nothing breaks due to it. Do you still want to block the iptables change
for it?

Cheers, Phil
