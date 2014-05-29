From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] ulogd2: Add Redis server instance as output target
Date: Thu, 29 May 2014 18:53:41 +0200
Message-ID: <1401382421.20014.14.camel@ice-age2.regit.org>
References: <CAC-pqZOat5TTjkEa1iC_XXUmSP3VpQm8Yp0TGfh1wbCARUkZ6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RA6hIdFhIoueCJP6tgxF"
Cc: netfilter-devel@vger.kernel.org, regit@netfilter.org
To: Jason Hensley <jhensley@subfx.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:41030 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaE2RYS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 13:24:18 -0400
In-Reply-To: <CAC-pqZOat5TTjkEa1iC_XXUmSP3VpQm8Yp0TGfh1wbCARUkZ6g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-RA6hIdFhIoueCJP6tgxF
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

That's a really interesting work. I've tried to save the mail and apply
it to latest  git master but it is failing:

$ git am /tmp/ulogd.mbox
Applying: ulogd2: Add Redis server instance as output target
fatal: corrupt patch at line 10
Patch failed at 0001 ulogd2: Add Redis server instance as output target

Did you generate the patch using git format-patch ? If not can you
resend a fixed version (some comments below).

Side not on this: do not prefix the patch text by ulogd2 but instead do:
[PATCH ulogd2] YOUR TEXT HERE

Please find some comments on your work inline.

On Thu, 2014-05-29 at 12:00 -0400, Jason Hensley wrote:
> Adds a Redis server instance as an output target for ulogd2,  Requires
> the hiredis library >=3D 0.10.
>=20
>=20
> Exposes the following configuration options:
>=20
>=20
> host=3D"127.0.0.1"
>=20
> port=3D6379
> sockpath=3D
> passwd=3D
> expire=3D
> exclude=3D
> pipeline=3D10
> keyformat=3D{{ip.saddr}}-{{ip.daddr}}

What is this ? I'm not familiar with redis and I don't get the usage of
this.

Regarding the commit messages, some more information about usage and
objective of the plugin would really be appreciated.

Regarding documentation, you should also describe how to use your plugin
by providing a commented example in ulogd.conf.in. This should at least
contain a working stach and a commented example of your plugin
configuration.

>=20
> Signed-off-by: Jason Hensley <jhensley@subfx.net>
> --------------------------------
> diff --git a/configure.ac b/configure.ac
> index 522c345..b1af14f 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -128,6 +128,18 @@ else
>   enable_jansson=3D"no"
>  fi
> =20
> +AC_ARG_WITH([redis], AS_HELP_STRING([--without-redis], [Build without
> REDIS output plugin [default=3Dtest]]))
> +AS_IF([test "x$with_redis" !=3D "xno"], [
> + AC_SEARCH_LIBS([redisConnectWithTimeout], [hiredis],
> [libhiredis_LIBS=3D"-lhiredis"; LIBS=3D""])
> + AC_SUBST([libhiredis_LIBS])
> +])
> +AM_CONDITIONAL([HAVE_HIREDIS], [test -n "$libhiredis_LIBS"])
> +if test "x$libhiredis_LIBS" !=3D "x"; then
> + enable_redis=3D"yes"
> +else
> + enable_redis=3D"no"
> +fi

You mention your code need libhiredis > 0.10 but I don't see any
explicit code on that. Is this linked to the detection of
redisConnectWithTimeout function ?

