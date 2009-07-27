From: Zhiyun Qian <zhiyunq@umich.edu>
Subject: Source IP or Dest IP rewriting failed with correct TCP and IP checksum
Date: Mon, 27 Jul 2009 03:17:03 -0400
Message-ID: <4A6D546F.8010606@umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.mail.umich.edu ([141.211.14.81]:60410 "EHLO
	hackers.mr.itd.umich.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbZG0HZu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:25:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

Sorry about sending the question to both lists cause I am not sure which 
one is the best list.

I am using the latest libnetfilter_queue and other dependencies 
(downloaded a couple of days ago).

I've spent some time trying to rewrite the packets (specifically, the 
source IP address or the destination IP address) and reinject it back to 
the network. I think I got the code right. However, after I did the 
modification on the packets, although with the correct checksum at both 
IP and TCP layer (I have tried several fixed packet headers where the 
checksum is known beforehand and make sure checksum is computed 
correctly), the packet was not successfully reinjected (not captured by 
tcpdump).

The weird thing is that they fail deterministically but randomly (to me) 
for different IP addresses. For example, if I rewrite the destination IP 
to 1.1.1.1, it succeeded, but if I rewrite the destination IP to 
1.1.1.2, it then failed. And for source IPs, it always fails. I've 
tested the other fields like TTL or source port and destination port, it 
always succeeded.

One possibility that can partially explain this is that my machine is 
not allowing spoofed IP address. But then I use hping to spoof other IPs 
and the packets are indeed captured by tcpdump (I also checked my 
iptables configuration). I then think if hping is using a different 
mechanism to send out packets than libnetfilter_queue. But I couldn't 
find the answer until I dive into the corresponding kernel module (I 
think hping is just using raw socket). I am wondering if there's a way 
to get the result of the injected packet (whether or not it is delivered 
out). I don't know what the return value of nfq_set_verdict() means, it 
is always some value larger than 0 (e.g. 32, 72 ...).

Can anybody shed some lights on this? Thanks a lot! I can post my code 
here if needed.

Regards.
-Zhiyun
