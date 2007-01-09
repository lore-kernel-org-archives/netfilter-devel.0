From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/04]: arp_tables: fix userspace compilation
Date: Tue,  9 Jan 2007 17:29:55 +0100 (MET)
Message-ID: <20070109162955.6229.99595.sendpatchset@localhost.localdomain>
References: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
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
commit 21f6325bc6e8e439cafcdc8d114d3c72743374a3
tree 126ad258b5e36580be61697979a76cc035b0e588
parent 9a70cbbeb7bfa5194411b8a65b5c6372b93fa99d
author Bart De Schuymer <bdschuym@pandora.be> Tue, 09 Jan 2007 12:01:42 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 09 Jan 2007 12:01:42 +0100

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
