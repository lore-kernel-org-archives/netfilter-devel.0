From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnfntl] Check all strdup
Date: Mon, 30 May 2016 19:16:34 +0200
Message-ID: <20160530171634.GA1017@salvia>
References: <1464627822-6173-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36148 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161383AbcE3RQo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 13:16:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C98A11B5CA6
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:16:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BA7881B3268
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:16:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B83FF1B3266
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:16:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464627822-6173-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 30, 2016 at 07:03:42PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> diff --git a/src/set.c b/src/set.c
> index dbea93b..65b8f1e 100644
> --- a/src/set.c
> +++ b/src/set.c
> @@ -291,10 +295,16 @@ struct nftnl_set *nftnl_set_clone(const struct =
nftnl_set *set)
> =20
>  	memcpy(newset, set, sizeof(*set));
> =20
> -	if (set->flags & (1 << NFTNL_SET_TABLE))
> +	if (set->flags & (1 << NFTNL_SET_TABLE)) {
>  		newset->table =3D strdup(set->table);
> -	if (set->flags & (1 << NFTNL_SET_NAME))
> +		if (!newset->table)
> +			return NULL;
> +	}
> +	if (set->flags & (1 << NFTNL_SET_NAME)) {
>  		newset->name =3D strdup(set->name);
> +		if (!newset->name)
> +			return NULL;
> +	}

This is leaking the clone object.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
