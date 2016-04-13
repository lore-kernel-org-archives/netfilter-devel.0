From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4 v6] libnftnl: rule: Change the "userdata" attribute
 to use new TLV buffer
Date: Thu, 14 Apr 2016 01:59:18 +0200
Message-ID: <20160413235918.GA12737@salvia>
References: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
 <1458675987-32398-2-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44440 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968AbcDMX7i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2016 19:59:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AB94B73F3
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 01:59:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9D6B2EBADB
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 01:59:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0AF08C21A8
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 01:59:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458675987-32398-2-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 08:46:25PM +0100, Carlos Falgueras Garc=EDa wro=
te:
> diff --git a/src/rule.c b/src/rule.c
> index 3a32bf6..db96e5b 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -28,6 +28,7 @@
>  #include <libnftnl/rule.h>
>  #include <libnftnl/set.h>
>  #include <libnftnl/expr.h>
> +#include <libnftnl/udata.h>
> =20
>  struct nftnl_rule {
>  	struct list_head head;
> @@ -38,10 +39,7 @@ struct nftnl_rule {
>  	const char	*chain;
>  	uint64_t	handle;
>  	uint64_t	position;
> -	struct {
> -			void		*data;
> -			uint32_t	len;
> -	} user;
> +	struct nftnl_udata_buf	*userdata;

This change, we don't need it, see below.

> @@ -162,8 +171,14 @@ void nftnl_rule_set_data(struct nftnl_rule *r, u=
int16_t attr,
>  		r->position =3D *((uint64_t *)data);
>  		break;
>  	case NFTNL_RULE_USERDATA:
> -		r->user.data =3D (void *)data;
> -		r->user.len =3D data_len;
> +		if (r->flags & (1 << NFTNL_RULE_USERDATA))
> +			nftnl_udata_buf_free(r->userdata);
> +		r->userdata =3D nftnl_udata_buf_alloc(data_len);
> +		if (!r->userdata) {
> +			perror("nftnl_rule_set_data - userdata");
> +			return;
> +		}
> +		nftnl_udata_buf_put(r->userdata, data, data_len);

Think about this: From nft, we allocate the udata_buf, then we add the
attributes. Once we have the TLV area ready, we pass it as a pointer
via nftnl_rule_set_data().

Then, from libnftnl you allocate nftnl_udata_buf_alloc() again, but we
actually don't need this. The reason is that udata_buf is *only*
needed to build the sequence of TLVs. Once we're done with it, we can
just pass the memory blob area that contains this info.

=46or this reason, I'm entirely keeping back this patch.

Good thing though is that we don't need it to get this working :-)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
