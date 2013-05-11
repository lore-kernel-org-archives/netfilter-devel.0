From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] libipset.pc must be installed via 'make install'
Date: Sat, 11 May 2013 23:00:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1305112259090.29805@blackhole.kfki.hu>
References: <1368217517-19894-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:57922 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab3EKVAG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 May 2013 17:00:06 -0400
In-Reply-To: <1368217517-19894-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 10 May 2013, Eric Leblond wrote:

> libipset.pc was not installed by classic 'make install'. This
> patch adds it to the list of installed files.

Thank you Eric, I have applied your patch.

Best regards,
Jozsef 

> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  lib/Makefile.am |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/Makefile.am b/lib/Makefile.am
> index 2d22aff..ccc02aa 100644
> --- a/lib/Makefile.am
> +++ b/lib/Makefile.am
> @@ -36,6 +36,9 @@ libipset_la_SOURCES = \
>  
>  EXTRA_DIST = $(IPSET_SETTYPE_LIST) libipset.map
>  
> +pkgconfigdir = $(libdir)/pkgconfig
> +pkgconfig_DATA = libipset.pc
> +
>  sparse-check: $(libipset_la_SOURCES:.c=.d)
>  
>  %.d: %.c
> -- 
> 1.7.10.4
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
