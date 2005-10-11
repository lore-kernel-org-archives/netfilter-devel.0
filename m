From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 15:54:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510111550170.2575@filer.marasystems.com>
References: <20051010164141.GG5627@rama>
	<20051010.141518.60492651.davem@davemloft.net>
	<20051010214619.GJ5627@rama>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051010214619.GJ5627@rama>
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

On Mon, 10 Oct 2005, Harald Welte wrote:

> I don't know why they are incomplete ;)  My guess is that they're mostly
> targeted to per_cpu users.  Basically to solve the 'iptables' problem,
> there are two ways:

Or three.

   3) Keep an NUM_CPUS array of pointers to the per-cpu tables, allocated 
separately per CPU instead of allocating a single large blob for all CPUs. 
These pointers are updated using RCU, and indexed using the physical CPU 
id.

Cost: One (most likely cached) indirect memory access on each packet, and 
slightly more complex update procedure (num_possible_cpus allocations and 
pointers to update instead of just one).

Regards
Henrik
