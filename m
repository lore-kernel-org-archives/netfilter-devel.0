From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] fixed configure.ac. Now autogen.sh will work
Date: Thu, 2 Aug 2012 17:50:23 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208021750000.10019@frira.zrqbmnf.qr>
References: <1343921755.12174.2.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Arif Hossain <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:53319 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab2HBPuZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:50:25 -0400
In-Reply-To: <1343921755.12174.2.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-08-02 17:35, Arif Hossain wrote:

> AC_ARG_WITH([xtlibdir],
> 	AS_HELP_STRING([--with-xtlibdir=PATH],
>-	[Path where to install Xtables extensions [[autodetect]]]]),
>+	[Path where to install Xtables extensions [[autodetect]]]),
> 	[xtlibdir="$withval"])
> AC_MSG_CHECKING([Xtables module directory])
> AC_MSG_RESULT([$xtlibdir])

Applied.
