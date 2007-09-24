From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.22.3 1/5] nfnetlink_log: Kill duplicate code
Date: Mon, 24 Sep 2007 14:26:49 +0200
Message-ID: <46F7AD09.7040002@trash.net>
References: <20070921164826.GA3779@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38197 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbXIXMfw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:35:52 -0400
In-Reply-To: <20070921164826.GA3779@rere.qmqm.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Micha=C2=B3 Miros=C2=B3aw wrote:
> Kill some cut'n'paste effect.
> Just after __nfulnl_send() returning, inst->skb is always NULL.


This patch introduces a warning:

net/netfilter/nfnetlink_log.c: In function '__nfulnl_flush':
net/netfilter/nfnetlink_log.c:365: warning: control reaches end of
non-void function

I fixed it by changing __nfulnl_flush to void, but please make sure
this doesn't happen again.

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
