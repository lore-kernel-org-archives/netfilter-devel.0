From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] configure.ac: Add --without-{mysql,pgsql}
Date: Fri, 15 May 2015 23:44:48 +0200
Message-ID: <1431726288.29730.28.camel@regit.org>
References: <1430663032-12704-1-git-send-email-laforge@gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:57689 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946207AbbEOVo7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 17:44:59 -0400
In-Reply-To: <1430663032-12704-1-git-send-email-laforge@gnumonks.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Harald,

Thanks for the patch! I've just pushed it to the master branch.

BR,
--
Eric

On Sun, 2015-05-03 at 16:23 +0200, Harald Welte wrote:
> In some cases you may not want to build a certain output plugin, even
> if the headers/libraries actually exist on the build host.
> ---
>  configure.ac | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index c814bec..1a7f8de 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -85,7 +85,10 @@ if [! test "x$enable_nfacct" = "xyes"]; then
>  	enable_nfacct="no"
>  fi
>  
> -CT_CHECK_POSTGRES_DB()
> +AC_ARG_WITH([pgsql], AS_HELP_STRING([--without-pgsql], [Build without postgresql output plugin [default=test]]))
> +AS_IF([test "x$with_pgsql" != "xno"], [
> +	CT_CHECK_POSTGRES_DB()
> +])
>  AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
>  if test "x$PQLIBPATH" != "x"; then
>  	enable_pgsql="yes"
> @@ -93,7 +96,10 @@ else
>  	enable_pgsql="no"
>  fi
>  
> -CT_CHECK_MYSQL_DB()
> +AC_ARG_WITH([mysql], AS_HELP_STRING([--without-mysql], [Build without mysql output plugin [default=test]]))
> +AS_IF([test "x$with_mysql" != "xno"], [
> +	CT_CHECK_MYSQL_DB()
> +])
>  AM_CONDITIONAL(HAVE_MYSQL, test "x$MYSQL_LIB" != "x")
>  if test "x$MYSQL_LIB" != "x"; then
>  	enable_mysql="yes"
> @@ -101,6 +107,7 @@ else
>  	enable_mysql="no"
>  fi
>  
> +
>  AC_ARG_WITH([sqlite], AS_HELP_STRING([--without-sqlite], [Build without SQLITE3 output plugin [default=test]]))
>  AS_IF([test "x$with_sqlite" != "xno"], [
>      PKG_CHECK_MODULES([libsqlite3], [sqlite3], [], [:])

-- 
Eric Leblond <eric@regit.org>

