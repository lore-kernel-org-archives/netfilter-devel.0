From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] update raw patch in POM [2.4.x]
Date: Tue, 21 Jun 2005 16:47:40 +0200
Message-ID: <42B8288C.9030004@trash.net>
References: <42A57FC4.7010508@tac.ch>	<42A5B144.3090005@tac.ch>	<42A625DA.7090807@eurodev.net>	<42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>
	<42B81D75.8090205@trash.net> <42B82177.5010101@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42B82177.5010101@tac.ch>
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

Roberto Nibali wrote:
>>Pablo mentioned to me in private mail that he believes the reason
>>is packets holding references to ip_conntrack_untracked on module
>>removal. I agree, and this patch should fix it. Roberto, could
>>you please try it and tell me if it helps?
> 
> 
> I already did. Here's an excerpt of an earlier email in this thread regarding
> this patch:

Hmmm I should have read the whole thread :)

>>--- linux-2.4.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-15
>>
>>>23:16:43.000000000 +0200
>>>+++ linux-2.4/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-17
>>>20:44:18.000000000 +0200
>>>@@ -1391,6 +1391,8 @@
>>> 		schedule();
>>> 		goto i_see_dead_people;
>>> 	}
>>>+	while (atomic_read(&ip_conntrack_untracked.ct_general.use) != 1)
>>>+		schedule();
>>>
>>> 	kmem_cache_destroy(ip_conntrack_cachep);
>>> 	vfree(ip_conntrack_hash);
> 
> 
> 
> This results in an endless loop when calling rmmod ip_conntrack. lsmod shows
> (deleted) but the process is in D state. No oops of course and no hang.
> 
> But I cannot remove the ip_conntrack kernel module anymore. It's "stuck".

This means we're either leaking conntrack entries or packets holding
a reference are queued somewhere. What do you use NOTRACK for?

> Do you want me to rerun the test for more precise statements?

Yes, please make sure no packets are queued in qdiscs (best to use
pfifo) and no raw/packet sockets are open and ip_queue isn't used.
You could also add a printk to the inner body of the
while(atomic_read(...)) loop and print out the reference count, perhaps
it will show something interesting.

Thanks
Patrick
