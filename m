From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Quota / SMP / IRQBalance
Date: Thu, 18 Dec 2003 08:04:28 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312180745070.26987-100000@filer.marasystems.com>
References: <0E051BDF2E73C847B9220964CBD1B8F32BC3@EXCHANGE.SHSU.EDU>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "McGuffin, Tim" <UCS_TIM@exchange.shsu.edu>
In-Reply-To: <0E051BDF2E73C847B9220964CBD1B8F32BC3@EXCHANGE.SHSU.EDU>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Dec 2003, McGuffin, Tim wrote:

> On the Dual 800 running Redhat 9 or Fedora Core 1, the quota match is
> completely broken by enabling the irqbalance service.  With irqbalance
> enabled, the box is able to transfer roughly twice the amount of data
> before the quota is exhausted (11437662 bytes out of a 5000000 byte
> quota).

Odd.. from what I can se it should be broken on SMP even without
irqbalance, but maybe irqbalance causes both processors to be used in a
more even fashion making the problem more visible.

The problem is due to the quota match saving the quota counter within the
iptables matchinfo. As this is duplicated per CPU a SMP system gives a
quota up to the number of CPUs times the specified quota and may cause
unwanted packet reordering when the quota is reached on one CPU (packets 
hitting other CPUs may still get accepted).

Btw, iptables -L (and iptables-save) just prints the quota counter from 
CPU #0.

Regards
Henrik
