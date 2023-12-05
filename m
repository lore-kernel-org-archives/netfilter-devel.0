Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988EFC3
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 03:44:40 -0800 (PST)
Received: from [78.30.43.141] (port=39760 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rATqs-00HY0C-Ou; Tue, 05 Dec 2023 12:44:36 +0100
Date: Tue, 5 Dec 2023 12:44:34 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH nft] parser: tcpopt: fix tcp option parsing with NUM +
 length field
Message-ID: <ZW8NIi20utwRiF9B@calendula>
References: <CAHo-Oox+54BTFAXewt-9AyDdk_2nZTx+tm488efXpa+7_7wQ5g@mail.gmail.com>
 <20231205010027.9339-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231205010027.9339-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Tue, Dec 05, 2023 at 02:00:01AM +0100, Florian Westphal wrote:
[...]
> @@ -182,13 +189,21 @@ struct expr *tcpopt_expr_alloc(const struct location *loc,
>  		desc = tcpopt_protocols[kind];
>  
>  	if (!desc) {
> -		if (field != TCPOPT_COMMON_KIND || kind > 255)
> +		if (kind > 255)
> +			return NULL;
> +
> +		switch (field) {
> +		case TCPOPT_COMMON_KIND:
> +		case TCPOPT_COMMON_LENGTH:
> +			break;
> +		default:
>  			return NULL;
> +		}
>  
>  		expr = expr_alloc(loc, EXPR_EXTHDR, &integer_type,
>  				  BYTEORDER_BIG_ENDIAN, 8);
>  
> -		desc = tcpopt_protocols[TCPOPT_NOP];
> +		desc = &tcpopt_fallback;
>  		tmpl = &desc->templates[field];
>  		expr->exthdr.desc   = desc;
>  		expr->exthdr.tmpl   = tmpl;

I believe this is missing in this patch:

                expr->exthdr.offset = tmpl->offset;

so it matches at offset 1, not 0:

  [ exthdr load tcpopt 1b @ 255 + 1 => reg 1 ]
  [ cmp eq reg 1 0x00000004 ]
