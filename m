From: Ed W <lists@wildgooses.com>
Subject: How to modify conntrack accounting?
Date: Tue, 02 Apr 2013 20:11:23 +0100
Message-ID: <515B2D5B.8010807@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:36577 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab3DBTLY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:11:24 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id D237134039B
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Apr 2013 20:11:23 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id lDxaRjkIcoq0 for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Apr 2013 20:11:23 +0100 (BST)
Received: from eds-macbook-pro.nippynetworks.local (unknown [212.69.38.73])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id A70B2340316
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Apr 2013 20:11:23 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, I have a requirement to account for "bytes I pay for" over some 
link, and conntrack very nearly gives me the right answer...  This link 
uses accounting somewhat like ATM, where the IP data is sliced into 
fixed size cells and you have to pay for the overhead per cell, plus the 
wasted space in the extra cell.

I look at the latest kernel sources and all the packet size accounting 
seems to be performed in: nf_conntrack_core.c / __nf_ct_refresh_acct() 
and __nf_ct_kill_acct().

I see several options:

1) Modify the accounting procedure in nf_conntrack_core.c so that 
certain connections will use a different accounting formula. However, 
how would I mark from userspace that a certain interface has this 
unusual accounting property?

2) Could/Should I produce a new netfilter module which operates per 
packet, looks up the connection object for a given packet, and then adds 
a "fudge" to the connection accounting number to correct for the effect 
of the odd packetisation? Presumably from userspace you would then 
simply create an iptables rule tagging packets out of a certain 
interface with "-m my_odd_accounting".

I don't yet know how to build option 2), but it seems appealing (anyone 
got any consultancy time and want to bill me to build it?)

I would appreciate feedback from those more knowledgeable? Given the 
small niche of the solution a modification to nf_conntrack_core.c is 
appealing, but I'm unsure how to indicate which are the peculiar 
interfaces, only userspace will know this.

Thanks for your thoughts/hints

Ed W
