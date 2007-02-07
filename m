From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/15]: ip_tables: remove declaration of non-existant
	ipt_find_target function
Date: Wed,  7 Feb 2007 09:23:09 +0100 (MET)
Message-ID: <20070207082308.27478.52259.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_tables: remove declaration of non-existant ipt_find_target function

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 86f832bd66647a6001f2cc345c4b62f8491bc2c2
tree 5b84eea376220d76faedd4e75f8e5a4452c1e864
parent 5a5812610d318df713ca8b2a63894ceafc503441
author Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:53:13 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:53:13 +0100

 include/linux/netfilter_ipv4/ip_tables.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index fccf4b8..9527296 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -276,9 +276,6 @@ extern int ipt_register_table(struct xt_
 			      const struct ipt_replace *repl);
 extern void ipt_unregister_table(struct xt_table *table);
 
-/* net/sched/ipt.c: Gimme access to your targets!  Gets target->me. */
-extern struct xt_target *ipt_find_target(const char *name, u8 revision);
-
 /* Standard entry. */
 struct ipt_standard
 {
