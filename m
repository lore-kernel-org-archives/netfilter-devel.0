Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7BE5100A
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=35346 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rNySk-00547a-L8; Thu, 11 Jan 2024 18:03:28 +0100
Date: Thu, 11 Jan 2024 18:03:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: disable ct set with ranges
Message-ID: <ZaAfXVRM/OULLSuD@calendula>
References: <20240111124649.27222-1-fw@strlen.de>
 <20240111131651.GD28014@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240111131651.GD28014@breakpoint.cc>
X-Spam-Score: -1.9 (-)

Hi Florian,

On Thu, Jan 11, 2024 at 02:16:51PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > ... this will cause an assertion in netlink linearization, catch this
> > at eval stage instead.
> > 
> > before:
> > BUG: unknown expression type range
> > nft: netlink_linearize.c:908: netlink_gen_expr: Assertion `0' failed.
> > 
> > after:
> > /unknown_expr_type_range_assert:3:31-40: Error: ct expression cannot be a range
> > ct mark set 0x001-3434
> >             ^^^^^^^^^^
>
> This isn't enough, we have a truckload of bugs like this.
> 
> e.g. 'tproxy to  1.1.1.10/0'.  This passes EXPR_RANGE check,
> but we still hit the assertion because prefix is translated to a range
> later on.

I am going to take a look at this one.

> dup and fwd also have this issue, probably a lot more.

I believe we have to go the extra mile and sanitize this, to avoid
non-sensical transformations which leads to hit BUG.
