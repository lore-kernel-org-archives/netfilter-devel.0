Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F6CC25B46
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 17:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjJWRP2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 13:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbjJWRPT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 13:15:19 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A61110D3
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 10:15:14 -0700 (PDT)
Received: from [78.30.35.151] (port=55042 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1quyWC-00H7s2-7o; Mon, 23 Oct 2023 19:15:10 +0200
Date:   Mon, 23 Oct 2023 19:15:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 3/3] parser_bison: fix length check for ifname in
 ifname_expr_alloc()
Message-ID: <ZTaqG+UTE/3JHdyW@calendula>
References: <20231023170058.919275-1-thaller@redhat.com>
 <20231023170058.919275-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231023170058.919275-3-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 23, 2023 at 07:00:47PM +0200, Thomas Haller wrote:
> IFNAMSIZ is 16, and the allowed byte length of the name is one less than
> that. Fix the length check and adjust a test for covering the longest
> allowed interface name.
> 
> This is obviously a change in behavior, because previously interface
> names with length 16 were accepted and were silently truncated along the
> way. Now they are rejected as invalid.
> 
> Fixes: fa52bc225806 ('parser: reject zero-length interface names')
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  src/parser_bison.y                                | 3 ++-
>  tests/shell/testcases/chains/0042chain_variable_0 | 7 +------
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index f0652ba651c6..9bfc3cdb2d12 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -16,6 +16,7 @@
>  #include <stdio.h>
>  #include <inttypes.h>
>  #include <syslog.h>
> +#include <net/if.h>
>  #include <netinet/ip.h>
>  #include <netinet/tcp.h>
>  #include <netinet/if_ether.h>
> @@ -158,7 +159,7 @@ static struct expr *ifname_expr_alloc(const struct location *location,
>  		return NULL;
>  	}
>  
> -	if (length > 16) {
> +	if (length >= IFNAMSIZ) {
>  		xfree(name);
>  		erec_queue(error(location, "interface name too long"), queue);
>  		return NULL;
> diff --git a/tests/shell/testcases/chains/0042chain_variable_0 b/tests/shell/testcases/chains/0042chain_variable_0
> index 739dc05a1777..a4b929f7344c 100755
> --- a/tests/shell/testcases/chains/0042chain_variable_0
> +++ b/tests/shell/testcases/chains/0042chain_variable_0
> @@ -26,18 +26,13 @@ table netdev filter2 {
>  
>  rc=0
>  $NFT -f - <<< $EXPECTED || rc=$?
> -test "$rc" = 0
> +test "$rc" = 1
>  cat <<EOF | $DIFF -u <($NFT list ruleset) -
>  table netdev filter1 {
>  	chain Main_Ingress1 {
>  		type filter hook ingress device "lo" priority -500; policy accept;
>  	}
>  }
> -table netdev filter2 {
> -	chain Main_Ingress2 {
> -		type filter hook ingress devices = { d23456789012345, lo } priority -500; policy accept;
> -	}
> -}

Please, do not remove it, fix this test.
