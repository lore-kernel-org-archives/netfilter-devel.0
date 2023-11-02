Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F64C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 15:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjKBP4p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjKBP4p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 11:56:45 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3E012E
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 08:56:39 -0700 (PDT)
Received: from [78.30.35.151] (port=48012 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qya3d-009l7i-37; Thu, 02 Nov 2023 16:56:37 +0100
Date:   Thu, 2 Nov 2023 16:56:32 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tproxy: Drop artificial port printing restriction
Message-ID: <ZUPGsLWmneAY6QGF@calendula>
References: <20231102135258.17214-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231102135258.17214-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 02:52:58PM +0100, Phil Sutter wrote:
> It does not make much sense to omit printing the port expression if it's
> not a value expression: On one hand, input allows for more advanced
> uses. On the other, if it is in-kernel, best nft can do is to try and
> print it no matter what. Just ignoring ruleset elements can't be
> correct.
> 
> Fixes: 2be1d52644cf7 ("src: Add tproxy support")
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1721
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Great work Phil.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  src/statement.c                |  2 +-
>  tests/py/inet/tproxy.t         |  2 ++
>  tests/py/inet/tproxy.t.json    | 35 ++++++++++++++++++++++++++++++++++
>  tests/py/inet/tproxy.t.payload | 12 ++++++++++++
>  4 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/src/statement.c b/src/statement.c
> index 475611664946a..f5176e6d87f95 100644
> --- a/src/statement.c
> +++ b/src/statement.c
> @@ -989,7 +989,7 @@ static void tproxy_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
>  			expr_print(stmt->tproxy.addr, octx);
>  		}
>  	}
> -	if (stmt->tproxy.port && stmt->tproxy.port->etype == EXPR_VALUE) {
> +	if (stmt->tproxy.port) {
>  		if (!stmt->tproxy.addr)
>  			nft_print(octx, " ");
>  		nft_print(octx, ":");
> diff --git a/tests/py/inet/tproxy.t b/tests/py/inet/tproxy.t
> index d23bbcb56cdcd..9901df75a91a8 100644
> --- a/tests/py/inet/tproxy.t
> +++ b/tests/py/inet/tproxy.t
> @@ -19,3 +19,5 @@ meta l4proto 17 tproxy ip to :50080;ok
>  meta l4proto 17 tproxy ip6 to :50080;ok
>  meta l4proto 17 tproxy to :50080;ok
>  ip daddr 0.0.0.0/0 meta l4proto 6 tproxy ip to :2000;ok
> +
> +meta l4proto 6 tproxy ip to 127.0.0.1:symhash mod 2 map { 0 : 23, 1 : 42 };ok
> diff --git a/tests/py/inet/tproxy.t.json b/tests/py/inet/tproxy.t.json
> index 7b3b11c49205a..71b6fd2f678dd 100644
> --- a/tests/py/inet/tproxy.t.json
> +++ b/tests/py/inet/tproxy.t.json
> @@ -183,3 +183,38 @@
>          }
>      }
>  ]
> +
> +# meta l4proto 6 tproxy ip to 127.0.0.1:symhash mod 2 map { 0 : 23, 1 : 42 }
> +[
> +    {
> +        "match": {
> +            "left": {
> +                "meta": {
> +                    "key": "l4proto"
> +                }
> +            },
> +            "op": "==",
> +            "right": 6
> +        }
> +    },
> +    {
> +        "tproxy": {
> +            "addr": "127.0.0.1",
> +            "family": "ip",
> +            "port": {
> +                "map": {
> +                    "data": {
> +                        "set": [
> +                            [ 0, 23 ],
> +                            [ 1, 42 ]
> +                        ]
> +                    },
> +                    "key": {
> +                        "symhash": { "mod": 2 }
> +                    }
> +                }
> +            }
> +        }
> +    }
> +]
> +
> diff --git a/tests/py/inet/tproxy.t.payload b/tests/py/inet/tproxy.t.payload
> index 24bf8f6002f8f..2f41904261144 100644
> --- a/tests/py/inet/tproxy.t.payload
> +++ b/tests/py/inet/tproxy.t.payload
> @@ -61,3 +61,15 @@ inet x y
>    [ immediate reg 1 0x0000d007 ]
>    [ tproxy ip port reg 1 ]
>  
> +# meta l4proto 6 tproxy ip to 127.0.0.1:symhash mod 2 map { 0 : 23, 1 : 42 }
> +__map%d x b size 2
> +__map%d x 0
> +	element 00000000  : 00001700 0 [end]	element 00000001  : 00002a00 0 [end]
> +inet x y
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ immediate reg 1 0x0100007f ]
> +  [ hash reg 2 = symhash() % mod 2 ]
> +  [ lookup reg 2 set __map%d dreg 2 ]
> +  [ tproxy ip addr reg 1 port reg 2 ]
> +
> -- 
> 2.41.0
> 
