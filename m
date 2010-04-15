From: "Morgon J. Kanter" <morgon.j.kanter@dartmouth.edu>
Subject: Named/numbered queues in the kernel?
Date: Thu, 15 Apr 2010 13:02:40 -0400
Message-ID: <201004151302.40872.morgon.j.kanter@dartmouth.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub2.dartmouth.edu ([129.170.17.107]:32769 "EHLO
	mailhub2.dartmouth.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab0DOSWj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:22:39 -0400
Received: from mewtwo.localnet ([129.170.71.61])
	(authenticated bits=0)
	by mailhub2.dartmouth.edu (8.13.5/DND2.0/8.13.5) with ESMTP id o3FI3TLC005869
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2010 14:03:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I was poking around the libnetfilter_queue code in an attempt to understand 
it, and was looking at the queue numbers. It looks like these numbers are only 
part of an individual application, and are not system-wide. Is there already a 
way to have system-wide numbers for queues, or is that something that I'll 
have to implement myself?

For example, when using iptables I can do a "-j QUEUE". It would be cool if 
instead I could do a "-j QUEUE <name or number>", and then have an individual 
application only listen to its own queue instead of the entire system's worth 
of queued packets. Is there general interest in this functionality beyond my 
own?

Thanks,
-- Morgon
