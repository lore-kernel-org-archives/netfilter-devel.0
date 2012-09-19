From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [pablo@netfilter.org: Re: [netfilter-core] Patch for ULOGD]
Date: Wed, 19 Sep 2012 04:31:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209190429410.13470@nerf07.vanv.qr>
References: <20120918193708.GA2498@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: anders@anduras.de, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:47889 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab2ISCbT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 22:31:19 -0400
In-Reply-To: <20120918193708.GA2498@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-09-18 21:37, Pablo Neira Ayuso wrote:
>
>This contribution reached netfilter-core mailing list.
>
> --- ulogd-2.0.0.orig/configure.ac	2012-06-17 13:01:58.000000000 +0200
> +++ ulogd-2.0.0/configure.ac	2012-08-29 13:11:01.000000000 +0200
> @@ -2,7 +2,7 @@
>  AC_PREREQ([2.50])
>  AC_INIT([ulogd], [2.0.0])
>  AC_CONFIG_AUX_DIR([build-aux])
> -AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b])
> +AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10])
>  AC_CONFIG_HEADER([config.h])
>  AC_CONFIG_MACRO_DIR([m4])

This should be a separate commit, and explain why this was done.

Now that I already looked it up: pkglibexecdir was introduced in automake
1.10b, however, we are no longer using the pkglibexecdir variable
since commit ulogd-2.0.0~6, so the requirement is relaxed.

