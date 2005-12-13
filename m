From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: execution context in netfilter hooks.
Date: Tue, 13 Dec 2005 11:30:15 +0100
Message-ID: <439EA2B7.8020408@eurodev.net>
References: <439C8E74.9070206@libero.it>	<20051212204337.GE3420@sunbeam.de.gnumonks.org>
	<885896af0512130004n1fa1fdt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Giacomo <jacum@libero.it>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Giacomo <delleceste@gmail.com>
In-Reply-To: <885896af0512130004n1fa1fdt@mail.gmail.com>
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

Giacomo wrote:
> A last question:
> 
>  you said LOCAL_OUT is on behalf of process, so it is in process
> context -> can be interrupted by timer -> the reason why code crashed!
> If so, the question would be finally clear!

Some packets traversing LOCAL_OUT can be in process context, those can
be interrupted by timers or whatever interrupt handling. But some others
can be in interrupt context because of retransmissions and other issues.
So, the affirmation: "packets in LOCAL_OUT are in process context" is bogus.

Moreover, you must also worry about preemption, eg. if preemption is
enabled one packet traversing LOCAL_OUT can be preempted by other one
from a process that has more priority. Although it is not recommended to
enable preemption in a server, you'll have to make your code
preemption-safe.

BTW, some people enable preemption in their firewalls because they don't
fully understand the concept. IMO, a firewall won't gain any advanges
from preemption since most of the work will come from interrupt context.

> LOCAL_INPUT instead should be softirq, shouldn't it? Just like
> FORWARD... so timers don't cause interruption..

That's it.

-- 
Pablo
