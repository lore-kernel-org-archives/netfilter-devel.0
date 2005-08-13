From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/2] make sure event order is correct in
 nf_conntrack
Date: Sun, 14 Aug 2005 02:32:58 +0900 (JST)
Message-ID: <200508131732.j7DHWx1l000454@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Aug_14_02_32_58_2005_600)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
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

----Next_Part(Sun_Aug_14_02_32_58_2005_600)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch synchronize nf_conntrack with ip_conntrack, and moves the event
IPCT_DESTROY to destroy_conntrack() which truly destroys conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
The following sequence is displayed during events dumping of an ICMP
connection: [NEW] [DESTROY] [UPDATE]

This happens because the event IPCT_DESTROY is delivered in
death_by_timeout(), that is called from the icmp protocol helper
(ct->timeout.function) once we see the reply.

To fix this, we move this event to destroy_conntrack().

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Sun_Aug_14_02_32_58_2005_600)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="destroy-order.patch"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -473,6 +473,7 @@ destroy_conntrack(struct nf_conntrack *n
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
 
+	nf_conntrack_event(IPCT_DESTROY, ct);
 	set_bit(IPS_DYING_BIT, &ct->status);
 
 	/* To make sure we don't get any weird locking issues here:
@@ -517,7 +518,6 @@ static void death_by_timeout(unsigned lo
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
 
-	nf_conntrack_event(IPCT_DESTROY, ct);
 	write_lock_bh(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */

----Next_Part(Sun_Aug_14_02_32_58_2005_600)----
