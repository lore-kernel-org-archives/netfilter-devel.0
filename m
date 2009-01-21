From: =?KOI8-R?Q?=EB=CF=C2=D9=CC=D1=CE=D3=CB=C9=CA_=F7=CC=C1=C4=C9=CD=C9?=
	 =?KOI8-R?Q?=D2?= <kent@lissi.ru>
Subject: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT hook.
Date: Wed, 21 Jan 2009 21:01:36 +0300
Message-ID: <49776300.1060708@lissi.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 1175.ovz4.hc.ru ([89.111.184.110]:49438 "EHLO mail.lissi.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbZAUSZS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:25:18 -0500
Received: from mail.dc-lissi.int ([194.84.136.194]:23456 helo=mail.lissi.ru)
	by mail.lissi.ru with esmtp (Exim 4.67)
	(envelope-from <kent@lissi.ru>)
	id 1LPhOs-0004Al-6b
	for netfilter-devel@vger.kernel.org; Wed, 21 Jan 2009 21:02:02 +0300
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

First of all - I am a beginner in kernel programming, so my question can
be very stupid. Sorry.

I try to write simple firewall module and I find incomprehensible (at
least for me) thing.

I have Linux-machine with 2.6.17 kernel with my firewall module.
My module register two hooks - LOCAL_OUT and PRE_ROUTING.
With wget I try to download index.html from external WWW-server.

I see in my module 3 handshake packets - they all normal.
Then I see first packet with payload - it is TCP-packet with PSH and ACK
flags and it is not normal at all.

In this packet in tcp-data area I MUST see such string:
"GET / HTTP/1.1..."
or in HEX
"4745 5420 2f20 4854 5450 2f31 2e31 ..."
BUT I see such data in it:
"0200 0100 0100 0000 0100 0000 0000 ....".

As you can see - payload data wrong. IP and TCP headers - all normal.
Length normal.

Even more - if I return NF_ACCEPT on this packet - WWW-server got normal
packet with normal payload data.

If I use my Linux-machine as gateway (and catch forwarding packets by
PRE_ROUTING hook) - I see this packet with normal data inside.


So, I have some questions:

1) Is it possible?
2) If it is possible - what happens and where I can get normal payload data?


P.S.: sorry if repeated question - I really was trying to find it in
archive.

P.P.S.: sorry for my English.
