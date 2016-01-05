From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4] nf: netfilter: nf_tables_api: Add new attributes
 into nft_set to store user data.
Date: Tue, 5 Jan 2016 11:34:06 +0100
Message-ID: <20160105103406.GA2828@salvia>
References: <1451849900-18077-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58482 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbcAEKeQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 05:34:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5DE30130FC4
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 11:34:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4E1B7DA804
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 11:34:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CE736DA808
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 11:34:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1451849900-18077-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 03, 2016 at 08:38:17PM +0100, Carlos Falgueras Garc=EDa wro=
te:
> @@ -2816,12 +2823,16 @@ static int nf_tables_newset(struct net *net, =
struct sock *nlsk,
>  	if (IS_ERR(ops))
>  		return PTR_ERR(ops);
> =20
> +	udlen =3D 0;
> +	if (nla[NFTA_SET_USERDATA])
> +		udlen =3D nla_len(nla[NFTA_SET_USERDATA]);
> +
>  	size =3D 0;
>  	if (ops->privsize !=3D NULL)
>  		size =3D ops->privsize(nla);
> =20
>  	err =3D -ENOMEM;
> -	set =3D kzalloc(sizeof(*set) + size, GFP_KERNEL);
> +	set =3D kzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
>  	if (set =3D=3D NULL)
>  		goto err1;
> =20
> @@ -2830,6 +2841,12 @@ static int nf_tables_newset(struct net *net, s=
truct sock *nlsk,
>  	if (err < 0)
>  		goto err2;
> =20
> +	udata =3D NULL;
> +	if (nla[NFTA_SET_USERDATA]) {

I think this should be:

        if (udlen)

instead, to ignore zero length user data.

> +		udata =3D set->data + size;
> +		nla_memcpy(udata, nla[NFTA_SET_USERDATA], udlen);
> +	}
> +
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
