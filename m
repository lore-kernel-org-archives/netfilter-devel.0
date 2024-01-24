Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2B2382
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706108249; cv=none; b=o7gnYm5j6VFv/Y/AbjbCYcWtcNoTYVWOYMSfjoyuGkJpggqVj65UWji4mAAkEY9R+wxABUpImKQYAm/pE8AZst61jO9QFdDEt5mfBMtSf6M/dihANrf9UewUhReAd+IqPRt+lH61x0kW9+VrXEwbh2K0MuKlk/VArw+KZOBAWPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706108249; c=relaxed/simple;
	bh=UbAaH3KMZH/RxesM/MSpq3yi4ieTiaAWlRo/Q4Ci1FI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=giEq7hYr7H/JrtLC+g0x/uShfdiPF2INB79kOzRoWWYfAy/jjNLiSrpiMuFaueMkhXeXtgzb8+MOT+i/qqJBWSKBpBT73sss+pVprhivQME68H/BqGTh4omQJPET/aGMjqQEKyEUaWzOJWvuLtH6m2S4/UcelSehop1onv2gbVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=p2falNcg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="p2falNcg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=124Va88P/SfY8Ljpw46/1JZkErPB/4JfnQpy6mNHfOA=; b=p2falNcgZroe11a+32HdJJ0LOJ
	OoVMydMCysO08R3YcDNGA9y8D+V69TZqSWYALQckoeNxusz6Fd6dUYuG+xUf2+wlg5yQgLDb8w66z
	qVnmtvWAu1jNhq1KNVY4EOaRNiJgpE8PM6pO8awCEuONOmd1zShe7LaXGnEEQKrJqC8KYZZ8VjPqi
	B+KPLNx5pd6kotwqhVlf+deUp/u4eLwXmbozu8FRhgxKdiKRaaFqFp4XKan5dEQEBeOWslk+/eR+W
	cLRsrEVcPUwVLoEK49svdfp+Q8z79ILvFy6TVgMc8F7+fyhCVSjVWLEkSV+DB5JO98+jKnCoMqlWo
	jrAQqWxw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rSegt-000000002l2-1uCt;
	Wed, 24 Jan 2024 15:57:23 +0100
Date: Wed, 24 Jan 2024 15:57:23 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] extensions: libebt_stp: fix range checking
Message-ID: <ZbElUwojpsHjxnGO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240123164936.14403-1-fw@strlen.de>
 <ZbEYDliDhUrO73eu@orbyte.nwl.cc>
 <20240124143757.GC31645@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124143757.GC31645@breakpoint.cc>

On Wed, Jan 24, 2024 at 03:37:57PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Tue, Jan 23, 2024 at 05:49:33PM +0100, Florian Westphal wrote:
> > > This has to either consider ->nvals > 1 or check the values
> > > post-no-range-fixup:
> > > 
> > > ./iptables-test.py  extensions/libebt_stp.t
> > > extensions/libebt_stp.t: ERROR: line 12 (cannot load: ebtables -A INPUT --stp-root-cost 1)
> > > 
> > > (it tests 0 < 1 and fails, but test should be 1 < 1).
> > > 
> > > Fixes: dc6efcfeac38 ("extensions: libebt_stp: Use guided option parser")
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > ---
> > >  extensions/libebt_stp.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
> > > index 81054b26c1f0..371fa04c870f 100644
> > > --- a/extensions/libebt_stp.c
> > > +++ b/extensions/libebt_stp.c
> > > @@ -142,7 +142,7 @@ static void brstp_parse(struct xt_option_call *cb)
> > >  #define RANGE_ASSIGN(name, fname, val) {				    \
> > >  		stpinfo->config.fname##l = val[0];			    \
> > >  		stpinfo->config.fname##u = cb->nvals > 1 ? val[1] : val[0]; \
> > > -		if (val[1] < val[0])					    \
> > > +		if (stpinfo->config.fname##u < stpinfo->config.fname##l)    \
> > >  			xtables_error(PARAMETER_PROBLEM,		    \
> > >  				      "Bad --stp-" name " range");	    \
> > >  }
> > 
> > This is odd: xtopt_parse_mint() assigns UINT32_MAX to val[1] for
> > XTTYPE_UINT32RC if no upper end is given. Also, extensions/libebt_stp.t
> > passes for me. What's missing on my end?
> 
> No fukcing clue. did git clean -d -f -x and it works now without the
> patch.

My first guess was outdated libxtables, but xtopt_parse_mint() is
basically unchanged since 2011 at least.

> I hate my life.

While you correctly hate the game instead of its player, you probably
hate the wrong game: The code above indeed is confusing. Maybe one
should move that monotonicity check into libxtables which should
simplify it quite a bit. I'll have a look. :)

Thanks, Phil
