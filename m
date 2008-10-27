From: "Jacky Luk" <jacky.luk@primecreation.com>
Subject: About the netfilter_queue and ip_queue!
Date: Mon, 27 Oct 2008 17:01:32 +0800
Message-ID: <web-4603247@mail.primecreation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n218103092061.netvigator.com ([218.103.92.61]:50582 "EHLO
	mail.primecreation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYJ0KF3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:05:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

My program is using ip_queue to develop in RHEL4.6. 
Recently, I need to port my program to RHEL5.2 because the 
stability issue of the system and my program in RHEL4.6.

I found that the ip_queue is replaced by netfilter_queue 
in RHEL5.2 now and netfilter_queue provides the backward 
compatibility of ip_queue. As a result, I try to 
re-compile my program without changing the source code (My 
program is still using the ip_queue) and I found that it 
can be compiled successfully in RHEL5.2.

However, I found that my program cannot retrieve the 
packets from the kernelspace into the userspace after it 
is initialized as usual (Set the rules in iptables, 
modprobe ip_queue - I think in RHEL5.2 is not needed to 
modprobe ip_queue, but RHEL4.6 is needed).

The following is my questions. Why my program cannot 
retrieve the packets? Is it the configuration problem of 
the rules in iptables? Or some steps is forgotten to 
perform? Or netfilter_queue cannot be backward compatible 
to the ip_queue?

The platform which I compiled and executed my program is 
RHEL5.2 (2.6.18-92.el5) with the installation of 
libnfnetlink-0.0.39 and libnetfilter_queue-0.0.16. The 
rules in iptables is listed in the below (It is the same 
in RHEL4.6 and RHEL5.2):
iptables -t mangle -A PREROUTING -i eth0 -p udp -d 
192.168.0.0/24 -m multiport --destination-port 
2123,2152,3386 -j QUEUE

Thank you very much!

Regards,

Jacky Luk
