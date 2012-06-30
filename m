From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] build: restore -version-info
Date: Sun, 1 Jul 2012 00:05:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1206302357430.1075@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <1341082043-26584-1-git-send-email-jengelh@inai.de> <1341082043-26584-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:60638 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab2F3WFe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jun 2012 18:05:34 -0400
In-Reply-To: <1341082043-26584-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Sat, 30 Jun 2012, Jan Engelhardt wrote:

> There was no noticable reason to switch to -version-number;
> version-number would have also seen the use of 3:0:0, not 3:0:1.
> 
> 3:0:1 only makes sense with -version-info, so put "-version-info"
> back. However, since ipset-6.13 already released libipset.so.3, going
> back to .so.2 might not be such a good idea, so continue using .so.3
> by means of 3:0:0.
> 
> Also note that the version names in libipset.map generally are not
> supposed to follow SO versions, but the program version):
> IPSET_6.13 {...}.
> ---
>  Make_global.am  |    2 +-
>  lib/Makefile.am |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Make_global.am b/Make_global.am
> index 4a8f61a..446c4de 100644
> --- a/Make_global.am
> +++ b/Make_global.am
> @@ -69,7 +69,7 @@
>  # interface. 
>  
>  #            curr:rev:age
> -LIBVERSION = 3:0:1
> +LIBVERSION = 3:0:0

The new library release is backward compatible with the previous one, so 
age must be incremented. That's why I set LIBVERSION to 3:0:1 from 2:1:0. 
Or do I miss something from the library interface version description 
cited in Make_global.am?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
