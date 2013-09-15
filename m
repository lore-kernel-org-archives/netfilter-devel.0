From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ipset PATCH] configure: uclinux is also linux
Date: Sun, 15 Sep 2013 15:00:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309151432160.8707@blackhole.kfki.hu>
References: <1378841015-23295-1-git-send-email-gustavo@zacarias.com.ar> <1378841015-23295-2-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:37139 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab3IONAi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Sep 2013 09:00:38 -0400
In-Reply-To: <1378841015-23295-2-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 10 Sep 2013, Gustavo Zacarias wrote:

> Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 6b64576..6d06ef5 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -14,7 +14,7 @@ LTDL_INIT([nonrecursive])
>  
>  dnl Shortcut: Linux supported alone
>  case "$host" in
> -*-*-linux*) ;;
> +*-*-linux* | *-*-uclinux*) ;;
>  *) AC_MSG_ERROR([Linux systems supported exclusively!]);;
>  esac
>  
> -- 
> 1.8.1.5

Patch is applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
