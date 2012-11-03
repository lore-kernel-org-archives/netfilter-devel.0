From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 3/4] Add configure flag to disable NFLOG build
Date: Sat, 3 Nov 2012 15:41:59 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211031541140.14935@nerf07.vanv.qr>
References: <1351942382-24791-1-git-send-email-eric@regit.org> <1351942382-24791-4-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49706 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab2KCOmA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:42:00 -0400
In-Reply-To: <1351942382-24791-4-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2012-11-03 12:33, Eric Leblond wrote:
> 
>+if BUILD_NFLOG
> pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la \
> 			 ulogd_inppkt_UNIXSOCK.la
> 
> ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
> ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
> ulogd_inppkt_NFLOG_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_LOG_CFLAGS)
>+else
>+pkglib_LTLIBRARIES = ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
>+endif

You can use

  pkglib_LTLIBRARIES = ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
  if BUILD_NFLOG
  pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
  ...
  endif

So that ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
does not have to be listed twice.
