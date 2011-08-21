From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] fix compilation of xtables 1.37
Date: Sun, 21 Aug 2011 13:53:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108211353500.31743@frira.zrqbmnf.qr>
References: <4E3F19DE.9040302@undermydesk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Frank Reppin <frank@undermydesk.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40396 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab1HULx7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:53:59 -0400
In-Reply-To: <4E3F19DE.9040302@undermydesk.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-08-08 01:03, Frank Reppin wrote:

> Hi,
>
> the attached patch fixes compilation of xtables 1.37.
>
> My scenario is:
>
> 1) xtables.h is in /usr/local/iptables/include
> 2) configure was done as:
>     export PKG_CONFIG_PATH=/usr/local/iptables/lib/pkgconfig
>     ./configure --with-xtlibdir=/usr/local/iptables/libexec/xtables
>
> The error was:
>
> libxt_ACCOUNT.c:13:21: warning: xtables.h: No such file or directory

Fixed now in master.
