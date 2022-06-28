Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F4DC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 19:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiF1TEU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235748AbiF1TDP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 15:03:15 -0400
Received: from janet.servers.dxld.at (unknown [5.9.225.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988C7193DA
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 12:01:20 -0700 (PDT)
Received: janet.servers.dxld.at; Tue, 28 Jun 2022 21:01:03 +0200
Date:   Tue, 28 Jun 2022 21:01:01 +0200
From:   Daniel =?utf-8?Q?Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] Allow resetting the include search path
Message-ID: <20220628190101.76cmatthftrsxbja@House>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yrs2nn/amfnaUDk8@salvia>
 <Yrs3kkbc4z5AMF+W@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Jun 28, 2022 at 07:13:02PM +0200, Pablo Neira Ayuso wrote:
> You can do
> 
> # cat x.nft
> include "./z.nft"
> # cat z.nft
> add table x
> 
> then:
> 
> # nft -f x.nft
> 
> using ./ at the beginning of the path overrides DEFAULT_INCLUDE_PATH.
> 
> Is this what you are searching for?

While that could work its rather a hassle. On my (Debian) system
nftables.service runs in the root directory so I'd have to do ugly stuff
like `include "./etc/nftables/foo.conf"` which I'd rather not. For one the
config would then depend on where `nft -f ...` is run exactly which sucks.

I think my patch is a much cleaner and general solution.

--Daniel
