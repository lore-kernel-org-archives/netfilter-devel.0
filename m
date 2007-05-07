From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/5]: nf_conntrack: Removes duplicated declarations
Date: Mon, 07 May 2007 12:00:41 +0900 (JST)
Message-ID: <200705070300.l4730fAv016222@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


These are also in include/net/netfilter/nf_conntrack_helper.h

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/nf_conntrack.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 1c6b8bd..4732432 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -183,13 +183,6 @@ extern void nf_conntrack_hash_insert(str
 
 extern void nf_conntrack_flush(void);
 
-extern struct nf_conntrack_helper *
-nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple);
-extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
-
-extern struct nf_conntrack_helper *
-__nf_conntrack_helper_find_byname(const char *name);
-
 extern int nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
 				const struct nf_conntrack_tuple *orig);
 
-- 
1.4.4
