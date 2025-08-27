Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB08C212D83
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 12:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756299448; cv=none; b=f/xkKfQVMr/xXZhjBV5t/Ja7xpMPDW1OtH+s5UgZXHT8kBpNLTNZEMGhk3kTym9Lai1E7HC1qb+YAi6um46siIVuK+Qu8RlPY/95hhOfKGjIjK4HBVIenu0iM6K1qvT+mqVkkhG6jUh3awWFJ2mcHsqSlA0V82p9tKxOpose0Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756299448; c=relaxed/simple;
	bh=BfuPOGzVFkLiFO3WY1PC9rkyVxTHbOJtVUC9kXmb97Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7rqAtFBLLrVG0GPDzneylr6iXjq4nOuR+/HR+ITydvm/fsB6f2FxTszTOy45Zts2D7lagtiRbxDuq4qbItMiAonxN9oiXnjt14Vbeifsar7myLfJ670mDiGe/P+G+OQix66G8axgMDnItUnXuUSklrm9p7f8rdEK/qbfMIaAkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XZxBzlgT; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lMVPTWuj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XZxBzlgT";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lMVPTWuj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B003E60284; Wed, 27 Aug 2025 14:57:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756299443;
	bh=0/LLv1PbO2o8VOQPwXK0sgACiG2hha6We5EVgy2MRec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XZxBzlgT9CvyLJ7PkCoO998jN40Uv4Q+lE6zIGzlq+cd728GC/6GP+ugQSLUTTDu+
	 S8yLUzBDe0XYzcCPJPfyKKiHYjX00k1scjhMzo4A2dlcJR9JJqG3jdiYQGDV+aTPVN
	 mHcRRJoJIB3WL6P15XBVug/nNaM7kavhDWRQX9ucI8V9k9hSH7PDknkZdCBJmHxQR9
	 SwkzaIGrQxYKlZtSrlM3K+XqAsK+SH7Wna/kmToDL3NRPJfExWnx/UgXkKzGz0o+HN
	 8PeKygToO2g42TgCWh75hWGXSToExJPXDq3mFhSuo3jYzWp9+kZ69G5Y9ATmrZdq7F
	 trZQaOIeGEVDA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 95AF160281;
	Wed, 27 Aug 2025 14:57:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756299442;
	bh=0/LLv1PbO2o8VOQPwXK0sgACiG2hha6We5EVgy2MRec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lMVPTWujrcTIqBSGdcxQPnGO1vGpZbUjcb61iZyxgXrlYSJ9aBNX1vP9ItqBO3nm1
	 GGI8s5+/m3Jr9/pRYr53BO31IRKbvq/m4sWYfuVvDxAPVx9shuBStyYYHqN8zvTtVy
	 5W+XFloCO0NmeZGizou9Q1T7XbtWaZqw37yAH8aqMhPUiONgueTxKKPh2LXd+lu28y
	 lsgA/npHmgYxMh1GWR1orlEvKWXWeBSggZWP2TU91360+iolVnRIb7y8h2Y6CQXALh
	 3n4bBhJ4rlJUWHNT1ViC/lahVKdKRNTx+YOqvBvSTOb4Ty3IG42XqQiGV/3D/gBKWi
	 7JPGKMP4K2t6Q==
Date: Wed, 27 Aug 2025 14:57:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@inai.de>
Cc: phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] build: make `make distcheck` succeed in the face of
 absolute paths
Message-ID: <aK8AsLl6A_paracl@calendula>
References: <90rp264n-po69-op18-1s8r-615r43sq38r0@vanv.qr>
 <20250827124307.894879-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250827124307.894879-1-jengelh@inai.de>

On Wed, Aug 27, 2025 at 02:43:07PM +0200, Jan Engelhardt wrote:
> `make distcheck` has an expectation that, if only --prefix is
> specified, all other potentially-configurable paths are somehow
> relative to '${prefix}', e.g. bindir defaults to '${prefix}/bin'.
> 
> We get an absolute path from $(pkg-config systemd ...) at all times
> in case systemd.pc is present, and an empty path in case it is not,
> which collides with the aforementioned expectation two ways. Add an
> internal --with-dcprefix configure option for the sake of distcheck.

Subtle internal detail is exposed:

nft configuration:
  cli support:                  editline
  enable debugging symbols:     yes
  use mini-gmp:                 no
  enable man page:              yes
  libxtables support:           no
  json output support:          no
  systemd unit:                 ${dcprefix}/lib/systemd/system
                                ^---------^

When running ./configure on the extracted tarball file.

I modified your patch to expose the systemd unit: file to provide a
hint that service file is being installed.

Any suggestion to refine this?

> ---
>  Makefile.am  | 1 +
>  configure.ac | 5 +++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/Makefile.am b/Makefile.am
> index e292d3b9..52a3e6c4 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -23,6 +23,7 @@ libnftables_LIBVERSION = 2:0:1
>  ###############################################################################
>  
>  ACLOCAL_AMFLAGS = -I m4
> +AM_DISTCHECK_CONFIGURE_FLAGS = --with-dcprefix='$${prefix}'
>  
>  EXTRA_DIST =
>  BUILT_SOURCES =
> diff --git a/configure.ac b/configure.ac
> index 626c641b..198b3be8 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -122,6 +122,11 @@ AC_ARG_WITH([unitdir],
>  		AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
>  	])
>  AC_SUBST([unitdir])
> +AC_ARG_WITH([dcprefix],
> +        [AS_HELP_STRING([Extra path inserted for distcheck])],
> +        [dcprefix="$withval"])
> +AC_SUBST([dcprefix])
> +AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'], [unitdir='${dcprefix}'"$unitdir"])
>  
>  
>  AC_CONFIG_FILES([					\
> -- 
> 2.51.0
> 
