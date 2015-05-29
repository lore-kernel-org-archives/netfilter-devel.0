From: Patrick Schaaf <netdev@bof.de>
Subject: Re: [PATCH v2 -next 1/2] netfilter: iptables: separate counters from iptables rules
Date: Fri, 29 May 2015 13:32:22 +0200
Message-ID: <2679129.rhlPpvF55Y@rofl>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mars.intermailgate.com ([80.242.145.70]:34373 "EHLO
	mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbE2Lc0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 07:32:26 -0400
In-Reply-To: <1432846296-26396-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian (+ list), (resend without HTML part...)

would it be feasible to have sysctl knobs to disable the counters? 

Easiest approach might be to keep all the counter memory allocation 
as it is (or as it is changed with your current work), and just not count at 
packet processing time. Which should make things a bit faster (no 
cache pollution for the RMW counter access of any matching rules.) 

More complicated approach might even save the whole counter 
memory consumption, faking 0 values when returning counters to 
userlevel, and ignoring userlevel supplied values (iptables-restore) 

best regards
  Patrick


