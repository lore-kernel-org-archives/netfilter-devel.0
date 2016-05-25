From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] libnfntl: Fix segfault due to invalid free of rule
 user data
Date: Wed, 25 May 2016 10:44:23 +0200
Message-ID: <20160525084423.GB4024@salvia>
References: <1463500816-26155-1-git-send-email-carlosfg@riseup.net>
 <1463500816-26155-2-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46027 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbcEYIod (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2016 04:44:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 480121C4381
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 10:44:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 362B811FE80
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 10:44:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2FC4315D626
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 10:44:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463500816-26155-2-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 17, 2016 at 06:00:15PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> If the user allocates a nftnl_udata_buf and then passes the TLV data =
to
> nftnl_rule_set_data, the pointer stored in rule.user.data is not the =
begining of
> the allocated block. In this situation, if it calls to nftnl_rule_fre=
e, it tries
> to free this pointer and segfault is thrown.
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  src/rule.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/src/rule.c b/src/rule.c
> index c299548..3f276f8 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -167,7 +167,12 @@ void nftnl_rule_set_data(struct nftnl_rule *r, u=
int16_t attr,
>  		if (r->user.data !=3D NULL)
>  			xfree(r->user.data);
> =20
> -		r->user.data =3D (void *)data;
> +		r->user.data =3D malloc(data_len);
> +		if (!r->user.data) {
> +			perror("libnftnl: " __FILE__ ": nftnl_rule_set_data()");

We should spot this error messages from the library. The only
exception is when netlink ABI gets broken. So I'm removing this line.

We should add a new version of these setters at some point so we can
return an error (instead of void), so the client may check if the
memory allocation has failed, later.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
