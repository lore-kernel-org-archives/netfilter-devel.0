From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Netfilter Queue
Date: Mon, 2 Feb 2004 13:34:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402021326580.11889-100000@filer.marasystems.com>
References: <200402021208.29583.hess@tkn.tu-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andreas Hess <hess@tkn.tu-berlin.de>
In-Reply-To: <200402021208.29583.hess@tkn.tu-berlin.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2 Feb 2004, Andreas Hess wrote:

> I have written a UDP packet processing kernel module that registers itself to 
> the PREROUTING hook of the Netfilter architecture. Now, each UDP packet that 
> arrives at this hook is passed  to my module. 

Ok.

> As far as I understand it: there are module-specific queues, in which the 
> packets are inserted?

What queues?

Netfilter modules are called inline in the normal packet forwarding of the 
Linux kernel. If your system receives packets faster than it can process 
then packets are dropped.

In most Ethernet drivers there is a relatively small queue between the
interrupt handler and the rest of the kernel. This queue is not related to
Netfilter but part of how the specific drivers work.


The only queue mechanism in netfilter is if your hook function returns
NF_QUEUE as verdict, in which case the packet will be sent to userspace
via ip_queue. I am not sure if there is a queue size limitation or not
when using NF_QUEUE.


Regards
Henrik
