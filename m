From: "Fischer, Anna" <anna.fischer@hp.com>
Subject: ip_conntrack fails to track Windows Vista TCP connection
Date: Mon, 14 Jun 2010 15:25:00 +0000
Message-ID: <0199E0D51A61344794750DC57738F58E70B258E2B3@GVW1118EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:34761 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0FNP0Z convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:26:25 -0400
Received: from G6W0640.americas.hpqcorp.net (g6w0640.atlanta.hp.com [16.230.34.76])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by g5t0008.atlanta.hp.com (Postfix) with ESMTPS id E9E70243EF
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2010 15:26:24 +0000 (UTC)
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am trying to track (and NAT) a TCP connection to a Windows Vista machine using ip_conntrack. However, Vista uses the Nagle algorithm combined with the TCP Delayed ACK mechanism which does not ACK every single packet, and it seems as if the connection tracking module has problems with this. Basically it fails to recognize Delayed ACK packets, and as these are not picked up by the connection tracking module, my NAT function does not work and so packets are not delivered properly because they are not rewritten by ip_nat. I am certain that the problem is the Vista TCP stack and its mechanisms as when I configure my Windows Vista machine with Nagle = off and TCPNODelay = 1, then actually connection tracking works fine. Also, all connections with Linux machines are tracked properly.

Is this a known issue?

Thanks,
Anna
