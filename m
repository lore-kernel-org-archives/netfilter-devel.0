From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/08]: nf_conntrack: Increment error count on parsing
	IPv4 header
Date: Sat, 14 Jul 2007 17:12:35 +0200 (MEST)
Message-ID: <20070714151151.9829.28661.sendpatchset@localhost.localdomain>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: Increment error count on parsing IPv4 header

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 95f7e72287ad5133bfefdf16cba3f6a1afb1ddb1
tree 1afb502056db9c764bbaf70db92f04e51e41d769
parent d84fbb3afb83c70385ccd341c2c4ed3b795c3963
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 14 Jul 2007 17:02:08 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 14 Jul 2007 17:02:08 +0200

 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 --
 net/netfilter/nf_conntrack_core.c              |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 89e20ab..b5c4bb5 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -131,8 +131,6 @@ ipv6_prepare(struct sk_buff **pskb, unsigned int hooknum, unsigned int *dataoff,
 	 */
 	if ((protoff < 0) || (protoff > (*pskb)->len)) {
 		pr_debug("ip6_conntrack_core: can't find proto in pkt\n");
-		NF_CT_STAT_INC_ATOMIC(error);
-		NF_CT_STAT_INC_ATOMIC(invalid);
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3d14110..b730413 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -625,6 +625,8 @@ nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff **pskb)
 
 	if ((ret = l3proto->prepare(pskb, hooknum, &dataoff, &protonum)) <= 0) {
 		pr_debug("not prepared to track yet or error occured\n");
+		NF_CT_STAT_INC_ATOMIC(error);
+		NF_CT_STAT_INC_ATOMIC(invalid);
 		return -ret;
 	}
 
