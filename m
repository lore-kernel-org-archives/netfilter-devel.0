From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.22.3 2/5] nfnetlink_log: Flush queue early
Date: Mon, 24 Sep 2007 14:30:33 +0200
Message-ID: <46F7ADE9.8000303@trash.net>
References: <20070921164846.GB3779@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38284 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbXIXMjf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:39:35 -0400
In-Reply-To: <20070921164846.GB3779@rere.qmqm.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Micha=C2=B3 Miros=C2=B3aw wrote:
> If queue is filled to its threshold, then flush it right away instead
> of waiting for timer or next packet.


Applied, thanks Michal.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
