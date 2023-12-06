Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D5DDE
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 07:56:13 -0800 (PST)
Received: from [78.30.43.141] (port=53790 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAuFt-003rbd-PA; Wed, 06 Dec 2023 16:56:11 +0100
Date: Wed, 6 Dec 2023 16:56:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH nft v3] parser: tcpopt: fix tcp option parsing with NUM +
 length field
Message-ID: <ZXCZmBW67HbEUNw/@calendula>
References: <20231206115205.4289-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231206115205.4289-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Wed, Dec 06, 2023 at 12:52:00PM +0100, Florian Westphal wrote:
> tcp option 254 length ge 4
> 
> ... will segfault.
> The crash bug is that tcpopt_expr_alloc() can return NULL if we cannot
> find a suitable template for the requested kind + field combination,
> so add the needed error handling in the bison parser.
> 
> However, we can handle this.  NOP and EOL have templates, all other
> options (known or unknown) must also have a length field.
> 
> So also add a fallback template to handle both kind and length, even
> if only a numeric option is given that nft doesn't recognize.
> 
> Don't bother with output, above will be printed via raw syntax, i.e.
> tcp option @254,8,8 >= 4.

Patch LGTM, please push it out.

Thanks.
