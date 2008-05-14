From: Anton <anton.vazir@gmail.com>
Subject: NFLOG and test results
Date: Wed, 14 May 2008 14:52:47 +0500
Message-ID: <200805141452.47163.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:33436 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbYENJwo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 05:52:44 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just did more tests with NFLOG on the 100mbit thoughput -
sending receiving big files - ulog with NFLOG looses 
packets, and it looses more when there is more to do with 
the logging target. For example we've hacked into the 
OPRINT and LOGEMU targets, trying to do initial packet 
aggreagation before logging - and as more work is done 
there - as more packets we loose, especially if there is 
network communication from the logging target (like DB 
logging). Just thinking about MULTICAST approach of the 
NFLOG - this seems logical - that tehere is the packet, and 
if we listen the MULTICAST not fast enough - we loose 
something... If it was not LOG target that would be ok, 
but, what use can we get from the logging, while we loose 
data, which are valuable? Accounting can't be built on top 
of ULOG or NFLOG while it's so. Maybe NFLOG should be 
rethought - there should be a way to get the all of the 
packets we want NFLOGed in userspace, regradless of the 
throughput, even at cost of slowing down kernel accepting 
more packets which match the chain. Maybe some in-kernel 
queue or an asknowledge from the NFLOG subscriber, that a 
packet, or bucket of packets have been delivered to 
userspace? For now, I see the only reliable target - is a 
QUEUE - where we process packet and can log it, and than 
return to a kernel - but NFLOG have a beautifull approach 
with labeling and so on - and possibly the best way is to 
find out wow NFLOG could be made to do reliable logging. 
Or maybe I'm completely wrong and all of the problems are in 
the ulogd?
