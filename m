From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/05]: nf_conntrack: move registration of __nf_ct_attach
Date: Thu, 16 Feb 2006 00:00:29 +0100 (MET)
Message-ID: <20060215230029.25078.58330.sendpatchset@localhost.localdomain>
References: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: move registration of __nf_ct_attach

Move registration of __nf_ct_attach to nf_conntrack_core to make it usable
for IPv6 connection tracking as well.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cb4fe8d7dc75acc6aa0f3ac21b286a3e2f8bc492
tree 1e24f1628e341fa43c4972f347ab54aee1196aa1
parent 1a99739a0044eae74cc17a6ae168bb30b49932d8
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 15 Feb 2006 11:01:49 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 15 Feb 2006 11:01:49 +0100

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    5 -----
 net/netfilter/nf_conntrack_core.c              |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 167619f..6c8624a 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -529,15 +529,10 @@ static int init_or_cleanup(int init)
 		goto cleanup_localinops;
 	}
 #endif
-
-	/* For use by REJECT target */
-	ip_ct_attach = __nf_conntrack_attach;
-
 	return ret;
 
  cleanup:
 	synchronize_net();
-	ip_ct_attach = NULL;
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(nf_ct_ipv4_sysctl_header);
  cleanup_localinops:
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0ce337a..d622ddf 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1556,6 +1556,8 @@ void nf_conntrack_cleanup(void)
 {
 	int i;
 
+	ip_ct_attach = NULL;
+
 	/* This makes sure all current packets have passed through
 	   netfilter framework.  Roll on, two-stage module
 	   delete... */
@@ -1715,6 +1717,9 @@ int __init nf_conntrack_init(void)
 		nf_ct_l3protos[i] = &nf_conntrack_generic_l3proto;
         write_unlock_bh(&nf_conntrack_lock);
 
+	/* For use by REJECT target */
+	ip_ct_attach = __nf_conntrack_attach;
+
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */
 	atomic_set(&nf_conntrack_untracked.ct_general.use, 1);
