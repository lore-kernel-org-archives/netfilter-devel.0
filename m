From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] pgsql: add SSL connection implementation to PGSQL plugin
Date: Sun, 02 Sep 2012 17:49:54 +0200
Message-ID: <1346600994.5194.27.camel@tiger.regit.org>
References: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-wRE3TIiXvn4pRp8leX+f"
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39640 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2IBPvU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Sep 2012 11:51:20 -0400
In-Reply-To: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-wRE3TIiXvn4pRp8leX+f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Please find my review inline.

Le samedi 01 septembre 2012 =C3=A0 13:51 +0100, Mr Dash Four a =C3=A9crit :
> This patch fixes a NULL pointer reference bug which existed in the
> PGSQL output plugin, as well as enables SSL connections to be made
> to PostgreSQL server by the ulog daemon. Parameters introduced are:
>=20
> 'sslmode' - one of:
>=20
...
>  'sslkey' - This parameter specifies the location for the secret key used
> 	    for the client certificate. It can either specify a file name that
> 	    will be used or it can specify a key obtained from an external
> 	    =E2=80=9Cengine=E2=80=9D (engines are OpenSSL loadable modules). An =
external
> 	    engine specification should consist of a colon-separated engine
> 	    name and an engine-specific key identifier. This parameter is
> 	    ignored if SSL connection is not made. If this key is protected
> 	    with a password, this will be asked when the connection is made.
> 	    It is asked every time an attempt for a connection is made.

Entering key for each new connection, you've find a new business for low
profile admin ;)

> 'sslroot' - This parameter specifies the name of a file containing SSL
> 	    certificate authority (CA) certificate(s). If the file exists,
> 	    the server's certificate will be verified to be signed by one of
> 	    these authorities.
>  'sslcrl' - This parameter specifies the file name of the SSL certificate
> 	    revocation list (CRL). Certificates listed in this file, if it
> 	    exists, will be rejected while attempting to authenticate the
> 	    server's certificate.

I don't see here the 'sslca' parameter: how ulogd does to verify
database certificate if it does not know which CA certs to use ?

> Example of use:

...

> SQL.c
> @@ -38,7 +38,7 @@ struct pgsql_instance {
> =20
>  /* our configuration directives */
>  static struct config_keyset pgsql_kset =3D {
> -	.num_ces =3D DB_CE_NUM + 6,
> +	.num_ces =3D DB_CE_NUM + 11,
>  	.ces =3D {
>  		DB_CES,
>  		{=20
> @@ -70,8 +70,32 @@ static struct config_keyset pgsql_kset =3D {
>  			.key =3D "schema",=20
>  			.type =3D CONFIG_TYPE_STRING,
>  			.options =3D CONFIG_OPT_NONE,
> -			.u.string =3D "public",

I don't see why this default value has been removed. Is this linked with
current feature ?

>  		},
> +		{  // sslmode=3Ddisable|allow|prefer|require|requiressl|verify-ca|veri=
fy-full
> +			.key =3D "sslmode",=20
> +			.type =3D CONFIG_TYPE_STRING,
> +			.options =3D CONFIG_OPT_NONE,
> +		},

No default value here. From code below, I understand that we will not
pass any SSL-related parameter in PGSQL connection chain if there is no
value.
What is the difference with using "disable" as default ?

> +		{
> +			.key =3D "sslcert",=20
> +			.type =3D CONFIG_TYPE_STRING,
> +			.options =3D CONFIG_OPT_NONE,
> +		},
> +		{
...
>  	ulogd_log(ULOGD_DEBUG, "%s\n", pgbuf);
> @@ -217,23 +249,39 @@ static int open_db_pgsql(struct ulogd_pluginstance =
*upi)
>  {
>  	struct pgsql_instance *pi =3D (struct pgsql_instance *) upi->private;
>  	int len;
> +	int status;
>  	char *connstr;
>  	char *server =3D host_ce(upi->config_kset).u.string;
>  	unsigned int port =3D port_ce(upi->config_kset).u.value;
>  	char *user =3D user_ce(upi->config_kset).u.string;
>  	char *pass =3D pass_ce(upi->config_kset).u.string;
>  	char *db =3D db_ce(upi->config_kset).u.string;
> +	char *sslmode =3D sslmode_ce(upi->config_kset).u.string;=09
> +	char *sslcert =3D sslcert_ce(upi->config_kset).u.string;=09
> +	char *sslkey =3D sslkey_ce(upi->config_kset).u.string;=09
> +	char *sslroot =3D sslroot_ce(upi->config_kset).u.string;=09
> +	char *sslcrl =3D sslcrl_ce(upi->config_kset).u.string;=09
> =20
>  	/* 80 is more than what we need for the fixed parts below */
>  	len =3D 80 + strlen(user) + strlen(db);
> =20
> -	/* hostname and  and password are the only optionals */
> +	/* hostname and password are not the only optional parameters */
>  	if (server)
>  		len +=3D strlen(server);
>  	if (pass)
>  		len +=3D strlen(pass);
>  	if (port)
>  		len +=3D 20;
> +	if (sslmode)
> +		len +=3D strlen(sslmode);
> +	if (sslcert)
> +		len +=3D strlen(sslcert);
> +	if (sslkey)
> +		len +=3D strlen(sslkey);
> +	if (sslroot)
> +		len +=3D strlen(sslroot);
> +	if (sslcrl)
> +		len +=3D strlen(sslcrl);

OK, we need to increase the length of the connection string and thus
this code is needed.
But, I don't see the length for the prefix use in the connection string.
For example we have below:
	strcat(connstr, " sslmode=3D");
	strcat(connstr, sslmode);
Am I missing something ?

>  	connstr =3D (char *) malloc(len);
>  	if (!connstr)=20
> @@ -261,10 +309,37 @@ static int open_db_pgsql(struct ulogd_pluginstance =
*upi)
>  		strcat(connstr, pass);
>  	}
>  =09
> +	if (sslmode && strlen(sslmode) > 0) {
> +		if (strncmp(sslmode, "requiressl", 10) =3D=3D 0) {
> +			strcat(connstr, " requiressl=3D1");

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-wRE3TIiXvn4pRp8leX+f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBDgCIACgkQnxA7CdMWjzInpwCfbjsNCuZmfRk4OI6zYX7mv5kh
0PkAn3fNeHEw/n/lh+isl1i4nMMxeDGu
=BCMQ
-----END PGP SIGNATURE-----

--=-wRE3TIiXvn4pRp8leX+f--