> +
>  dnl AC_SUBST(DATABASE_DIR)
>  dnl AC_SUBST(DATABASE_LIB)
>  dnl AC_SUBST(DATABASE_LIB_DIR)
> @@ -164,5 +176,6 @@ Ulogd configuration:
>      SQLITE3 plugin: ${enable_sqlite3}
>      DBI plugin: ${enable_dbi}
>      JSON plugin: ${enable_jansson}
> +    REDIS plugin: ${enable_redis}
>  "
>  echo "You can now run 'make' and 'make install'"
> diff --git a/output/Makefile.am b/output/Makefile.am
> index ff851ad..760fa35 100644
> --- a/output/Makefile.am
> +++ b/output/Makefile.am
> @@ -13,6 +13,10 @@ if HAVE_JANSSON
>  pkglib_LTLIBRARIES +=3D ulogd_output_JSON.la
>  endif
> =20
> +if HAVE_HIREDIS
> +pkglib_LTLIBRARIES +=3D ulogd_output_REDIS.la
> +endif
> +
>  ulogd_output_GPRINT_la_SOURCES =3D ulogd_output_GPRINT.c
>  ulogd_output_GPRINT_la_LDFLAGS =3D -avoid-version -module
> =20
> @@ -42,3 +46,9 @@ ulogd_output_JSON_la_SOURCES =3D ulogd_output_JSON.c
>  ulogd_output_JSON_la_LIBADD  =3D ${libjansson_LIBS}
>  ulogd_output_JSON_la_LDFLAGS =3D -avoid-version -module
>  endif
> +
> +if HAVE_HIREDIS
> +ulogd_output_REDIS_la_SOURCES =3D ulogd_output_REDIS.c
> +ulogd_output_REDIS_la_LIBADD  =3D ${libhiredis_LIBS}
> +ulogd_output_REDIS_la_LDFLAGS =3D -avoid-version -module
> +endif
> diff --git a/output/ulogd_output_REDIS.c b/output/ulogd_output_REDIS.c
> new file mode 100644
> index 0000000..9c90d37
> --- /dev/null
> +++ b/output/ulogd_output_REDIS.c
> @@ -0,0 +1,572 @@
> +/**
> + * ulogd_output_REDIS.c
> + *
> + * ulogd output target to feed data to a Redis database.
> + *
> + * (C) 2014 Jason Hensley <jhensley at subfx.net>
> + *
> + *  This program is free software; you can redistribute it and/or
> modify
> + *  it under the terms of the GNU General Public License version 2
> + *  as published by the Free Software Foundation
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
>  02111-1307  USA
> + *
> + */
> +#include <ctype.h>
> +#include <ulogd/ulogd.h>
> +#include <ulogd/common.h>
> +#include <hiredis/hiredis.h>
> +
> +#define ULOGD_REDIS_MAX_DATA_SIZE 128
> +#define ULOGD_REDIS_MAX_HASH_ENTRIES 128
> +#define ULOGD_REDIS_MAX_MACRO_FIELDS 8
> +
> +#define ULOGD_REDIS_DEFAULT_HOST "127.0.0.1"
> +#define ULOGD_REDIS_DEFAULT_PORT 6379
> +#define ULOGD_REDIS_DEFAULT_DB 1
> +
> +#define ULOGD_REDIS_MACRO_OPEN  "{{"
> +#define ULOGD_REDIS_MACRO_CLOSE "}}"
> +
> +#define ULOGD_REDIS_DEFAULT_KEYFORMAT
> "{{ip.saddr}}|{{ip.daddr}}|{{oob.time.sec}}.{{oob.time.usec}}"
> +#define NIPQUAD(addr)          \
> + ((unsigned char *)&addr)[0], \
> + ((unsigned char *)&addr)[1], \
> + ((unsigned char *)&addr)[2], \
> + ((unsigned char *)&addr)[3]
> +
> +static struct config_keyset redis_cfg_kset =3D {
> + .num_ces =3D 9,
> + .ces =3D {
> + {

The formatting of the code is not correct here. We use Linux kernel
coding style inside ulogd. See
https://www.kernel.org/doc/Documentation/CodingStyle

Please fix the indentation in the file before resubmitting.

> + .key =3D "host",
> + .type =3D CONFIG_TYPE_STRING,
> + .options =3D CONFIG_OPT_NONE,
> + .u =3D { .string =3D ULOGD_REDIS_DEFAULT_HOST },
> + },
> + {
> + .key =3D "port",
> + .type =3D CONFIG_TYPE_INT,
> + .options =3D CONFIG_OPT_NONE,
> + .u =3D { .value =3D ULOGD_REDIS_DEFAULT_PORT },
> + },
> + {
> + .key =3D "sockpath",
> + .type =3D CONFIG_TYPE_STRING,
> + .options =3D CONFIG_OPT_NONE,
> + },
> + {
> + .key =3D "db",
> + .type =3D CONFIG_TYPE_INT,
> + .options =3D CONFIG_OPT_NONE,
> + .u =3D { .value =3D ULOGD_REDIS_DEFAULT_DB },
> + },
> + {
> + .key =3D "passwd",
> + .type =3D CONFIG_TYPE_STRING,
> + .options =3D CONFIG_OPT_NONE,
> + },
> + {
> + .key =3D "expire",
> + .type =3D CONFIG_TYPE_INT,
> + .options =3D CONFIG_OPT_NONE,
> + .u =3D { .value =3D 0 },
> + },
> + {
> + .key =3D "keyformat",
> + .type =3D CONFIG_TYPE_STRING,
> + .options =3D CONFIG_OPT_NONE,
> + .u =3D { .string =3D ULOGD_REDIS_DEFAULT_KEYFORMAT },
> + },
> + {
> + .key =3D "pipeline",
> + .type =3D CONFIG_TYPE_INT,
> + .options =3D CONFIG_OPT_NONE,
> + .u =3D { .value =3D 0 },
> + },
> + {
> + .key =3D "exclude",
> + .type =3D CONFIG_TYPE_STRING,
> + .options =3D CONFIG_OPT_NONE,
> + },
> + },
> +};
> +
> +#define redis_host_ce(x)     (x->config_kset->ces[0])
> +#define redis_port_ce(x)     (x->config_kset->ces[1])
> +#define redis_sock_ce(x)     (x->config_kset->ces[2])
> +#define redis_db_ce(x)     (x->config_kset->ces[3])
> +#define redis_passwd_ce(x)   (x->config_kset->ces[4])
> +#define redis_expire_ce(x)  (x->config_kset->ces[5])
> +#define redis_keyfmt_ce(x)   (x->config_kset->ces[6])
> +#define redis_pipeline_ce(x) (x->config_kset->ces[7])
> +#define redis_exclude_ce(x)  (x->config_kset->ces[8])
> +
> +struct macro_field {
> + char field[ULOGD_MAX_KEYLEN];
> + char macro[ULOGD_MAX_KEYLEN+4];
> +};
> +
> +struct redis_cmd {
> + char *argv[ULOGD_REDIS_MAX_HASH_ENTRIES];
> + size_t argvlen[ULOGD_REDIS_MAX_HASH_ENTRIES];
> + int argc;
> +};
> +
> +struct redis_ctx {
> + redisContext *c;
> + u_int16_t pipelined;
> + int bufavail;
> + char keybuf[ULOGD_REDIS_MAX_DATA_SIZE];
> + char *excludes_buf;
> + char **excludes;
> + struct redis_cmd cmd;
> + struct macro_field macros[ULOGD_REDIS_MAX_MACRO_FIELDS];
> +};
> +
> +static int connect_redis(struct ulogd_pluginstance *upi)
> +{
> + char *host =3D NULL;
> + char *sockpath =3D NULL;
> + char *passwd =3D NULL;
> + int db;
> + int port;
> + struct timeval tv;
> + redisReply *reply;
> + struct redis_ctx *ctx =3D (struct redis_ctx *)upi->private;
> +
> + host =3D redis_host_ce(upi).u.string;
> + passwd =3D (strlen(redis_passwd_ce(upi).u.string)) ?
> redis_passwd_ce(upi).u.string : NULL;
> + sockpath =3D (strlen(redis_sock_ce(upi).u.string)) ?
> redis_sock_ce(upi).u.string   : NULL;
> + port =3D redis_port_ce(upi).u.value;
> + db =3D redis_db_ce(upi).u.value;
> +
> + tv.tv_sec  =3D 1;
> + tv.tv_usec =3D 5000;
> +
> + if (sockpath) {
> + ulogd_log(ULOGD_DEBUG, "Connecting to Redis via UNIX socket at: %s
> \n", sockpath);
> + ctx->c =3D redisConnectUnixWithTimeout(sockpath, tv);
> + } else {
> + ulogd_log(ULOGD_DEBUG, "Connecting to Redis via TCP at: %s:%d\n",
> host, port);
> + ctx->c =3D redisConnectWithTimeout(host, port, tv);
> + //redisEnableKeepAlive(ctx->c);

Commented code is not needed. Please remove this.

As said before, this work is really interesting but the reading of the
code is painful due to the formatting. So I stop my review here.

Can you address the few comments and resubmit?

I will be happy to accept this plugin once everything is fixed.

Best Regards,
--=20
Eric Leblond <eric@regit.org>

--=-RA6hIdFhIoueCJP6tgxF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iD8DBQBTh2YYnxA7CdMWjzIRAsiRAJoC2xHBLh3CJu8dxD90XZFP0fdVewCeJjO+
RbiL3sdljG11gJjEwu3SfS4=
=nm4R
-----END PGP SIGNATURE-----

--=-RA6hIdFhIoueCJP6tgxF--

