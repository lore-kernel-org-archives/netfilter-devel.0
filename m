Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC695C433E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 08:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F1922240
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 08:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732555AbgJII34 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 04:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732477AbgJII3z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 04:29:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61859C0613D2
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 01:29:55 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kQnmj-0007ey-Bz; Fri, 09 Oct 2020 10:29:53 +0200
Date:   Fri, 9 Oct 2020 10:29:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy configuration
Message-ID: <20201009082953.GD13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <160163907669.18523.7311010971070291883.stgit@endurance>
 <20201008173156.GA14654@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008173156.GA14654@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Oct 08, 2020 at 07:31:56PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 02, 2020 at 01:44:36PM +0200, Arturo Borrero Gonzalez wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Previous to this patch, the basechain policy could not be properly configured if it wasn't
> > explictly set when loading the ruleset, leading to iptables-nft-restore (and ip6tables-nft-restore)
> > trying to send an invalid ruleset to the kernel.
> 
> I have applied this with some amendments to the test file to cover
> the --noflush case. I think this is a real problem there, where you
> can combine to apply incremental updates to the ruleset.

Yes, at least I can imagine people relying upon this behaviour.

> For the --flush case, I still have doubts how to use this feature, not
> sure it is worth the effort to actually fix it.

I even find it unintuitive as it retains state despite flushing. But
that is a significant divergence between legacy and nft:

| # iptables -P FORWARD DROP
| # iptables-restore <<EOF
| *filter
| COMMIT
| EOF
| # iptables-save

With legacy, the output is:

| *filter
| :INPUT ACCEPT [0:0]
| :FORWARD DROP [0:0]
| :OUTPUT ACCEPT [0:0]
| COMMIT

With nft, there's no output at all. What do you think, should we fix
that? If so, which side?

> We can revisit later, you can rewrite this later Phil.

Sure, no problem.

Thanks, Phil
