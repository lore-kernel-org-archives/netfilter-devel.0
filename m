From: Damon Gray <dgray@internap.com>
Subject: when is checkentry/destroy called
Date: Fri, 22 Jul 2005 17:39:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0507221726470.26736@dgray-test.acs.internap.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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


In the match module I'm developing I am seeing the checkentry and the 
destroy "methods" being called for each entry every time a new iptables 
rule is added or deleting in the chain. Is this correct?

To get a better idea of what is going on. I have a match module that 
obviously has checkentry and destroy methods. For debugging, both output a 
printk every time they are called.

  1. insert rule with a match using my module
     see printk that checkentry was called

  2. insert or delete another rule (without my module) in the same chain
     see printk that checkentry was called again (given a different
         matchinfo pointer)
     see printk that destroy was called on the old rule

This seems bad to me, especially since many match modules may allocate or 
deallocate memory in the checkentry and destroy methods. It makes it seem 
like every time *anything* is added or deleted in a chain the whole chain 
gets all new entries. Maybe this is how it has always been and I just 
didn't notice, but I hope not. :)

iptables 1.3.2
kernel 2.6.11.7

-Damon-
