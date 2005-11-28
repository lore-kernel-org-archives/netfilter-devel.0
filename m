From: Giacomo Strangolino <giacomo.strangolino@elettra.trieste.it>
Subject: irq problems?
Date: Mon, 28 Nov 2005 14:44:22 +0100
Message-ID: <438B09B6.2080700@elettra.trieste.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Good morning.
I wrote a simple packet filter in kernel space.
I register with netfilter hooks and then i process
packets in input, output, forward, pre, post.

For rules and internal structures i use linked lists with read_lock_bh / 
write_lock_bh to protect concurrency, since there are timers which, at 
timeout, delete entries in lists.

All works fine, but sometimes when i unplug video cable from graphic 
card system hangs.
Sometimes this happens after unloading my modules, but this happens more 
frequently when my  filter is running.

Can it be an issue related to my work?
Perhaps could it be an interrupt raised by
network card which i should protect code from?
Should i disable hw interrupts?

What can be wrong, any idea?

Thanks a lot!

Giacomo

www.giacomos.it/ipfire
