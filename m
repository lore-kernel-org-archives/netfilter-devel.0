From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK]: fixed the bug that conntrack becomes its
 master.
Date: Thu, 17 Mar 2005 04:02:05 +0900 (JST)
Message-ID: <200503161902.j2GJ26J2028676@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Mar_17_04:02:05_2005_460)--"
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
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

----Next_Part(Thu_Mar_17_04:02:05_2005_460)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Patrick,

This patch for nf_conntrack fixes a shameful bug that conntrack becomes
its master.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

Regards,

----Next_Part(Thu_Mar_17_04:02:05_2005_460)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="fix-master.patch"

Index: linux-2.6/net/netfilter/nf_conntrack_core.c
===================================================================
--- linux-2.6/net/netfilter/nf_conntrack_core.c	(revision 3776)
+++ linux-2.6/net/netfilter/nf_conntrack_core.c	(working copy)
@@ -761,7 +761,7 @@
 			conntrack, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
 		__set_bit(NF_S_EXPECTED_BIT, &conntrack->status);
-		conntrack->master = conntrack;
+		conntrack->master = exp->master;
 #if CONFIG_NF_CONNTRACK_MARK
 		conntrack->mark = exp->master->mark;
 #endif

----Next_Part(Thu_Mar_17_04:02:05_2005_460)----
