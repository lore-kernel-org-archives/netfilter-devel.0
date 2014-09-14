From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 3/5] ipset: coalesce two ifs
Date: Sun, 14 Sep 2014 21:10:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409142109150.1020@blackhole.kfki.hu>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org> <20140908143043.16930.51865.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:48324 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbaINTKi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:10:38 -0400
In-Reply-To: <20140908143043.16930.51865.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 8 Sep 2014, Holger Eitzenberger wrote:

> Because they are doing the same for both IPSET_CMD_LIST and
> IPSET_CMD_SAVE.
> 
> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> ---
>  lib/session.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/session.c b/lib/session.c
> index 7a719b2..d4fe836 100644
> --- a/lib/session.c
> +++ b/lib/session.c
> @@ -1936,13 +1936,11 @@ ipset_cmd(struct ipset_session *session, enum ipset_cmd cmd, uint32_t lineno)
>  	session->lineno = lineno;
>  
>  	/* Set default output mode */
> -	if (cmd == IPSET_CMD_LIST) {
> +	if (cmd == IPSET_CMD_LIST || cmd == IPSET_CMD_SAVE) {
>  		if (session->mode == IPSET_LIST_NONE)
>  			session->mode = IPSET_LIST_PLAIN;
> -	} else if (cmd == IPSET_CMD_SAVE) {
> -		if (session->mode == IPSET_LIST_NONE)
> -			session->mode = IPSET_LIST_SAVE;
>  	}
> +
>  	/* Start the root element in XML mode */
>  	if ((cmd == IPSET_CMD_LIST || cmd == IPSET_CMD_SAVE) &&
>  	    session->mode == IPSET_LIST_XML)
> 

The two ifs don't do the same thing: by coalescing them the safe mode 
would be broken (unless XML mode is specified). So this patch is skipped.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
