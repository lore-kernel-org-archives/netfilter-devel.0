Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4C220CCD1
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 16:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730997503; cv=none; b=YjmMKV/XwuU7ws/vxK5IPpyT5IARxOAidz9SviqKhGsA1nK67Pr3SV3xYTTuuRhC2QGg6JIRIE7q7pTFOM62llDxXdLDDAEhQQEQqTAAV3Vv5p8fiWdFvfpyfzpQOeNTxx2iHvNdaB3bD/VRmh/rfpydnt/pKh/MKXxHq7HwGvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730997503; c=relaxed/simple;
	bh=OKPUrfi2XloFbcZ2Aafof/JYLr8BTVXnRzzXCs2lacA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxO7K56aeoST6PCvbHmPh4kxuLGl3HX1iMfARRjXhjoEftXObEa2hXX7eVCB9nA5XTS0zbEKE6JYyTzhQ3+WjgIvzkLc7PZrzsPSPzoJZG/J6aHsDfCtRfzbtLfiW4AccIrdWVAEPsnXAihLRDKhDoZ08/WccLxZFg63BUpBSsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=38698 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t95WM-00FGlV-7b; Thu, 07 Nov 2024 17:38:12 +0100
Date: Thu, 7 Nov 2024 17:38:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [iptables PATCH] libxtables: Hide xtables_strtoul_base() symbol
Message-ID: <Zyzs8NAsIeq-ZmHy@calendula>
References: <ZyzYApZKx79g8jqm@calendula>
 <20241107161233.22665-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241107161233.22665-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Thu, Nov 07, 2024 at 05:12:33PM +0100, Phil Sutter wrote:
> There are no external users, no need to promote it in xtables.h.
> 
> Fixes: 1af6984c57cce ("libxtables: Introduce xtables_strtoul_base()")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  include/Makefile.am        | 2 +-
>  include/xtables.h          | 2 --
>  include/xtables_internal.h | 7 +++++++
>  libxtables/xtables.c       | 1 +
>  libxtables/xtoptions.c     | 1 +
>  5 files changed, 10 insertions(+), 3 deletions(-)
>  create mode 100644 include/xtables_internal.h
> 
> diff --git a/include/Makefile.am b/include/Makefile.am
> index 07c88b901e808..f3e480f72bf09 100644
> --- a/include/Makefile.am
> +++ b/include/Makefile.am
> @@ -11,7 +11,7 @@ nobase_include_HEADERS = \
>  	libiptc/ipt_kernel_headers.h libiptc/libiptc.h \
>  	libiptc/libip6tc.h libiptc/libxtc.h libiptc/xtcshared.h
>  
> -EXTRA_DIST = iptables linux iptables.h ip6tables.h
> +EXTRA_DIST = iptables linux iptables.h ip6tables.h xtables_internal.h
>  
>  uninstall-hook:
>  	dir=${includedir}/libiptc; { \
> diff --git a/include/xtables.h b/include/xtables.h
> index ab856ebc426ac..9fdd8291e91b9 100644
> --- a/include/xtables.h
> +++ b/include/xtables.h
> @@ -491,8 +491,6 @@ extern void xtables_register_matches(struct xtables_match *, unsigned int);
>  extern void xtables_register_target(struct xtables_target *me);
>  extern void xtables_register_targets(struct xtables_target *, unsigned int);
>  
> -extern bool xtables_strtoul_base(const char *, char **, uintmax_t *,
> -	uintmax_t, uintmax_t, unsigned int);
>  extern bool xtables_strtoul(const char *, char **, uintmax_t *,
>  	uintmax_t, uintmax_t);
>  extern bool xtables_strtoui(const char *, char **, unsigned int *,
> diff --git a/include/xtables_internal.h b/include/xtables_internal.h
> new file mode 100644
> index 0000000000000..a87a40cc8dae5
> --- /dev/null
> +++ b/include/xtables_internal.h
> @@ -0,0 +1,7 @@
> +#ifndef XTABLES_INTERNAL_H
> +#define XTABLES_INTERNAL_H 1
> +
> +extern bool xtables_strtoul_base(const char *, char **, uintmax_t *,
> +	uintmax_t, uintmax_t, unsigned int);
> +
> +#endif /* XTABLES_INTERNAL_H */
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index 7d54540b73b73..5fc50a63f380b 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -64,6 +64,7 @@
>  #endif
>  #include <getopt.h>
>  #include "iptables/internal.h"
> +#include "xtables_internal.h"
>  
>  #define NPROTO	255
>  
> diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
> index 774d0ee655ba7..64d6599af904b 100644
> --- a/libxtables/xtoptions.c
> +++ b/libxtables/xtoptions.c
> @@ -21,6 +21,7 @@
>  #include <arpa/inet.h>
>  #include <netinet/ip.h>
>  #include "xtables.h"
> +#include "xtables_internal.h"
>  #ifndef IPTOS_NORMALSVC
>  #	define IPTOS_NORMALSVC 0
>  #endif
> -- 
> 2.47.0
> 
