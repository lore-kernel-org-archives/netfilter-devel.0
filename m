From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] ulogd: fix cross compilation errors with mysql_config
Date: Thu, 31 Mar 2016 08:52:56 +0200
Message-ID: <1459407176.13447.14.camel@regit.org>
References: <1458312204-2874-1-git-send-email-helmut.schaa@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:37952 "EHLO home.regit.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbcCaH2v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Mar 2016 03:28:51 -0400
In-Reply-To: <1458312204-2874-1-git-send-email-helmut.schaa@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Helmut,

On Fri, 2016-03-18 at 15:43 +0100, Helmut Schaa wrote:
> When cross-compiling ulogd, mysql_config and pg_config will return
> build host
> configuration not build target configuration. This leads to build
> failures
> if mysql_config is installed on the host system but mysql is not
> available
> on the build target.
>=20
> Fix this by not using mysql_config and pg_config for cross-
> compilation.

Applied, thanks!

BR,

> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> =A0acinclude.m4 | 4 ++--
> =A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/acinclude.m4 b/acinclude.m4
> index 56d47b8..bd21255 100644
> --- a/acinclude.m4
> +++ b/acinclude.m4
> @@ -35,7 +35,7 @@ if test "$pg_prefix" !=3D "no"; then
> =A0AC_MSG_CHECKING([for PostgreSQL pg_config program])
> =A0for d in $pg_prefix/bin /usr/bin /usr/local/bin /usr/local/pgsql/b=
in
> /opt/pgsql/bin /opt/packages/pgsql/bin
> =A0do
> -	if test -x $d/pg_config
> +	if test -x $d/pg_config -a "$cross_compiling" =3D "no";
> =A0	then
> =A0		AC_MSG_RESULT(found pg_config in $d)
> =A0		PQINCPATH=3D`$d/pg_config --includedir`
> @@ -130,7 +130,7 @@ if test "$my_prefix" !=3D "no"; then
> =A0AC_MSG_CHECKING([for MySQL mysql_config program])
> =A0for d in $my_prefix/bin /usr/bin /usr/local/bin /usr/local/mysql/b=
in
> /opt/mysql/bin /opt/packages/mysql/bin
> =A0do
> -	if test -x $d/mysql_config
> +	if test -x $d/mysql_config -a "$cross_compiling" =3D "no";
> =A0	then
> =A0		AC_MSG_RESULT(found mysql_config in $d)
> =A0		MYSQL_INC=3D`$d/mysql_config --include`
--=20
Eric Leblond <eric@regit.org>


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
