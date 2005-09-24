From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 2/4] add support for permanent expectations
Date: Sat, 24 Sep 2005 19:02:40 +0900 (JST)
Message-ID: <200509241002.j8OA2e4B023496@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Sep_24_19_02_40_2005_711)--"
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

----Next_Part(Sat_Sep_24_19_02_40_2005_711)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This follows ip_conntrack change which introduces permanent expectation.
A permanent expectation exists until timing out and can expect
multiple related connections.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sat_Sep_24_19_02_40_2005_711)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-permanent-exp.patch"

[NETFILTER] add support for permanent expectations to nf_conntrack

This follows ip_conntrack change which introduces permanent expectation.
A permanent expectation exists until timing out and can expect
multiple related connections.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 1dc9382979bbb27e26b83043452e623f7219bf81
tree 374951836b362a87e282ec0088ea22fc885ff857
parent f0a0202390adaeebebce329f36fa654a82c2105b
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 23 Sep 2005 20:04:04 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 23 Sep 2005 20:04:04 +0900

 include/linux/netfilter/nf_conntrack.h |    5 +++++
 net/netfilter/nf_conntrack_core.c      |   12 ++++++++----
 net/netfilter/nf_conntrack_ftp.c       |    1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack.h b/include/linux/netfilter/nf_conntrack.h
--- a/include/linux/netfilter/nf_conntrack.h
+++ b/include/linux/netfilter/nf_conntrack.h
@@ -139,6 +139,9 @@ struct nf_conntrack_expect
 	/* Usage count. */
 	atomic_t use;
 
+	/* Flags */
+	unsigned int flags;
+
 #ifdef CONFIG_NF_NAT_NEEDED
 	/* This is the original per-proto part, used to map the
 	 * expected connection the way the recipient expects. */
@@ -148,6 +151,8 @@ struct nf_conntrack_expect
 #endif
 };
 
+#define NF_CT_EXPECT_PERMANENT 0x1
+
 static inline struct nf_conn *
 nf_ct_tuplehash_to_ctrack(const struct nf_conntrack_tuple_hash *hash)
 {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -420,10 +420,14 @@ find_expectation(const struct nf_conntra
 	   master ct never got confirmed, we'd hold a reference to it
 	   and weird things would happen to future packets). */
 		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
-		    && nf_ct_is_confirmed(i->master)
-		    && del_timer(&i->timeout)) {
-			nf_ct_unlink_expect(i);
-			return i;
+		    && nf_ct_is_confirmed(i->master)) {
+			if (i->flags & NF_CT_EXPECT_PERMANENT) {
+				atomic_inc(&i->use);
+				return i;
+			} else if (del_timer(&i->timeout)) {
+				nf_ct_unlink_expect(i);
+				return i;
+			}
 		}
 	}
 	return NULL;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -592,6 +592,7 @@ static int help(struct sk_buff **pskb,
 	}
 
 	exp->expectfn = NULL;
+	exp->flags = 0;
 
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */

----Next_Part(Sat_Sep_24_19_02_40_2005_711)----
