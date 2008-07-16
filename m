From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Conntrack Events Performance - Multipart Messages?
Date: Wed, 16 Jul 2008 17:42:36 +0100
Message-ID: <487E24FC.60700@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59766 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756768AbYGPQmi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:42:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am writing a network application for a genuine wireless router (266Mhz 
IXP4XX). I am capturing packets with ULOG and need connection tracking. 
For performance reasons I planned to use connection tracking events 
(NEW/DESTROY) to avoid doing the same work twice.

In a high load test case I stress the router with UDP packets with 
random source ports (1000B payload, 1800pps). CPU usage is 100%, 10% of 
packets and 80% ctevents are dropped. If I disable ctevents, the CPU 
usage is just 24% and no packet drops occur.

My application is not very heavy and I expect most of the ctevent 
overhead to be caused by passing events from kernel to user space. I 
expect that performance could be increased by using multipart messages 
for ctevents like it is done in ULOG/NFLOG.

Do you share my opinion, that multipart messages would lead to 
significant performance improvements? (Actually, I doubt that I will be 
more efficient than performing connection tracking in user space)

Do you think introducing multipart messages for connection tracking 
events is feasible without breaking existing applications? Maybe with a 
default setting of 1 bundled events, which can be increased by a 
function call?

Is someone intending to implement multipart messages for ctevents? ;-)

Any comments are appreciated.

Regards,

Fabian
