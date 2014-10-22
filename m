From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] libipset: Add missing ipset_parse_uint16 to map file
Date: Wed, 22 Oct 2014 21:44:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410222140390.8153@blackhole.kfki.hu>
References: <20141017040644.GA27263@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:56689 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbaJVToG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:44:06 -0400
In-Reply-To: <20141017040644.GA27263@nitrogen.neutroncom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 17 Oct 2014, Neutron Soutmun wrote:

> The libipset was not included the ipset_parse_uint16 symbol
> 
> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
> ---
>  lib/libipset.map | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/libipset.map b/lib/libipset.map
> index 58174ec..74069dc 100644
> --- a/lib/libipset.map
> +++ b/lib/libipset.map
> @@ -149,6 +149,7 @@ LIBIPSET_4.3 {
>  global:
>    ipset_parse_skbmark;
>    ipset_parse_skbprio;
> +  ipset_parse_uint16;
>    ipset_print_skbmark;
>    ipset_print_skbprio;
>  } LIBIPSET_4.2;

Yes, that's missing from the map file. However, please advance the API 
curr and age in Make_global.am and add a new section to libipset.map 
instead of inserting the symbol as above. Better not change the library 
silently...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
