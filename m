Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1081A236A73
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 23:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769556511; cv=none; b=CQ4cC4tcfq5vyjoN0wJk0A2iCoiFVQAsVwQmmplgpy09lAstmYO6BvaSTDhIur6X+5w58tWod6vRXovQo0G6t8jMax8Aec92QKzvgnH/nIgH/Jcz0g1KcD5hPRYnk8mAviAtTdeQ7OnnccWNPWe3xlxBeoqwIcchK+nVp6P41gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769556511; c=relaxed/simple;
	bh=/05+mP8blz0NAG5IU3JxiQjmDLJR7OZPJASDnwwVn04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uaTb3IzEXyrT6KkWUYww/DZbyPuiLOIX5iqUgM9OTwwH/BZnFh032xYL8kqVpHNPTkDu9tUdOvezSCrcebMAz7W5Anb7SYhovFu0S6gS8bXA3o5ze8+WByI5EaA/7fYu3ydslDFZ90jjBvgIMCb2ClAXk18rS44OvMLjf3O/shI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UT4EblU6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UT4EblU6"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7DDA660178;
	Wed, 28 Jan 2026 00:28:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1769556499;
	bh=czKDN4Nr3SGGGEnFHk8jR0jlQIHEJmZtZeAFTQjxfRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UT4EblU6U4+TyNnhJ9KmcoJ+ZvrWuYe2ySsATQF68Ik3Znid/1fNkS5j3Xow3tpQP
	 m1vy+P6e7pmn6YqJ8uFfQ+iz6HXiYvDv0EcVZCPWTQ6A/ErojxsCTaugoLhW0h3SIp
	 XTe5d9BDiUq1MoQAK07CvYPOZbXsz0SdtUwyFlXDYvVE83spLKQYUYy5NeNaZaUITz
	 7MptkUY6R78e4e0KM0t0QtIIHhgPGLFv3VqPsxiUy/wYkKBoGhN3R9P2ku0HY3GEGz
	 oJRqaT92yqTozZ6Qga2YuyoqsHTJsEDggzDt5yMvYQjmPCurQpuqQr8ljgOHsj8sXc
	 AwciXMOIX7++g==
Date: Wed, 28 Jan 2026 00:28:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 02/11] mergesort: Fix sorting of string values
Message-ID: <aXlKECq5p9SUYuJO@chamomile>
References: <20251114002542.22667-1-phil@nwl.cc>
 <20251114002542.22667-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251114002542.22667-3-phil@nwl.cc>

On Fri, Nov 14, 2025 at 01:25:33AM +0100, Phil Sutter wrote:
> Sorting order was obviously wrong, e.g. "ppp0" ordered before "eth1".
> Moreover, this happened on Little Endian only so sorting order actually
> depended on host's byteorder. By reimporting string values as Big
> Endian, both issues are fixed: On one hand, GMP-internal byteorder no
> longer depends on host's byteorder, on the other comparing strings
> really starts with the first character, not the last.
> 
> Fixes: 14ee0a979b622 ("src: sort set elements in netlink_get_setelems()")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/mergesort.c                               |  7 +++
>  tests/py/any/meta.t.json.output               | 54 -------------------
>  tests/py/any/queue.t.json.output              |  4 +-
>  tests/py/inet/osf.t.json.output               | 54 +++++++++++++++++++
>  .../testcases/maps/dumps/0012map_0.json-nft   | 20 +++----
>  .../shell/testcases/maps/dumps/0012map_0.nft  |  8 +--
>  .../maps/dumps/named_ct_objects.json-nft      |  4 +-
>  .../testcases/maps/dumps/named_ct_objects.nft |  4 +-
>  .../sets/dumps/sets_with_ifnames.json-nft     |  4 +-
>  .../sets/dumps/sets_with_ifnames.nft          |  2 +-
>  10 files changed, 84 insertions(+), 77 deletions(-)
> 
> diff --git a/src/mergesort.c b/src/mergesort.c
> index a9cba614612ed..97e36917280f3 100644
> --- a/src/mergesort.c
> +++ b/src/mergesort.c
> @@ -37,6 +37,13 @@ static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
>  	case EXPR_RANGE:
>  		return expr_msort_value(expr->left, value);
>  	case EXPR_VALUE:
> +		if (expr_basetype(expr)->type == TYPE_STRING) {
> +			char buf[expr->len];
> +
> +			mpz_export_data(buf, expr->value, BYTEORDER_HOST_ENDIAN, expr->len);
> +			mpz_import_data(value, buf, BYTEORDER_BIG_ENDIAN, expr->len);
> +			return value;
> +		}

