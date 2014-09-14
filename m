From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 4/5] ipset: remove extran newline on debug output
Date: Sun, 14 Sep 2014 21:11:29 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409142111040.1020@blackhole.kfki.hu>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org> <20140908143048.16930.51389.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:48421 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaINTLK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:11:10 -0400
In-Reply-To: <20140908143048.16930.51389.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 8 Sep 2014, Holger Eitzenberger wrote:

> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> ---
>  lib/session.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/session.c b/lib/session.c
> index d4fe836..8d79a96 100644
> --- a/lib/session.c
> +++ b/lib/session.c
> @@ -804,7 +804,7 @@ list_adt(struct ipset_session *session, struct nlattr *nla[])
>  		safe_snprintf(session, "</elem>");
>  
>  	for (arg = type->args[IPSET_ADD]; arg != NULL && arg->opt; arg++) {
> -		D("print arg opt %u %s\n", arg->opt,
> +		D("print arg opt %u %s", arg->opt,
>  		   ipset_data_test(data, arg->opt) ? "(yes)" : "(missing)");
>  		if (!(arg->print && ipset_data_test(data, arg->opt)))
>  			continue;
> 

This patch is also applied, thanks Holger.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
