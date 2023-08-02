Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5C2C001E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 22:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjHBWpd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 18:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjHBWpb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 18:45:31 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1517C213F
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 15:45:30 -0700 (PDT)
Received: from fews01-sea.riseup.net (fews01-sea-pn.riseup.net [10.0.1.109])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx1.riseup.net (Postfix) with ESMTPS id 4RGRrn3sPyzDqkd;
        Wed,  2 Aug 2023 22:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1691016329; bh=6KXzPlVQP3x+w6/CDrWPZmqua7ARbi/WPSsLEiVsOzo=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=N6gLbjaPSC2xu9tL0RzA2D1VrRqUf2Ie4g4GT/60EdYg/ea5Q5qRVvLOiOTvDHUyy
         7GoQdNxuf0bgA0b/fW+4GXkM2+1yJYTtra2u/Y08mXg8SbIa+cs3y0CvZHD0jpIKQG
         q8USbSMXGNBRJa9mFqFfmyLEbKDoY+YgAnJVTJGU=
X-Riseup-User-ID: ABFF8C414E1F48EDCCFDA5C4379031570569BB28E9AF84A486ED25F760008E17
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews01-sea.riseup.net (Postfix) with ESMTPSA id 4RGRrY45wVzJnsZ;
        Wed,  2 Aug 2023 22:45:17 +0000 (UTC)
Message-ID: <8e5ab358-23dd-56dd-bc7a-b551ef950689@riseup.net>
Date:   Thu, 3 Aug 2023 00:45:14 +0200
MIME-Version: 1.0
Subject: Re: [nft PATCH] tests: shell: Review test-cases for destroy command
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
References: <20230801114236.27235-1-phil@nwl.cc>
From:   "Fernando F. Mancera" <ffmancera@riseup.net>
In-Reply-To: <20230801114236.27235-1-phil@nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Thanks Phil, LGTM. Just one comment:

On 01/08/2023 13:42, Phil Sutter wrote:
> Having separate files for successful destroy of existing and
> non-existing objects is a bit too much, just combine them into one.
> 
> While being at it:
> 
> * Check that deleted objects are actually gone

I think that is done automatically with the expected ruleset.. isn't? If 
not, what is the purpose of having them?

Thanks,
Fernando.

