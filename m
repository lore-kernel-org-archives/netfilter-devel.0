From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: A bug in xtables-addons-1.38
Date: Sun, 28 Aug 2011 19:46:26 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108281942090.12106@frira.zrqbmnf.qr>
References: <j2uigu$sk4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergei Zhirikov <sfzhi@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:43210 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab1H1Rq2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Aug 2011 13:46:28 -0400
In-Reply-To: <j2uigu$sk4$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-08-22 23:42, Sergei Zhirikov wrote:

> Hi,
>
> Looks like there is a small bug in xtables-addons-1.38.
> extensions/xt_CHECKSUM.c should #include <linux/version.h>
> otherwise build fails (tried with kernel 2.6.35.14).

Fixed, thanks.
