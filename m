From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH: NF_CONNTRACK 2/6] Advance seq-file position in
 exp_next_seq()
Date: Thu, 30 Jun 2005 10:30:55 +0900 (JST)
Message-ID: <200506300130.j5U1Uu5i028308@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Jun_30_10:30:55_2005_897)--"
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

----Next_Part(Thu_Jun_30_10:30:55_2005_897)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
        [NETFILTER]: Advance seq-file position in exp_next_seq()

        Signed-off-by: Patrick McHardy <kaber@trash.net>
        Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Jun_30_10:30:55_2005_897)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-advance-seq.patch"

Index: net/netfilter/nf_conntrack_standalone.c
===================================================================
--- 32cce2d444d56a2b6fd30aa4e0f5d2f75f7c6f95/net/netfilter/nf_conntrack_standalone.c  (mode:100644)
+++ 943a81f457fa24df61ea4c6e469854149645aa1c/net/netfilter/nf_conntrack_standalone.c  (mode:100644)
@@ -280,6 +280,7 @@
 {
 	struct list_head *e = v;
 
+	++*pos;
 	e = e->next;
 
 	if (e == &nf_conntrack_expect_list)

----Next_Part(Thu_Jun_30_10:30:55_2005_897)----
