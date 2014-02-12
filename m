From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC libnetfilter_log][PATCH] configure: add --without-ipulog
 option to disable libipulog build
Date: Wed, 12 Feb 2014 23:53:38 +0100
Message-ID: <20140212225337.GA6744@localhost>
References: <1391606337-8706-1-git-send-email-Matthieu.Crapet@ingenico.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Matthieu Crapet <Matthieu.Crapet@ingenico.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49763 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbaBLWxt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:53:49 -0500
Content-Disposition: inline
In-Reply-To: <1391606337-8706-1-git-send-email-Matthieu.Crapet@ingenico.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 02:18:57PM +0100, Matthieu Crapet wrote:
> This is a compat library used for netfilter ULOG target.
> ULOG only works with IPv4. NFLOG has replaced ULOG.

Applied minor glitch, thanks.

> Signed-off-by: Matthieu Crapet <Matthieu.Crapet@ingenico.com>
> ---
>  configure.ac                         |    5 +++++
>  include/libnetfilter_log/Makefile.am |    4 ++++
>  src/Makefile.am                      |    6 +++++-
>  utils/Makefile.am                    |    7 +++++--
>  4 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index fe6e75f..01f6890 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -23,6 +23,11 @@ case "$host" in
>  *) AC_MSG_ERROR([Linux only, dude!]);;
>  esac
>  
> +AC_ARG_WITH([ipulog],
> +  AC_HELP_STRING([--without-ipulog], [don't build libipulog compat library]),
> +  [ipulog_skip=1], [ipulog_skip=0])
> +AM_CONDITIONAL([BUILD_IPULOG], [test $ipulog_skip = 0])
> +
>  dnl Dependencies
>  PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
>  
> diff --git a/include/libnetfilter_log/Makefile.am b/include/libnetfilter_log/Makefile.am
> index fe934f1..0305357 100644
> --- a/include/libnetfilter_log/Makefile.am
> +++ b/include/libnetfilter_log/Makefile.am
> @@ -1,3 +1,7 @@
>  
> +if BUILD_IPULOG
>  pkginclude_HEADERS = libnetfilter_log.h libipulog.h linux_nfnetlink_log.h
> +else
> +pkginclude_HEADERS = libnetfilter_log.h linux_nfnetlink_log.h
> +endif

Just to avoid redundancy:

@@ -1,3 +1,6 @@
 
-pkginclude_HEADERS = libnetfilter_log.h libipulog.h
linux_nfnetlink_log.h
+pkginclude_HEADERS = libnetfilter_log.h linux_nfnetlink_log.h
 
+if BUILD_IPULOG
+pkginclude_HEADERS += libipulog.h
+endif
