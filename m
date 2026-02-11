Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02F915B0EC
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 13:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815033; cv=none; b=OPhvEy4Xp1gsCwSI4I+tXWiLUZzk2NaWrkX7P3IBuBislQNAkiF6H70ZyBBzbk8ZIuSO/Mr98MXMy17HB0oCa9mEDAPuCfvL96KtS6FlNa1oFS2dM4x2jjFBIPW2S92HcYo2uXEmQMdNavKGY0nGFOupScT2Xao97j95hgEGSH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815033; c=relaxed/simple;
	bh=Ug+TDH8dORjYiIokbzRpYq7ZUPJ36NfAnDJRSx/jWG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNo67nrEImChp+jDVBhg/fxDqfrSco5eE6wzY3VV55WKg1x8flPUZA/xu9zLeqbFQlqeNjoau60yfh+xmIEBwgVMia/Qz3TWMT8sRCiyNkrYArym5jUsqV8g+DJ5IJkuKENSmWZ/anjvG5yTcCeDzLJ+9z0yRMYDZNm6UJShG68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B1DAE605E7; Wed, 11 Feb 2026 14:03:49 +0100 (CET)
Date: Wed, 11 Feb 2026 14:03:49 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] configure: Implement --enable-profiling option
Message-ID: <aYx-NR-4YctzvJBf@strlen.de>
References: <20260205151839.5321-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205151839.5321-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> This will set compiler flag --coverage so code coverage may be inspected
> using gcov.
> 
> In order to successfully profile processes which are killed or
> interrupted as well, add a signal handler for those cases which calls
> exit(). This is relevant for test cases invoking nft monitor.
>
> index 022608627908a..5756f873f61a7 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -156,6 +156,13 @@ AC_ARG_ENABLE([distcheck],
>  	      [enable_distcheck=yes], [])
>  AM_CONDITIONAL([BUILD_DISTCHECK], [test "x$enable_distcheck" = "xyes"])
>  
> +AC_ARG_ENABLE([profiling],
> +	      AS_HELP_STRING([--enable-profiling], [build for use of gcov/gprof]),
> +	      [enable_profiling="$enableval"], [enable_profiling="no"])
> +AM_CONDITIONAL([BUILD_PROFILING], [test "x$enable_profiling" = xyes])
> +AM_COND_IF([BUILD_PROFILING],
> +	   [AC_DEFINE([BUILD_PROFILING], [1], [Define for profiling])])
> +
>  AC_CONFIG_FILES([					\
>  		Makefile				\
>  		libnftables.pc				\

I think this should show up in:

nft configuration:
  cli support:                  readline
  enable debugging symbols:     yes
  use mini-gmp:                 no
  enable man page:              yes
  libxtables support:           no
  json output support:          yes
  systemd unit:                 no