This is also used for automerge, not only get_setelems().

Are you sure this is correct?

>  		return expr->value;
>  	case EXPR_RANGE_VALUE:
>  		return expr->range.low;
> diff --git a/tests/py/any/meta.t.json.output b/tests/py/any/meta.t.json.output
> index 8f4d597a5034e..4454bb960385d 100644
> --- a/tests/py/any/meta.t.json.output
> +++ b/tests/py/any/meta.t.json.output
> @@ -233,60 +233,6 @@
>      }
>  ]
>  
> -# meta iifname {"dummy0", "lo"}
> -[
> -    {
> -        "match": {
> -            "left": {
> -                "meta": { "key": "iifname" }
> -            },
> -	    "op": "==",
> -            "right": {
> -                "set": [
> -                    "lo",
> -                    "dummy0"
> -                ]
> -            }
> -        }
> -    }
> -]
> -
> -# meta iifname != {"dummy0", "lo"}
> -[
> -    {
> -        "match": {
> -            "left": {
> -                "meta": { "key": "iifname" }
> -            },
> -            "op": "!=",
> -            "right": {
> -                "set": [
> -                    "lo",
> -                    "dummy0"
> -                ]
> -            }
> -        }
> -    }
> -]
> -
> -# meta oifname { "dummy0", "lo"}
> -[
> -    {
> -        "match": {
> -            "left": {
> -                "meta": { "key": "oifname" }
> -            },
> -	    "op": "==",
> -            "right": {
> -                "set": [
> -                    "lo",
> -                    "dummy0"
> -                ]
> -            }
> -        }
> -    }
> -]
> -
>  # meta skuid {"bin", "root", "daemon"} accept
>  [
>      {
> diff --git a/tests/py/any/queue.t.json.output b/tests/py/any/queue.t.json.output
> index ea3722383f113..90670cc938866 100644
> --- a/tests/py/any/queue.t.json.output
> +++ b/tests/py/any/queue.t.json.output
> @@ -104,11 +104,11 @@
>                                  0
>                              ],
>                              [
> -                                "ppp0",
> +                                "eth1",
>                                  2
>                              ],
>                              [
> -                                "eth1",
> +                                "ppp0",
>                                  2
>                              ]
>                          ]
> diff --git a/tests/py/inet/osf.t.json.output b/tests/py/inet/osf.t.json.output
> index 922e395f202c7..77ca7e30e0f77 100644
> --- a/tests/py/inet/osf.t.json.output
> +++ b/tests/py/inet/osf.t.json.output
> @@ -18,6 +18,26 @@
>      }
>  ]
>  
> +# osf version { "Windows:XP", "MacOs:Sierra" }
> +[
> +    {
> +        "match": {
> +            "left": {
> +                "osf": {
> +                    "key": "version"
> +                }
> +            },
> +            "op": "==",
> +            "right": {
> +                "set": [
> +                    "MacOs:Sierra",
> +                    "Windows:XP"
> +                ]
> +            }
> +        }
> +    }
> +]
> +
>  # ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 }
>  [
>      {
> @@ -51,3 +71,37 @@
>          }
>      }
>  ]
> +
> +# ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
> +[
> +    {
> +        "mangle": {
> +            "key": {
> +                "ct": {
> +                    "key": "mark"
> +                }
> +            },
> +            "value": {
> +                "map": {
> +                    "data": {
> +                        "set": [
> +                            [
> +                                "MacOs:Sierra",
> +                                4
> +                            ],
> +                            [
> +                                "Windows:XP",
> +                                3
> +                            ]
> +                        ]
> +                    },
> +                    "key": {
> +                        "osf": {
> +                            "key": "version"
> +                        }
> +                    }
> +                }
> +            }
> +        }
> +    }
> +]
> diff --git a/tests/shell/testcases/maps/dumps/0012map_0.json-nft b/tests/shell/testcases/maps/dumps/0012map_0.json-nft
> index 2892e11d71f54..6c885703ffd6b 100644
> --- a/tests/shell/testcases/maps/dumps/0012map_0.json-nft
> +++ b/tests/shell/testcases/maps/dumps/0012map_0.json-nft
> @@ -32,21 +32,21 @@
>          "map": "verdict",
>          "elem": [
>            [
> -            "lo",
> +            "eth0",
>              {
> -              "accept": null
> +              "drop": null
>              }
>            ],
>            [
> -            "eth0",
> +            "eth1",
>              {
>                "drop": null
>              }
>            ],
>            [
> -            "eth1",
> +            "lo",
>              {
> -              "drop": null
> +              "accept": null
>              }
>            ]
>          ]
> @@ -69,21 +69,21 @@
>                "data": {
>                  "set": [
>                    [
> -                    "lo",
> +                    "eth0",
>                      {
> -                      "accept": null
> +                      "drop": null
>                      }
>                    ],
>                    [
> -                    "eth0",
> +                    "eth1",
>                      {
>                        "drop": null
>                      }
>                    ],
>                    [
> -                    "eth1",
> +                    "lo",
>                      {
> -                      "drop": null
> +                      "accept": null
>                      }
>                    ]
>                  ]
> diff --git a/tests/shell/testcases/maps/dumps/0012map_0.nft b/tests/shell/testcases/maps/dumps/0012map_0.nft
> index e734fc1c70b93..0df329a550518 100644
> --- a/tests/shell/testcases/maps/dumps/0012map_0.nft
> +++ b/tests/shell/testcases/maps/dumps/0012map_0.nft
> @@ -1,12 +1,12 @@
>  table ip x {
>  	map z {
>  		type ifname : verdict
> -		elements = { "lo" : accept,
> -			     "eth0" : drop,
> -			     "eth1" : drop }
> +		elements = { "eth0" : drop,
> +			     "eth1" : drop,
> +			     "lo" : accept }
>  	}
>  
>  	chain y {
> -		iifname vmap { "lo" : accept, "eth0" : drop, "eth1" : drop }
> +		iifname vmap { "eth0" : drop, "eth1" : drop, "lo" : accept }
>  	}
>  }
> diff --git a/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft b/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
> index c0f270e372b24..34c8798dee8fb 100644
> --- a/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
> +++ b/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
> @@ -195,8 +195,8 @@
>          },
>          "handle": 0,
>          "elem": [
> -          "sip",
> -          "ftp"
> +          "ftp",
> +          "sip"
>          ]
>        }
>      },
> diff --git a/tests/shell/testcases/maps/dumps/named_ct_objects.nft b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
> index 59f18932b28ad..dab683bf5cdbd 100644
> --- a/tests/shell/testcases/maps/dumps/named_ct_objects.nft
> +++ b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
> @@ -50,8 +50,8 @@ table inet t {
>  
>  	set helpname {
>  		typeof ct helper
> -		elements = { "sip",
> -			     "ftp" }
> +		elements = { "ftp",
> +			     "sip" }
>  	}
>  
>  	chain y {
> diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
> index ac4284293c32a..7b4849e0530d3 100644
> --- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
> +++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
> @@ -260,8 +260,8 @@
>                },
>                "right": {
>                  "set": [
> -                  "eth0",
> -                  "abcdef0"
> +                  "abcdef0",
> +                  "eth0"
>                  ]
>                }
>              }
> diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
> index 77a8baf58cef2..8abca03a080ec 100644
> --- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
> +++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
> @@ -39,7 +39,7 @@ table inet testifsets {
>  	chain v4icmp {
>  		iifname @simple counter packets 0 bytes 0
>  		iifname @simple_wild counter packets 0 bytes 0
> -		iifname { "eth0", "abcdef0" } counter packets 0 bytes 0
> +		iifname { "abcdef0", "eth0" } counter packets 0 bytes 0
>  		iifname { "abcdef*", "eth0" } counter packets 0 bytes 0
>  		iifname vmap @map_wild
>  	}
> -- 
> 2.51.0
> 
