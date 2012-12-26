From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 01/13] doc: add package version to all manpages
Date: Wed, 26 Dec 2012 15:33:00 +0100
Message-ID: <20121226143300.GB31482@1984>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
 <1356477089-13241-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45552 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab2LZOdN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2012 09:33:13 -0500
Content-Disposition: inline
In-Reply-To: <1356477089-13241-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 26, 2012 at 12:11:17AM +0100, Jan Engelhardt wrote:
> diff --git a/iptables/Makefile.am b/iptables/Makefile.am
> index 61e78db..0f4c1f6 100644
> --- a/iptables/Makefile.am
> +++ b/iptables/Makefile.am
> @@ -27,8 +27,8 @@ xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
>  sbin_PROGRAMS    = xtables-multi
>  man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
>                     iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
> -                   ip6tables-save.8 iptables-extensions.8
> -CLEANFILES       = iptables.8 ip6tables.8
> +                   ip6tables-save.8 iptables-extensions.8 iptables-apply.8
> +CLEANFILES       = ${man_MANS}
>  
>  vx_bin_links   = iptables-xml
>  if ENABLE_IPV4
> @@ -38,14 +38,36 @@ if ENABLE_IPV6
>  v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
>  endif
>  
> -iptables.8: ${srcdir}/iptables.8.in
> -	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
> +fill_in_date = ${AM_V_GEN} sed -e \
> +               's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' \
> +               $< >$@;
> +
> +iptables-xml.1: ${srcdir}/iptables-xml.1.in
> +	${fill_in_date}
> +
> +ip6tables-restore.8: ${srcdir}/ip6tables-restore.8.in
> +	${fill_in_date}
> +
> +ip6tables-save.8: ${srcdir}/ip6tables-save.8.in
> +	${fill_in_date}
>  
>  ip6tables.8: ${srcdir}/ip6tables.8.in
> -	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
> +	${fill_in_date}
> +
> +iptables-apply.8: ${srcdir}/iptables-apply.8.in
> +	${fill_in_date}
> +
> +iptables-restore.8: ${srcdir}/iptables-restore.8.in
> +	${fill_in_date}
> +
> +iptables-save.8: ${srcdir}/iptables-save.8.in
> +	${fill_in_date}
> +
> +iptables.8: ${srcdir}/iptables.8.in
> +	${fill_in_date}

This belongs more naturally to the ./configure stage, including
setting the date via AC_SUBST. You should be able to make it with
little changes in configure.ac.

For iptables-extensions.8 it will be a special case, it still requires
part of the magic in the makefile to build the page.
