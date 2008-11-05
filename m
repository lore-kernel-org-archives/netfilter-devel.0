From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: IPv6 conntrack support for neighbour discovery
Date: Wed, 05 Nov 2008 22:01:31 +0900 (JST)
Message-ID: <200811051301.mA5D1Wwg001246@toshiba.co.jp>
References: <200811050444.mA54i7F8028119@toshiba.co.jp>
	<49116C65.7030405@trash.net>
	<20081105134021.041ff27f@hiperon.ws.hirg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp,
	Marek.Szuba@if.pw.edu.pl, netfilter-devel@vger.kernel.org
To: Marek.Szuba@student.if.pw.edu.pl
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx12.toshiba.co.jp ([61.202.160.132]:42769 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbYKENBf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:01:35 -0500
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id mA5D1XE6023359
	for <netfilter-devel@vger.kernel.org>; Wed, 5 Nov 2008 22:01:33 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id mA5D1XvN029897
	for netfilter-devel@vger.kernel.org; Wed, 5 Nov 2008 22:01:33 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id mA5D1WRh006537
	for <netfilter-devel@vger.kernel.org>; Wed, 5 Nov 2008 22:01:33 +0900 (JST)
In-Reply-To: <20081105134021.041ff27f@hiperon.ws.hirg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


From: Marek Szuba <Marek.Szuba@student.if.pw.edu.pl>
Date: Wed, 5 Nov 2008 13:40:21 +0100

> On Wed, 05 Nov 2008 10:50:29 +0100
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > Marek, could you close the bugzilla report with a link to
> > Yasuyuki's explanation please? Thanks!
> What resolution should I specify? I believe we've got the following
> options: CODE_FIX, WILL_NOT_FIX (which rejects the bug) and
> WILL_FIX_LATER (which defers the bug).

WILL_NOT_FIX. That is not bug of connection tracking.

Your patch cannot support protocols using their ICMPv6 messages
as I explained. Please feel free to implement my suggestion or propose
better way.

-- Yasuyuki Kozakai
