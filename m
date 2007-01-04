From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/05]: nf_nat: fix MASQUERADE crash on device down
Date: Thu,  4 Jan 2007 19:38:25 +0100 (MET)
Message-ID: <20070104183825.18369.29920.sendpatchset@localhost.localdomain>
References: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: fix MASQUERADE crash on device down

Check the return value of nfct_nat() in device_cmp(), we might very well
have non NAT conntrack entries as well (Netfilter bugzilla #528).

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 36263425185d6993ca8af49ad6e7d1af66846d9c
tree 99089b7efc4c5c76d7afdc07f82537b9c525a799
parent d137d1a8688da1e81415c8a6a33d283210408bf0
author Martin Josefsson <gandalf@wlug.westbo.se> Thu, 04 Jan 2007 19:25:56 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 04 Jan 2007 19:25:56 +0100

 net/ipv4/netfilter/ipt_MASQUERADE.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 28b9233..d669685 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -127,10 +127,13 @@ #endif
 static inline int
 device_cmp(struct ip_conntrack *i, void *ifindex)
 {
+	int ret;
 #ifdef CONFIG_NF_NAT_NEEDED
 	struct nf_conn_nat *nat = nfct_nat(i);
+
+	if (!nat)
+		return 0;
 #endif
-	int ret;
 
 	read_lock_bh(&masq_lock);
 #ifdef CONFIG_NF_NAT_NEEDED
