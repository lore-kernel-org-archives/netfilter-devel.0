From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2,libnftnl] Free user data in unsetters
Date: Thu, 2 Jun 2016 12:55:38 +0200
Message-ID: <20160602105538.GA3013@salvia>
References: <1464864024-12108-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59513 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124AbcFBKzn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 06:55:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 47919438F71
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:55:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 36F4B1B4040
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:55:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C565F1B4055
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:55:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464864024-12108-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 02, 2016 at 12:40:23PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  src/rule.c     | 2 ++
>  src/set_elem.c | 2 ++
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/src/rule.c b/src/rule.c
> index 8ee8648..3576e32 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -112,6 +112,8 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint1=
6_t attr)
>  	case NFTNL_RULE_POSITION:
>  	case NFTNL_RULE_FAMILY:
>  	case NFTNL_RULE_USERDATA:
> +		xfree(r->user.data);
> +		r->user.len =3D 0;

I think we don't need to reset user.len, right?

>  		break;
>  	}
> =20
> diff --git a/src/set_elem.c b/src/set_elem.c
> index b9c7e1e..47ad6f4 100644
> --- a/src/set_elem.c
> +++ b/src/set_elem.c
> @@ -82,6 +82,8 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s,=
 uint16_t attr)
>  	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
>  	case NFTNL_SET_ELEM_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
>  	case NFTNL_SET_ELEM_USERDATA:	/* NFTA_SET_ELEM_USERDATA */
> +		xfree(s->user.data);
> +		s->user.len =3D 0;
>  		break;
>  	case NFTNL_SET_ELEM_EXPR:
>  		if (s->flags & (1 << NFTNL_SET_ELEM_EXPR)) {
> --=20
> 2.8.2
>=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
