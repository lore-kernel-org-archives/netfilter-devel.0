Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDEA56A01D
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710955047; cv=none; b=dcc8pVTuLB8eZxdaaGIT0nuVO+I9ko9LfQ25/gHfswXZk5HGJTfBW0eP1jNN22DKKQ+nU4eMV3ptfEvjcbySQ8PG2lfLKM4ZlT3ar7BT17U7HYmrc9vGam5wCGAZdXAwyLqVd0f8n8fTzX5mXBxGsV45DQodNnwQ/3tZc0nXkms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710955047; c=relaxed/simple;
	bh=cjUMEJa+pAVV2l3C3mYYctRLbBbNMlLnDnpua1slKfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJuu/H7CyPBbvjLo4Va0UquD3aaPdbsLZSGoqp9Wq5I6bz0lLVkD0NncEE4Wu1L8YJjncJTb6j9csMj0rGfpw8wfVKlSvVHoghbvJY+ip8va1bW2ZEiuT0jPeoVeU/Uuptdy/USvsxHWxl4qvjO4khv9drr3EyjdD6YuutQK0R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 20 Mar 2024 18:17:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] json: Accept more than two operands in binary
 expressions
Message-ID: <ZfsaHoVscFBO73ib@calendula>
References: <20240320145806.4167-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320145806.4167-1-phil@nwl.cc>

On Wed, Mar 20, 2024 at 03:58:06PM +0100, Phil Sutter wrote:
> The most common use case is ORing flags like
> 
> | syn | ack | rst
> 
> but nft seems to be fine with less intuitive stuff like
> 
> | meta mark set ip dscp << 2 << 3

This is equivalent to:

  meta mark set ip dscp << 5

userspace is lacking the code to simplify this, just like it does for:

  meta mark set ip dscp | 0x8 | 0xf0

results in:

  meta mark set ip dscp | 0xf8

