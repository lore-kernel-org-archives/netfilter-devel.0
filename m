From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix conntrack iteration.
Date: Sat, 25 Dec 2004 15:32:24 +0100
Message-ID: <41CD79F8.5060003@trash.net>
References: <1103888157.4000.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1103888157.4000.2.camel@localhost.localdomain>
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

Rusty Russell wrote:
> Found this bug while searching for another.  Potential crash on unload
> (unlikely though, unless packets are queued).
> 
> Name: Fix ip_ct_selective_cleanup(), and rename ip_ct_iterate_cleanup()
> Status: Tested under nfsim
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Several places use ip_ct_selective_cleanup() as a general iterator,
> which it was not intended for (it takes a const ip_conntrack *).  So
> rename it, and make it take a non-const argument.
> 
> Also, it missed unconfirmed connections, which aren't in the hash
> table.  This introduces a potential problem for users which expect to
> iterate all connections (such as the helper deletion code).  So keep a
> linked list of unconfirmed connections as well.
> 
> Index: linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_nat_core.c
> ===================================================================
> --- linux-2.6.10-rc3-bk16-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2004-12-24 22:11:43.372205240 +1100
> +++ linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2004-12-24 22:15:18.980427808 +1100
> @@ -298,9 +299,13 @@
>  		ip_conntrack_destroyed(ct);
>  
>  	WRITE_LOCK(&ip_conntrack_lock);
> -	/* Make sure don't leave any orphaned expectations lying around */
> -	if (ct->expecting)
> -		remove_expectations(ct, 1);
> +	BUG_ON(ct->expecting);

This doesn't look right. The call to remove_expectations was
added to deal with the TFTP helper registering expectations
for unconfirmed connections.

Testcase from Phil Oester, who tracked down the problem:
--------
on a:
   iptables -I INPUT -p udp --dport 69 -j DROP

on b:
   tftp -c get a:foo

The expect is setup by the tftp helper, but the master conntrack is not
confirmed.  Instead, the master is immediately sent to 
destroy_conntrack. Whoops!  We've now got an orphaned expectation which 
will not go away (ever!).
--------

Regards
Patrick
