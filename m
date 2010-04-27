From: David F <netfilter@meta-dynamic.com>
Subject: nfnetlink_queue: which userspace library?
Date: Tue, 27 Apr 2010 13:48:39 -0400
Message-ID: <4BD72377.8070400@meta-dynamic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from troy.meta-dynamic.com ([204.11.35.233]:58791 "EHLO
	mail.meta-dynamic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab0D0R4z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:56:55 -0400
Received: from mandelbrot.meta-dynamic.com (mds-server [192.168.137.138])
	by mail.meta-dynamic.com (Postfix) with ESMTP id A08BF192
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Apr 2010 13:49:33 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I want to do some packet manipulation that seems beyond the scope of 
what can be done directly by existing iptables modules (ipv4 options 
mangling), so I'd like to queue the packets in question for userspace, 
for easy experimentation and development.

After a fair bit of googling, it seems to me that the most common and 
well-documented way to do this is via the QUEUE target and libipq.  But 
numerous references indicate that QUEUE and libipq are deprecated and 
NFQUEUE/nfnetlink_queue is the preferred method.  Setting up the 
iptables looks straightforward, but then how to receive/return them on 
the userspace side?  Aside from libipq, it seems that there are 3 
alternatives:

* libnetfilter_queue http://www.netfilter.org/projects/libnetfilter_queue/
* libnl and its "queue" group of functions 
http://www.infradead.org/~tgr/libnl/doc/group__queue.html 
<http://www.infradead.org/%7Etgr/libnl/doc/group__queue.html>
* Code your own using netlink sockets directly, and 
<linux/netfilter/nfnetlink_queue.h>.

None of these seem to have great documentation or example programs, 
although I have found a few resources.  So I'm wondering if anyone can 
give me a little direction as to what are the differences, which would 
be the best option, and why there seems to be a duplication between 
libnl and libnetfilter.  Is libipq truly deprecated?  I would prefer not 
to code into a "dead end" and eventually end up re-coding for a 
different library.

Thanks,
David F

