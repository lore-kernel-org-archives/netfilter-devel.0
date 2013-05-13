From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: Fix hyphen used as minus sign in manpage
Date: Mon, 13 May 2013 09:02:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1305130901460.32425@blackhole.kfki.hu>
References: <20130512093057.GB9286@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:49692 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3EMHCH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 May 2013 03:02:07 -0400
In-Reply-To: <20130512093057.GB9286@nitrogen.neutroncom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 12 May 2013, Neutron Soutmun wrote:

> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
> ---
>  src/ipset.8 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/ipset.8 b/src/ipset.8
> index 6e627a2..7bb55e1 100644
> --- a/src/ipset.8
> +++ b/src/ipset.8
> @@ -278,7 +278,7 @@ ipset create test hash:ip timeout 300
>  .IP
>  ipset add test 192.168.0.1 timeout 60
>  .IP
> -ipset -exist add test 192.168.0.1 timeout 600
> +ipset \-exist add test 192.168.0.1 timeout 600
>  .PP 
>  .SS nomatch
>  The \fBhash\fR set types which can store \fBnet\fR type of data (i.e. hash:*net*)
> -- 
> 1.7.10.4

Thanks, patch is applied.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
