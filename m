From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH: NF_CONNTRACK 5/6] expectation timeouts are compulsory
Date: Thu, 30 Jun 2005 10:31:29 +0900 (JST)
Message-ID: <200506300131.j5U1VTle029136@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Jun_30_10:31:29_2005_247)--"
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

----Next_Part(Thu_Jun_30_10:31:29_2005_247)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---

     [NETFILTER]: expectation timeouts are compulsory

     Since expectation timeouts were made compulsory [1], there is no need to

     check for them in ip_conntrack_expect_insert.

     [1] https://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018143.html

        Signed-off-by: Phil Oester <kernel@linuxace.com>
        Signed-off-by: Patrick McHardy <kaber@trash.net>
        Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>



----Next_Part(Thu_Jun_30_10:31:29_2005_247)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="05-exp-timeout.patch"

Index: net/netfilter/nf_conntrack_core.c
===================================================================
--- 7c492b3fe4e0c83f4208674b57adb88662a42da7/net/netfilter/nf_conntrack_core.c  (mode:100644)
+++ f871f52dbc341242903410f69bff6c850e4471c4/net/netfilter/nf_conntrack_core.c  (mode:100644)
@@ -1003,15 +1003,11 @@
 	exp->master->expecting++;
 	list_add(&exp->list, &nf_conntrack_expect_list);
 
-	if (exp->master->helper->timeout) {
-		init_timer(&exp->timeout);
-		exp->timeout.data = (unsigned long)exp;
-		exp->timeout.function = expectation_timed_out;
-		exp->timeout.expires
-			= jiffies + exp->master->helper->timeout * HZ;
-		add_timer(&exp->timeout);
-	} else
-		exp->timeout.function = NULL;
+	init_timer(&exp->timeout);
+	exp->timeout.data = (unsigned long)exp;
+	exp->timeout.function = expectation_timed_out;
+	exp->timeout.expires = jiffies + exp->master->helper->timeout * HZ;
+	add_timer(&exp->timeout);
 
 	NF_CT_STAT_INC(expect_create);
 }

----Next_Part(Thu_Jun_30_10:31:29_2005_247)----
