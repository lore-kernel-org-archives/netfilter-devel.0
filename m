Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898AAC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FA1A61073
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhKBUXx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 16:23:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33150 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhKBUXt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 16:23:49 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 73B60605C1;
        Tue,  2 Nov 2021 21:19:19 +0100 (CET)
Date:   Tue, 2 Nov 2021 21:21:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [nft PATCH] tests: shell: Fix bogus testsuite failure with 250Hz
Message-ID: <YYGdtUX8YbEScUHE@salvia>
References: <20211102200753.25311-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211102200753.25311-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 02, 2021 at 09:07:53PM +0100, Phil Sutter wrote:
> Previous fix for HZ=100 was not sufficient, a kernel with HZ=250 rounds
> the 10ms to 8ms it seems. Do as Lukas suggests and accept the occasional
> input/output asymmetry instead of continuing the hide'n'seek game.
> 
> Fixes: c9c5b5f621c37 ("tests: shell: Fix bogus testsuite failure with 100Hz")
> Suggested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

ACK

> ---
>  tests/shell/testcases/sets/0031set_timeout_size_0 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/shell/testcases/sets/0031set_timeout_size_0 b/tests/shell/testcases/sets/0031set_timeout_size_0
> index 796640d64670a..9a4a27f6c4512 100755
> --- a/tests/shell/testcases/sets/0031set_timeout_size_0
> +++ b/tests/shell/testcases/sets/0031set_timeout_size_0
> @@ -8,5 +8,5 @@ add rule x test set update ip daddr timeout 100ms @y"
>  
>  set -e
>  $NFT -f - <<< "$RULESET"
> -$NFT list chain x test | grep -q 'update @y { ip saddr timeout 1d2h3m4s10ms }'
> +$NFT list chain x test | grep -q 'update @y { ip saddr timeout 1d2h3m4s\(10\|8\)ms }'
>  $NFT list chain x test | grep -q 'update @y { ip daddr timeout 100ms }'
> -- 
> 2.33.0
> 
