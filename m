From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Mon, 10 Oct 2005 23:52:11 +0200
Message-ID: <434AE28B.2070607@trash.net>
References: <20051010164141.GG5627@rama>	<20051010.141518.60492651.davem@davemloft.net>
	<434AE017.2020905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <434AE017.2020905@trash.net>
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

Patrick McHardy wrote:
> David S. Miller wrote:
> 
>>From: Harald Welte <laforge@netfilter.org>
>>Date: Mon, 10 Oct 2005 18:41:41 +0200
>>
>>Why don't any of the existing interfaces on cpumasks and numbers
>>provide what you need here?  Perhaps this routine you are adding
>>(highest_processor_id()) belongs in linux/cpumask.h?  Perhaps
>>named something like "highest_possible_processor_id()" to be
>>consistent with the "num_possible_cpus()" naming?
> 
> 
> Even better would be a function returning the CPU ID as "physical"
> ID, skipping holes in the space. This would allow to save the memory
> for unused CPU IDs. Maybe a small table mapping "virtual" to "phyiscal"
> IDs?

I don't know which other architectures are affected by this, but for
the case Dave mentioned some function

static inline int cpu_physical_id(void)
{
	return smp_processor_id() >> 1;
}

should also solve the problem. Even if not as easily implementable
as this. it looks like a logical complement to num_possible_cpus().
