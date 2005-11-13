From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/4] fix leak of fragment queue at unloading
 nf_conntrack_ipv6
Date: Sun, 13 Nov 2005 17:50:42 +0900 (JST)
Message-ID: <200511130850.jAD8ohX5026342@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Nov_13_17_50_42_2005_535)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
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

----Next_Part(Sun_Nov_13_17_50_42_2005_535)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This makes nf_conntrack_ipv6 free all IPv6 fragment queues at unloading.
This also check inconsistency between memory tracking and actual usage
to avoid endless loop at eviction.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Sun_Nov_13_17_50_42_2005_535)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-nfct-reasm-leak.patch"

[NETFILTER] fix leak of fragment queue at unloading nf_conntrack_ipv6

This makes nf_conntrack_ipv6 free all IPv6 fragment queues at unloading.
This also check inconsistency between memory tracking and actual usage
to avoid endless loop at eviction.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit c233efcbadfe21a7909bd0c24ea16b9084f0c0f4
tree 77891f23db93aa8b3bf243229a5e2f104da44b27
parent 52282bc26fc11ea1b1ccc669e5a50594a1ec0197
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 13:37:23 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 13:37:23 +0900

 net/ipv6/netfilter/nf_conntrack_reasm.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index aea37cd..587293b 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -259,6 +259,12 @@ static void nf_ct_frag6_evictor(void)
 			return;
 		}
 		tmp = nf_ct_frag6_lru_list.next;
+		if (tmp == NULL) {
+			if (net_ratelimit())
+				printk(KERN_ERR
+				       "nf_ct_reasm: no queue to be evicted");
+			return;
+		}
 		fq = list_entry(tmp, struct nf_ct_frag6_queue, lru_list);
 		atomic_inc(&fq->refcnt);
 		read_unlock(&nf_ct_frag6_lock);
@@ -868,5 +874,6 @@ int nf_ct_frag6_init(void)
 void nf_ct_frag6_cleanup(void)
 {
 	del_timer(&nf_ct_frag6_secret_timer);
+	nf_ct_frag6_low_thresh = 0;
 	nf_ct_frag6_evictor();
 }

----Next_Part(Sun_Nov_13_17_50_42_2005_535)----
