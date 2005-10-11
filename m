From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 12:39:20 -0700 (PDT)
Message-ID: <20051011.123920.104724390.davem@davemloft.net>
References: <434AE28B.2070607@trash.net>
	<20051010.150623.94217913.davem@davemloft.net>
	<20051011142304.GA4756@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051011142304.GA4756@rama.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Harald Welte <laforge@netfilter.org>
Date: Tue, 11 Oct 2005 16:23:04 +0200

> given that discontiguous processor id's seem to be very rare, I think
> it's fine to waste some memory on those few systems by ussing this
> "allocate array from 0 to max smp processor id" approach.

Let's get your patch working first :-)  The original reporter
said that your patch still OOPSes when he tries to start
using iptables.  Didn't you see that?

On thinking about this some more, the duplication of _all_ of this
information per-cpu is quite questionable, at least the "read mostly"
parts that just describe the rules.  The counters make tons of sense,
per cpu, but that's the majority of it.
