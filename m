From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/04]: ipt_DNAT: accept port randomization option
Date: Thu,  3 May 2007 03:25:57 +0200 (MEST)
Message-ID: <20070503012439.12818.28836.sendpatchset@localhost.localdomain>
References: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_DNAT: accept port randomization option

Also accept the --random option for DNAT to allow randomly selecting a
destination port from the given range.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 316258f1e782f387bcd01fd81d673aaeec24b8dc
tree 99e75850f1927d958ee195cb9294f8b6b15302f9
parent dc87c3985e9b442c60994308a96f887579addc39
author Patrick McHardy <kaber@trash.net> Wed, 02 May 2007 16:17:22 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 02 May 2007 16:17:22 +0200

 net/ipv4/netfilter/nf_nat_rule.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 2a28339..2534f71 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -226,10 +226,6 @@ static int ipt_dnat_checkentry(const char *tablename,
 		printk("DNAT: multiple ranges no longer supported\n");
 		return 0;
 	}
-	if (mr->range[0].flags & IP_NAT_RANGE_PROTO_RANDOM) {
-		printk("DNAT: port randomization not supported\n");
-		return 0;
-	}
 	return 1;
 }
 
