From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/50]: Remove incorrect inline markers
Date: Sat,  7 Jul 2007 14:23:12 +0200 (MEST)
Message-ID: <20070707122228.1589.6450.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Remove incorrect inline markers

device_cmp: the function's address is taken (call to nf_ct_iterate_cleanup)
alloc_null_binding: referenced externally

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 32b9ac8539a493fc11337b5d0a7623a24989aa6b
tree daa49d3f47302c04758e145eca61428ccceb029a
parent a04b76f652ab27c1258a2809630389babf12ada4
author Jan Engelhardt <jengelh@gmx.de> Sat, 07 Jul 2007 12:15:16 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:16 +0200

 net/ipv4/netfilter/ipt_MASQUERADE.c |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 846a0e7..f136ef7 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -109,7 +109,7 @@ masquerade_target(struct sk_buff **pskb,
 	return nf_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static inline int
+static int
 device_cmp(struct nf_conn *i, void *ifindex)
 {
 	const struct nf_conn_nat *nat = nfct_nat(i);
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index fc3d943..ea1a07c 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -172,7 +172,7 @@ static bool ipt_dnat_checkentry(const char *tablename,
 	return true;
 }
 
-inline unsigned int
+unsigned int
 alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 {
 	/* Force range to this IP; let proto decide mapping for
