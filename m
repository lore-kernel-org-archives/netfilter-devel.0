Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB3CEB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 12:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbjHCMwo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 08:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbjHCMwn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 08:52:43 -0400
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651C83A92
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 05:52:26 -0700 (PDT)
Received: from fews02-sea.riseup.net (fews02-sea-pn.riseup.net [10.0.1.112])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx0.riseup.net (Postfix) with ESMTPS id 4RGpf14L4Pz9t07;
        Thu,  3 Aug 2023 12:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1691067145; bh=JfTrVVkeIZnYkP93jsQ3NrWtmq4/s0s4ykD1L1y6kRs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Afdgc/Y04XiuVuJUB901UX8ogTxTtFWtTYomsBew+uRVIHJkc0vGDPZiTineALYyZ
         Vsyz+vQ/K92zOfxnJS6vHabSd3unkK3tpVfArbl+ZNDcWO9Fe2n6WEK7mwCs2rlcQm
         dYJmCB4ZWxkEqLwsE8G37Q2MN8nEe9pnM+x/rM2A=
X-Riseup-User-ID: 1A42D2119FD88E2AB41E30D3930FD4AAFD3AA64214CC77AAD9C1326B7F53AFA9
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews02-sea.riseup.net (Postfix) with ESMTPSA id 4RGpdn4Tr7zFqgS;
        Thu,  3 Aug 2023 12:52:13 +0000 (UTC)
Message-ID: <87992425-c2c1-9ca9-bf4a-6bac9a005ba7@riseup.net>
Date:   Thu, 3 Aug 2023 14:52:11 +0200
MIME-Version: 1.0
Subject: Re: [nft PATCH v2] tests: shell: Review test-cases for destroy
 command
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20230803105725.5813-1-phil@nwl.cc>
From:   "Fernando F. Mancera" <ffmancera@riseup.net>
In-Reply-To: <20230803105725.5813-1-phil@nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Looks good to me, thank you!

