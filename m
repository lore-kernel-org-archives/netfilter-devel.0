From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack: made the manual page and help consistent in
 case of proto option
Date: Fri, 26 Jun 2015 10:29:23 +0200
Message-ID: <20150626082923.GA15136@salvia>
References: <1435226541-15244-1-git-send-email-pfeiffer.szilard@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pfeiffer.szilard@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53255 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbbFZIX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 04:23:57 -0400
Content-Disposition: inline
In-Reply-To: <1435226541-15244-1-git-send-email-pfeiffer.szilard@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 25, 2015 at 12:02:21PM +0200, pfeiffer.szilard@balabit.hu w=
rote:
> From: Szil=E1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
>=20
> Signed-off-by: Szil=E1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
> ---
>  conntrack.8     | 2 +-
>  src/conntrack.c | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/conntrack.8 b/conntrack.8
> index abc26c5..ac82f33 100644
> --- a/conntrack.8
> +++ b/conntrack.8
> @@ -127,7 +127,7 @@ Match only entries whose source address in the re=
ply direction equals the one sp
>  .BI "-q, --reply-dst " IP_ADDRESS
>  Match only entries whose destination address in the reply direction =
equals the one specified as argument.
>  .TP
> -.BI "-p, --proto " "PROTO "
> +.BI "-p, --protocol " "PROTO "
>  Specify layer four (TCP, UDP, ...) protocol.
>  .TP
>  .BI "-f, --family " "PROTO"
> diff --git a/src/conntrack.c b/src/conntrack.c
> index f6d7d9a..f7d37fb 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -279,7 +279,7 @@ static const char *optflags[NUMBER_OF_OPT] =3D {
>  	[CT_OPT_ORIG_DST_BIT]	=3D "dst",
>  	[CT_OPT_REPL_SRC_BIT]	=3D "reply-src",
>  	[CT_OPT_REPL_DST_BIT]	=3D "reply-dst",
> -	[CT_OPT_PROTO_BIT]	=3D "protonum",
> +	[CT_OPT_PROTO_BIT]	=3D "protocol",
>  	[CT_OPT_TIMEOUT_BIT]	=3D "timeout",
>  	[CT_OPT_STATUS_BIT]	=3D "status",
>  	[CT_OPT_ZERO_BIT]	=3D "zero",
> @@ -322,7 +322,7 @@ static struct option original_opts[] =3D {
>  	{"dst", 1, 0, 'd'},
>  	{"reply-src", 1, 0, 'r'},
>  	{"reply-dst", 1, 0, 'q'},
> -	{"protonum", 1, 0, 'p'},
> +	{"protocol", 1, 0, 'p'},

You have to keep --protonum in place as an alias, this may break
existing scripts. Then, keep --protocol from the manpage so we
encourage users to adopt it.

Please, also add some tests so we can make sure this doesn't break
anything. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
