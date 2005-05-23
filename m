From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: fix for conntrack match
Date: Mon, 23 May 2005 18:17:41 +0900 (JST)
Message-ID: <200505230917.j4N9HftW026181@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_18:17:41_2005_915)--"
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

----Next_Part(Mon_May_23_18:17:41_2005_915)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

This patch fixes the bug that --ctstate NONE doesn't match conntrack which
have no state.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_May_23_18:17:41_2005_915)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="fix-ipt_conntrack.patch"

Index: net/ipv4/netfilter/ipt_conntrack.c
===================================================================
--- ec1d95eb1e03e320fc5eb5cfb40379f2f4a7267d/net/ipv4/netfilter/ipt_conntrack.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ipt_conntrack.c  (mode:100644)
@@ -83,7 +83,9 @@
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_STATUS) {
-		if (!ct || FWINV((ct->status & sinfo->statusmask) == 0, IPT_CONNTRACK_STATUS))
+		if (!ct || FWINV((ct->status & sinfo->statusmask) == 0 &&
+				 (ct->status | sinfo->statusmask) != 0,
+				 IPT_CONNTRACK_STATUS))
 			return 0;
 	}
 

----Next_Part(Mon_May_23_18:17:41_2005_915)----
