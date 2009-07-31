From: Hugo Miguel Mendes <hugo-m-mendes@ptinovacao.pt>
Subject: conntrack helper - expectations
Date: Fri, 31 Jul 2009 12:58:54 +0100
Message-ID: <47A7F67C62706041BC49DB7822B1C9DB34D79A8740@INOAVREX11.ptin.corpPT.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from owa.ptinovacao.pt ([194.65.138.99]:24671 "EHLO
	owa.ptinovacao.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZGaL7d convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Jul 2009 07:59:33 -0400
Content-Language: pt-PT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear all,

I'm operating netfilter, kernel 2.6.25.17 on a router and I have noticed the following situation in using conntrack helper and NAT helper modules.

When the reply connection which is expected by an expectation comes from a different IP and with the same source port as the destination port of the request, the reply connection gets dropped, although I have logged the connection in the FORWARD chain and it I could see it was successfully NATed.

In my practical case the situation is the following:

-Send request to 194.65.47.55, src port random, dst port 123.
-Reply comes from 213.128.200.3, src port 123, dst port same as the src of the request.

Expectation: 300 proto=17 src=0.0.0.0 dst=10.194.30.172 sport=123 dport=55437

10.194.30.172 is my router IP, then this gets NATed to a PC on the LAN. 55437 is the source port of the request.

Can anyone tell me where is the code that matches the incoming connections to the expectations tables?

Best Regards
Hugo Mendes