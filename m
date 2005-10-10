From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Mon, 10 Oct 2005 15:06:23 -0700 (PDT)
Message-ID: <20051010.150623.94217913.davem@davemloft.net>
References: <20051010.141518.60492651.davem@davemloft.net>
	<434AE017.2020905@trash.net> <434AE28B.2070607@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <434AE28B.2070607@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 10 Oct 2005 23:52:11 +0200

> I don't know which other architectures are affected by this, but for
> the case Dave mentioned some function
> 
> static inline int cpu_physical_id(void)
> {
> 	return smp_processor_id() >> 1;
> }
> 
> should also solve the problem. Even if not as easily implementable
> as this. it looks like a logical complement to num_possible_cpus().

Stop papering around this issue, please. :-)

The cpu ID space is discontiguous, period.

If you need to allocate per-cpu data there are very straightforward
ways to do this.  Many other subsystems do this in an error free
manner and I think netfilter iptables can do it too. :)
