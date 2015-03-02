From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Add kernel headers needed from v3.16
Date: Mon, 2 Mar 2015 12:13:30 +0100
Message-ID: <20150302111330.GA6271@salvia>
References: <54EFA21A.5090507@codethink.co.uk>
 <1425038050-31511-1-git-send-email-pedro.alvarez@codethink.co.uk>
 <1425038050-31511-2-git-send-email-pedro.alvarez@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pedro Alvarez <pedro.alvarez@codethink.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42783 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbCBLJw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 06:09:52 -0500
Content-Disposition: inline
In-Reply-To: <1425038050-31511-2-git-send-email-pedro.alvarez@codethink.co.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 27, 2015 at 11:54:10AM +0000, Pedro Alvarez wrote:
> Ebtables fails to compile with versions of the linux headers greater
> than v3.16 with this error:
> 
>   extensions/ebt_ulog.c:17:45: fatal error: linux/netfilter_bridge/ebt_ulog.h: No such file or directory
>    #include <linux/netfilter_bridge/ebt_ulog.h>
> 
> This patch adds netfilter_bridge headers for every supported
> extension, including filter.h and types.h, to avoid this problem and
> future problems with changes in the kernel headers.

Applied, thanks.

BTW, I have also included include/linux/netfilter_bridge/ebtables.h
