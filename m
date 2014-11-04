From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Make_global.am: Don't include host headers
Date: Tue, 4 Nov 2014 21:32:57 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1411042132380.30681@blackhole.kfki.hu>
References: <91631e0597af2d757e8f943c540aaa19cca30b89.1414524094.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:39959 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaKDUcQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:32:16 -0500
In-Reply-To: <91631e0597af2d757e8f943c540aaa19cca30b89.1414524094.git.baruch@tkos.co.il>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 28 Oct 2014, Baruch Siach wrote:

> This is bad for cross compilation.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  Make_global.am | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Make_global.am b/Make_global.am
> index 7953451aeaa3..5922aeeb4fa8 100644
> --- a/Make_global.am
> +++ b/Make_global.am
> @@ -71,8 +71,7 @@
>  #            curr:rev:age
>  LIBVERSION = 8:0:5
>  
> -AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
> -	-I/usr/local/include
> +AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include
>  
>  AM_CFLAGS = -std=gnu99
>  
> -- 

Patch is applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
