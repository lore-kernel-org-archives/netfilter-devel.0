From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: Fix hyphen used as minus sign in manpage
Date: Tue, 30 Sep 2014 09:50:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409300949350.15090@blackhole.kfki.hu>
References: <20140925075611.GA12768@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:38716 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaI3Hti (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:49:38 -0400
In-Reply-To: <20140925075611.GA12768@nitrogen.neutroncom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 25 Sep 2014, Neutron Soutmun wrote:

> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
> ---
>  src/ipset.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/ipset.8 b/src/ipset.8
> index a7bd94f..c923956 100644
> --- a/src/ipset.8
> +++ b/src/ipset.8
> @@ -319,7 +319,7 @@ the above would appear as: "allow access to SMB share on \\\\fileserv\\"
>  .SS "skbinfo, skbmark, skbprio, skbqueue"
>  All set types support the optional \fBskbinfo\fR extension. This extension allow to
>  store the metainfo (firewall mark, tc class and hardware queue) with every entry and map it to
> -packets by usage of SET netfilter target with --map-set option.
> +packets by usage of SET netfilter target with \-\-map\-set option.
>  \fBskbmark\fR option format: \fBMARK\fR or \fBMARK/MASK\fR, where \fBMARK\fR and \fBMASK\fR are 32bit hex
>  numbers with 0x prefix. If only \fBmark\fR is specified mask 0xffffffff are used.
>  \fBskbprio\fR option has tc class format: \fBMAJOR:MINOR\fR, where \fBmajor\fR and \fBminor\fR numbers

Patch is applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
