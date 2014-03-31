From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd RFC PATCH 1/2] sprint: introduce new output plugin
Date: Mon, 31 Mar 2014 23:06:44 +0200
Message-ID: <1396300004.8629.80.camel@tiger2>
References: <20140329042336.GA22821@gmail.com>
	 <20140329042716.GB22821@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:60767 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaCaVHG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:07:06 -0400
In-Reply-To: <20140329042716.GB22821@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Some comments on the form below. I will review later code if needed.

On Sat, 2014-03-29 at 13:27 +0900, Ken-ichirou MATSUZAWA wrote:
> This patch introduces a new string output plugin. The output string can be
> specified by "form" in config file. Format is consists of:
> 
>     key: struct ulogd_key name enclosed by <>, e.g. <orig.ip.saddr.str>
>     group: enclosed by () and separated by |, pick first one if exists.
>         (<orig.l4.dport>|<icmp.type>|unknown) means
>         pick orig.l4.dport value if exist, or icmp.type value. if both
>         of them do not exist, select "unknown" string.
>     +: add two key value if it can be
>     anything else: as is
> 
> meta character <>()|+\ needs to be escaped by \. Sink can be specified by
> "proto" and "dest" in config file. "proto" is either file, tcp and udp.
> "dest" is file name if "proto" is file, or port@address in tcp or udp.

I'm not ok with address format. Is it used in some other project ? It
would seem more natural to use a URI like syntax: tcp://address:port.

> More patch is needed to work, I think this will be suited for graphite and
> statsd to see whole of traffic.
> 
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  configure.ac                                |  15 +-
>  output/Makefile.am                          |   2 +-
>  output/sprint/Makefile.am                   |  21 ++
>  output/sprint/ulogd_output_SPRINT-parser.y  | 358 ++++++++++++++++++++
>  output/sprint/ulogd_output_SPRINT-scanner.l | 112 +++++++
>  output/sprint/ulogd_output_SPRINT.c         | 495 ++++++++++++++++++++++++++++
>  output/sprint/ulogd_output_SPRINT.h         |  45 +++
>  7 files changed, 1046 insertions(+), 2 deletions(-)
>  create mode 100644 output/sprint/Makefile.am
>  create mode 100644 output/sprint/ulogd_output_SPRINT-parser.y
>  create mode 100644 output/sprint/ulogd_output_SPRINT-scanner.l
>  create mode 100644 output/sprint/ulogd_output_SPRINT.c
>  create mode 100644 output/sprint/ulogd_output_SPRINT.h
> 
> diff --git a/configure.ac b/configure.ac
> index 544a256..8ab2b27 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -14,6 +14,8 @@ dnl Checks for programs.
>  AC_PROG_MAKE_SET
>  AC_PROG_CC
>  AC_PROG_INSTALL
> +AC_PROG_YACC
> +AC_PROG_LEX
>  AC_DISABLE_STATIC
>  AC_PROG_LIBTOOL
>  
> @@ -128,6 +130,16 @@ else
>  	enable_jansson="no"
>  fi
>  
> +AC_ARG_WITH([sprint], AS_HELP_STRING([--without-sprint], [Build without SPRINT output plugin [default=test]]))
> +AS_IF([test "x$with_sprint" != "xno"], [
> +if test "x$LEX" = "xflex" -a "x$YACC" = "xbison -y"; then
> +	enable_sprint="yes"
> +else
> +	enable_sprint="no"
> +fi
> +])
> +AM_CONDITIONAL([BUILD_SPRINT], [test "x$enable_sprint" = "xyes"])
> +
>  dnl AC_SUBST(DATABASE_DIR)
>  dnl AC_SUBST(DATABASE_LIB)
>  dnl AC_SUBST(DATABASE_LIB_DIR)
> @@ -147,7 +159,7 @@ AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefi
>  	  input/sum/Makefile \
>  	  filter/Makefile filter/raw2packet/Makefile filter/packet2flow/Makefile \
>  	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
> -	  output/dbi/Makefile \
> +	  output/dbi/Makefile output/sprint/Makefile \
>  	  src/Makefile Makefile Rules.make)
>  AC_OUTPUT
>  
> @@ -164,5 +176,6 @@ Ulogd configuration:
>      SQLITE3 plugin:			${enable_sqlite3}
>      DBI plugin:				${enable_dbi}
>      JSON plugin:			${enable_jansson}
> +    SPRINT plugin:			${enable_sprint}
>  "
>  echo "You can now run 'make' and 'make install'"
> diff --git a/output/Makefile.am b/output/Makefile.am
> index ff851ad..7a39150 100644
> --- a/output/Makefile.am
> +++ b/output/Makefile.am
> @@ -2,7 +2,7 @@ AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS} \
>                ${LIBNETFILTER_CONNTRACK_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS}
>  AM_CFLAGS = ${regular_CFLAGS}
>  
> -SUBDIRS= pcap mysql pgsql sqlite3 dbi
> +SUBDIRS= pcap mysql pgsql sqlite3 dbi sprint
>  
>  pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
>  			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
> diff --git a/output/sprint/Makefile.am b/output/sprint/Makefile.am
> new file mode 100644
> index 0000000..90cbb34
> --- /dev/null
> +++ b/output/sprint/Makefile.am
> @@ -0,0 +1,21 @@
> +AM_CPPFLAGS = -I$(top_srcdir)/include
> +AM_CFLAGS = ${regular_CFLAGS}
> +AM_YFLAGS = -d
> +#AM_LFLAGS = --header-file=scanner.h
> +
> +if BUILD_SPRINT
> +
> +pkglib_LTLIBRARIES = ulogd_output_SPRINT.la
> +
> +ulogd_output_SPRINT_la_SOURCES = ulogd_output_SPRINT.c ulogd_output_SPRINT-scanner.l ulogd_output_SPRINT-parser.y
> +ulogd_output_SPRINT_la_LDFLAGS = -avoid-version -module
> +# ulogd_output_SPRINT_la_LFLAGS =  --header-file=scanner.h
> +
> +BUILT_SOURCES = ulogd_output_SPRINT-parser.h ulogd_output_SPRINT-parser.c \
> +		ulogd_output_SPRINT-scanner.h ulogd_output_SPRINT-scanner.c
> +CLEANFILES = $(BUILT_SOURCES)
> +
> +ulogd_output_SPRINT-scanner.h: ulogd_output_SPRINT-scanner.l
> +	$(LEX) -o /dev/null --header-file=$@ $<
> +
> +endif
> diff --git a/output/sprint/ulogd_output_SPRINT-parser.y b/output/sprint/ulogd_output_SPRINT-parser.y
> new file mode 100644
> index 0000000..83f5af9
> --- /dev/null
> +++ b/output/sprint/ulogd_output_SPRINT-parser.y
> @@ -0,0 +1,358 @@
> +/*

Some clarifications about who is holding copyright are needed before
code can be accepted.

> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2
> + *  as published by the Free Software Foundation.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

