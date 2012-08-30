From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race condition against ctnetlink_del_conntrack
Date: Thu, 30 Aug 2012 14:39:44 +0200
Message-ID: <1833197.YFsvR70GWT@gentoovm>
References: <7353554.n89QJXU3eh@gentoovm> <20120830103437.GA13756@1984> <149613366.axl8ME3any@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:39930 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2H3Mj3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:39:29 -0400
In-Reply-To: <149613366.axl8ME3any@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 30 August 2012 14:28:20 Oliver wrote:
> Yep, I'd be happy to test. I've also uncovered a new issue: I have two
> Active- Active machines (conntrackd running NOTRACK mode with both External
> and Internal cache disabled)
> 
> In kernel 3.2 this pair works asymmetric and issue-free. Upgrade it to 3.4
> and it immediately has around 50% failure of TCP connection attempts on
> systems behind them - ICMP on the other hand is flawless, DNS lookups also
> are OK so I *believe* that UDP may also be performing well - I've no idea
> where to even look on this one so any insight would be most appreciated.
> 
> Kind Regards,
> Oliver

Another thing that just entered my mind: I configured raw/PREROUTING to -j CT 
--notrack TCP port 80 (source and dest) on the appropriate interfaces and this 
resulted in total loss despite the fact that I had --ctstate UNTRACKED set to 
ACCEPT - and again, this behaviour only occurs under 3.4.[9|10] (probably 
earlier too but I didn't test)
