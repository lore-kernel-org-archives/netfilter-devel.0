From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 8/9]: zero-clear union area in tuple for
 expectant
Date: Mon, 23 May 2005 15:23:21 +0900 (JST)
Message-ID: <200505230623.j4N6NMVu004917@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_15:23:21_2005_365)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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

----Next_Part(Mon_May_23_15:23:21_2005_365)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch clears union area in tuple for expectant.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Mon_May_23_15:23:21_2005_365)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="08-expect.patch"

diff -Nur linux-2.6.12-rc4-nfct-7-nat-seq/net/netfilter/nf_conntrack_core.c linux-2.6.12-rc4-nfct-8-expect/net/netfilter/nf_conntrack_core.c
--- linux-2.6.12-rc4-nfct-7-nat-seq/net/netfilter/nf_conntrack_core.c	2005-05-20 03:18:29.000000000 +0900
+++ linux-2.6.12-rc4-nfct-8-expect/net/netfilter/nf_conntrack_core.c	2005-05-20 03:16:23.000000000 +0900
@@ -987,6 +987,8 @@
 		DEBUGP("expect_related: OOM allocating expect\n");
 		return NULL;
 	}
+	NF_CT_TUPLE_U_BLANK(&new->tuple);
+	NF_CT_TUPLE_U_BLANK(&new->mask);
 	new->master = NULL;
 	return new;
 }

----Next_Part(Mon_May_23_15:23:21_2005_365)----
