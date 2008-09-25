From: Dave Horton <dhorton@pactolus.com>
Subject: been a while...what happened to NFC_ALTERED?
Date: Thu, 25 Sep 2008 18:38:26 -0400
Message-ID: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com>
Mime-Version: 1.0 (Apple Message framework v928.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host66.216.41.17.conversent.net ([216.41.17.66]:34534 "EHLO
	pcs-psrt-01.pactolus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756119AbYIYXEa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:04:30 -0400
Received: from [10.10.200.129] ([10.10.200.129])
	by pcs-psrt-01.pactolus.com (8.12.11.20060308/8.12.11) with ESMTP id m8PMcQfj009739
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2008 18:38:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've hunted around a bit but can't find the answer to my question,  
even though it seems like it must be covered somewhere obvious -  
apologies in advance if I've missed it.

Here's my situation: I wrote a simple netfilter target a couple of  
years back, been running it on Redhat 3, 2.4 kernel successfully for  
quite a while.  I install it on the PREROUTING chain, and I mangle UDP  
packets; modifiying the source and destination addresses.  My code was  
then setting the NFC_ALTERED bit in the nf_cache of the sk_buff so  
that it would get re-processed by netfilter.  Everything fine.  Now I  
simply want to update my code to run on Centos 5, kernel 2.6.18 and  
iptables 1.4.  Whoa, now I find my kernel module doesn't compile  
because that data structure has changed.  If I remove that line of  
code, it compiles, but the packet forwarding does not work (and it  
seems like I stop getting packets routed to my target at all once I  
mangle the first one).

Can someone help me out?  What is the new improved way of indicating  
that I've changed a packet's header or body so that netfilter re- 
examines it?
