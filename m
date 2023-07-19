Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5420EB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 10:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjGSKxn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjGSKxl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2023 06:53:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6C0E42
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2023 03:53:41 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qM4oM-0005oL-OT; Wed, 19 Jul 2023 12:53:38 +0200
Date:   Wed, 19 Jul 2023 12:53:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Easynet <devel@easynet.dev>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: libnftnl adding element to a set of type ipv4_addr or ipv6_addr
Message-ID: <ZLfAshHpX+Zqp6Mh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Easynet <devel@easynet.dev>,
        netfilter-devel@vger.kernel.org
References: <ff54bc23-95f3-8300-c9d4-e5d74581a0e7@easynet.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff54bc23-95f3-8300-c9d4-e5d74581a0e7@easynet.dev>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Jul 18, 2023 at 09:02:02PM +0200, Easynet wrote:
> I'm building a small firewall daemon that it receives if an user is 
> authenticated and then is adding his IP in a set to be allowed for 24h.
> I'm new in nftnl library and I started to read the documentation and 
> also the examples.
> 
> Until now I was able to add in my daemon these tools based on libnftnl:
> 
> - create / delete / get tables
> - create / delete chains
> - create / delete sets.
> 
> Right now I'm facing an issue that I can't understand how to build the 
> nftnl packet for adding an element to my set, which has interval and 
> timeout flags.

With libnftnl, source is documentation. Go check nftables code on how to
use it. If you need a simpler interface to nftables, I highly recommend
using libnftables instead. You'll either have to pass strings or use a
JSON library for structured in- and output. For simple things such as
adding an element to a set, it more or less boils down to:

| struct nft_ctx *ctx = nft_ctx_new(NFT_CTX_DEFAULT);
| nft_run_cmd_from_buffer(ctx, "add element mytable myset { 123 }");
| nft_ctx_free(ctx);

Cheers, Phil
