Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A8334F479
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 10:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761819407; cv=none; b=Zw4hi3qgWDD8qy4jPHChytD7UphEO988XHiePQ6MmukgH315w+iQpQuiXLGkq+xwpcsmj9LpWNckKVmArj5uhvLmpT4z3JF/tJ6VuQoJBKEVfhjMAlqwCT7mFqIhhNJpAqWgM1sqeyztWDzPWW+X6YQGN2jdrb27wpszYNHDO+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761819407; c=relaxed/simple;
	bh=261QWg+/HavFdabHRUGCeR2/T9nTQ0VrrInAHLwwVag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NkYHt5RMT4JI8ZUqVQoCLyNv4a7ih285Es+TJ7lEyNjMNq/+totjYGVDokb/upnEZ0AVXMaIZ1ahKASC77ZZ5RZ8vmkbg+mznl72AU3w/VaCiL0aA15FkM2lCekZZxVUz2poqmNg0O0xTx1tdCZrqR47/3o1d9JF5RbHgNq3JtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UQE8Xuna; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UQE8Xuna"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XMkqz4AyGZDz5tO6Uaz8lOFwLW/5h9w1INcn+3oyUWU=; b=UQE8Xuna9VqOhRAx2QrC9rvUj1
	Z5WsNgdLbHFM0ul3aNUwFJE+zQf6JLqh1Sh+9ci/DTW2r4nc0Tw8hjHQ2oJ/tX5LLwm1/uuLtzlJr
	TX/OII/RyKJihcAToHUN4yvrglI99A/t5BiG1klH2s4o/LgPolpNH13QRERpn4mfMtiAwB1IZ5M2l
	dgp+7sz8alNed+5cgr9iB7sMBg/Gln5j8Xb0V+DWqlXuUsimlPpoVgKNwxifNvXhpvEPmH9CXPZvf
	sKRIjbEFy0mZwQYjeSCzXmhcGhRoEvRiTjVsQvLRdjmVUfOWXSNhk6tU7TNrVLumeYszLgMIL5Dvd
	QespgmNA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEPhy-000000008VL-2M4z;
	Thu, 30 Oct 2025 11:16:42 +0100
Date: Thu, 30 Oct 2025 11:16:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 26/28] utils: Introduce expr_print_debug()
Message-ID: <aQM7CsLvfHCgKUbD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-27-phil@nwl.cc>
 <aQJdejPMgrhyjeAT@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQJdejPMgrhyjeAT@calendula>

Hi Pablo,

On Wed, Oct 29, 2025 at 07:31:22PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 23, 2025 at 06:14:15PM +0200, Phil Sutter wrote:
> > A simple function to call in random places when debugging
> > expression-related code.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/utils.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/include/utils.h b/include/utils.h
> > index e18fabec56ba3..0db0cf20e493c 100644
> > --- a/include/utils.h
> > +++ b/include/utils.h
> > @@ -26,6 +26,15 @@
> >  #define pr_gmp_debug(fmt, arg...) ({ if (false) {}; 0; })
> >  #endif
> >  
> > +#define expr_print_debug(expr)					\
> > +{								\
> > +	struct output_ctx octx = { .output_fp = stdout };	\
> > +	printf("%s:%d: ", __FILE__, __LINE__);			\
> > +	printf("'" #expr "' type %s: ", expr_name(expr));	\
> > +	expr_print((expr), &octx);				\
> > +	printf("\n");						\
> > +}
> 
> Where is the first user of this? Better add and add users to improve
> tracking when looking at git annotate?

There are no users. This macro's sole purpose is for printf-debugging,
to call temporarily in random spots when trying to figure what's going
on.
It came in handy when I debugged bugs in the byteorder fixup code since
often I wondered what kind of 'struct expr *' there was at a given spot
and what it contained.
It's just an extra, I can drop it from this series if you think it's not
worth keeping it in the code/history.

Cheers, Phil
