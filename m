From: "David S. Miller" <davem@davemloft.net>
Subject: Re: num_possible_cpus() usage in iptables
Date: Mon, 10 Oct 2005 17:27:28 -0700 (PDT)
Message-ID: <20051010.172728.72244069.davem@davemloft.net>
References: <20051009.204734.30319051.davem@davemloft.net>
	<434A08DF.5090402@cosmosbay.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dada1@cosmosbay.com
In-Reply-To: <434A08DF.5090402@cosmosbay.com>
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

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Mon, 10 Oct 2005 08:23:27 +0200

> My previous patch ([PATCH 3/3] netfilter : 3 patches to boost ip_tables 
> performance) addressed this problem.
> 
> http://marc.theaimsgroup.com/?l=linux-netdev&m=112733887410796&w=2

Long term this is the kind of thing we should be doing.

But for 2.6.14, I would like to suggest that we revert back
to using NR_CPUS as that is the simplest fix for this bug.

I even spent part of this afternoon investigating other kinds of
fixes, and all of them have possible non-trivial regressions.

Yes, using NR_CPUS wastes a lot of ram, but it fixes this
bug in a straightforward and easy to verify fashion.

Comments?
