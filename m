From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd RFC PATCH 2/2] ip2str: introduce changable address
 separator
Date: Mon, 31 Mar 2014 22:17:24 +0200
Message-ID: <1396297044.8629.66.camel@tiger2>
References: <20140329042336.GA22821@gmail.com>
	 <20140329042915.GC22821@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-EZuQKEoG90cSthFoScvT"
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:60385 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaCaURs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:17:48 -0400
In-Reply-To: <20140329042915.GC22821@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-EZuQKEoG90cSthFoScvT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Sat, 2014-03-29 at 13:29 +0900, Ken-ichirou MATSUZAWA wrote:
> This patch make change address string separator by "v4sep" or "v6sep" in =
config
> file, because graphite uses `.' as path separator and statsd uses `:' as =
path
> and value separator. Now I am testing ulogd and statsd (actually statsite=
) using
> ulogd config:
>=20
>   stack=3Dct1:NFCT,ip2str1:IP2STR,sprint:SPRINT
>   [ct1]
>   # in event mode, NF_NETLINK_CONNTRACK_DESTROY only
>   event_mask=3D4
>   [ip2str1]
>   v4sep=3D"_"
>   v6sep=3D"_"
>   [sprint]
>   form=3D"myrouter.<orig.ip.daddr.str>.<orig.ip.protocol>.(<icmp.type>|<o=
rig.l4.dport>|unknown).<orig.ip.saddr.str>:<orig.raw.pktlen> + <reply.raw.p=
ktlen>\|kv\n"
>   proto=3D"tcp"
>   dest=3D"8125@192.168.1.1"

I'm not ok with this patch because it induces some tests for all stack
using the ip2str plugin. Furthermore it is making configuration of
ip2str a bit too complex.

I see two possible solutions:
      * You create a plugin dedicated to the conversion of separator in
        IP address. This will lead to add a plugin to your existing
        stack.
      * Your code does know what field it is using as address. So it
        could simply do the translation before creating the message.

BR,

> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  filter/ulogd_filter_IP2STR.c | 74 ++++++++++++++++++++++++++++++++++++++=
++++--
>  1 file changed, 72 insertions(+), 2 deletions(-)
>=20
> diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
> index 732e1ef..774b9cf 100644
> --- a/filter/ulogd_filter_IP2STR.c
> +++ b/filter/ulogd_filter_IP2STR.c
> @@ -137,10 +137,55 @@ static struct ulogd_key ip2str_keys[] =3D {
>  	},
>  };
> =20
> +enum ip2str_conf {
> +	IP2STR_CONF_V6SEP =3D 0,
> +	IP2STR_CONF_V4SEP,
> +	IP2STR_CONF_MAX
> +};
> +
> +static struct config_keyset ip2str_config_kset =3D {
> +	.num_ces =3D 2,
> +	.ces =3D {
> +		[IP2STR_CONF_V6SEP] =3D {
> +			.key =3D "v6sep",
> +			.type =3D CONFIG_TYPE_STRING,
> +			.options =3D CONFIG_OPT_NONE,
> +			.u =3D {.string =3D ":"},
> +		},
> +		[IP2STR_CONF_V4SEP] =3D {
> +			.key =3D "v4sep",
> +			.type =3D CONFIG_TYPE_STRING,
> +			.options =3D CONFIG_OPT_NONE,
> +			.u =3D {.string =3D "."},
> +		},
> +	},
> +};
> +
> +#define v6sep_ce(x)	(x->ces[IP2STR_CONF_V6SEP])
> +#define v4sep_ce(x)	(x->ces[IP2STR_CONF_V4SEP])
> +
>  static char ipstr_array[MAX_KEY-START_KEY][IPADDR_LENGTH];
> =20
> -static int ip2str(struct ulogd_key *inp, int index, int oindex)
> +void change_separator(char family, char *addr, char to)
>  {
> +	char from;
> +	char *cur;
> +
> +	switch(family) {
> +	case AF_INET6: from =3D ':'; break;
> +	case AF_INET: from =3D '.'; break;
> +	default:
> +		ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
> +		return;
> +	}
> +
> +	for (cur =3D strchr(addr, from); cur !=3D NULL; cur =3D strchr(cur + 1,=
 from))
> +		*cur =3D to;
> +}
> +
> +static int ip2str(struct ulogd_pluginstance *upi, int index, int oindex)
> +{
> +	struct ulogd_key *inp =3D upi->input.keys;
>  	char family =3D ikey_get_u8(&inp[KEY_OOB_FAMILY]);
>  	char convfamily =3D family;
> =20
> @@ -173,11 +218,17 @@ static int ip2str(struct ulogd_key *inp, int index,=
 int oindex)
>  		inet_ntop(AF_INET6,
>  			  ikey_get_u128(&inp[index]),
>  			  ipstr_array[oindex], sizeof(ipstr_array[oindex]));
> +		if (*v6sep_ce(upi->config_kset).u.string !=3D ':')
> +			change_separator(convfamily, ipstr_array[oindex],
> +					 *v6sep_ce(upi->config_kset).u.string);
>  		break;
>  	case AF_INET:
>  		ip =3D ikey_get_u32(&inp[index]);
>  		inet_ntop(AF_INET, &ip,
>  			  ipstr_array[oindex], sizeof(ipstr_array[oindex]));
> +		if (*v4sep_ce(upi->config_kset).u.string !=3D '.')
> +			change_separator(convfamily, ipstr_array[oindex],
> +					 *v4sep_ce(upi->config_kset).u.string);
>  		break;
>  	default:
>  		/* TODO error handling */
> @@ -197,7 +248,7 @@ static int interp_ip2str(struct ulogd_pluginstance *p=
i)
>  	/* Iter on all addr fields */
>  	for (i =3D START_KEY; i <=3D MAX_KEY; i++) {
>  		if (pp_is_valid(inp, i)) {
> -			fret =3D ip2str(inp, i, i-START_KEY);
> +			fret =3D ip2str(pi, i, i-START_KEY);
>  			if (fret !=3D ULOGD_IRET_OK)
>  				return fret;
>  			okey_set_ptr(&ret[i-START_KEY],
> @@ -208,6 +259,23 @@ static int interp_ip2str(struct ulogd_pluginstance *=
pi)
>  	return ULOGD_IRET_OK;
>  }
> =20
> +static int configure_ip2str(struct ulogd_pluginstance *upi,
> +			    struct ulogd_pluginstance_stack *stack)
> +{
> +	int ret =3D config_parse_file(upi->id, upi->config_kset);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (strlen(v6sep_ce(upi->config_kset).u.string) > 1)
> +		ulogd_log(ULOGD_NOTICE, "only one char v6 separator is allowed,"
> +			  " using: %c\n", *v6sep_ce(upi->config_kset).u.string);
> +	if (strlen(v4sep_ce(upi->config_kset).u.string) > 1)
> +		ulogd_log(ULOGD_NOTICE, "only one char v4 separator is allowed,"
> +			  " using: %c\n", *v4sep_ce(upi->config_kset).u.string);
> +	return ret;
> +}
> +
>  static struct ulogd_plugin ip2str_pluging =3D {
>  	.name =3D "IP2STR",
>  	.input =3D {
> @@ -220,7 +288,9 @@ static struct ulogd_plugin ip2str_pluging =3D {
>  		.num_keys =3D ARRAY_SIZE(ip2str_keys),
>  		.type =3D ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
>  		},
> +	.config_kset =3D &ip2str_config_kset,
>  	.interp =3D &interp_ip2str,
> +	.configure =3D &configure_ip2str,
>  	.version =3D VERSION,
>  };
> =20

--=20
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

--=-EZuQKEoG90cSthFoScvT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlM5zVQACgkQnxA7CdMWjzKpLQCcDpb1EeOQ3X4481/GUUib4qIQ
dJQAn3RrBkEqXakoG9O6RhNhU6YJ6gJr
=dS/G
-----END PGP SIGNATURE-----

--=-EZuQKEoG90cSthFoScvT--

