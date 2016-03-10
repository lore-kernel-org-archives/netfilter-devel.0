From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] libxt_multiport: Add translation to nft
Date: Thu, 10 Mar 2016 19:31:47 +0100
Message-ID: <20160310183146.GA32439@salvia>
References: <20160307212141.GA10594@sonyv>
 <20160308105346.GB4008@salvia>
 <56DFC995.7090009@gmail.com>
 <20160309123238.GA30363@salvia>
 <56E0359F.7060308@gmail.com>
 <20160309173032.GA10722@salvia>
 <56E16DA8.1060007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47002 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbcCJSbz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 13:31:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AF00CC9ED8
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:31:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A50CDA39C
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:31:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9B176DA38A
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:31:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56E16DA8.1060007@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 06:20:48PM +0530, Piyush Pangtey wrote:
> Added full translation for multiport
>=20
> Examples :
> $ iptables-translate -A input -p tcp -m multiport --ports ssh:http -j=
 ACCEPT
> nft add rule ip filter input ip protocol tcp tcp dport { ssh - http }=
 tcp sport
> { ssh - http } counter accept
>=20
> $ iptables-translate -A input -p sctp -m multiport --dports 11:18  -j=
 ACCEPT
> nft add rule ip filter input ip protocol sctp sctp dport { 11 - 18 } =
counter
> accept
>=20
> $ iptables-translate -A input -p dccp -m multiport --sports 11:18 -j =
ACCEPT
> nft add rule ip filter input ip protocol dccp dccp sport { 11 - 18 } =
counter
> accept
>=20
> $ ip6tables-translate -A input -p udplite -m multiport --sports 11:18=
 -j ACCEPT
> nft add rule ip6 filter input meta l4proto udplite udplite sport { 11=
 - 18 }
> counter accept
>=20
> Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
> ---
> v2:
> 	Corrected the translations , as suggested by Arturo Borrero Gonz=E1l=
ez
> v3:
> 	Removed static variable trick. Now utilizes ipt_ip and ip6t_ip which
> 	is now passed to xlate ,from the patch
> 	http://patchwork.ozlabs.org/patch/595128/
>=20
> Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
> ---
>  extensions/libxt_multiport.c | 199 +++++++++++++++++++++++++++++++++=
++++++++++
>  1 file changed, 199 insertions(+)
>=20
> diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multipor=
t.c
> index 03af5a9..4dccc1b 100644
> --- a/extensions/libxt_multiport.c
> +++ b/extensions/libxt_multiport.c
> @@ -278,6 +278,18 @@ print_port(uint16_t port, uint8_t protocol, int =
numeric)
>  }
> =20
>  static void
> +print_port_xlate(struct xt_xlate *xl, uint16_t port, uint8_t protoco=
l,
> +		int numeric)
> +{
> +	const char *service;
> +
> +	if (numeric || (service =3D port_to_service(port, protocol)) =3D=3D=
 NULL)
> +		xt_xlate_add(xl, "%u", port);
> +	else
> +		xt_xlate_add(xl, "%s", service);
> +}
> +
> +static void
>  __multiport_print(const struct xt_entry_match *match, int numeric,
>                    uint16_t proto)
>  {
> @@ -318,6 +330,20 @@ static void multiport_print(const void *ip_void,
>  	__multiport_print(match, numeric, ip->proto);
>  }
> =20
> +static void multiport_print_xlate(const struct xt_entry_match *match=
,
> +				 struct xt_xlate *xl, uint16_t proto,
> +				 int numeric)
> +{
> +	const struct xt_multiport_v1 *multiinfo =3D
> +		(const struct xt_multiport_v1 *)match->data;
> +	unsigned int i;

Missing line break here.

> +	for (i =3D 0; i < multiinfo->count; i++) {
> +		xt_xlate_add(xl, "%s", i ? "," : "");
> +		print_port_xlate(xl, multiinfo->ports[i],
> +				proto, numeric);
> +	}
> +}
> +
>  static void multiport_print6(const void *ip_void,
>                               const struct xt_entry_match *match, int=
 numeric)
>  {
> @@ -372,6 +398,24 @@ static void multiport_print_v1(const void *ip_vo=
id,
>  	__multiport_print_v1(match, numeric, ip->proto);
>  }
> =20
> +static void multiport_print_v1_xlate(const struct xt_entry_match *ma=
tch,
> +				    struct xt_xlate *xl, uint16_t proto,
> +				    int numeric)
> +{
> +	const struct xt_multiport_v1 *multiinfo =3D
> +		(const struct xt_multiport_v1 *)match->data;
> +	unsigned int i;

Missing line break here to separate variable declaration and function
body.

> +	for (i =3D 0; i < multiinfo->count; i++) {
> +		xt_xlate_add(xl, "%s", i ? "," : "");
> +		print_port_xlate(xl, multiinfo->ports[i], proto, numeric);
> +		if (multiinfo->pflags[i]) {
> +			xt_xlate_add(xl, " - ");
> +			print_port_xlate(xl, multiinfo->ports[++i],
> +					proto, numeric);
> +		}
> +	}
> +}
> +
>  static void multiport_print6_v1(const void *ip_void,
>                                  const struct xt_entry_match *match, =
int numeric)
>  {
> @@ -468,6 +512,157 @@ static void multiport_save6_v1(const void *ip_v=
oid,
>  	__multiport_save_v1(match, ip->proto);
>  }
> =20
> +static int __multiport_xlate(const struct xt_entry_match *match,
> +			    struct xt_xlate *xl, uint16_t protocol, int numeric)
> +{
> +	const struct xt_multiport_v1 *multiinfo =3D
> +		(const struct xt_multiport_v1 *)match->data;
> +	const char *proto_name;
> +	bool have_multiple =3D false, have_invert =3D false ;
                                                       ^
remove this space.

> +
> +	if((proto_name =3D proto_to_name(protocol)) !=3D NULL){
          ^                                               ^

missing space after if.

> +		if (multiinfo->count > 1) have_multiple =3D true;

                if (multiinfo->count > 1)
                        have_multiple =3D true;

Please, review coding style and resubmit. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
