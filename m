Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4173D2D6E5C
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770828665; cv=none; b=JA7SzWibEzAg9TijC51/NFAUYH+scd9NUWHHesx6vJgKx0AWIu80Ln1YtgGVteGrzUHNd/4CGNvaa2Zey36/0vISXtWTnEiyG9QJ04/Gm9IxNDV9nO6s5Tt8Lk78nKNqnDnzdZ6ApUdXmDc0sAypfz2ato000oVGsaZrgyjOv/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770828665; c=relaxed/simple;
	bh=IhUI4bXROJ7yTKZamIMYLnreJMHt0rKA27vTlfDSOJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fJ3Hb8F8zWwrYut/sMeXkWnn5nxxoAcRYxGWATfoTN7Qww9XQO9NtnyUHVsdAAZ/k43IFZIF29QcAIMBa58/DSWedzwAvHarRhi56YDT7W9jAcZOH6abpV71rdlBMMnZb0w7H4D8KUTZWxh9E/72cPZAEz94QefLoYTIKe6Zc8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mbzXSjqF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mbzXSjqF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1smUeRuu95uDx8u9X+8WVuqdX2mAlpwMiaMofZ5KhiU=; b=mbzXSjqFNKh+0cH61uYM/4WjWP
	lAQOKJnIIjrQOPdTtJPZeOeAcZ4Br4vztoRmOXwVZ0haeLrDfeKRye0bUxvR7xrSXC9Q33m5aw+5B
	lPRbw+u97+j1ESrNF0urqEJM8PveC86sV8JrSL+LfAeaCh7K+3EwcpIzfv1Sh2cheLdXpOTKutdsO
	0vQmaRywD+FKElu85hk6eUg+AkXFNFDjHJ6HHB59bJJmG23jeNvjZ8nKHetIEKfOU03O5lRXTf5c8
	f21ICILbKlh3Gjc6NNKznrfmA0NgIT1J8bQ8Oqzi2Ju6/5/KzuogXxKeZoHI5e9WGOzBJuS12WDWR
	g6gtPEog==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqDQU-000000004ob-1ZFc;
	Wed, 11 Feb 2026 17:50:54 +0100
Date: Wed, 11 Feb 2026 17:50:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] configure: Implement --enable-profiling option
Message-ID: <aYyzbpzkDJ_WzVIp@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260205151839.5321-1-phil@nwl.cc>
 <aYx-NR-4YctzvJBf@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYx-NR-4YctzvJBf@strlen.de>

On Wed, Feb 11, 2026 at 02:03:49PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > This will set compiler flag --coverage so code coverage may be inspected
> > using gcov.
> > 
> > In order to successfully profile processes which are killed or
> > interrupted as well, add a signal handler for those cases which calls
> > exit(). This is relevant for test cases invoking nft monitor.
> >
> > index 022608627908a..5756f873f61a7 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -156,6 +156,13 @@ AC_ARG_ENABLE([distcheck],
> >  	      [enable_distcheck=yes], [])
> >  AM_CONDITIONAL([BUILD_DISTCHECK], [test "x$enable_distcheck" = "xyes"])
> >  
> > +AC_ARG_ENABLE([profiling],
> > +	      AS_HELP_STRING([--enable-profiling], [build for use of gcov/gprof]),
> > +	      [enable_profiling="$enableval"], [enable_profiling="no"])
> > +AM_CONDITIONAL([BUILD_PROFILING], [test "x$enable_profiling" = xyes])
> > +AM_COND_IF([BUILD_PROFILING],
> > +	   [AC_DEFINE([BUILD_PROFILING], [1], [Define for profiling])])
> > +
> >  AC_CONFIG_FILES([					\
> >  		Makefile				\
> >  		libnftables.pc				\
> 
> I think this should show up in:
> 
> nft configuration:
>   cli support:                  readline
>   enable debugging symbols:     yes
>   use mini-gmp:                 no
>   enable man page:              yes
>   libxtables support:           no
>   json output support:          yes
>   systemd unit:                 no

ACK, I'll prepare a v3.

Thanks, Phil
