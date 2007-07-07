From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 23/50]: nf_conntrack_extend: use __read_mostly for
	struct nf_ct_ext_type
Date: Sat,  7 Jul 2007 14:23:34 +0200 (MEST)
Message-ID: <20070707122249.1589.28076.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_extend: use __read_mostly for struct nf_ct_ext_type

Also make them static.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit baa1fb29b43978190d2c3338d4fd558325f955ab
tree 6f59f4a6ad671801308b748889805f09dddfb745
parent 2f2bd54e891a73950d8b8fd8c625ed7ac5d2c0f8
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:37 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:37 +0200

 net/ipv4/netfilter/nf_nat_core.c    |    2 +-
 net/netfilter/nf_conntrack_helper.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 7e31777..04691ed 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -623,7 +623,7 @@ static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
 	write_unlock_bh(&nf_nat_lock);
 }
 
-struct nf_ct_ext_type nat_extend = {
+static struct nf_ct_ext_type nat_extend __read_mostly = {
 	.len		= sizeof(struct nf_conn_nat),
 	.align		= __alignof__(struct nf_conn_nat),
 	.destroy	= nf_nat_cleanup_conntrack,
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6d32399..dc352f5 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -145,7 +145,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
-struct nf_ct_ext_type helper_extend = {
+static struct nf_ct_ext_type helper_extend __read_mostly = {
 	.len	= sizeof(struct nf_conn_help),
 	.align	= __alignof__(struct nf_conn_help),
 	.id	= NF_CT_EXT_HELPER,
