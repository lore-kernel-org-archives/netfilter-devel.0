From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/6] netfilter: kconfig: NFQUEUE is useless without
 NETFILTER_NETLINK_QUEUE
Date: Mon, 27 Dec 2010 09:41:29 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012270940350.20009@obet.zrqbmnf.qr>
References: <1293407904-31464-1-git-send-email-fw@strlen.de> <1293407904-31464-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44266 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab0L0Ilb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Dec 2010 03:41:31 -0500
In-Reply-To: <1293407904-31464-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-12-27 00:58, Florian Westphal wrote:

>NFLOG already does the same thing for NETFILTER_NETLINK_LOG.
>diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
>index 1534f2b..c617ec9 100644
>--- a/net/netfilter/Kconfig
>+++ b/net/netfilter/Kconfig
>@@ -477,6 +477,7 @@ config NETFILTER_XT_TARGET_NFLOG
> config NETFILTER_XT_TARGET_NFQUEUE
> 	tristate '"NFQUEUE" target Support'
> 	depends on NETFILTER_ADVANCED
>+	select NETFILTER_NETLINK_QUEUE
> 	help
> 	  This target replaced the old obsolete QUEUE target.
> 
>-- 

There once was sort of a small debate on whether we should not reduce 
the usage of "select" (and instead use: depends on 
NETFILTER_NETLINK_QUEUE, in this case). What do people think about it?

