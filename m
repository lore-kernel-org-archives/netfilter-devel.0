Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107C018D
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 06:10:08 -0800 (PST)
Received: from [78.30.43.141] (port=42724 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAW7f-000IAl-U7; Tue, 05 Dec 2023 15:10:06 +0100
Date: Tue, 5 Dec 2023 15:10:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH v2 nft] parser: tcpopt: fix tcp option parsing with NUM +
 length field
Message-ID: <ZW8vOk8C3zTR3R8K@calendula>
References: <20231205115610.19791-1-fw@strlen.de>
 <ZW8Sl6M+1bkLihy9@calendula>
 <20231205122026.GA13832@breakpoint.cc>
 <ZW8cgUtUjMGS/apR@calendula>
 <20231205131448.GB13832@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231205131448.GB13832@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Tue, Dec 05, 2023 at 02:14:48PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Dec 05, 2023 at 01:20:26PM +0100, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > >  	if (!desc) {
> > > > > -		if (field != TCPOPT_COMMON_KIND || kind > 255)
> > > > > +		if (kind > 255)
> > > > >  			return NULL;
> > > > 
> > > > Another suggestion: Remove this NULL, it leaves lhs as NULL in the
> > > > relational. kind > 255 cannot ever happen, parser rejects numbers over
> > > > 255.
> > > 
> > > We can also feed this via input from udata (typeof).
> > > So I'd rather not assert() or rely on bison checks.
> > 
> > OK, but then NULL does not help either, that will crash on evaluation too.
> > 
> > You could narrow down kind and field in tcpopt_expr_alloc() to uint8_t.
> 
> Unfortunately, no.  'kind' is overloaded, SACK blocks 1/2/3/4 use values
> gt 255, see TCPOPT_KIND_SACK3 at end of enum tcpopt_kind.

OK, patch is fine then.
