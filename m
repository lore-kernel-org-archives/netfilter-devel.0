Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE934C6E
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Mar 2025 14:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741270594; cv=none; b=rbUs+EoVtpLti14W3Ax2hrCrYYxaw/0Y9vMEj2LKBpWq1OeCPEF2awSNBa52aRVD2siYxdBmspXPcEYU0lOFJK2J+veER6omn7Vjk9JImsnHBMX0vcmU8RUsJZm0Tezfx6c2N2Ob4lIjIMSwNkYfEmkDf/mORtMpkEjx2klywSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741270594; c=relaxed/simple;
	bh=0ICkcQ25t4cydgXHlQ8/CoIQa3X5/2De9qbFmlCuZ7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=poTqIuo/w/8LwhyD8M14AeXebGgdV1HmEwnTSsqADpmmtAZf1K8y8IIS1jXdHtqauRjn6paYZiHRylQMMyd4yVAfwohHQ5eQRXFrnteCSLCeQYn3g7c6urSNVQWXm+B9LmV4x6W+hHB7COStV8Y62ufqYg9Wl2FYgZ67wdM0/uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b4nrgDXV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b4nrgDXV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741270591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yuOLuJq7K+w2EM5a9Bh0w91cZM9IrQQGclAGi/93/U=;
	b=b4nrgDXVNZdj3J3LlV9S/GajuLKSfCA80OuZhAVcgRXuIg41VhsTQM28Ux7/ZuJWYfP6ss
	U23xtd/ZvtCPGT1mPt/C0t6t6IHMr3tv3h2T2rdfnzE/w4JezfJXhoPA2I7YLB440hzp75
	pRKNrhmFfVtz0PldnZUNVKa7M7qLFiU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-scBErTdYMB6L2JzlBwJJFA-1; Thu,
 06 Mar 2025 09:16:11 -0500
X-MC-Unique: scBErTdYMB6L2JzlBwJJFA-1
X-Mimecast-MFC-AGG-ID: scBErTdYMB6L2JzlBwJJFA_1741270570
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED767180AF6A;
	Thu,  6 Mar 2025 14:16:09 +0000 (UTC)
Received: from localhost (unknown [10.22.65.44])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 041CF300019E;
	Thu,  6 Mar 2025 14:16:07 +0000 (UTC)
Date: Thu, 6 Mar 2025 09:16:05 -0500
From: Eric Garver <eric@garver.life>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
Message-ID: <Z8muJWOYP3y-giAP@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, pablo@netfilter.org
References: <20250228205935.59659-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228205935.59659-1-jengelh@inai.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Feb 28, 2025 at 09:59:35PM +0100, Jan Engelhardt wrote:
> There is a customer request (bugreport) for wanting to trivially load a ruleset
> from a well-known location on boot, forwarded to me by M. Gerstner. A systemd
> service unit is hereby added to provide that functionality. This is based on
> various distributions attempting to do same, cf.
> 
> https://src.fedoraproject.org/rpms/nftables/tree/rawhide
> https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/nftables/nftables.initd
> https://gitlab.archlinux.org/archlinux/packaging/packages/nftables
> 
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

I think it's worth mentioning that a user could alternatively do:

  # nft list ruleset > /etc/nftables/rules/main.nft

to save the entire running ruleset. That's what I do. Mostly because I
want to make sure runtime accepts it before I make it permanent.

Perhaps this is not mentioned due to the `flush ruleset`. We could
suggest saving runtime to a file that's included from main.nft, thus
retaining the flush.

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

The service definition is pretty close to the RHEL one [1]. The major
difference is DefaultDependencies=no, i.e. early boot service. I think
setting this to 'no' is okay for nftables. I don't see any
incompatibilities with the RHEL version.

[1]: https://gitlab.com/redhat/centos-stream/rpms/nftables/-/blob/6e830a1e31e5984cec278fe33de2518e2000514b/nftables.service