On 03/08/2023 12:57, Phil Sutter wrote:
> Having separate files for successful destroy of existing and
> non-existing objects is a bit too much, just combine them into one.
> 
> While being at it:
> 
> * No bashisms, using /bin/sh is fine
> * Append '-e' to shebang itself instead of calling 'set'
> * Use 'nft -a -e' instead of assuming the created rule's handle value
> * Shellcheck warned about curly braces, quote them
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Non-existence already asserted via dump files
> - Drop dump files left-over after removing tests
> ---
>   tests/shell/testcases/chains/0044chain_destroy_0      | 11 +++++++----
>   tests/shell/testcases/chains/0045chain_destroy_0      |  8 --------
>   .../testcases/chains/dumps/0045chain_destroy_0.nft    |  2 --
>   tests/shell/testcases/flowtable/0015destroy_0         |  9 ++++++---
>   tests/shell/testcases/flowtable/0016destroy_0         |  6 ------
>   .../shell/testcases/flowtable/dumps/0016destroy_0.nft |  2 --
>   tests/shell/testcases/maps/0014destroy_0              | 10 ++++++----
>   tests/shell/testcases/maps/0015destroy_0              |  7 -------
>   tests/shell/testcases/maps/dumps/0015destroy_0.nft    |  2 --
>   tests/shell/testcases/rule_management/0012destroy_0   |  9 +++++++--
>   tests/shell/testcases/rule_management/0013destroy_0   |  8 --------
>   .../testcases/rule_management/dumps/0013destroy_0     |  4 ----
>   tests/shell/testcases/sets/0072destroy_0              | 10 ++++++----
>   tests/shell/testcases/sets/0073destroy_0              |  7 -------
>   tests/shell/testcases/sets/dumps/0073destroy_0.nft    |  2 --
>   15 files changed, 32 insertions(+), 65 deletions(-)
>   delete mode 100755 tests/shell/testcases/chains/0045chain_destroy_0
>   delete mode 100644 tests/shell/testcases/chains/dumps/0045chain_destroy_0.nft
>   delete mode 100755 tests/shell/testcases/flowtable/0016destroy_0
>   delete mode 100644 tests/shell/testcases/flowtable/dumps/0016destroy_0.nft
>   delete mode 100755 tests/shell/testcases/maps/0015destroy_0
>   delete mode 100644 tests/shell/testcases/maps/dumps/0015destroy_0.nft
>   delete mode 100755 tests/shell/testcases/rule_management/0013destroy_0
>   delete mode 100644 tests/shell/testcases/rule_management/dumps/0013destroy_0
>   delete mode 100755 tests/shell/testcases/sets/0073destroy_0
>   delete mode 100644 tests/shell/testcases/sets/dumps/0073destroy_0.nft
> 
> diff --git a/tests/shell/testcases/chains/0044chain_destroy_0 b/tests/shell/testcases/chains/0044chain_destroy_0
> index 070021cf12f24..8384da66a5b0d 100755
> --- a/tests/shell/testcases/chains/0044chain_destroy_0
> +++ b/tests/shell/testcases/chains/0044chain_destroy_0
> @@ -1,7 +1,10 @@
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
> diff --git a/tests/shell/testcases/chains/dumps/0045chain_destroy_0.nft b/tests/shell/testcases/chains/dumps/0045chain_destroy_0.nft
> deleted file mode 100644
> index 985768baf3a1f..0000000000000
> --- a/tests/shell/testcases/chains/dumps/0045chain_destroy_0.nft
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -table ip t {
> -}
> diff --git a/tests/shell/testcases/flowtable/0015destroy_0 b/tests/shell/testcases/flowtable/0015destroy_0
> index 4828d8187018c..66fce4992a502 100755
> --- a/tests/shell/testcases/flowtable/0015destroy_0
> +++ b/tests/shell/testcases/flowtable/0015destroy_0
> @@ -1,7 +1,10 @@
> -#!/bin/bash
> +#!/bin/sh -e
>   
> -set -e
>   $NFT add table t
> -$NFT add flowtable t f { hook ingress priority 10 \; devices = { lo }\; }
>   
> +# pass for non-existent flowtable
> +$NFT destroy flowtable t f
> +
> +# successfully delete existing flowtable
> +$NFT add flowtable t f '{ hook ingress priority 10; devices = { lo }; }'
>   $NFT destroy flowtable t f
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
> diff --git a/tests/shell/testcases/flowtable/dumps/0016destroy_0.nft b/tests/shell/testcases/flowtable/dumps/0016destroy_0.nft
> deleted file mode 100644
> index 985768baf3a1f..0000000000000
> --- a/tests/shell/testcases/flowtable/dumps/0016destroy_0.nft
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -table ip t {
> -}
> diff --git a/tests/shell/testcases/maps/0014destroy_0 b/tests/shell/testcases/maps/0014destroy_0
> index b769276d52599..14c3f78af7f19 100755
> --- a/tests/shell/testcases/maps/0014destroy_0
> +++ b/tests/shell/testcases/maps/0014destroy_0
> @@ -1,8 +1,10 @@
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
> diff --git a/tests/shell/testcases/maps/dumps/0015destroy_0.nft b/tests/shell/testcases/maps/dumps/0015destroy_0.nft
> deleted file mode 100644
> index 5d4d2cafb577d..0000000000000
> --- a/tests/shell/testcases/maps/dumps/0015destroy_0.nft
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -table ip x {
> -}
> diff --git a/tests/shell/testcases/rule_management/0012destroy_0 b/tests/shell/testcases/rule_management/0012destroy_0
> index 1b61155e9b7ef..85f9c9f6d4c78 100755
> --- a/tests/shell/testcases/rule_management/0012destroy_0
> +++ b/tests/shell/testcases/rule_management/0012destroy_0
> @@ -1,7 +1,12 @@
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
> diff --git a/tests/shell/testcases/rule_management/dumps/0013destroy_0 b/tests/shell/testcases/rule_management/dumps/0013destroy_0
> deleted file mode 100644
> index 1e0d1d603739b..0000000000000
> --- a/tests/shell/testcases/rule_management/dumps/0013destroy_0
> +++ /dev/null
> @@ -1,4 +0,0 @@
> -table ip t {
> -	chain c {
> -	}
> -}
> diff --git a/tests/shell/testcases/sets/0072destroy_0 b/tests/shell/testcases/sets/0072destroy_0
> index c9cf9ff716349..fd1d645057c09 100755
> --- a/tests/shell/testcases/sets/0072destroy_0
> +++ b/tests/shell/testcases/sets/0072destroy_0
> @@ -1,8 +1,10 @@
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
> diff --git a/tests/shell/testcases/sets/dumps/0073destroy_0.nft b/tests/shell/testcases/sets/dumps/0073destroy_0.nft
> deleted file mode 100644
> index 5d4d2cafb577d..0000000000000
> --- a/tests/shell/testcases/sets/dumps/0073destroy_0.nft
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -table ip x {
> -}
