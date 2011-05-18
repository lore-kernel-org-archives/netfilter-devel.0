From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Re: [PATCH 8/9] libxt_udp: use guided option parser
Date: Wed, 18 May 2011 14:49:16 +0200
Message-ID: <20110518124916.GA12964@lutz.bln.innominate.local>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
 <1304250630-6150-9-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:53181 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab1ERMtS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 08:49:18 -0400
Content-Disposition: inline
In-Reply-To: <1304250630-6150-9-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

this modification lead to a subtle failure I don't know how to cure yet=
=2E

On Sun, May 01, 2011 at 01:50:28PM +0200, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  extensions/libxt_udp.c |   95 +++++++++++++++-----------------------=
----------
>  1 files changed, 30 insertions(+), 65 deletions(-)
>=20
> diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
> index 505b3c8..a539edd 100644
> --- a/extensions/libxt_udp.c
> +++ b/extensions/libxt_udp.c

=2E..
> +#define s struct xt_udp
> +static const struct xt_option_entry udp_opts[] =3D {
> +	{.name =3D "source-port", .id =3D O_SOURCE_PORT, .type =3D XTTYPE_P=
ORTRC_NE,
> +	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, spts)},
> +	{.name =3D "sport", .id =3D O_SOURCE_PORT, .type =3D XTTYPE_PORTRC_=
NE,
> +	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, spts)},
> +	{.name =3D "destination-port", .id =3D O_DEST_PORT, .type =3D XTTYP=
E_PORTRC_NE,
> +	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, dpts)},
> +	{.name =3D "dport", .id =3D O_DEST_PORT, .type =3D XTTYPE_PORTRC_NE=
,
> +	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, dpts)},
> +	XTOPT_TABLEEND,
>  };

The port parsing now performed indirectly via xtables_getportbyname() a=
nd
then hence getaddrinfo().
At least for uClibc (did not test glibc), getaddrinfo() will complain
when a port is specified by number but no socket type of address family
is set:
=2E..
  /*
   * Can't specify a numerical socket unless a protocol
   * family was given.
   */
   if (hints->ai_socktype =3D=3D 0 && hints->ai_protocol =3D=3D 0)
            return EAI_SERVICE;
=2E..

The straight forward solution would be to add a respective ai_protocol
information (we actually know that it is IPPROTO_UDP). I am currently
however not deep enough into the new parser structure to know where to
add this information to the function calls and or data structures.

Note: the same issue will pop up for not yet converted protocols like U=
DP.

Best regards,
	Lutz
--=20
Dr.-Ing. Lutz J=E4nicke
CTO
Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.921028-200
fax: +49.30.921028-020
Rudower Chaussee 13
D-12489 Berlin, Germany
www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Volker Bibelhausen
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
