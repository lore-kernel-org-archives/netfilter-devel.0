From: Stephen Clark <sclark46@earthlink.net>
Subject: ipsec nat issue
Date: Fri, 12 Oct 2012 16:22:44 -0400
Message-ID: <50787C14.7060009@earthlink.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:45598 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab2JLUWq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:22:46 -0400
Received: from [69.22.83.100] (helo=joker.seclark.com)
	by elasmtp-scoter.atl.sa.earthlink.net with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <sclark46@earthlink.net>)
	id 1TMlks-0000En-3Y
	for netfilter-devel@vger.kernel.org; Fri, 12 Oct 2012 16:22:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have the following setup:

ipsec tunnel 10.255.3.128/25 - pub add1 <-> pub add2 - 10.255.5.128/25

trying to SNAT remote private address 10.255.5.128/25 to make it appear 
like it was local 10.255.3.254
but it doesn't work - see below.

iptables -t nat -I POSTROUTING -o eth0 -s 10.255.5.128/25 -d 
10.255.3.128/25 -j SNAT --to-source 10.255.3.254

Chain POSTROUTING (policy ACCEPT 6 packets, 456 bytes)
  pkts bytes target     prot opt in     out     source               
destination
     0     0 SNAT       all  --  *      eth0    10.255.5.128/25      
10.255.3.128/25     to:10.255.3.254

$ sudo tcpdump -nli eth0 icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 65535 bytes
15:20:17.772396 IP 10.255.5.254 > 10.255.3.129: ICMP echo request, id 
52588, seq 62, length 64
15:20:18.777272 IP 10.255.5.254 > 10.255.3.129: ICMP echo request, id 
52588, seq 63, length 64
15:20:19.772572 IP 10.255.5.254 > 10.255.3.129: ICMP echo request, id 
52588, seq 64, length 64
15:20:20.770681 IP 10.255.5.254 > 10.255.3.129: ICMP echo request, id 
52588, seq 65, length 64

I would expect 10.255.5.254 to be replaced with 10.255.3.254 what am I 
missing? Is this possible
I could do it when we were using FreeBSD.

I didn't find anything googling.

Thanks,
Steve


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



