From: Arif Hossain <freefall1986@gmail.com>
Subject: after setting verdict in netfilter_queue packet is not reaching udp
 server daemon
Date: Tue, 13 Mar 2012 18:03:07 +0600
Message-ID: <1331640187.2239.10.camel@arifLaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65324 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2CMMDN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:03:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm receiving packets from NFQUEUE target. after making modifications to
it i'm setting verdict with nfq_set_verdict. nfq_set_verdict() is
returning nonzero values indicating there is no problem with it. but my
udp daemon which should receive the modified packet is not receiving it.
is there is any way to trace it packet from nfq_set_verdict() to
udp_server?.

During development i have seen sometimes it does not work. if i restart
the udp daemon it starts working again. during development we were using
a simple echo udp server. it worked there more or less. This is not
happening in a full blown udp server(which is udp packet relay server).
if there is a way to tell what happens to the packet after
nfq_set_verdict()(i mean after returning from the registered callback
function) i can find out what's wrong with the thing.

Thanks in advance.

