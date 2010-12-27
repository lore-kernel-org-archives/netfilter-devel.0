From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq@rere.qmqm.pl>
Subject: Re: [PATCH 1/6] netfilter: kconfig: NFQUEUE is useless without
	NETFILTER_NETLINK_QUEUE
Date: Mon, 27 Dec 2010 09:47:55 +0100
Message-ID: <20101227084755.GA2715@rere.qmqm.pl>
References: <1293407904-31464-1-git-send-email-fw@strlen.de> <1293407904-31464-2-git-send-email-fw@strlen.de> <alpine.LNX.2.01.1012270940350.20009@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([89.167.52.164]:47464 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab0L0Ir5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Dec 2010 03:47:57 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1012270940350.20009@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 27, 2010 at 09:41:29AM +0100, Jan Engelhardt wrote:
> On Monday 2010-12-27 00:58, Florian Westphal wrote:
> >NFLOG already does the same thing for NETFILTER_NETLINK_LOG.
> >diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> >index 1534f2b..c617ec9 100644
> >--- a/net/netfilter/Kconfig
> >+++ b/net/netfilter/Kconfig
> >@@ -477,6 +477,7 @@ config NETFILTER_XT_TARGET_NFLOG
> > config NETFILTER_XT_TARGET_NFQUEUE
> > 	tristate '"NFQUEUE" target Support'
> > 	depends on NETFILTER_ADVANCED
> >+	select NETFILTER_NETLINK_QUEUE
> > 	help
> > 	  This target replaced the old obsolete QUEUE target.
> There once was sort of a small debate on whether we should not reduce=
=20
> the usage of "select" (and instead use: depends on=20
> NETFILTER_NETLINK_QUEUE, in this case). What do people think about it=
?

=46or users, NETFILTER_XT_TARGET_NFQUEUE is a real thing they want and
NETFILTER_NETLINK_QUEUE just an implementation detail. So I suggest
select here, like the patch does.

Best Regards,
Micha=B3 Miros=B3aw
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
