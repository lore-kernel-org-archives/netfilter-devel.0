From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] set: Fix nftnl_set_set_str
Date: Fri, 1 Jul 2016 16:22:47 +0200
Message-ID: <20160701142247.GA8806@salvia>
References: <20160627162425.4376-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60177 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbcGAOW4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 10:22:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7450F1B1DFA
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:22:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 64735FAB45
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:22:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6097DFAB45
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:22:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160627162425.4376-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 27, 2016 at 06:24:25PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> We need the string length
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  src/set.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/src/set.c b/src/set.c
> index 879100c..edbcbe5 100644
> --- a/src/set.c
> +++ b/src/set.c
> @@ -203,7 +203,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_set_set_u64, nft_set_at=
tr_set_u64);
> =20
>  int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char=
 *str)
>  {
> -	return nftnl_set_set(s, attr, str);
> +	return nftnl_set_set_data(s, attr, str, strlen(str));

I think this should be strlen(str) + 1 so we make sure the string is
nul-terminated.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
