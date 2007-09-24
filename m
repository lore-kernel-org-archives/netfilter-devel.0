From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.22.3 5/5] nfnetlink_log: Fix some constants
Date: Mon, 24 Sep 2007 14:39:03 +0200
Message-ID: <46F7AFE7.3030001@trash.net>
References: <20070921164935.GE3779@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38434 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbXIXMsG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:48:06 -0400
In-Reply-To: <20070921164935.GE3779@rere.qmqm.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Micha=C2=B3 Miros=C2=B3aw wrote:
> Fix timeout (one second is 1 * HZ) and convert max packet copy length
> to #defined constant.


Another new warning:

net/netfilter/nfnetlink_log.c: In function 'nfulnl_set_mode':
net/netfilter/nfnetlink_log.c:240: warning: comparison of distinct
pointer types lacks a cast

I also fixed this, but next time I might not apply something like this.
Well, thanks anyway.

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
