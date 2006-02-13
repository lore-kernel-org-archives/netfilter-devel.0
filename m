From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/3] nf_conntrack: move registration of __nf_ct_attach
Date: Tue, 14 Feb 2006 01:29:27 +0900 (JST)
Message-ID: <200602131629.k1DGTRaq019968@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org, kaber@trash.net, laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename="01-nfct-move-attach.patch"
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

[NETFILTER] nf_conntrack: move registration of __nf_ct_attach

This makes nf_conntrack core module register the callback
"__nf_ct_attach" to "ip_ct_attach".

To avoid double registration by ip_conntrack and nf_conntrack_ipv6,
nf_conntrack_ipv6 didn't register anything to ip_ct_attach. And I would
introduce "ip6_ct_attach" for IPv6 stack. But we never load them together
today and we don't have to worry about such case.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 9fc7cbdd2585028ecba2e55009d1d30605373300
tree e4a5e3c8c5211266b7710778d5273ef9a77b7a94
parent bc15f15e0bffe041dc88a038e9fd15e92829ef70
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 09 Feb 2006 02:18:57 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 09 Feb 2006 02:18:57 +0900

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
