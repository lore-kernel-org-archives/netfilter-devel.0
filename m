From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 -next 1/2] netfilter: iptables: separate counters from
 iptables rules
Date: Fri, 5 Jun 2015 14:28:41 +0200
Message-ID: <20150605122841.GG11015@breakpoint.cc>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
 <2679129.rhlPpvF55Y@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38238 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbbFEM2n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 08:28:43 -0400
Content-Disposition: inline
In-Reply-To: <2679129.rhlPpvF55Y@rofl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick Schaaf <netdev@bof.de> wrote:
> Hi Florian (+ list), (resend without HTML part...)
> 
> would it be feasible to have sysctl knobs to disable the counters? 
>
> Easiest approach might be to keep all the counter memory allocation 
> as it is (or as it is changed with your current work), and just not count at 
> packet processing time. Which should make things a bit faster (no 
> cache pollution for the RMW counter access of any matching rules.) 
> 
> More complicated approach might even save the whole counter 
> memory consumption, faking 0 values when returning counters to 
> userlevel, and ignoring userlevel supplied values (iptables-restore) 

I'm not sure its worth doing, nftables does the right thing already.

I'm merely looking at the percpu rule deduplication because increase
in number of cpus is starting to make it problematic from memory
consumption point of view, and ip(6)tables isn't going to disappear anytime
soon.

