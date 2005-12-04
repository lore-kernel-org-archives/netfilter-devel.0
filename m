From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 4/9]: Fix ip_conntrack_flush abuse in ctnetlink
Date: Sun, 04 Dec 2005 22:01:21 +0100
Message-ID: <20051204210121.24032.27250.sendpatchset@localhost.localdomain>
References: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix ip_conntrack_flush abuse in ctnetlink

ip_conntrack_flush() used to be part of ip_conntrack_cleanup(), which needs
to drop _all_ references on module unload. Table flushed using ctnetlink
just needs to clean the table and doesn't need to flush the event cache or
wait for any references attached to skbs. Move everything but pure table
flushing back to ip_conntrack_cleanup().

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 01563e56ad1c48c85e1258e2eaabcc270385e1a5
tree 244d6a9b8cbe0daf3be9f356d9c69018a75de7ad
parent 5b33d73e5d4153241c8e2378332f9810f4eca160
author Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 16:54:55 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 16:54:55 +0100

 net/ipv4/netfilter/ip_conntrack_core.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 7a4ecdd..84c66db 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1345,6 +1345,11 @@ static int kill_all(struct ip_conntrack 
 	return 1;
 }
 
+void ip_conntrack_flush(void)
+{
+	ip_ct_iterate_cleanup(kill_all, NULL);
+}
+
 static void free_conntrack_hash(struct list_head *hash, int vmalloced,int size)
 {
 	if (vmalloced)
@@ -1354,8 +1359,12 @@ static void free_conntrack_hash(struct l
 			   get_order(sizeof(struct list_head) * size));
 }
 
-void ip_conntrack_flush(void)
+/* Mishearing the voices in his head, our hero wonders how he's
+   supposed to kill the mall. */
+void ip_conntrack_cleanup(void)
 {
+	ip_ct_attach = NULL;
+
 	/* This makes sure all current packets have passed through
            netfilter framework.  Roll on, two-stage module
            delete... */
@@ -1363,7 +1372,7 @@ void ip_conntrack_flush(void)
 
 	ip_ct_event_cache_flush();
  i_see_dead_people:
-	ip_ct_iterate_cleanup(kill_all, NULL);
+	ip_conntrack_flush();
 	if (atomic_read(&ip_conntrack_count) != 0) {
 		schedule();
 		goto i_see_dead_people;
@@ -1371,14 +1380,7 @@ void ip_conntrack_flush(void)
 	/* wait until all references to ip_conntrack_untracked are dropped */
 	while (atomic_read(&ip_conntrack_untracked.ct_general.use) > 1)
 		schedule();
-}
 
-/* Mishearing the voices in his head, our hero wonders how he's
-   supposed to kill the mall. */
-void ip_conntrack_cleanup(void)
-{
-	ip_ct_attach = NULL;
-	ip_conntrack_flush();
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	free_conntrack_hash(ip_conntrack_hash, ip_conntrack_vmalloc,
