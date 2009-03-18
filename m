From: "Damian Lezama" <damian.lezama@hotmail.com>
Subject: Problem changing source IP or Protocol in user space with NFQUEUE
Date: Wed, 18 Mar 2009 08:51:20 -0700
Message-ID: <COL110-DS24E63C96E7A93473A4751CF1990@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from col0-omc1-s7.col0.hotmail.com ([65.55.34.17]:17485 "EHLO
	col0-omc1-s7.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbZCRP5j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:57:39 -0400
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'll update my message to make it more clear:

I need to change the Source IP of incoming packets in PREROUTING. I'm
implementing a tunnel like protocol. I'm intercepting the packets with an
NFQUEUE in mangle table. When I change the Source IP or Protocol and return
the packet with ACCEPT or REPEAT verdict it disappears. If I put my hook in
INPUT (to handle the packets that are sent to the host) the applications get
the packet but with the "old" IP.

About packets that are going to be routed: If I change them in PREROUTING
and change the Source IP I lose them. But I have to change the Destination
there or the router will use the "old" IP for routing. I can change the
destination in PREROUTING and the source in FORWARDING but it's ugly (and
it's only a fix for these packets, I couldn't find a fix for packets sent to
the host).

I'm using the last version of libnetfilter_queue I'd appreciate any help
here because I'm depending on this to advance with a prototype I need for my
thesis, thanks!


Regards,
Damian



