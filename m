Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EBB10961
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 09:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=51472 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rNrOM-004XyI-Gu; Thu, 11 Jan 2024 10:30:28 +0100
Date: Thu, 11 Jan 2024 10:30:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 4/4] Revert "datatype: do not assert when value
 exceeds expected width"
Message-ID: <ZZ+1MR6osSfdRkK4@calendula>
References: <20240110194217.484064-1-pablo@netfilter.org>
 <20240110194217.484064-5-pablo@netfilter.org>
 <20240110225738.GB28014@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240110225738.GB28014@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Wed, Jan 10, 2024 at 11:57:38PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  # nft -f ruleset.nft
> >  ruleset.nft:3:28-35: Error: expression is not a concatenation
> >                 ip protocol . th dport { tcp / 22,  }
> >                                          ^^^^^^^^
> > 
> > Therefore, a852022d719e ("datatype: do not assert when value exceeds
> > expected width") not needed anymore after two previous fixes.
> 
> We can't rely on the expression soup coming from nftables.

I can keep this patch then, no problem.

Or you mean this series is botched? Please elaborate :)
