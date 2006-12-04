From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/05]: nf_conntrack: fix warning in PPTP helper
Date: Mon,  4 Dec 2006 11:56:00 +0100 (MET)
Message-ID: <20061204105910.6456.77379.sendpatchset@localhost.localdomain>
References: <20061204105906.6456.62345.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061204105906.6456.62345.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: fix warning in PPTP helper

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b8ef637f630bc2206673170e07800a8e537f95d8
tree 7bf34146e21f397f7b58d81e9baf02912cae5ef0
parent 5b7e23ebb667b2bf890844be31e46502c5b146d6
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 04 Dec 2006 11:30:09 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 04 Dec 2006 11:30:09 +0100

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
