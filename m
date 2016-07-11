From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2, libnftnl] Fix nftnl_*_get to set data_len
Date: Mon, 11 Jul 2016 13:48:07 +0200
Message-ID: <20160711114807.GA1788@salvia>
References: <20160706152058.GB31894@salvia>
 <1468237267-15246-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48187 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbcGKLsM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 07:48:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 636D91F4B70
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 13:48:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 51CB99EBCC
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 13:48:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 304B5266749
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 13:48:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468237267-15246-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 11, 2016 at 01:41:07PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> diff --git a/src/expr/lookup.c b/src/expr/lookup.c
> index 7f68f74..a29b7e5 100644
> --- a/src/expr/lookup.c
> +++ b/src/expr/lookup.c
> @@ -73,10 +73,13 @@ nftnl_expr_lookup_get(const struct nftnl_expr *e,=
 uint16_t type,
>  		*data_len =3D sizeof(lookup->dreg);
>  		return &lookup->dreg;
>  	case NFTNL_EXPR_LOOKUP_SET:
> +		*data_len =3D strlen(lookup->set_name) + 1;
>  		return lookup->set_name;
>  	case NFTNL_EXPR_LOOKUP_SET_ID:
> +		*data_len =3D sizeof(lookup->set_id) + 1;
>  		return &lookup->set_id;
>  	case NFTNL_EXPR_LOOKUP_FLAGS:
> +		*data_len =3D sizeof(lookup->flags) + 1;

This + 1 here doesn't make any sense.

Please, send v3 without all these + 1.

And as I said in the previous version, you have to return strlen() as i=
s.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
