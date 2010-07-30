From: Daniel Gibson <metalcaedes@gmail.com>
Subject: TCPMSS clamp-mss-to-pmtu breaks packets that have no MSS set (incl.
 solution)
Date: Fri, 30 Jul 2010 03:01:21 +0200
Message-ID: <4C522461.4070000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab0G3BBV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jul 2010 21:01:21 -0400
Received: by fxm14 with SMTP id 14so626662fxm.19
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jul 2010 18:01:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

clamp-mss-to-pmtu (as used in "iptables -A FORWARD -p tcp --tcp-flags 
SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu") sets a possibly much to high 
MSS (the one it got from PMTU) in packets that had no MSS set before.
RFC 879 says "HOSTS MUST NOT SEND DATAGRAMS LARGER THAN 576 OCTETS 
UNLESS THEY HAVE SPECIFIC KNOWLEDGE THAT THE DESTINATION HOST IS 
PREPARED TO ACCEPT LARGER DATAGRAMS."
That means that if no MSS was set by a server, one must not send packets 
with a MSS > 536 to that server.
clamp-mss-to-pmtu however ignores this and, if no MSS was set in a 
packet, sets the MSS determined by PMTU, often something like 1452, so 
much to big packets are sent to the host that conforms to the RFC but, 
braindead as it is, blocks "ICMP Fragmentation needed" packets.
So the connection times out after some retries that are all dropped on 
the remote firewall or whatever because the packets are to big.
By the way, this bug seems to be present since kernel 2.4.3 (when TCPMSS 
was introduced).

The solution: If no MSS was set in the packet and "newmss", as 
determined by PMTU, is > 536, set "newmss" to 536 before applying it to 
the packet.
I think this is the only sane fix:
* Leaving it as it is now obviously breaks the RFC
* I realized that not setting a MSS for a packet that had none set 
before (or always setting 536) might cause trouble if the MSS determined 
by PMTU is (for whatever reason) < 536.

See http://bugzilla.netfilter.org/show_bug.cgi?id=662 for further 
information and a (really simple) patch.

Cheers,
- Daniel

PS: The bugreport mentions that http://research.microsoft.com doesn't 
work because of this bug - it seem like Microsoft has fixed this 
recently. They still don't send a MSS, but they accept larger packets now.
