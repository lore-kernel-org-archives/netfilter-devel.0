From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3 libnftnl] fix some error checking in parser functions
Date: Thu, 16 Jun 2016 14:53:04 +0200
Message-ID: <20160616125304.GA2864@salvia>
References: <20160616102012.32036-1-carlosfg@riseup.net>
 <20160616102012.32036-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbcFPMxH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2016 08:53:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id ABF369BF2D5
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2016 14:53:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9C4CE6446A
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2016 14:53:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8AE4E6446F
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2016 14:53:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160616102012.32036-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 16, 2016 at 12:20:11PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> diff --git a/src/rule.c b/src/rule.c
> index b009c37..930ecc0 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -427,7 +427,7 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr =
*nlh, struct nftnl_rule *r)
>  {
>  	struct nlattr *tb[NFTA_RULE_MAX+1] =3D {};
>  	struct nfgenmsg *nfg =3D mnl_nlmsg_get_payload(nlh);
> -	int ret =3D 0;
> +	int ret;
> =20
>  	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_rule_parse_attr_cb, tb)=
 < 0)
>  		return -1;
> @@ -452,10 +452,16 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghd=
r *nlh, struct nftnl_rule *r)
>  		r->handle =3D be64toh(mnl_attr_get_u64(tb[NFTA_RULE_HANDLE]));
>  		r->flags |=3D (1 << NFTNL_RULE_HANDLE);
>  	}
> -	if (tb[NFTA_RULE_EXPRESSIONS])
> +	if (tb[NFTA_RULE_EXPRESSIONS]) {
>  		ret =3D nftnl_rule_parse_expr(tb[NFTA_RULE_EXPRESSIONS], r);
> -	if (tb[NFTA_RULE_COMPAT])
> +		if (ret)
> +			return ret;

Please use:
                if (ret < 0)
                        return ret;

instead. I think this is the common idiom we're using all around this
library.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
