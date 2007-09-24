From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.22.3 4/5] nfnetlink_log: Fix instance_create() failure
 path
Date: Mon, 24 Sep 2007 14:34:46 +0200
Message-ID: <46F7AEE6.1090603@trash.net>
References: <20070921164917.GD3779@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38348 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbXIXMns (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:43:48 -0400
In-Reply-To: <20070921164917.GD3779@rere.qmqm.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Micha=C2=B3 Miros=C2=B3aw wrote:
> Fix memory leak on instance_create() while module is being unloaded.


Applied, thanks.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
