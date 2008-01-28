From: Zan Lynx <zlynx@acm.org>
Subject: Bug with Fedora's 2.6.23.9-85 kernel (at least) and ESTABLISHED and
 SACK
Date: Sun, 27 Jan 2008 22:14:24 -0700
Message-ID: <479D64B0.10101@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from threatwall.zlynx.org ([199.45.143.218]:32990 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750750AbYA1Fnv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:43:51 -0500
Received: from [64.81.103.126] (helo=[192.168.31.180])
	by zlynx.org with esmtpa
	(envelope-from <zlynx@acm.org>)
	id 1JJMJy-00084e-8H
	for netfilter-devel@vger.kernel.org; Sun, 27 Jan 2008 22:14:14 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please CC me on any replies as I am not subscribed.

I was downloading a new Google Earth when I noticed a LOT of max-size 
dropped packets in my firewall log.  I only allow RELATED,ESTABLISHED 
sessions into my firewall.

tcpdump showed that every time Google sent a packet to satisfy the 
missing data identified by SACK, that packet was rejected.  So it must 
have been missing the ESTABLISHED rule.

I fixed the problem by adding an ALLOW source port 80 rule for the 
Google download site IP.

This makes me wonder how often this has happened and I haven't noticed 
it.  Is this a known bug or something new?

BTW, your netfilter Bugzilla is dead or at least 404 missing.
