From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] sqlite3: Remove unused "buffer" option.
Date: Wed, 13 Jan 2016 09:12:26 -0500
Message-ID: <1452694346.11918.3.camel@regit.org>
References: <1451667942-30746-1-git-send-email-alex_y_xu@yahoo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: Alex Xu <alex_y_xu@yahoo.ca>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:38781 "EHLO home.regit.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbcAMOMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 09:12:33 -0500
In-Reply-To: <1451667942-30746-1-git-send-email-alex_y_xu@yahoo.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Good for me but I will need a=C2=A0Signed-off-by line in your patch to =
be
able to push it.

Thanks for this work.
--
Eric

On Fri, 2016-01-01 at 12:05 -0500, Alex Xu wrote:
> ---
> =C2=A0doc/ulogd.sgml=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 --
> =C2=A0output/sqlite3/ulogd_output_SQLITE3.c | 17 +----------------
> =C2=A0ulogd.conf.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 --
> =C2=A03 files changed, 1 insertion(+), 20 deletions(-)
>=20
> diff --git a/doc/ulogd.sgml b/doc/ulogd.sgml
> index 30bfecb..65a63cf 100644
> --- a/doc/ulogd.sgml
> +++ b/doc/ulogd.sgml
> @@ -603,8 +603,6 @@ The module defines the following configuration
> directives:
> =C2=A0Name of the table to which ulogd should log.
> =C2=A0<tag>db</tag>
> =C2=A0Name of the database.
> -<tag>buffer</tag>
> -Size of the sqlite buffer.
> =C2=A0</descrip>
> =C2=A0</sect2>
> =C2=A0
> diff --git a/output/sqlite3/ulogd_output_SQLITE3.c
> b/output/sqlite3/ulogd_output_SQLITE3.c
> index 5c49055..20ceb3b 100644
> --- a/output/sqlite3/ulogd_output_SQLITE3.c
> +++ b/output/sqlite3/ulogd_output_SQLITE3.c
> @@ -63,8 +63,6 @@ struct sqlite3_priv {
> =C2=A0	struct field_lh fields;
> =C2=A0	char *stmt;
> =C2=A0	sqlite3_stmt *p_stmt;
> -	int buffer_size;
> -	int buffer_curr;
> =C2=A0	struct {
> =C2=A0		unsigned err_tbl_busy;	/* "Table busy" */
> =C2=A0	} stats;
> @@ -83,18 +81,11 @@ static struct config_keyset sqlite3_kset =3D {
> =C2=A0			.type =3D CONFIG_TYPE_STRING,
> =C2=A0			.options =3D CONFIG_OPT_MANDATORY,
> =C2=A0		},
> -		{
> -			.key =3D "buffer",
> -			.type =3D CONFIG_TYPE_INT,
> -			.options =3D CONFIG_OPT_NONE,
> -			.u.value =3D CFG_BUFFER_DEFAULT,
> -		},
> =C2=A0	},
> =C2=A0};
> =C2=A0
> =C2=A0#define db_ce(pi)		(pi)->config_kset->ces[0].u.string
> =C2=A0#define table_ce(pi)	(pi)->config_kset->ces[1].u.string
> -#define buffer_ce(pi)	(pi)->config_kset->ces[2].u.value
> =C2=A0
> =C2=A0/* forward declarations */
> =C2=A0static int sqlite3_createstmt(struct ulogd_pluginstance *);
> @@ -107,9 +98,7 @@ add_row(struct ulogd_pluginstance *pi)
> =C2=A0	int ret;
> =C2=A0
> =C2=A0	ret =3D sqlite3_step(priv->p_stmt);
> -	if (ret =3D=3D SQLITE_DONE)
> -		priv->buffer_curr++;
> -	else if (ret =3D=3D SQLITE_BUSY)
> +	if (ret =3D=3D SQLITE_BUSY)
> =C2=A0		priv->stats.err_tbl_busy++;
> =C2=A0	else if (ret =3D=3D SQLITE_ERROR) {
> =C2=A0		ret =3D sqlite3_finalize(priv->p_stmt);
> @@ -404,10 +393,6 @@ sqlite3_start(struct ulogd_pluginstance *pi)
> =C2=A0		return -1;
> =C2=A0	}
> =C2=A0
> -	/* initialize our buffer size and counter */
> -	priv->buffer_size =3D buffer_ce(pi);
> -	priv->buffer_curr =3D 0;
> -
> =C2=A0	/* create and prepare the actual insert statement */
> =C2=A0	sqlite3_createstmt(pi);
> =C2=A0
> diff --git a/ulogd.conf.in b/ulogd.conf.in
> index 9624a4b..2fcf39a 100644
> --- a/ulogd.conf.in
> +++ b/ulogd.conf.in
> @@ -301,12 +301,10 @@ procedure=3D"INSERT_PACKET_FULL"
> =C2=A0[sqlite3_ct]
> =C2=A0table=3D"ulog_ct"
> =C2=A0db=3D"/var/log/ulogd.sqlite3db"
> -buffer=3D200
> =C2=A0
> =C2=A0[sqlite3_pkt]
> =C2=A0table=3D"ulog_pkt"
> =C2=A0db=3D"/var/log/ulogd.sqlite3db"
> -buffer=3D200
> =C2=A0
> =C2=A0[sys2]
> =C2=A0facility=3DLOG_LOCAL2
--=20
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
