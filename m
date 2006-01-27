From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: [PATCH] x_tables : Use SMP friendly (percpu) rwlock_t to
 protect x_tables
Date: Fri, 27 Jan 2006 07:37:21 -0800
Message-ID: <20060127073721.1888808f@localhost.localdomain>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<43C247CF.2000608@cosmosbay.com> <43DA393F.6010801@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Dumazet <dada1@cosmosbay.com>
In-Reply-To: <43DA393F.6010801@cosmosbay.com>
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

On Fri, 27 Jan 2006 16:16:15 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> This patch helps scalability of x_tables on SMP, especially NUMA machines.
> 
> Instead of using a single rwlock_t to protect x_tables, use an array of 
> rwlock_t, one for each possible cpu in the machine.
> 
> 1) No more cache line ping pongs between cpus. read_lock_bh(&table->lock) / 
> read_unlock_bh(&table->lock) were still expensive because of the very hot 
> central rwlock.
> 
> 2) get_counters() is more latency friendly than before (we lock each sub table 
> one at a time instead of the full x_tables)
> 
> 3) When a replace of table must be done, the 'writer' have to write_lock_bh() 
> all the locks of the array. This is 'expensive' but seldom done (underlying 
> vmalloc/copy_from_user costs are more expensive anyway)
> 
> This patch was tested on a 4 way Opteron machine, two gigabit links, with 
> rather complex iptables rules (around 200 rules) and gives excellent results 
> so far.
> 
> 
> Thank you
> Eric Dumazet
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> 

You just reinvented brlock.  Figure out how to use atomic operations and/or RCU
and you will do even better.
