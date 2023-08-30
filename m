Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A0EC83F1A
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbjH3SjH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242458AbjH3Igm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 04:36:42 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E684D1AE
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 01:36:39 -0700 (PDT)
Received: from [78.30.34.192] (port=56496 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qbGgk-0011Zd-RR; Wed, 30 Aug 2023 10:36:37 +0200
Date:   Wed, 30 Aug 2023 10:36:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jorge Ortiz <jorge.ortiz.escribano@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, jortiz@teldat.com, fw@strlen.de
Subject: Re: [nft PATCH] evaluate: place byteorder conversion after numgen
 for IP address datatypes
Message-ID: <ZO7/kuB9rxbU08Qx@calendula>
References: <20230828190910.51041-1-jorge.ortiz.escribano@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230828190910.51041-1-jorge.ortiz.escribano@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 28, 2023 at 09:09:10PM +0200, Jorge Ortiz wrote:
> The numgen extension generates numbers in little-endian.
> This can be very tricky when trying to combine it with IP addresses, which use big endian.
> This change adds a new byteorder operation to convert data type endianness.
> 
> Before this patch:
> $ sudo nft -d netlink add rule nat snat_chain snat to numgen inc mod 7 offset 0x0a000001
> ip nat snat_chain
>   [ numgen reg 1 = inc mod 7 offset 167772161 ]
>   [ nat snat ip addr_min reg 1 ]
> 
> After this patch:
> $ sudo nft -d netlink add rule nat snat_chain snat to numgen inc mod 7 offset 0x0a000001
> ip nat snat_chain
>   [ numgen reg 1 = inc mod 7 offset 167772161 ]
>   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
>   [ nat snat ip addr_min reg 1 ]
> 
> Regression tests have been modified to include these new cases.

Missing Signed-off-by: tag. Maybe I add it before applying?

> ---
>  src/evaluate.c                   |  4 ++
>  tests/py/ip/numgen.t             |  2 +
>  tests/py/ip/numgen.t.json        | 73 +++++++++++++++++++------
>  tests/py/ip/numgen.t.json.output | 92 ++++++++++++++++++++++++++------
>  tests/py/ip/numgen.t.payload     | 13 ++++-
>  5 files changed, 152 insertions(+), 32 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 1ae2ef0d..fda72c34 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2830,6 +2830,10 @@ static int __stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
>  		return byteorder_conversion(ctx, expr, byteorder);
>  	case EXPR_PREFIX:
>  		return stmt_prefix_conversion(ctx, expr, byteorder);
> +	case EXPR_NUMGEN:
> +		if (dtype->type == TYPE_IPADDR)
> +			return byteorder_conversion(ctx, expr, byteorder);
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/tests/py/ip/numgen.t b/tests/py/ip/numgen.t
> index 29a6a105..2a881460 100644
> --- a/tests/py/ip/numgen.t
> +++ b/tests/py/ip/numgen.t
> @@ -5,3 +5,5 @@ ct mark set numgen inc mod 2;ok
>  ct mark set numgen inc mod 2 offset 100;ok
>  dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 };ok
>  dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200};ok
> +dnat to numgen inc mod 7 offset 167772161;ok
> +dnat to numgen inc mod 255 offset 167772161;ok
> diff --git a/tests/py/ip/numgen.t.json b/tests/py/ip/numgen.t.json
> index 9902c2cf..77bc0a78 100644
> --- a/tests/py/ip/numgen.t.json
> +++ b/tests/py/ip/numgen.t.json
> @@ -10,7 +10,8 @@
>              "value": {
>                  "numgen": {
>                      "mod": 2,
> -                    "mode": "inc"
> +                    "mode": "inc",
> +                    "offset": 0
>                  }
>              }
>          }
> @@ -43,12 +44,6 @@
>          "dnat": {
>              "addr": {
>                  "map": {
> -                    "key": {
> -                        "numgen": {
> -                            "mod": 2,
> -                            "mode": "inc"
> -                        }
> -                    },
>                      "data": {
>                          "set": [
>                              [
> @@ -60,6 +55,13 @@
>                                  "192.168.20.200"
>                              ]
>                          ]
> +                    },
> +                    "key": {
> +                        "numgen": {
> +                            "mod": 2,
> +                            "mode": "inc",
> +                            "offset": 0
> +                        }
>                      }
>                  }
>              }
> @@ -73,23 +75,34 @@
>          "dnat": {
>              "addr": {
>                  "map": {
> -                    "key": {
> -                        "numgen": {
> -                            "mod": 10,
> -                            "mode": "inc"
> -                        }
> -                    },
>                      "data": {
>                          "set": [
>                              [
> -                                { "range": [ 0, 5 ] },
> +                                {
> +                                    "range": [
> +                                        0,
> +                                        5
> +                                    ]
> +                                },
>                                  "192.168.10.100"
>                              ],
>                              [
> -                                { "range": [ 6, 9 ] },
> +                                {
> +                                    "range": [
> +                                        6,
> +                                        9
> +                                    ]
> +                                },
>                                  "192.168.20.200"
>                              ]
>                          ]
> +                    },
> +                    "key": {
> +                        "numgen": {
> +                            "mod": 10,
> +                            "mode": "inc",
> +                            "offset": 0
> +                        }
>                      }
>                  }
>              }
> @@ -97,3 +110,33 @@
>      }
>  ]
>  
> +# dnat to numgen inc mod 7 offset 167772161
> +[
> +    {
> +        "dnat": {
> +            "addr": {
> +                "numgen": {
> +                    "mod": 7,
> +                    "mode": "inc",
> +                    "offset": 167772161
> +                }
> +            }
> +        }
> +    }
> +]
> +
> +# dnat to numgen inc mod 255 offset 167772161
> +[
> +    {
> +        "dnat": {
> +            "addr": {
> +                "numgen": {
> +                    "mod": 255,
> +                    "mode": "inc",
> +                    "offset": 167772161
> +                }
> +            }
> +        }
> +    }
> +]
> +
> diff --git a/tests/py/ip/numgen.t.json.output b/tests/py/ip/numgen.t.json.output
> index b54121ca..77bc0a78 100644
> --- a/tests/py/ip/numgen.t.json.output
> +++ b/tests/py/ip/numgen.t.json.output
> @@ -18,19 +18,32 @@
>      }
>  ]
>  
> +# ct mark set numgen inc mod 2 offset 100
> +[
> +    {
> +        "mangle": {
> +            "key": {
> +                "ct": {
> +                    "key": "mark"
> +                }
> +            },
> +            "value": {
> +                "numgen": {
> +                    "mod": 2,
> +                    "mode": "inc",
> +                    "offset": 100
> +                }
> +            }
> +        }
> +    }
> +]
> +
>  # dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 }
>  [
>      {
>          "dnat": {
>              "addr": {
>                  "map": {
> -                    "key": {
> -                        "numgen": {
> -                            "mod": 2,
> -                            "mode": "inc",
> -                            "offset": 0
> -                        }
> -                    },
>                      "data": {
>                          "set": [
>                              [
> @@ -42,6 +55,13 @@
>                                  "192.168.20.200"
>                              ]
>                          ]
> +                    },
> +                    "key": {
> +                        "numgen": {
> +                            "mod": 2,
> +                            "mode": "inc",
> +                            "offset": 0
> +                        }
>                      }
>                  }
>              }
> @@ -55,24 +75,34 @@
>          "dnat": {
>              "addr": {
>                  "map": {
> -                    "key": {
> -                        "numgen": {
> -                            "mod": 10,
> -                            "mode": "inc",
> -                            "offset": 0
> -                        }
> -                    },
>                      "data": {
>                          "set": [
>                              [
> -                                { "range": [ 0, 5 ] },
> +                                {
> +                                    "range": [
> +                                        0,
> +                                        5
> +                                    ]
> +                                },
>                                  "192.168.10.100"
>                              ],
>                              [
> -                                { "range": [ 6, 9 ] },
> +                                {
> +                                    "range": [
> +                                        6,
> +                                        9
> +                                    ]
> +                                },
>                                  "192.168.20.200"
>                              ]
>                          ]
> +                    },
> +                    "key": {
> +                        "numgen": {
> +                            "mod": 10,
> +                            "mode": "inc",
> +                            "offset": 0
> +                        }
>                      }
>                  }
>              }
> @@ -80,3 +110,33 @@
>      }
>  ]
>  
> +# dnat to numgen inc mod 7 offset 167772161
> +[
> +    {
> +        "dnat": {
> +            "addr": {
> +                "numgen": {
> +                    "mod": 7,
> +                    "mode": "inc",
> +                    "offset": 167772161
> +                }
> +            }
> +        }
> +    }
> +]
> +
> +# dnat to numgen inc mod 255 offset 167772161
> +[
> +    {
> +        "dnat": {
> +            "addr": {
> +                "numgen": {
> +                    "mod": 255,
> +                    "mode": "inc",
> +                    "offset": 167772161
> +                }
> +            }
> +        }
> +    }
> +]
> +
> diff --git a/tests/py/ip/numgen.t.payload b/tests/py/ip/numgen.t.payload
> index 3349c68b..34960093 100644
> --- a/tests/py/ip/numgen.t.payload
> +++ b/tests/py/ip/numgen.t.payload
> @@ -7,7 +7,7 @@ ip test-ip4 pre
>  __map%d x b
>  __map%d x 0
>          element 00000000  : 640aa8c0 0 [end]    element 00000001  : c814a8c0 0 [end]
> -ip test-ip4 pre 
> +ip test-ip4 pre
>    [ numgen reg 1 = inc mod 2 ]
>    [ lookup reg 1 set __map%d dreg 1 ]
>    [ nat dnat ip addr_min reg 1 ]
> @@ -27,3 +27,14 @@ ip test-ip4 pre
>    [ numgen reg 1 = inc mod 2 offset 100 ]
>    [ ct set mark with reg 1 ]
>  
> +# dnat to numgen inc mod 7 offset 167772161
> +ip test-ip4 pre
> +  [ numgen reg 1 = inc mod 7 offset 167772161 ]
> +  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
> +  [ nat dnat ip addr_min reg 1 ]
> +
> +# dnat to numgen inc mod 255 offset 167772161
> +ip test-ip4 pre
> +  [ numgen reg 1 = inc mod 255 offset 167772161 ]
> +  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
> +  [ nat dnat ip addr_min reg 1 ]
> -- 
> 2.34.1
> 
