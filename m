From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 3/3] renames unlink_expect
Date: Wed, 07 Sep 2005 11:09:37 +0900 (JST)
Message-ID: <200509070209.j8729cve008447@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Sep__7_11_09_37_2005_913)--"
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

----Next_Part(Wed_Sep__7_11_09_37_2005_913)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch follows the recent change for ip_conntrack, which kills
__ip_ct_expect_unlink_destroy. In now nf_conntrack doesn't support
nfnetlink and doesn't have it, so this patch just renames unlink_expect
to nf_ct_expect_unlink_destroy.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Wed_Sep__7_11_09_37_2005_913)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-rename-unlink-expect.patch"

[NETFILTER] renames unlink_expect of nf_conntrack

This patch follows the recent change for ip_conntrack, which kills
__ip_ct_expect_unlink_destroy. In now nf_conntrack doesn't support
nfnetlink and doesn't have it, so this patch just renames unlink_expect
to nf_ct_expect_unlink_destroy.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 2dffafb3a639ab945d506885dfbd51a6f1d76aaf
tree a85ab4aa6323d18f96c645ef276f7771287ecba7
parent 58d33a593b1a6baf0ae6ce34ec4ac8c6a867143d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 07 Sep 2005 09:29:51 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 07 Sep 2005 09:29:51 +0900

 net/netfilter/nf_conntrack_core.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -401,7 +401,7 @@ static void expectation_timed_out(unsign
 	struct nf_conntrack_expect *exp = (void *)ul_expect;
 
 	write_lock_bh(&nf_conntrack_lock);
-	unlink_expect(exp);
+	nf_ct_unlink_expect(exp);
 	write_unlock_bh(&nf_conntrack_lock);
 	nf_conntrack_expect_put(exp);
 }
@@ -422,7 +422,7 @@ find_expectation(const struct nf_conntra
 		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
 		    && nf_ct_is_confirmed(i->master)
 		    && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			nf_ct_unlink_expect(i);
 			return i;
 		}
 	}
@@ -440,7 +440,7 @@ static void remove_expectations(struct n
 
 	list_for_each_entry_safe(i, tmp, &nf_conntrack_expect_list, list) {
 		if (i->master == ct && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			nf_ct_unlink_expect(i);
 			nf_conntrack_expect_put(i);
  		}
 	}
@@ -1050,7 +1050,7 @@ void nf_conntrack_unexpect_related(struc
 	/* choose the the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			nf_ct_unlink_expect(i);
 			write_unlock_bh(&nf_conntrack_lock);
 			nf_conntrack_expect_put(i);
 			return;
@@ -1106,7 +1106,7 @@ static void evict_oldest_expect(struct n
 	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
 		if (i->master == master) {
 			if (del_timer(&i->timeout)) {
-				unlink_expect(i);
+				nf_ct_unlink_expect(i);
 				nf_conntrack_expect_put(i);
 			}
 			break;
@@ -1220,7 +1220,7 @@ void nf_conntrack_helper_unregister(stru
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list, list) {
 		if (exp->master->helper == me && del_timer(&exp->timeout)) {
-			unlink_expect(exp);
+			nf_ct_unlink_expect(exp);
 			nf_conntrack_expect_put(exp);
 		}
 	}

----Next_Part(Wed_Sep__7_11_09_37_2005_913)----
