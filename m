From: WGH <wgh@torlan.ru>
Subject: conntrack, idle TCP connection and keep-alives
Date: Sun, 27 Oct 2013 00:14:48 +0400
Message-ID: <526C22B8.5030102@torlan.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward2h.mail.yandex.net ([84.201.187.147]:47653 "EHLO
	forward2h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3JZUWK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:22:10 -0400
Received: from smtp1h.mail.yandex.net (smtp1h.mail.yandex.net [84.201.187.144])
	by forward2h.mail.yandex.net (Yandex) with ESMTP id 11ACF702115
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2013 00:14:50 +0400 (MSK)
Received: from smtp1h.mail.yandex.net (localhost [127.0.0.1])
	by smtp1h.mail.yandex.net (Yandex) with ESMTP id D174C13400EC
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2013 00:14:50 +0400 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

It seems that, when masquerading, conntrack silently drops idle
connection after nf_conntrack_tcp_timeout_established seconds. This's
pretty terrible, as application inside the network, if it never sends
anything, will never know that connection was dropped.

RFC 5382 gives us a solution to this:
> A NAT can check if an endpoint for a session has crashed by sending a
> TCP keep-alive packet and receiving a TCP RST packet in response.

However, it I couldn't find such feature in netfilter. It would be
pretty nice to have.

It would be much more effective than enabling keep-alives system-wide
(which is not even possible in practice). It makes sense that NAT has to
manage such things, as only NAT knows the timeouts of itself. If there's
a NAT along the route, it will send keep-alives (overhead, but
inevitable). If there's no NATs, there will be no keep-alives. Simple.

AFAIK, Cisco implements this under name Dead Connection Detection.
