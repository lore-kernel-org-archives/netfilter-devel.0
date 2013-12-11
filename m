From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH ulogd] ulogd: use AC_SEARCH_LIBS for libpthread
Date: Wed, 11 Dec 2013 01:46:10 +0100
Message-ID: <1386722770.4710.3.camel@ice-age2.regit.org>
References: <1386678252-6853-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45377 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3LKAqO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:46:14 -0500
In-Reply-To: <1386678252-6853-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
On Tue, 2013-12-10 at 09:24 -0300, Gustavo Zacarias wrote:
> Some uClibc-based toolchains lack threading support, so use
> AC_SEARCH_LIB instead of AC_CHECK_LIB to check for libpthread
> availability and link conditionally if found since it's only used for
> the database backends.

Is there some need for this type of systems to have access to the
database backends ? In this case, it will be interesting to make
conditional the build of the new thread running mode.

BR,

> 
> Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
> ---
>  configure.ac    | 3 ++-
>  src/Makefile.am | 4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 7f5ffa9..5e45aaa 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -39,7 +39,8 @@ AC_CHECK_FUNCS(socket strerror)
>  regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter"
>  AC_SUBST([regular_CFLAGS])
>  
> -AC_CHECK_LIB(pthread, pthread_create)
> +AC_SEARCH_LIBS([pthread_create], [pthread], [libpthread_LIBS="$LIBS"; LIBS=""])
> +AC_SUBST([libpthread_LIBS])
>  
>  dnl Check for the right nfnetlink version
>  PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 1097468..998e776 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -7,5 +7,5 @@ AM_CFLAGS = ${regular_CFLAGS}
>  sbin_PROGRAMS = ulogd
>  
>  ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c addr.c
> -ulogd_LDADD   = ${libdl_LIBS}
> -ulogd_LDFLAGS = -export-dynamic -lpthread
> +ulogd_LDADD   = ${libdl_LIBS} ${libpthread_LIBS}
> +ulogd_LDFLAGS = -export-dynamic

-- 
Eric Leblond <eric@regit.org>

