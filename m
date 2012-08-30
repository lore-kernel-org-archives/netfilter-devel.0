From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race condition against ctnetlink_del_conntrack
Date: Thu, 30 Aug 2012 14:28:20 +0200
Message-ID: <149613366.axl8ME3any@gentoovm>
References: <7353554.n89QJXU3eh@gentoovm> <5239380.eElFyXbOPg@gentoovm> <20120830103437.GA13756@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:39901 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab2H3M2N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:28:13 -0400
In-Reply-To: <20120830103437.GA13756@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 30 August 2012 12:34:37 you wrote:
> Yes, I prefer the second patch. There is still races in the first
> patch I sent you, harder to trigger, but still there.
> 
> There are several cleanups I'd like to recover from the first patch
> though. Would you help testing them?
> 
> Thanks a lot for testing.

HI Pablo,

Yep, I'd be happy to test. I've also uncovered a new issue: I have two Active-
Active machines (conntrackd running NOTRACK mode with both External and 
Internal cache disabled)

In kernel 3.2 this pair works asymmetric and issue-free. Upgrade it to 3.4 and 
it immediately has around 50% failure of TCP connection attempts on systems 
behind them - ICMP on the other hand is flawless, DNS lookups also are OK so I 
*believe* that UDP may also be performing well - I've no idea where to even 
look on this one so any insight would be most appreciated.

Kind Regards,
Oliver
