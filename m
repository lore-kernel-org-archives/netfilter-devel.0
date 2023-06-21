Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EAC3EB64D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 12:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjFUMMy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 08:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFUMMx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 08:12:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D18DD
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 05:12:52 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qBwhf-0008Ca-4c; Wed, 21 Jun 2023 14:12:51 +0200
Date:   Wed, 21 Jun 2023 14:12:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] cli: Make valgrind happy
Message-ID: <ZJLpQ0Wxnek0dtVQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230620140352.21633-1-phil@nwl.cc>
 <ZJHOEff+hNaj6g8e@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJHOEff+hNaj6g8e@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 20, 2023 at 06:04:33PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jun 20, 2023 at 04:03:52PM +0200, Phil Sutter wrote:
> > Missing call to nft_ctx_free() upsets valgrind enough to suspect
> > possible losses, add them where sensible. This fixes reports with
> > readline-lined builds at least. The same code is shared for libedit
> > though, and there's an obvious spot for linenoise.
> 
> Maybe call nft_ctx_free() from cli_exit() ?

That's doable, but linenoise code does not use the static global cli_nft
variable and thus cli_exit() can't access the struct nft_ctx pointer.

At first, I tried to make main() not exit after calling cli_init() so
final cleanup takes place. But the different CLI variants are a bit of a
mess in that regard: While there are code-paths returning to caller,
most don't. I'm tempted to fix that instead. What do you think?

Thanks, Phil
