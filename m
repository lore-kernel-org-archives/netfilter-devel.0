From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/4] forgotten renaming unlink_expect
Date: Sat, 24 Sep 2005 19:02:54 +0900 (JST)
Message-ID: <200509241002.j8OA2sCc023551@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Sep_24_19_02_54_2005_706)--"
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

----Next_Part(Sat_Sep_24_19_02_54_2005_706)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


I renamed unlink_expect to nf_ct_unlink_expect but it wasn't perfect.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sat_Sep_24_19_02_54_2005_706)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-unlink-exp.patch"

[NETFILTER] forgotten renaming unlink_expect in nf_conntrack

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit f0a0202390adaeebebce329f36fa654a82c2105b
tree 8f808e0540ced573026d2d7d6c7e1d211426ca58
parent d580daa8a08dbf05fc9ed443cd4ba09a7d270e12
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 23 Sep 2005 19:57:04 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 23 Sep 2005 19:57:04 +0900

 net/netfilter/nf_conntrack_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -386,7 +386,7 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 }
 
 /* nf_conntrack_expect helper functions */
-static void unlink_expect(struct nf_conntrack_expect *exp)
+static void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 {
 	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
 	NF_CT_ASSERT(!timer_pending(&exp_timeout));

----Next_Part(Sat_Sep_24_19_02_54_2005_706)----
