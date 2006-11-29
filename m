From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/33]: nf_conntrack: remove ASSERT_{READ,WRITE}_LOCK
Date: Wed, 29 Nov 2006 03:08:56 +0100 (MET)
Message-ID: <20061129020856.21082.55668.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: remove ASSERT_{READ,WRITE}_LOCK

Remove the usage of ASSERT_READ_LOCK/ASSERT_WRITE_LOCK in nf_conntrack,
it didn't do anything, it was just an empty define and it uglified the code.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fa685ac2d1dfe17d62464fd28c8151df5d323e47
tree 3f065a78dc8a815cc1456d3d433580580350521a
parent 806420ab0fbfae2bcb4a3942190747afe5809b4d
author Martin Josefsson <gandalf@wlug.westbo.se> Tue, 28 Nov 2006 23:13:01 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:57:08 +0100

 net/netfilter/nf_conntrack_core.c       |    7 -------
 net/netfilter/nf_conntrack_standalone.c |    4 ----
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 73615d3..ab161b7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -47,11 +47,6 @@ #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/socket.h>
 
-/* This rwlock protects the main hash table, protocol/helper/expected
-   registrations, conntrack timers*/
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
@@ -292,7 +287,6 @@ static void
 clean_from_lists(struct nf_conn *ct)
 {
 	DEBUGP("clean_from_lists(%p)\n", ct);
-	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
 	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 	list_del(&ct->tuplehash[IP_CT_DIR_REPLY].list);
 
@@ -371,7 +365,6 @@ __nf_conntrack_find(const struct nf_conn
 	struct nf_conntrack_tuple_hash *h;
 	unsigned int hash = hash_conntrack(tuple);
 
-	ASSERT_READ_LOCK(&nf_conntrack_lock);
 	list_for_each_entry(h, &nf_conntrack_hash[hash], list) {
 		if (nf_ct_tuplehash_to_ctrack(h) != ignored_conntrack &&
 		    nf_ct_tuple_equal(tuple, &h->tuple)) {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 6ebac7d..f87d333 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -29,9 +29,6 @@ #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
 #endif
 
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
@@ -137,7 +134,6 @@ static int ct_seq_show(struct seq_file *
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
 
-	ASSERT_READ_LOCK(&nf_conntrack_lock);
 	NF_CT_ASSERT(conntrack);
 
 	/* we only want to print DIR_ORIGINAL */
