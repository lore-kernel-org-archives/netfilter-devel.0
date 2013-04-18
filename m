From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/5] src: rule: small fix XML output
Date: Fri, 19 Apr 2013 01:32:38 +0200
Message-ID: <20130418233238.GB16842@localhost>
References: <20130410163912.6303.8705.stgit@nfdev.cica.es>
 <20130410163957.6303.44318.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51207 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936645Ab3DRXcm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:32:42 -0400
Content-Disposition: inline
In-Reply-To: <20130410163957.6303.44318.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Wed, Apr 10, 2013 at 06:39:57PM +0200, Arturo Borrero wrote:
> This patch aplies two fixes:
> 	* snprintf XML output offset for rule.
> 	* add XML <flags> node, missing in previous patches.
>=20
> The <flags> node will be used for parsing a rule in XML.
>=20
> Signed-off-by: Arturo Borrero Gonz=E1lez <arturo.borrero.glez@gmail.c=
om>
> ---
>  src/rule.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/src/rule.c b/src/rule.c
> index e419b0a..c463c69 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -451,9 +451,10 @@ static int nft_rule_snprintf_xml(char *buf, size=
_t size, struct nft_rule *r,
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> =20
>  	ret =3D snprintf(buf+offset, len, "<rule_flags>%u</rule_flags>"
> +					"<flags>%u</flags>"
>  					"<compat_flags>%u</compat_flags>"
>  					"<compat_proto>%u</compat_proto>",
> -					r->rule_flags,
> +					r->rule_flags, r->flags,

You should not rely on the r->flags in the XML parser. Same thing for
table, chain and expressions. Those flags are internal to the library
object representation and I would prefer if they still remain like
that.

I have applied this chunk below as bugfix.

>  					r->compat.flags, r->compat.proto);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> =20
> @@ -469,7 +470,7 @@ static int nft_rule_snprintf_xml(char *buf, size_=
t size, struct nft_rule *r,
>  		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> =20
>  	}
> -	ret =3D snprintf(buf+offset-1, len, "\n</rule>\n ");
> +	ret =3D snprintf(buf+offset, len, "\n</rule>\n ");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> =20
>  	return ret;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
