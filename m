From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/04]: arp_tables: fix userspace compilation
Date: Wed, 10 Jan 2007 08:04:50 +0100 (MET)
Message-ID: <20070110070450.13495.10693.sendpatchset@localhost.localdomain>
References: <20070110070444.13495.95670.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
In-Reply-To: <20070110070444.13495.95670.sendpatchset@localhost.localdomain>
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

[NETFILTER]: arp_tables: fix userspace compilation

The included patch translates arpt_counters to xt_counters, making
userspace arptables compile against recent kernels.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9c6b7b0317c24d820352a7dbb1c3ba1014419df3
tree 55ed35499dc2a34c6201732013f16e9300fbdf4f
parent c209c563107b15f3c452266b5c2e5bd0fa75a470
author Bart De Schuymer <bdschuym@pandora.be> Wed, 10 Jan 2007 05:44:34 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 10 Jan 2007 05:44:34 +0100

 include/linux/netfilter_arp/arp_tables.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 0be2354..24c8786 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -190,6 +190,7 @@ struct arpt_replace
 
 /* The argument to ARPT_SO_ADD_COUNTERS. */
 #define arpt_counters_info xt_counters_info
+#define arpt_counters xt_counters
 
 /* The argument to ARPT_SO_GET_ENTRIES. */
 struct arpt_get_entries
