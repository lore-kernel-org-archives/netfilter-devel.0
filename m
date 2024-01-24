Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E2632182
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706107083; cv=none; b=pxni5eWiE+2RvyMu34qbK+PmXyqgxhDnubr0eoCiNp9B4L7mIq5UmNeMjdvdTl1G5vSnN1biQrLgQZhpaY+XGIZmBBY/98xbxhcAqMfHxygdg3g06TMAmFiv6s2OrsvSmqIZFfFB3XBPCm77nPjHBSEDJ8BGI+NXlTvz8WG8qrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706107083; c=relaxed/simple;
	bh=nxGAx5EDWXy+5Wx9vnoc49HiYZzIHrD5uz2Fcml3tJM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QiHeCeHXFhfhhSQEsVK08XtLMiLtZ5I4594to2BhP/uPvL/0kqVInMTaPDdIFwyKOIp0U8pU9xpStlw8SuKWMcZq4bsi/reQJT6e3eYNGKYX/squpTrhHsLskb2iGgG5kH47e4l8PU2g0YLKDWvXKd5mDHcPizNRCY8nX6qeDhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rSeO5-0000wa-Um; Wed, 24 Jan 2024 15:37:57 +0100
Date: Wed, 24 Jan 2024 15:37:57 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] extensions: libebt_stp: fix range checking
Message-ID: <20240124143757.GC31645@breakpoint.cc>
References: <20240123164936.14403-1-fw@strlen.de>
 <ZbEYDliDhUrO73eu@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbEYDliDhUrO73eu@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> On Tue, Jan 23, 2024 at 05:49:33PM +0100, Florian Westphal wrote:
> > This has to either consider ->nvals > 1 or check the values
> > post-no-range-fixup:
> > 
> > ./iptables-test.py  extensions/libebt_stp.t
> > extensions/libebt_stp.t: ERROR: line 12 (cannot load: ebtables -A INPUT --stp-root-cost 1)
> > 
> > (it tests 0 < 1 and fails, but test should be 1 < 1).
> > 
> > Fixes: dc6efcfeac38 ("extensions: libebt_stp: Use guided option parser")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  extensions/libebt_stp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
> > index 81054b26c1f0..371fa04c870f 100644
> > --- a/extensions/libebt_stp.c
> > +++ b/extensions/libebt_stp.c
> > @@ -142,7 +142,7 @@ static void brstp_parse(struct xt_option_call *cb)
> >  #define RANGE_ASSIGN(name, fname, val) {				    \
> >  		stpinfo->config.fname##l = val[0];			    \
> >  		stpinfo->config.fname##u = cb->nvals > 1 ? val[1] : val[0]; \
> > -		if (val[1] < val[0])					    \
> > +		if (stpinfo->config.fname##u < stpinfo->config.fname##l)    \
> >  			xtables_error(PARAMETER_PROBLEM,		    \
> >  				      "Bad --stp-" name " range");	    \
> >  }
> 
> This is odd: xtopt_parse_mint() assigns UINT32_MAX to val[1] for
> XTTYPE_UINT32RC if no upper end is given. Also, extensions/libebt_stp.t
> passes for me. What's missing on my end?

No fukcing clue. did git clean -d -f -x and it works now without the
patch.

I hate my life.