> so support all of them.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  doc/libnftables-json.adoc                     | 18 ++--
>  src/json.c                                    | 19 +++-
>  src/parser_json.c                             | 12 +++
>  tests/py/inet/tcp.t.json                      | 50 +---------
>  tests/py/inet/tcp.t.json.output               | 34 ++-----
>  .../dumps/0012different_defines_0.json-nft    |  8 +-
>  .../sets/dumps/0055tcpflags_0.json-nft        | 98 +++++--------------
>  7 files changed, 75 insertions(+), 164 deletions(-)
> 
> diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
> index 3948a0bad47c1..e3b24cc4ed60d 100644
> --- a/doc/libnftables-json.adoc
> +++ b/doc/libnftables-json.adoc
> @@ -1343,15 +1343,17 @@ Perform kernel Forwarding Information Base lookups.
>  
>  === BINARY OPERATION
>  [verse]
> -*{ "|": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
> -*{ "^": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
> -*{ "&": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
> -*{ "+<<+": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
> -*{ ">>": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
> -
> -All binary operations expect an array of exactly two expressions, of which the
> +*{ "|": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
> +*{ "^": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
> +*{ "&": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
> +*{ "+<<+": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
> +*{ ">>": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
> +'EXPRESSIONS' := 'EXPRESSION' | 'EXPRESSION'*,* 'EXPRESSIONS'
> +
> +All binary operations expect an array of at least two expressions, of which the
>  first element denotes the left hand side and the second one the right hand
> -side.
> +side. Extra elements are accepted in the given array and appended to the term
> +accordingly.
>  
>  === VERDICT
>  [verse]
> diff --git a/src/json.c b/src/json.c
> index 29fbd0cfdba28..3753017169930 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -540,11 +540,24 @@ json_t *flagcmp_expr_json(const struct expr *expr, struct output_ctx *octx)
>  			 "right", expr_print_json(expr->flagcmp.value, octx));
>  }
>  
> +static json_t *
> +__binop_expr_json(int op, const struct expr *expr, struct output_ctx *octx)
> +{
> +	json_t *a = json_array();
> +
> +	if (expr->etype == EXPR_BINOP && expr->op == op) {
> +		json_array_extend(a, __binop_expr_json(op, expr->left, octx));
> +		json_array_extend(a, __binop_expr_json(op, expr->right, octx));
> +	} else {
> +		json_array_append_new(a, expr_print_json(expr, octx));
> +	}
> +	return a;
> +}
> +
>  json_t *binop_expr_json(const struct expr *expr, struct output_ctx *octx)
>  {
> -	return json_pack("{s:[o, o]}", expr_op_symbols[expr->op],
> -			 expr_print_json(expr->left, octx),
> -			 expr_print_json(expr->right, octx));
> +	return json_pack("{s:o}", expr_op_symbols[expr->op],
> +			 __binop_expr_json(expr->op, expr, octx));
>  }
>  
>  json_t *relational_expr_json(const struct expr *expr, struct output_ctx *octx)
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 04255688ca04c..55d65c415bf5c 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -1204,6 +1204,18 @@ static struct expr *json_parse_binop_expr(struct json_ctx *ctx,
>  		return NULL;
>  	}
>  
> +	if (json_array_size(root) > 2) {
> +		left = json_parse_primary_expr(ctx, json_array_get(root, 0));
> +		right = json_parse_primary_expr(ctx, json_array_get(root, 1));
> +		left = binop_expr_alloc(int_loc, thisop, left, right);
> +		for (i = 2; i < json_array_size(root); i++) {
> +			jright = json_array_get(root, i);
> +			right = json_parse_primary_expr(ctx, jright);
> +			left = binop_expr_alloc(int_loc, thisop, left, right);
> +		}
> +		return left;
> +	}
> +
>  	if (json_unpack_err(ctx, root, "[o, o!]", &jleft, &jright))
>  		return NULL;
>  
> diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
> index 8439c2b5931dd..9a1b158e7ac0b 100644
> --- a/tests/py/inet/tcp.t.json
> +++ b/tests/py/inet/tcp.t.json
> @@ -954,12 +954,12 @@
>                          }
>                      },
>                      {
> -                        "|": [ "fin", { "|": [ "syn", { "|": [ "rst", { "|": [ "psh", { "|": [ "ack", { "|": [ "urg", { "|": [ "ecn", "cwr" ] } ] } ] } ] } ] } ] } ]
> +                        "|": [ "fin", "syn", "rst", "psh", "ack", "urg", "ecn", "cwr" ]
>                      }
>                  ]
>              },
>              "op": "==",
> -            "right": { "|": [ "fin", { "|": [ "syn", { "|": [ "rst", { "|": [ "psh", { "|": [ "ack", { "|": [ "urg", { "|": [ "ecn", "cwr" ] } ] } ] } ] } ] } ] } ] }
> +            "right": { "|": [ "fin", "syn", "rst", "psh", "ack", "urg", "ecn", "cwr" ] }
>          }
>      }
>  ]
> @@ -1395,55 +1395,15 @@
>                              "protocol": "tcp"
>                          }
>                      },
> -                    {
> -                        "|": [
> -                            {
> -                                "|": [
> -                                    {
> -                                        "|": [
> -                                            {
> -                                                "|": [
> -                                                    {
> -                                                        "|": [
> -                                                            "fin",
> -                                                            "syn"
> -                                                        ]
> -                                                    },
> -                                                    "rst"
> -                                                ]
> -                                            },
> -                                            "psh"
> -                                        ]
> -                                    },
> -                                    "ack"
> -                                ]
> -                            },
> -                            "urg"
> -                        ]
> -                    }
> +                    { "|": [ "fin", "syn", "rst", "psh", "ack", "urg" ] }
>                  ]
>              },
>              "op": "==",
>              "right": {
>                  "set": [
> -                    {
> -                        "|": [
> -                            {
> -                                "|": [
> -                                    "fin",
> -                                    "psh"
> -                                ]
> -                            },
> -                            "ack"
> -                        ]
> -                    },
> +                    { "|": [ "fin", "psh", "ack" ] },
>                      "fin",
> -                    {
> -                        "|": [
> -                            "psh",
> -                            "ack"
> -                        ]
> -                    },
> +                    { "|": [ "psh", "ack" ] },
>                      "ack"
>                  ]
>              }
> diff --git a/tests/py/inet/tcp.t.json.output b/tests/py/inet/tcp.t.json.output
> index c471e8d8dcef5..5a16714e9145d 100644
> --- a/tests/py/inet/tcp.t.json.output
> +++ b/tests/py/inet/tcp.t.json.output
> @@ -155,27 +155,11 @@
>                      },
>                      {
>                          "|": [
> -                            {
> -                                "|": [
> -                                    {
> -                                        "|": [
> -                                            {
> -                                                "|": [
> -                                                    {
> -                                                        "|": [
> -                                                            "fin",
> -                                                            "syn"
> -                                                        ]
> -                                                    },
> -                                                    "rst"
> -                                                ]
> -                                            },
> -                                            "psh"
> -                                        ]
> -                                    },
> -                                    "ack"
> -                                ]
> -                            },
> +                            "fin",
> +                            "syn",
> +                            "rst",
> +                            "psh",
> +                            "ack",
>                              "urg"
>                          ]
>                      }
> @@ -187,12 +171,8 @@
>                      "fin",
>                      {
>                          "|": [
> -                            {
> -                                "|": [
> -                                    "fin",
> -                                    "psh"
> -                                ]
> -                            },
> +                            "fin",
> +                            "psh",
>                              "ack"
>                          ]
>                      },
> diff --git a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
> index 8f3f3a81a9bc8..1b2e342047f4b 100644
> --- a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
> +++ b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
> @@ -169,12 +169,8 @@
>                },
>                "right": {
>                  "|": [
> -                  {
> -                    "|": [
> -                      "established",
> -                      "related"
> -                    ]
> -                  },
> +                  "established",
> +                  "related",
>                    "new"
>                  ]
>                }
> diff --git a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
> index cd39f0909e120..6a3511515f785 100644
> --- a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
> +++ b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
> @@ -27,39 +27,23 @@
>          "elem": [
>            {
>              "|": [
> -              {
> -                "|": [
> -                  {
> -                    "|": [
> -                      "fin",
> -                      "psh"
> -                    ]
> -                  },
> -                  "ack"
> -                ]
> -              },
> +              "fin",
> +              "psh",
> +              "ack",
>                "urg"
>              ]
>            },
>            {
>              "|": [
> -              {
> -                "|": [
> -                  "fin",
> -                  "psh"
> -                ]
> -              },
> +              "fin",
> +              "psh",
>                "ack"
>              ]
>            },
>            {
>              "|": [
> -              {
> -                "|": [
> -                  "fin",
> -                  "ack"
> -                ]
> -              },
> +              "fin",
> +              "ack",
>                "urg"
>              ]
>            },
> @@ -71,39 +55,23 @@
>            },
>            {
>              "|": [
> -              {
> -                "|": [
> -                  {
> -                    "|": [
> -                      "syn",
> -                      "psh"
> -                    ]
> -                  },
> -                  "ack"
> -                ]
> -              },
> +              "syn",
> +              "psh",
> +              "ack",
>                "urg"
>              ]
>            },
>            {
>              "|": [
> -              {
> -                "|": [
> -                  "syn",
> -                  "psh"
> -                ]
> -              },
> +              "syn",
> +              "psh",
>                "ack"
>              ]
>            },
>            {
>              "|": [
> -              {
> -                "|": [
> -                  "syn",
> -                  "ack"
> -                ]
> -              },
> +              "syn",
> +              "ack",
>                "urg"
>              ]
>            },
> @@ -116,39 +84,23 @@
>            "syn",
>            {
>              "|": [
> -              {
> -                "|": [
> -                  {
> -                    "|": [
> -                      "rst",
> -                      "psh"
> -                    ]
> -                  },
> -                  "ack"
> -                ]
> -              },
> +              "rst",
> +              "psh",
> +              "ack",
>                "urg"
>              ]
>            },
>            {
>              "|": [
> -              {
> -                "|": [
> -                  "rst",
> -                  "psh"
> -                ]
> -              },
> +              "rst",
> +              "psh",
>                "ack"
>              ]
>            },
>            {
>              "|": [
> -              {
> -                "|": [
> -                  "rst",
> -                  "ack"
> -                ]
> -              },
> +              "rst",
> +              "ack",
>                "urg"
>              ]
>            },
> @@ -161,12 +113,8 @@
>            "rst",
>            {
>              "|": [
> -              {
> -                "|": [
> -                  "psh",
> -                  "ack"
> -                ]
> -              },
> +              "psh",
> +              "ack",
>                "urg"
>              ]
>            },
> -- 
> 2.43.0
> 
