From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: 2.6.15-rc2-mm1 problems (get_cpu / NUMA optimizations)
Date: Fri, 25 Nov 2005 03:18:48 +0100
Message-ID: <43867488.1030700@trash.net>
References: <20051123.155603.64967447.davem@davemloft.net>
	<20051124205828.GD31478@sunbeam.de.gnumonks.org>
	<43863A93.2010406@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Dumazet <dada1@cosmosbay.com>
In-Reply-To: <43863A93.2010406@cosmosbay.com>
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

Eric Dumazet wrote:
> Hum... I was not aware that disabling preemption (in get_cpu()) had this 
> effect (ie not allowing to sleep). I was using get_cpu() to bind the 
> thread to the current cpu, maybe there is something better ?

set_cpus_allowed() might work.

> If not, we can zap get_cpu()/pu_cpu() and use raw_smp_processor_id() as 
> a hint only, (and dont care of preemption/cpu migration), as the value 
> is only used as a hint to speedup operations in do_replace(), 
> do_add_counters(), ipt_unregister_table(), translate_table()...

That sounds like a good way. iptables ruleset replacement is and
will always be slow anyway.
