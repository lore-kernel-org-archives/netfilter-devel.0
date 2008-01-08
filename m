From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 23/27] xt_iprange match, revision 1
Date: Tue, 08 Jan 2008 16:56:17 +0100
Message-ID: <47839D21.7060601@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022131340.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63334 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYAHQAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:00:14 -0500
In-Reply-To: <Pine.LNX.4.64.0801022131340.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 057131958a0e09403fc47090549fe9d25afd763c
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 18:51:10 2008 +0100
>=20
>     [NETFILTER]: xt_iprange match, revision 1
>    =20
>     Adds IPv6 support to xt_iprange, making it possible to match on I=
Pv6
>     address ranges with ip6tables.
>    =20
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>=20
>  net/netfilter/xt_iprange.c |  123 +++++++++++++++++++++++++++++++++-=
--
>  1 files changed, 114 insertions(+), 9 deletions(-)
>=20
> diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
> index ff71868..cd08f17 100644
> --- a/net/netfilter/xt_iprange.c
> +++ b/net/netfilter/xt_iprange.c
> @@ -2,6 +2,8 @@
>   *	xt_iprange - Netfilter module to match IP address ranges
>   *
>   *	(C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + *	Copyright =A9 CC Computer Consultants GmbH, 2008
> + *	Contact: <jengelh@computergmbh.de>


This gives the impression that Jozsef doesn't want to be contacted
about this module anymore, which I don't think is true.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
