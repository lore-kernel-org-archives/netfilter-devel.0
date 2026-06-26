Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D1A2E7368
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 11:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782475134; cv=none; b=ERtmWYrl5qe08mZ8dFoSGosMkQyKOkMU5PdnflgH3BnN1A+3fAPt607EecbyR6444JVoibf8Efb6NXvVgszkVXS/uCL++1DVmNa6yun9svi8712EoeD/6DIi2v3yxh+xOjIK+74JKrYFhEfoF1U7m8ybOxpJ7FRDR6g2ip2qgX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782475134; c=relaxed/simple;
	bh=kxC7Zwj7WPiFdyPhDOi28ejhrTVCprouGIlBTwaNJ7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDYaE1PihOKl5AaVWbvi605DyfCuPAjCB9+2Utr4yrULHrV/iLZYGAutC5W96GgjKz3HN7lr1U0uEXWVSbFKXTkdzkj76OKoXgNYD8Rye2/9iAbmfkkzRBXKy3CxpiOjplJnvFDclWEo1QMTmejQGuNqcoVMBx2FZ9UsCSuRCZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E0D5660299; Fri, 26 Jun 2026 13:58:43 +0200 (CEST)
Date: Fri, 26 Jun 2026 13:58:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack_expect: zero at allocation
 time
Message-ID: <aj5pc-9CKwnuG5iE@strlen.de>
References: <20260625001356.16478-1-fw@strlen.de>
 <aj5h9eFJE1glpYfz@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aj5h9eFJE1glpYfz@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jun 25, 2026 at 02:13:53AM +0200, Florian Westphal wrote:
> > There are occasional LLM hints wrt. leaking uninitialized data to
> > userspace via ctnetlink.  Just zero at allocation time, expectations are
> > not frequently used these days.
> 
> Fine with me. IIRC hints came because of real issue, ie. paths where
> I was missing to initial something.


> > @@ -389,6 +389,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
> >  #if IS_ENABLED(CONFIG_NF_NAT)
> >  	memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
> >  	memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
> > +	exp->dir = 0;
> 
> Hm. But now area is expect is zeroed, right?
> 
> Maybe nf_ct_expect_init() needs to be updated to remove needless
> zeroing too?

See:
> > Intentionally keeps _init as-is because we could theoretically support
> > re-init, so add the missing exp->dir there.

If you say we are guaranteed to always have:

exp = nf_ct_expect_alloc(ct);
nf_ct_expect_init(exp)

then we could remove it.  But then I'd question why we even have this
alloc / init split and not:

exp = nf_ct_expect_new(rtp_exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
                       &ct->tuplehash[!dir].tuple.src.u3,
                       &ct->tuplehash[!dir].tuple.dst.u3,
                       IPPROTO_UDP, NULL, &rtp_port);
