From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH 2.6.22.3 1/5] nfnetlink_log: Kill duplicate code
Date: Mon, 24 Sep 2007 17:42:00 +0200
Message-ID: <20070924154200.GA29236@rere.qmqm.pl>
References: <20070921164826.GA3779@rere.qmqm.pl> <46F7AD09.7040002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([86.63.132.164]:33324 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbXIXPmI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:42:08 -0400
Content-Disposition: inline
In-Reply-To: <46F7AD09.7040002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Sep 24, 2007 at 02:26:49PM +0200, Patrick McHardy wrote:
> Micha=C2=B3 Miros=C2=B3aw wrote:
> > Kill some cut'n'paste effect.
> > Just after __nfulnl_send() returning, inst->skb is always NULL.
> This patch introduces a warning:
> net/netfilter/nfnetlink_log.c: In function '__nfulnl_flush':
> net/netfilter/nfnetlink_log.c:365: warning: control reaches end of
> non-void function
>=20
> I fixed it by changing __nfulnl_flush to void, but please make sure
> this doesn't happen again.

Ah... Looks like no one is interested a value returned by __nfulnl_send=
()
but nevertheless it's there...  I'll keep my eyes open wider next time.

Thanks,
Michal Miroslaw
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
