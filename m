From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: using ip_queue in kernel space
Date: Thu, 4 Mar 2004 23:56:47 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403042353310.30943-100000@filer.marasystems.com>
References: <Pine.LNX.4.56L0.0403041712040.12794@zero.fdns.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Unit Zero <onyx@zero.fdns.net>
In-Reply-To: <Pine.LNX.4.56L0.0403041712040.12794@zero.fdns.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 4 Mar 2004, Unit Zero wrote:

> I've been curious for a while about the viability of using ip_queue from 
> a kernel module, without any userland side. It seems that ip_queue is 
> really only used for deferring the verdict on packets to a userspace 
> program

This is the purpose of the ip_queue module yes, but another QUEUE handlers
may be installed if you prefer differently.

QUEUE is a function of netfilter to defer the verdict of a packet.

ip_queue is a QUEUE handler communicating to userspace to get the 
verdirct.

As long as your QUEUE handler follows the defined API for QUEUE handlers 
it should work. Netfilter does not care what the QUEUE handler does, only 
that there is a handler and how/when it returns the verdict.

Regards
Henrik
