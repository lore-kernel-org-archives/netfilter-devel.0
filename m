From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/5] Remove a duplicate debug print
Date: Sun, 14 Sep 2014 21:08:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409142108010.1020@blackhole.kfki.hu>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org> <20140908143033.16930.26216.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36004 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbaINTIT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:08:19 -0400
In-Reply-To: <20140908143033.16930.26216.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 8 Sep 2014, Holger Eitzenberger wrote:

> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> ---
>  lib/session.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/lib/session.c b/lib/session.c
> index d2957a5..7a719b2 100644
> --- a/lib/session.c
> +++ b/lib/session.c
> @@ -1038,8 +1038,7 @@ callback_list(struct ipset_session *session, struct nlattr *nla[],
>  		ipset_data_flags_unset(data, IPSET_CREATE_FLAGS);
>  		D("nla typename %s",
>  		  (char *) mnl_attr_get_payload(nla[IPSET_ATTR_TYPENAME]));
> -		D("nla typename %s",
> -		  (char *) mnl_attr_get_payload(nla[IPSET_ATTR_TYPENAME]));
> +
>  		ATTR2DATA(session, nla, IPSET_ATTR_FAMILY, cmd_attrs);
>  		ATTR2DATA(session, nla, IPSET_ATTR_TYPENAME, cmd_attrs);
>  		ATTR2DATA(session, nla, IPSET_ATTR_REVISION, cmd_attrs);
> 

Patch is applied, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
