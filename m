From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] conntrack: made the protocol option value case
 insensitive
Date: Fri, 26 Jun 2015 09:19:21 +0200
Message-ID: <20150626071921.GA30656@breakpoint.cc>
References: <1435227145-15554-1-git-send-email-pfeiffer.szilard@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pfeiffer.szilard@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43203 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbbFZHTX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 03:19:23 -0400
Content-Disposition: inline
In-Reply-To: <1435227145-15554-1-git-send-email-pfeiffer.szilard@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

pfeiffer.szilard@balabit.hu <pfeiffer.szilard@balabit.hu> wrote:
> From: Szil=E1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
>=20
> Extensions register protocols by lowercase protocol name, but value o=
f
> proto command line option may be uppercase. Extension related options
> cannot be used when protocol name comparision fails.
>=20
> Signed-off-by: Szil=E1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
> ---
>  src/conntrack.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/src/conntrack.c b/src/conntrack.c
> index f7d37fb..b1a2589 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -555,6 +555,12 @@ static struct ctproto_handler *findproto(char *n=
ame, int *pnum)
>  	/* using the protocol name for an unsupported protocol? */
>  	if ((pent =3D getprotobyname(name))) {
>  		*pnum =3D pent->p_proto;

Why not use strcasecmp to check the proto_list?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
