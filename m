From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/2] nf_conntrack: Fix warning of pptp helper
Date: Mon, 04 Dec 2006 09:38:11 +0900 (JST)
Message-ID: <200612040038.kB40cCd5003827@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/linux/netfilter/nf_conntrack_pptp.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index fb049ec..9d8144a 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_PPTP_H
 #define _NF_CONNTRACK_PPTP_H
 
+#include <linux/netfilter/nf_conntrack_common.h>
+
 /* state of the control session */
 enum pptp_ctrlsess_state {
 	PPTP_SESSION_NONE,			/* no session present */
@@ -295,7 +297,6 @@ union pptp_ctrl_union {
 /* crap needed for nf_conntrack_compat.h */
 struct nf_conn;
 struct nf_conntrack_expect;
-enum ip_conntrack_info;
 
 extern int
 (*nf_nat_pptp_hook_outbound)(struct sk_buff **pskb,
-- 
1.4.4
