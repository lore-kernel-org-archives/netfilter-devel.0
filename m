Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1909B90
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 06:18:43 -0800 (PST)
Received: from [78.30.43.141] (port=33960 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAWFz-000IaF-GO; Tue, 05 Dec 2023 15:18:41 +0100
Date: Tue, 5 Dec 2023 15:18:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] intervals: don't assert when symbolic expression is
 to be split into a range
Message-ID: <ZW8xPv2DVo5J0Pd5@calendula>
References: <20231205130923.3633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231205130923.3633-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Tue, Dec 05, 2023 at 02:09:19PM +0100, Florian Westphal wrote:
> tests/shell/testcases/bogons/nft-f/set_definition_with_no_key_assert
> BUG: unhandled key type 2
> nft: src/intervals.c:59: setelem_expr_to_range: Assertion `0' failed.
> 
> Fixes: 3975430b12d9 ("src: expand table command before evaluation")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/intervals.h                           |  1 -
>  src/intervals.c                               | 60 +++++++++++++++----
>  .../nft-f/set_definition_with_no_key_assert   | 12 ++++
>  3 files changed, 60 insertions(+), 13 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/set_definition_with_no_key_assert
> 
[...]
> diff --git a/src/intervals.c b/src/intervals.c
> index 85de0199c373..7181af58013e 100644
> --- a/src/intervals.c
> +++ b/src/intervals.c
> @@ -13,7 +13,9 @@
>  #include <intervals.h>
>  #include <rule.h>
>  
> -static void setelem_expr_to_range(struct expr *expr)
> +static int set_to_range(struct expr *init);
> +
> +static int setelem_expr_to_range(struct expr *expr)
>  {
>  	unsigned char data[sizeof(struct in6_addr) * BITS_PER_BYTE];
>  	struct expr *key, *value;
> @@ -55,9 +57,13 @@ static void setelem_expr_to_range(struct expr *expr)
>  		expr_free(expr->key);
>  		expr->key = key;
>  		break;
> +	case EXPR_SYMBOL:
> +		return -1;

How can we get EXPR_SYMBOL in this path?
