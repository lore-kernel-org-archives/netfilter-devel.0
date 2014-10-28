From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] libipset: Bump lib version and update map file
Date: Tue, 28 Oct 2014 19:37:30 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1410281937100.15435@blackhole.kfki.hu>
References: <20141024093622.GA5771@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:44412 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbaJ1Sgu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:36:50 -0400
In-Reply-To: <20141024093622.GA5771@nitrogen.neutroncom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 24 Oct 2014, Neutron Soutmun wrote:

> The ipset_parse_uint16() was introduced but no lib version bumped and
> no map file updated.
> 
> Bump lib version to 9:0:6. (current and age was bumped)
> 
> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
> ---
>  Make_global.am   | 2 +-
>  lib/libipset.map | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/Make_global.am b/Make_global.am
> index 7953451..f9ec7b2 100644
> --- a/Make_global.am
> +++ b/Make_global.am
> @@ -69,7 +69,7 @@
>  # interface. 
>  
>  #            curr:rev:age
> -LIBVERSION = 8:0:5
> +LIBVERSION = 9:0:6
>  
>  AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
>  	-I/usr/local/include
> diff --git a/lib/libipset.map b/lib/libipset.map
> index 58174ec..61f6d6e 100644
> --- a/lib/libipset.map
> +++ b/lib/libipset.map
> @@ -152,3 +152,8 @@ global:
>    ipset_print_skbmark;
>    ipset_print_skbprio;
>  } LIBIPSET_4.2;
> +
> +LIBIPSET_4.4 {
> +global:
> +  ipset_parse_uint16;
> +} LIBIPSET_4.3;
> -- 
> 2.1.1

Patch is applied, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
