From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC conntrackd PATCH] conntrackd: add basic systemd notification
 support
Date: Mon, 19 Oct 2015 00:50:06 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510190049380.21673@nerf40.vanv.qr>
References: <20151016120800.15632.42888.stgit@r2d2.cica.es> <alpine.LSU.2.20.1510161607550.18200@nerf40.vanv.qr> <CAOkSjBh7hyB_QAidiXsoBtCOj9xG8y0cUcu-ERZTCZQsnHXRJA@mail.gmail.com> <alpine.LSU.2.20.1510162326001.24538@nerf40.vanv.qr>
 <20151017105720.GA1462@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:37931 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbbJRWuI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Oct 2015 18:50:08 -0400
In-Reply-To: <20151017105720.GA1462@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2015-10-17 12:57, Pablo Neira Ayuso wrote:
>Something like this (that we already have in nftables) should be fine:
>
> AC_ARG_ENABLE([debug],
>-             AS_HELP_STRING([--enable-debug], [Enable debugging]),
>-             [with_debug=no],
>+             AS_HELP_STRING([--enable-debug], [Disable debugging]),
>+             AS_IF([test "x$enable_debug" = "xno"], [with_debug=no],
>[with_debug=yes]),
>              [with_debug=yes])

Well the whole AS_IF part is not really needed, because you
are already testing in AM_CONDITIONAL:

> AC_SUBST(with_debug)
> AM_CONDITIONAL([BUILD_DEBUG], [test "x$with_debug" != xno])
