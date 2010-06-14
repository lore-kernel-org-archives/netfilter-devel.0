From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack fails to track Windows Vista TCP connection
Date: Mon, 14 Jun 2010 18:15:18 +0200
Message-ID: <4C165596.8020700@trash.net>
References: <0199E0D51A61344794750DC57738F58E70B258E2B3@GVW1118EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Fischer, Anna" <anna.fischer@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53488 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab0FNQPU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:15:20 -0400
In-Reply-To: <0199E0D51A61344794750DC57738F58E70B258E2B3@GVW1118EXC.americas.hpqcorp.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fischer, Anna wrote:
> I am trying to track (and NAT) a TCP connection to a Windows Vista machine using ip_conntrack. However, Vista uses the Nagle algorithm combined with the TCP Delayed ACK mechanism which does not ACK every single packet, and it seems as if the connection tracking module has problems with this. Basically it fails to recognize Delayed ACK packets, and as these are not picked up by the connection tracking module, my NAT function does not work and so packets are not delivered properly because they are not rewritten by ip_nat. I am certain that the problem is the Vista TCP stack and its mechanisms as when I configure my Windows Vista machine with Nagle = off and TCPNODelay = 1, then actually connection tracking works fine. Also, all connections with Linux machines are tracked properly.
>
> Is this a known issue?

You're mentioning ip_conntrack, which is obsoleted for multiple
years now. Which kernel version are you using?
