Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855B9201110
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 21:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741210521; cv=none; b=Q3TiOvhHs7u6uy2W2tG2DyBPXP7156hVMKP/y8lnvutVMHzz8kbCtJQBiEOR8pPEs7UPlz6IYlQ6BCggj31Ienrh+g9I7QlKz1Hrtdt5T0QPBF7R4qqd2MWCx39BxCootcS7Wj2WpMULlfg1T0Wd2lNFvl3XzKYbG88ZhznMLwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741210521; c=relaxed/simple;
	bh=UlM4ZV53lrXqYXLP8ZIzjYWm2Au2oAvWC26F6qULOAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbyl/SV32zmSkWssXpjGLyipT3G6maKiASXqF7+afHeT468t8RggXv1dgf+8nYx3DP7X7PWLs5tY2nKLWOqGpFMV/Q51RYAqBBO6Pjzk0TaV6P1gKJfn1TED6WpyJMCCAMn01NOQKuJRTS/jSkcIcuworLMBwgcELyxnqNcBajQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RL6WRMzq; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UVW2UTpn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RL6WRMzq";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UVW2UTpn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F3728602A0; Wed,  5 Mar 2025 22:35:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741210517;
	bh=QTlZEmNZDqm3+Bwr87UkNGrEqS4Ma2gLkstpKp9e/9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RL6WRMzqdj0cridqkmVE4njNBKo4Repx7rg3I9+A4UwRCS30nlIMBhr8h1PbrcB1D
	 hb8H3SNuQ1FT6ypxQIUsF+wxXrU5FvbQzBUix7r/xpmlaxxoxwOFox/FHfFdh1Fdkf
	 HeQW66KKts+5vTAVgb46+J9bg4iolPzQR74YDg3wjJgC6K+PVkDV0QPZU2bs6iE0kV
	 jpymkRFG7kKfC3oVOn/9AI+S2r6CBgZjBChy0zyIYS0GHwNN/w/YJLUGB3ucvGwNJS
	 SiZNTN7Ss+pNHfReGZsnWm8aGjIrxdKqdmKMQ1cdkYug4rhW/50RJUnWVSYuXDQKcx
	 JiIitV3LTsu1Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 04CB860288;
	Wed,  5 Mar 2025 22:35:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741210513;
	bh=QTlZEmNZDqm3+Bwr87UkNGrEqS4Ma2gLkstpKp9e/9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UVW2UTpnQALaJ2lH04ymv/xNvqfNjnW/hakzUELuP+Hi8piXorErqCUPvmKO97ZLx
	 18nWyHIJbpFF+QHfyaBeOAwc592WIqUeSkjomIJkHex0VHfIfnWEOBrohOusj1YD5C
	 kNp+tB2TJAheHXMXpwyutV3pXVjyGXQlhzHU3TIB0d26xIwZ5SxJrsYVTZveAK311e
	 irskob9kDhYhQpEfaP1B0RgCFbjmI9cL2CCYIVWeq1CTF3ObBItr/6k60Kok8a36CS
	 OSMKIuA0k8QDecXqZLaJyv0wL+R7RSAAKIfpRg4bV2ytNmpFfOVRq0Xpy1kVFtCvlh
	 PFcsQr8Z9XZEw==
Date: Wed, 5 Mar 2025 22:35:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	matthias.gerstner@suse.com, arturo@debian.org, phil@nwl.cc,
	eric@garver.life
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
Message-ID: <Z8jDjlJcehMB_Z9F@calendula>
References: <20250228205935.59659-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250228205935.59659-1-jengelh@inai.de>

Hi Jan,

I added a few more people to Cc.

On Fri, Feb 28, 2025 at 09:59:35PM +0100, Jan Engelhardt wrote:
> There is a customer request (bugreport) for wanting to trivially load a ruleset
> from a well-known location on boot, forwarded to me by M. Gerstner. A systemd
> service unit is hereby added to provide that functionality. This is based on
> various distributions attempting to do same, cf.
> 
> https://src.fedoraproject.org/rpms/nftables/tree/rawhide
> https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/nftables/nftables.initd
> https://gitlab.archlinux.org/archlinux/packaging/packages/nftables

Any chance to Cc these maintainers too? Given this is closer to
downstream than upstream, I would like to understand if this could
cause any hypothetical interference with distro packagers.

Only subtle nitpick I see with this patch is that INSTALL file is not
updated to provide information on how to use --with-unitdir=.

Thanks.

