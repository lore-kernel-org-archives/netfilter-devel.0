From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] remove dynamic libiptc.so from iptables-static
Date: Mon, 1 Jun 2009 13:30:54 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906011303460.7784@fbirervta.pbzchgretzou.qr>
References: <4A01A97C.6040305@nanometrics.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ben Gardiner <BenGardiner@nanometrics.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53192 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZFALax (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:30:53 -0400
In-Reply-To: <4A01A97C.6040305@nanometrics.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-05-06 17:15, Ben Gardiner wrote:
>
> I was building iptables-static from 1.4.3.2 and I noticed that ldd
> reported libiptc.so was a dependency; I was using gcc 4.0.1 for ppc
> cross compile -- but I don't think the toolchain is the cause.

This is intentional. "static" here means that all the extensions are
included; we certainly do not want a truly static binary where ldd
would report "not a dynamic executable".

> I was able to get iptables-static to depend only on libm and libc
> with the following patch (made against the 1.4.3.2 dist, but
> applies clean to svn trunk). I hope you will consider it for
> inclusion in the next release.

> # libiptc
> lib_LTLIBRARIES           += libiptc/libiptc.la
> -libiptc_libiptc_la_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
> +if ENABLE_IPV4
> +libiptc_libiptc_la_SOURCES = libiptc/libip4tc.c
> +endif
> +if ENABLE_IPV6
> +libiptc_libiptc_la_SOURCES = libiptc/libip6tc.c
> +endif
> libiptc_libiptc_la_LDFLAGS = -version-info 0:0:0

If both ENABLE_IPV4=1, ENABLE_IPV6=1, it won't do the right thing
anymore.

> lib_LTLIBRARIES      += libxtables.la
> @@ -44,10 +49,10 @@ iptables_save_SOURCES     = iptables-save.c iptables.c
> iptables_save_LDFLAGS     = ${iptables_LDFLAGS}
> iptables_save_LDADD       = ${iptables_LDADD}
>
> -# iptables-multi, semi-static
> -iptables_static_SOURCES   = ${iptables_multi_SOURCES} xtables.c
> +# iptables-static
> +iptables_static_SOURCES   = ${iptables_multi_SOURCES} xtables.c
> ${libiptc_libiptc_la_SOURCES}
> iptables_static_CFLAGS    = ${iptables_multi_CFLAGS} -DNO_SHARED_LIBS=1
> -iptables_static_LDADD     = libiptc/libiptc.la extensions/libext4.a -lm
> +iptables_static_LDADD     = extensions/libext4.a -lm
>
> iptables_xml_SOURCES      = iptables-xml.c

Not needed - just run ./configure --disable-shared.
