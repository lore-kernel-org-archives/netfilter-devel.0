Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB92EC001E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jul 2023 15:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjGaPcT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 11:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjGaPcP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 11:32:15 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131111706
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2023 08:32:14 -0700 (PDT)
Received: from [46.222.105.127] (port=12914 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qQUsT-001BBs-7B; Mon, 31 Jul 2023 17:32:11 +0200
Date:   Mon, 31 Jul 2023 17:32:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nftables: syntax ambiguity with objref map and ct helper objects
Message-ID: <ZMfT97SbKBov4UzD@calendula>
References: <20230728195614.GA18109@breakpoint.cc>
 <ZMenriLfu+luvh9i@calendula>
 <20230731124637.GA7056@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230731124637.GA7056@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 31, 2023 at 02:46:37PM +0200, Florian Westphal wrote:
[...]
> My point is how nft should differentiate between
> 
> ct helper "bla" {
> 
> rule add ct helper "foo"
> 
> In above map declaration.  What does
> 
> "typeof ip saddr : ct helper" declare?
> As far as I can see its arbitrary 16-byte strings, so the
> above doesn't delcare an objref map that maps ip addresses
> to conntrack helper templates.

Oh, indeed. Selector semantics are overloaded, I proposed kernel
patches that have remained behind:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210309210134.13620-2-pablo@netfilter.org/
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210309210134.13620-3-pablo@netfilter.org/

I also proposed change to have two selectors, one for the helper type
and another for the user-defined helper name. I still have to update
libnftnl and nftables.

I don't think this is specifically related to the map definition
itself, but the fact that the selector semantics is ambiguous.