> Cc: Matthias Gerstner <matthias.gerstner@suse.com>
> ---
>  .gitignore                |  1 +
>  Makefile.am               | 16 ++++++++++++----
>  configure.ac              | 10 ++++++++++
>  files/nftables/main.nft   | 24 ++++++++++++++++++++++++
>  tools/nftables.service.8  | 18 ++++++++++++++++++
>  tools/nftables.service.in | 21 +++++++++++++++++++++
>  6 files changed, 86 insertions(+), 4 deletions(-)
>  create mode 100644 files/nftables/main.nft
>  create mode 100644 tools/nftables.service.8
>  create mode 100644 tools/nftables.service.in
> 
> diff --git a/.gitignore b/.gitignore
> index a62e31f3..f92187ef 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -14,6 +14,7 @@ autom4te.cache
>  build-aux/
>  libnftables.pc
>  libtool
> +tools/nftables.service
>  
>  # cscope files
>  /cscope.*
> diff --git a/Makefile.am b/Makefile.am
> index fb64105d..050991f4 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -375,18 +375,19 @@ dist_pkgdata_DATA = \
>  	files/nftables/netdev-ingress.nft \
>  	$(NULL)
>  
> -pkgdocdir = ${docdir}/examples
> +exampledir = ${docdir}/examples
>  
> -dist_pkgdoc_SCRIPTS = \
> +dist_example_SCRIPTS = \
>  	files/examples/ct_helpers.nft \
>  	files/examples/load_balancing.nft \
>  	files/examples/secmark.nft \
>  	files/examples/sets_and_maps.nft \
>  	$(NULL)
>  
> -pkgsysconfdir = ${sysconfdir}/nftables/osf
> +pkgsysconfdir = ${sysconfdir}/${PACKAGE}
> +osfdir = ${pkgsysconfdir}/osf
>  
> -dist_pkgsysconf_DATA = \
> +dist_osf_DATA = \
>  	files/osf/pf.os \
>  	$(NULL)
>  
> @@ -410,3 +411,10 @@ EXTRA_DIST += \
>  
>  pkgconfigdir = $(libdir)/pkgconfig
>  pkgconfig_DATA = libnftables.pc
> +unit_DATA = tools/nftables.service
> +man_MANS = tools/nftables.service.8
> +doc_DATA = files/nftables/main.nft
> +
> +tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
> +	${AM_V_GEN}${MKDIR_P} tools
> +	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
> diff --git a/configure.ac b/configure.ac
> index 80a64813..64a164e5 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -114,6 +114,16 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
>  #include <netdb.h>
>  ]])
>  
> +AC_ARG_WITH([unitdir],
> +	[AS_HELP_STRING([--with-unitdir=PATH], [Path to systemd service unit directory])],
> +	[unitdir="$withval"],
> +	[
> +		unitdir=$("$PKG_CONFIG" systemd --variable systemdsystemunitdir 2>/dev/null)
> +		AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
> +	])
> +AC_SUBST([unitdir])
> +
> +
>  AC_CONFIG_FILES([					\
>  		Makefile				\
>  		libnftables.pc				\
> diff --git a/files/nftables/main.nft b/files/nftables/main.nft
> new file mode 100644
> index 00000000..8e62f9bc
> --- /dev/null
> +++ b/files/nftables/main.nft
> @@ -0,0 +1,24 @@
> +#!/usr/sbin/nft -f
> +
> +# template static firewall configuration file
> +#
> +# copy this over to /etc/nftables/rules/main.nft as a starting point for
> +# configuring a rule set which will be loaded by nftables.service.
> +
> +flush ruleset
> +
> +table inet filter {
> +	chain input {
> +		type filter hook input priority filter;
> +	}
> +	chain forward {
> +		type filter hook forward priority filter;
> +	}
> +	chain output {
> +		type filter hook output priority filter;
> +	}
> +}
> +
> +# this can be used to split the rule set into multiple smaller files concerned
> +# with specific topics, like forwarding rules
> +#include "/etc/nftables/rules/forwarding.nft"
> diff --git a/tools/nftables.service.8 b/tools/nftables.service.8
> new file mode 100644
> index 00000000..4a83b01c
> --- /dev/null
> +++ b/tools/nftables.service.8
> @@ -0,0 +1,18 @@
> +.TH nftables.service 8 "" "nftables" "nftables admin reference"
> +.SH Name
> +nftables.service \(em Static Firewall Configuration with nftables.service
> +.SH Description
> +An nftables systemd service is provided which allows to setup static firewall
> +rulesets based on a configuration file.
> +.PP
> +To use this service, you need to create the main configuration file in
> +/etc/nftables/rules/main.nft. A template for this can be copied from
> +/usr/share/doc/nftables/main.nft. The static firewall configuration can be
> +split up into multiple files which are included from the main.nft
> +configuration file.
> +.PP
> +Once the desired static firewall configuration is in place, it can be tested by
> +running `systemctl start nftables.service`. To enable the service at boot time,
> +run `systemctl enable nftables.service`.
> +.SH See also
> +\fBnft\fP(8)
> diff --git a/tools/nftables.service.in b/tools/nftables.service.in
> new file mode 100644
> index 00000000..8d94e0fc
> --- /dev/null
> +++ b/tools/nftables.service.in
> @@ -0,0 +1,21 @@
> +[Unit]
> +Description=nftables static rule set
> +Documentation=nftables.service(8)
> +Wants=network-pre.target
> +Before=network-pre.target shutdown.target
> +Conflicts=shutdown.target
> +DefaultDependencies=no
> +ConditionPathExists=@pkgsysconfdir@/rules/main.nft
> +
> +[Service]
> +Type=oneshot
> +RemainAfterExit=yes
> +StandardInput=null
> +ProtectSystem=full
> +ProtectHome=true
> +ExecStart=@sbindir@/nft -f @pkgsysconfdir@/rules/main.nft
> +ExecReload=@sbindir@/nft -f @pkgsysconfdir@/rules/main.nft
> +ExecStop=@sbindir@/nft flush ruleset
> +
> +[Install]
> +WantedBy=sysinit.target
> -- 
> 2.48.1
> 
