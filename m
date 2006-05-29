From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/17]: conntrack: don't call helpers for related ICMP
	messages
Date: Tue, 30 May 2006 00:34:17 +0200 (MEST)
Message-ID: <20060529223417.24834.49502.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
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

[NETFILTER]: conntrack: don't call helpers for related ICMP messages

None of the existing helpers expects to get called for related ICMP
packets and some even drop them if they can't parse them.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ee0877ce5fb4e72afee68e2c393d86ac64e69afe
tree 56960aeb26e21354aa619d687172541162adcea7
parent ac0eb5fe3ab7b4637f208b8dc79a5446e4d59dea
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:42 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:42 +0200

 net/ipv4/netfilter/ip_conntrack_standalone.c   |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index 929d61f..f0cc7fe 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -417,7 +417,7 @@ static unsigned int ip_conntrack_help(un
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = ip_conntrack_get(*pskb, &ctinfo);
-	if (ct && ct->helper) {
+	if (ct && ct->helper && ctinfo != IP_CT_RELATED + IP_CT_IS_REPLY) {
 		unsigned int ret;
 		ret = ct->helper->help(pskb, ct, ctinfo);
 		if (ret != NF_ACCEPT)
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 5bc9f64..5b43945 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -145,7 +145,7 @@ static unsigned int ipv4_conntrack_help(
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(*pskb, &ctinfo);
-	if (!ct)
+	if (!ct || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY)
 		return NF_ACCEPT;
 
 	help = nfct_help(ct);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 93bae36..2a71c3b 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -189,7 +189,7 @@ static unsigned int ipv6_confirm(unsigne
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(*pskb, &ctinfo);
-	if (!ct)
+	if (!ct || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY)
 		goto out;
 
 	help = nfct_help(ct);
