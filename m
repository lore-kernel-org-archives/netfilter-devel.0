From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/12]: H.323 helper: change EXPORT_SYMBOL to
	EXPORT_SYMBOL_GPL
Date: Thu,  6 Apr 2006 12:05:00 +0200 (MEST)
Message-ID: <20060406100500.17409.42955.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
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

[NETFILTER]: H.323 helper: change EXPORT_SYMBOL to EXPORT_SYMBOL_GPL

Signed-off-by: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3c1284349cc00613a738dbd582e6096236c4a44e
tree d62e9e0c5af6c4efa448c7650642182cbb5a6418
parent 02fe897a46c3da14bab9fafeaa99692da6ae7fc1
author Jing Min Zhao <zhaojingmin@users.sourceforge.net> Thu, 06 Apr 2006 11:41:27 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:41:27 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index fc817fd..83140d2 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -1711,18 +1711,17 @@ static int __init init(void)
 module_init(init);
 module_exit(fini);
 
-EXPORT_SYMBOL(get_h245_addr);
-EXPORT_SYMBOL(get_h225_addr);
-EXPORT_SYMBOL(ip_conntrack_h245_expect);
-EXPORT_SYMBOL(ip_conntrack_q931_expect);
-EXPORT_SYMBOL(set_h245_addr_hook);
-EXPORT_SYMBOL(set_h225_addr_hook);
-EXPORT_SYMBOL(set_sig_addr_hook);
-EXPORT_SYMBOL(set_ras_addr_hook);
-EXPORT_SYMBOL(nat_rtp_rtcp_hook);
-EXPORT_SYMBOL(nat_t120_hook);
-EXPORT_SYMBOL(nat_h245_hook);
-EXPORT_SYMBOL(nat_q931_hook);
+EXPORT_SYMBOL_GPL(get_h225_addr);
+EXPORT_SYMBOL_GPL(ip_conntrack_h245_expect);
+EXPORT_SYMBOL_GPL(ip_conntrack_q931_expect);
+EXPORT_SYMBOL_GPL(set_h245_addr_hook);
+EXPORT_SYMBOL_GPL(set_h225_addr_hook);
+EXPORT_SYMBOL_GPL(set_sig_addr_hook);
+EXPORT_SYMBOL_GPL(set_ras_addr_hook);
+EXPORT_SYMBOL_GPL(nat_rtp_rtcp_hook);
+EXPORT_SYMBOL_GPL(nat_t120_hook);
+EXPORT_SYMBOL_GPL(nat_h245_hook);
+EXPORT_SYMBOL_GPL(nat_q931_hook);
 
 MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");
 MODULE_DESCRIPTION("H.323 connection tracking helper");
