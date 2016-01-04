From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] nf: netfilter: nf_tables_api: Add new attributes
 into nft_set to store user data.
Date: Mon, 4 Jan 2016 12:32:31 +0000
Message-ID: <20160104123230.GA32583@macbook.localdomain>
References: <1451849900-18077-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44189 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbcADMcm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 07:32:42 -0500
Content-Disposition: inline
In-Reply-To: <1451849900-18077-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03.01, Carlos Falgueras Garc=EDa wrote:
> @@ -2704,6 +2709,8 @@ static int nf_tables_newset(struct net *net, st=
ruct sock *nlsk,
>  	u64 timeout;
>  	u32 ktype, dtype, flags, policy, gc_int;
>  	struct nft_set_desc desc;
> +	unsigned char udlen;

This will overflow at size 256. Please use an explicitly sized type (u1=
6).

> +	unsigned char *udata;
>  	int err;
> =20
>  	if (nla[NFTA_SET_TABLE] =3D=3D NULL ||
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
