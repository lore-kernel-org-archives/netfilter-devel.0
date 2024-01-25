Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A3446BF
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2024 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706193872; cv=none; b=AWGTAPhCZDkoNLPm9J33xrrNctKErmrs4JWC0eRE9UqNHkx1aJjQkT6Xh72jmrzO9aSPe5mIeqUcVETTkJfpgKlMrkP0DrWit4ykliFRYVT6DQUDyScWDBFR4s2x63o2KeJ3C7MeU/AmC5awcW77558Qhguw6hg1tQinariRFQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706193872; c=relaxed/simple;
	bh=JuHPehpBjo4D1urG3jveecZHSCpvvcXYmFHTeoAm//0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DeRHsAEQNxDLgEWChnAXUCJmZfQM4vvIj5L/5tklhi9j52fp0weBJtWxAdo+ZPyJhtUxQJKP8fuNOD25PlhO30BjhBDhGxzwksFdMWnnpw8C6H1A0jXIGs2P61BoIipI8vcZEaFnu0wQuEAhY18kXP9TSWGlyAY4zFH69RTz++Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=S0GtFAcV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="S0GtFAcV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Nwszglpv3LDXJMkWZXm5Gd2lomOWM3Fw3CKxtkxVwAM=; b=S0GtFAcVSnp/F4c7gt44x7ctqz
	VBcW/amwIXxF77yWMGs00BjHXvNtxZQKuMC9WE5KfX2qfrmmxc9UgVkrUgh/LcJlzU6XFHjYZxRZD
	d1/mBMqWK+VH7Btoo+8ictVrcxH+F66Z+5wXbiUPZ0QK/1U5vwHiKJ06dFbBWvp9H+VEEK95rZjoc
	7esAKVrPejASzCkLRgcL7WKlBwai32CZ/FdoZV1/5RIteExtgDGRr6a5vDLdUtbqqreJ7foL9zVgy
	oMGW+xAGXg5PeW5EHxy6zlUkHnxTVBizV6jkgp2Ajg32qZSi7MAVR5ThZXU0HMASNSHooSeHJlp22
	qNkUHeTQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rT0xp-000000001xj-2S6A;
	Thu, 25 Jan 2024 15:44:21 +0100
Date: Thu, 25 Jan 2024 15:44:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] extensions: libebt_stp: fix range checking
Message-ID: <ZbJzxRvG7afyu4e8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240123164936.14403-1-fw@strlen.de>
 <ZbEYDliDhUrO73eu@orbyte.nwl.cc>
 <20240124143757.GC31645@breakpoint.cc>
 <ZbElUwojpsHjxnGO@orbyte.nwl.cc>
 <20240124154216.GD31645@breakpoint.cc>
 <ZbE3OUiDlnf7A7kI@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbE3OUiDlnf7A7kI@orbyte.nwl.cc>

On Wed, Jan 24, 2024 at 05:13:45PM +0100, Phil Sutter wrote:
> On Wed, Jan 24, 2024 at 04:42:16PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > While you correctly hate the game instead of its player, you probably
> > > hate the wrong game: The code above indeed is confusing. Maybe one
> > > should move that monotonicity check into libxtables which should
> > > simplify it quite a bit. I'll have a look. :)
> > 
> > Something IS broken.  Still not working on FC 39 test machine
> > even after fresh clone.
> > 
> > On a "working" VM:
> > export XTABLES_LIBDIR=$(pwd)/extensions
> > iptables/xtables-nft-multi ebtables -A INPUT --stp-root-cost 1
> > have 1 32765
> > 
> > @@ -150,7 +151,9 @@ static void brstp_parse(struct xt_option_call *cb)
> >                 RANGE_ASSIGN("root-prio", root_prio, cb->val.u16_range);
> >                 break;
> >         case O_RCOST:
> > +               fprintf(stderr, "have %u %u\n", cb->val.u32_range[0], cb->val.u32_range[1]);
> > 
> > I can't even figure out where the correct max value is supposed to be set.
> > 
> > Varying the input:
> > 
> > xtables-nft-multi ebtables -A INPUT --stp-root-cost 1
> > have 1 32764
> > 
> > Looks to me as if the upper value is undefined.
> > 
> > Other users of *RC versions handle it in .parse, e.g. libxt_length.
> > No idea how this is working.
> 
> In xtopt_parse_mint(), there is:
> 
> | const uintmax_t lmax = xtopt_max_by_type(entry->type);
> | [...]
> | if (*arg == '\0' || *arg == sep) {
> |         /* Default range components when field not spec'd. */
> |         end = (char *)arg;
> |         value = (cb->nvals == 1) ? lmax : 0;
> 
> But that branch appears to be dead code. So this is indeed a bug and a
> specific build may or may not hit it as your experience shows. I'll see
> how xtopt_parse_mint() can be fixed.

The big elucidation was the code is called only for ranges and somehow I
managed to miss the point that your sample command doesn't contain a
range in the first place.

So while I still think it makes sense to have the 'low <= high' check
done by the parser, I applied your patch for now as it indeed fixes that
bug in libebt_stp extension parser. Sorry for all the confusion I must
have caused. :(

Meanwhile I've added test cases for ranges in various formats which
uncovered quite a few things to fix.

Thanks, Phil
