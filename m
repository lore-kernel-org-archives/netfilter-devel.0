From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Fix wrong order in event notification
Date: Fri, 05 Aug 2005 02:38:12 +0200
Message-ID: <42F2B4F4.2080604@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080403010901020808050409"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------080403010901020808050409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The following sequence is displayed during events dumping of an ICMP 
connection:

[NEW]
[DESTROY]
[UPDATE]

This happens because the event IPCT_DESTROY is delivered in 
death_by_timeout, that is called from the icmp protocol helper 
(ct->timeout.function) once we see the reply.

To fix this, I propose to move this event to destroy_conntrack instead.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--------------080403010901020808050409
Content-Type: text/x-patch;
 name="03destroy-event.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03destroy-event.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-03 16:30:26.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-03 16:32:30.000000000 +0200
@@ -327,6 +327,7 @@
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
 
+	ip_conntrack_event(IPCT_DESTROY, ct);
 	set_bit(IPS_DYING_BIT, &ct->status);
 
 	/* To make sure we don't get any weird locking issues here:
@@ -366,7 +367,6 @@
 {
 	struct ip_conntrack *ct = (void *)ul_conntrack;
 
-	ip_conntrack_event(IPCT_DESTROY, ct);
 	write_lock_bh(&ip_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */

--------------080403010901020808050409--