> * No bashisms, using /bin/sh is fine
> * Append '-e' to shebang itself instead of calling 'set'
> * Use 'nft -a -e' instead of assuming the created rule's handle value
> * Shellcheck warned about curly braces, quote them
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>   tests/shell/testcases/chains/0044chain_destroy_0    | 12 ++++++++----
>   tests/shell/testcases/chains/0045chain_destroy_0    |  8 --------
>   tests/shell/testcases/flowtable/0015destroy_0       | 10 +++++++---
>   tests/shell/testcases/flowtable/0016destroy_0       |  6 ------
>   tests/shell/testcases/maps/0014destroy_0            | 11 +++++++----
>   tests/shell/testcases/maps/0015destroy_0            |  7 -------
>   tests/shell/testcases/rule_management/0012destroy_0 | 10 ++++++++--
>   tests/shell/testcases/rule_management/0013destroy_0 |  8 --------
>   tests/shell/testcases/sets/0072destroy_0            | 11 +++++++----
>   tests/shell/testcases/sets/0073destroy_0            |  7 -------
>   10 files changed, 37 insertions(+), 53 deletions(-)
>   delete mode 100755 tests/shell/testcases/chains/0045chain_destroy_0
>   delete mode 100755 tests/shell/testcases/flowtable/0016destroy_0
>   delete mode 100755 tests/shell/testcases/maps/0015destroy_0
>   delete mode 100755 tests/shell/testcases/rule_management/0013destroy_0
>   delete mode 100755 tests/shell/testcases/sets/0073destroy_0
> 
> diff --git a/tests/shell/testcases/chains/0044chain_destroy_0 b/tests/shell/testcases/chains/0044chain_destroy_0
> index 070021cf12f24..fbc1044474b12 100755
> --- a/tests/shell/testcases/chains/0044chain_destroy_0
> +++ b/tests/shell/testcases/chains/0044chain_destroy_0
> @@ -1,7 +1,11 @@
> -#!/bin/bash
> -
> -set -e
> +#!/bin/sh -e
>   
>   $NFT add table t
>   
> -$NFT destroy chain t nochain
> +# pass for non-existent chain
> +$NFT destroy chain t c
> +
> +# successfully delete existing chain
> +$NFT add chain t c
> +$NFT destroy chain t c
> +! $NFT list chain t c 2>/dev/null
> diff --git a/tests/shell/testcases/chains/0045chain_destroy_0 b/tests/shell/testcases/chains/0045chain_destroy_0
> deleted file mode 100755
> index b356f8f885ca4..0000000000000
> --- a/tests/shell/testcases/chains/0045chain_destroy_0
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -#!/bin/bash
> -
> -set -e
> -
> -$NFT add table t
> -$NFT add chain t c
> -
> -$NFT destroy chain t c
> diff --git a/tests/shell/testcases/flowtable/0015destroy_0 b/tests/shell/testcases/flowtable/0015destroy_0
> index 4828d8187018c..01af84869a3e0 100755
> --- a/tests/shell/testcases/flowtable/0015destroy_0
> +++ b/tests/shell/testcases/flowtable/0015destroy_0
> @@ -1,7 +1,11 @@
> -#!/bin/bash
> +#!/bin/sh -e
>   
> -set -e
>   $NFT add table t
> -$NFT add flowtable t f { hook ingress priority 10 \; devices = { lo }\; }
>   
> +# pass for non-existent flowtable
>   $NFT destroy flowtable t f
> +
> +# successfully delete existing flowtable
> +$NFT add flowtable t f '{ hook ingress priority 10; devices = { lo }; }'
> +$NFT destroy flowtable t f
> +! $NFT list flowtable t f 2>/dev/null
> diff --git a/tests/shell/testcases/flowtable/0016destroy_0 b/tests/shell/testcases/flowtable/0016destroy_0
> deleted file mode 100755
> index ce23c753365af..0000000000000
> --- a/tests/shell/testcases/flowtable/0016destroy_0
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#!/bin/bash
> -
> -set -e
> -$NFT add table t
> -
> -$NFT destroy flowtable t f
> diff --git a/tests/shell/testcases/maps/0014destroy_0 b/tests/shell/testcases/maps/0014destroy_0
> index b769276d52599..6e639a11e2ac2 100755
> --- a/tests/shell/testcases/maps/0014destroy_0
> +++ b/tests/shell/testcases/maps/0014destroy_0
> @@ -1,8 +1,11 @@
> -#!/bin/bash
> -
> -set -e
> +#!/bin/sh -e
>   
>   $NFT add table x
> -$NFT add map x y { type ipv4_addr : ipv4_addr\; }
>   
> +# pass for non-existent map
> +$NFT destroy map x y
> +
> +# successfully delete existing map
> +$NFT add map x y '{ type ipv4_addr : ipv4_addr; }'
>   $NFT destroy map x y
> +! $NFT list map x y 2>/dev/null
> diff --git a/tests/shell/testcases/maps/0015destroy_0 b/tests/shell/testcases/maps/0015destroy_0
> deleted file mode 100755
> index abad4d57e7221..0000000000000
> --- a/tests/shell/testcases/maps/0015destroy_0
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#!/bin/bash
> -
> -set -e
> -
> -$NFT add table x
> -
> -$NFT destroy map x nonmap
> diff --git a/tests/shell/testcases/rule_management/0012destroy_0 b/tests/shell/testcases/rule_management/0012destroy_0
> index 1b61155e9b7ef..57c4da99c285c 100755
> --- a/tests/shell/testcases/rule_management/0012destroy_0
> +++ b/tests/shell/testcases/rule_management/0012destroy_0
> @@ -1,7 +1,13 @@
> -#!/bin/bash
> +#!/bin/sh -e
>   
> -set -e
>   $NFT add table t
>   $NFT add chain t c
>   
> +# pass for non-existent rule
>   $NFT destroy rule t c handle 3333
> +
> +# successfully delete existing rule
> +handle=$($NFT -a -e insert rule t c accept | \
> +	sed -n 's/.*handle \([0-9]*\)$/\1/p')
> +$NFT destroy rule t c handle "$handle"
> +! $NFT list chain t c | grep -q accept
> diff --git a/tests/shell/testcases/rule_management/0013destroy_0 b/tests/shell/testcases/rule_management/0013destroy_0
> deleted file mode 100755
> index 895c24a4dacba..0000000000000
> --- a/tests/shell/testcases/rule_management/0013destroy_0
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -#!/bin/bash
> -
> -set -e
> -$NFT add table t
> -$NFT add chain t c
> -$NFT insert rule t c accept # should have handle 2
> -
> -$NFT destroy rule t c handle 2
> diff --git a/tests/shell/testcases/sets/0072destroy_0 b/tests/shell/testcases/sets/0072destroy_0
> index c9cf9ff716349..80d24b4760099 100755
> --- a/tests/shell/testcases/sets/0072destroy_0
> +++ b/tests/shell/testcases/sets/0072destroy_0
> @@ -1,8 +1,11 @@
> -#!/bin/bash
> -
> -set -e
> +#!/bin/sh -e
>   
>   $NFT add table x
> -$NFT add set x s {type ipv4_addr\; size 2\;}
>   
> +# pass for non-existent set
> +$NFT destroy set x s
> +
> +# successfully delete existing set
> +$NFT add set x s '{type ipv4_addr; size 2;}'
>   $NFT destroy set x s
> +! $NFT list set x s 2>/dev/null
> diff --git a/tests/shell/testcases/sets/0073destroy_0 b/tests/shell/testcases/sets/0073destroy_0
> deleted file mode 100755
> index a9d65a5541c53..0000000000000
> --- a/tests/shell/testcases/sets/0073destroy_0
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#!/bin/bash
> -
> -set -e
> -
> -$NFT add table x
> -
> -$NFT destroy set x s
