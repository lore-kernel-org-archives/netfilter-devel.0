From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 08/11] Remove ASSERT_{READ,WRITE}_LOCK
Date: Wed, 01 Nov 2006 22:08:53 +0100
Message-ID: <20061101210914.306515682@wlug.westbo.se>
References: <20061101210845.337590368@wlug.westbo.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline; filename=remove-assert-locks
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

Remove the usage of ASSERT_READ_LOCK/ASSERT_WRITE_LOCK in x_tables and
nf_conntrack, it didn't do anything, it was just an empty define and it
uglified the code.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 net/netfilter/nf_conntrack_core.c       |    7 -------
 net/netfilter/nf_conntrack_standalone.c |    4 ----
 2 files changed, 11 deletions(-)

Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:07.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:10.000000000 +0100
@@ -47,11 +47,6 @@
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
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_standalone.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_standalone.c	2006-11-01 21:40:01.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_standalone.c	2006-11-01 21:40:10.000000000 +0100
@@ -29,9 +29,6 @@
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

--
/Martin
