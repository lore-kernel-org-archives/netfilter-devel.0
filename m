From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft tool PATCH] src: include <stdio.h>
Date: Tue, 29 Oct 2013 13:24:53 +0100
Message-ID: <20131029122453.GA8056@localhost>
References: <20131028232710.11563.530.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40280 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab3J2MY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:24:58 -0400
Content-Disposition: inline
In-Reply-To: <20131028232710.11563.530.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 29, 2013 at 12:27:10AM +0100, Arturo Borrero Gonzalez wrote=
:
> This prevents compile errors:
> 	[...] error: unknown type name =E2=80=98FILE=E2=80=99
>=20
> when using with the libnftables patch 'src: add fprintf API functions=
'.
>=20
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>
> ---
>  src/netlink_delinearize.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 3bb143b..8318e5c 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -10,6 +10,7 @@
>   */
> =20
>  #include <stdlib.h>
> +#include <stdio.h>

This means that you have to include this in the libnftables header
files.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
