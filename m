From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER00/07]: Netfilter update+fixes
Date: Tue, 06 Nov 2007 01:12:29 +0100
Message-ID: <472FB16D.2000203@trash.net>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain> <1194286854.2641.4.camel@dhcppc0>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?S8WCb2N6a28gVG9tYXN6?= <kloczek@zie.pg.gda.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47907 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbXKFAMq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:12:46 -0500
In-Reply-To: <1194286854.2641.4.camel@dhcppc0>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

K=C5=82oczko Tomasz wrote:
> Dnia 02-11-2007, pi=C4=85 o godzinie 12:23 +0100, Patrick McHardy pis=
ze:
> [..]
>  =20
>>  net/netfilter/xt_connlimit.c        |    5 ++-
>>  net/netfilter/xt_time.c             |    3 +-
>>  net/netfilter/xt_u32.c              |    5 ++-
>>    =20
>
> Still there is no officialy released stable iptables source tar ball
> with connlimit, time and u32 support. It will be good release updated
> iptables (1.3.9 ?)
>  =20

There is a release candidate for 1.4.0. We'll probably release in the
next couple of weeks.

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
