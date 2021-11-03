Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D75BC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 07:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2275260FC4
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 07:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhKCIAO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 04:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhKCIAM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 04:00:12 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7A6C061714
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Nov 2021 00:57:36 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id BA60730000E54;
        Wed,  3 Nov 2021 08:57:32 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id A353427FF24; Wed,  3 Nov 2021 08:57:32 +0100 (CET)
Date:   Wed, 3 Nov 2021 08:57:32 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix bogus testsuite failure with 250Hz
Message-ID: <20211103075732.GA6561@wunner.de>
References: <20211102200753.25311-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102200753.25311-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 02, 2021 at 09:07:53PM +0100, Phil Sutter wrote:
> Previous fix for HZ=100 was not sufficient, a kernel with HZ=250 rounds
> the 10ms to 8ms it seems. Do as Lukas suggests and accept the occasional
> input/output asymmetry instead of continuing the hide'n'seek game.
[...]
> --- a/tests/shell/testcases/sets/0031set_timeout_size_0
> +++ b/tests/shell/testcases/sets/0031set_timeout_size_0
> @@ -8,5 +8,5 @@ add rule x test set update ip daddr timeout 100ms @y"
>  
>  set -e
>  $NFT -f - <<< "$RULESET"
> -$NFT list chain x test | grep -q 'update @y { ip saddr timeout 1d2h3m4s10ms }'
> +$NFT list chain x test | grep -q 'update @y { ip saddr timeout 1d2h3m4s\(10\|8\)ms }'
>  $NFT list chain x test | grep -q 'update @y { ip daddr timeout 100ms }'

Thanks, LGTM.

(The backslashes preceding the ( | ) characters could be avoided with
grep -E, but that's just a matter of personal preference.)
