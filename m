From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/03]: nf_nat: add symbolic dependency on IPv4 conntrack
Date: Mon,  6 Aug 2007 15:29:07 +0200 (MEST)
Message-ID: <20070806132848.17202.86547.sendpatchset@localhost.localdomain>
References: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: add symbolic dependency on IPv4 conntrack

Loading nf_nat causes the conntrack core to be loaded, but we need IPv4 as
well.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b92420f32053da61c90aca8cfae3f9be80b2b472
tree 74d4e99ae728c3ee61d3de72c6e48f4846ea8502
parent 58ff363db6a293220756361af531b11acc5a46e1
author Patrick McHardy <kaber@trash.net> Mon, 06 Aug 2007 15:26:39 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 06 Aug 2007 15:26:39 +0200

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    2 ++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    6 ++++++
 net/ipv4/netfilter/nf_nat_standalone.c         |    2 +-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 7a67160..9bf0598 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -21,4 +21,6 @@ extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 extern int nf_conntrack_ipv4_compat_init(void);
 extern void nf_conntrack_ipv4_compat_fini(void);
 
+extern void need_ipv4_conntrack(void);
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 64552af..d9b5177 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -509,3 +509,9 @@ static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 
 module_init(nf_conntrack_l3proto_ipv4_init);
 module_exit(nf_conntrack_l3proto_ipv4_fini);
+
+void need_ipv4_conntrack(void)
+{
+	return;
+}
+EXPORT_SYMBOL_GPL(need_ipv4_conntrack);
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 332814d..46cc99d 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -328,7 +328,7 @@ static int __init nf_nat_standalone_init(void)
 {
 	int ret = 0;
 
-	need_conntrack();
+	need_ipv4_conntrack();
 
 #ifdef CONFIG_XFRM
 	BUG_ON(ip_nat_decode_session != NULL);
