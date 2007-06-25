From: David Miller <davem@davemloft.net>
Subject: Re: [RFC SKBUFF]: Keep track of writable header len of headerless
 clones
Date: Sun, 24 Jun 2007 19:37:51 -0700 (PDT)
Message-ID: <20070624.193751.46198776.davem@davemloft.net>
References: <467E6950.4020707@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <467E6950.4020707@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 24 Jun 2007 14:53:36 +0200

> - sendmsg eth0, no NAT:		sys     0m2.508s
> - sendmsg eth0, NAT:		sys     0m2.539s
> - sendmsg eth0, NAT + patch:	sys     0m2.445s	(no change)

This is probably because we're touching all the data anyways
and if the resident set size is small enough (as a gigabit
or 100MB ethernet TCP stream window would be) then it all fits
mostly in the L2 caches of the cpu.

Oh yeah and I like your patch Patrick :-)
