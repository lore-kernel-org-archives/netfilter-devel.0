From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] use 32bit counters for connection-based accounting
Date: Sun, 09 Oct 2005 21:45:38 -0700 (PDT)
Message-ID: <20051009.214538.23725682.davem@davemloft.net>
References: <20051007105451.GE4719@rama>
	<20051007.132619.129111295.davem@davemloft.net>
	<20051007220435.GJ4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051007220435.GJ4450@rama.customers.eurospot.com>
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
Date: Sat, 8 Oct 2005 00:04:35 +0200

> > Is there a truly strong reason to shrink them to be 32-bits?
> 
> Because we now can do better (by signalling the event and having
> userspace accounting daemon take care of it) while not wasting
> rediculous amounts of memory.  I mean, everywhere we try to make struct
> ip_conntrack smaller (similar to the skb diet), and those 64bit counters
> are really large.  We need four of them.  Yes, they're only present if
> you actually enable CONNTRACK_ACCT.  But like we all know, most people
> (and esp. distributions) will just enable them - at least as soon as
> ulogd2 (or even other accounting daemons) are finished.  ulogd2 is
> almost there, so I think it can be released when 2.6.14 final hits the
> road.

I'm convinced, so I'll apply the patch.

It's just that we've had problems upgrading from 32-bit to 64-bit
counters in other areas of the networking, some of which have still
not occurred, such that this change felt like a regression :-)

Anyways, like I said, I'll apply it :)
