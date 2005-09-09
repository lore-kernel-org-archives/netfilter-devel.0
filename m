From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] Fix wrong order in event notification
Date: Fri, 09 Sep 2005 17:16:53 +0100
Message-ID: <4321B575.4040009@ufomechanic.net>
References: <42F2B4F4.2080604@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42F2B4F4.2080604@eurodev.net>
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

I want to "backport" this patch to 2.6.11.7 (before IPS_DYING was
invented to help shrink the conntrack struct)

The obvious fixup is below, I just wanted to check that it was safe, and
that sending the event earlier instead of during death by timeout wasn't
also depending on side effects of IPS_DYING


--- net/ipv4/netfilter/ip_conntrack_core.c.orig 2005-09-09
16:57:44.000000000 +0100
+++ net/ipv4/netfilter/ip_conntrack_core.c      2005-09-09
17:01:45.000000000 +0100
@@ -257,6 +257,7 @@
        IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
        IP_NF_ASSERT(!timer_pending(&ct->timeout));

+       ip_conntrack_event(IPCT_DESTROY, ct);
        set_bit(IPS_DESTROYED_BIT, &ct->status);

        /* To make sure we don't get any weird locking issues here:
@@ -304,7 +305,6 @@
 {
        struct ip_conntrack *ct = (void *)ul_conntrack;

-       ip_conntrack_event(IPCT_DESTROY, ct);
        WRITE_LOCK(&ip_conntrack_lock);
        /* Inside lock so preempt is disabled on module removal path.
         * Otherwise we can get spurious warnings. */

Sam


Pablo Neira wrote:

> The following sequence is displayed during events dumping of an ICMP
> connection:
>
> [NEW]
> [DESTROY]
> [UPDATE]
>
> This happens because the event IPCT_DESTROY is delivered in
> death_by_timeout, that is called from the icmp protocol helper
> (ct->timeout.function) once we see the reply.
>
> To fix this, I propose to move this event to destroy_conntrack instead.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
>
>------------------------------------------------------------------------
>
>Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
>===================================================================
>--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-03 16:30:26.000000000 +0200
>+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-03 16:32:30.000000000 +0200
>@@ -327,6 +327,7 @@
> 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
> 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
> 
>+	ip_conntrack_event(IPCT_DESTROY, ct);
> 	set_bit(IPS_DYING_BIT, &ct->status);
> 
> 	/* To make sure we don't get any weird locking issues here:
>@@ -366,7 +367,6 @@
> {
> 	struct ip_conntrack *ct = (void *)ul_conntrack;
> 
>-	ip_conntrack_event(IPCT_DESTROY, ct);
> 	write_lock_bh(&ip_conntrack_lock);
> 	/* Inside lock so preempt is disabled on module removal path.
> 	 * Otherwise we can get spurious warnings. */
>  
>
