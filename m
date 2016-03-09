From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] libxt_multiport: Add translation to nft
Date: Wed, 9 Mar 2016 18:30:32 +0100
Message-ID: <20160309173032.GA10722@salvia>
References: <20160307212141.GA10594@sonyv>
 <20160308105346.GB4008@salvia>
 <56DFC995.7090009@gmail.com>
 <20160309123238.GA30363@salvia>
 <56E0359F.7060308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37552 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbcCIRah (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 12:30:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D678673F7
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 18:30:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C4E2EDA380
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 18:30:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5CD15DA38B
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 18:30:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56E0359F.7060308@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 09, 2016 at 08:09:27PM +0530, Piyush Pangtey wrote:
> Added full translation for multiport.
>=20
> Examples :
> $ iptables-translate -A INPUT -p tcp -m multiport --ports 3:4  -j ACC=
EPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport { 3-4 } tcp sp=
ort { 3-4 }
> counter accept
>=20
> $ iptables-translate -A input -p sctp -m multiport --dports 11:18  -j=
 ACCEPT
> nft add rule ip filter input ip protocol sctp sctp dport { 11-18 } co=
unter
> accept
>=20
> $ iptables-translate -A input -p dccp -m multiport --ports 11:18  -j =
ACCEPT
> nft add rule ip filter input ip protocol dccp dccp dport { 11-18 } dc=
cp sport {
> 11-18 } counter accept
>=20
> $ ip6tables-translate -A input -p dccp -m multiport --ports 11:18  -j=
 ACCEPT
> nft add rule ip6 filter input meta l4proto dccp dccp dport { 11-18 } =
dccp sport
> { 11-18 } counter accept
>=20
> Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
> ---
> v2:
> 	Corrected the translations , as suggested by Arturo Borrero Gonz=E1l=
ez
>=20
>  extensions/libxt_multiport.c | 171 +++++++++++++++++++++++++++++++++=
+++++++++-
>  1 file changed, 170 insertions(+), 1 deletion(-)
>=20
> diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multipor=
t.c
> index 03af5a9..6358ffd 100644
> --- a/extensions/libxt_multiport.c
> +++ b/extensions/libxt_multiport.c
> @@ -18,6 +18,8 @@ enum {
>  	F_ANY          =3D F_SOURCE_PORTS | F_DEST_PORTS | F_SD_PORTS,
>  };
> =20
> +static const char *xlate_proto;

I don't like this global variable trick.

Please, use the ipt_ip and ip6t_ip information instead, which is will
be now available through this patch, so we pass information as
parameter to functions.

http://patchwork.ozlabs.org/patch/595128/

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
