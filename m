From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] net/netfilter/xt_tables: Remove duplicate of xt_prefix
Date: Fri, 26 Jan 2007 14:07:14 +0100
Message-ID: <20070126130714.GA28541@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Remove xt_proto_prefix array which duplicates xt_prefix and change all
users of xt_proto_prefix to xt_prefix.

Fix is compile-tested on i386.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

---
 net/netfilter/x_tables.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8996584..6080d50 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -56,8 +56,8 @@ enum {
 };
 
 static const char *xt_prefix[NPROTO] = {
-	[AF_INET] 	= "ip",
-	[AF_INET6] 	= "ip6",
+	[AF_INET]	= "ip",
+	[AF_INET6]	= "ip6",
 	[NF_ARP]	= "arp",
 };
 
@@ -651,12 +651,6 @@ void *xt_unregister_table(struct xt_table *table)
 EXPORT_SYMBOL_GPL(xt_unregister_table);
 
 #ifdef CONFIG_PROC_FS
-static char *xt_proto_prefix[NPROTO] = {
-	[AF_INET]	= "ip",
-	[AF_INET6]	= "ip6",
-	[NF_ARP]	= "arp",
-};
-
 static struct list_head *xt_get_idx(struct list_head *list, struct seq_file *seq, loff_t pos)
 {
 	struct list_head *head = list->next;
@@ -798,7 +792,7 @@ int xt_proto_init(int af)
 
 
 #ifdef CONFIG_PROC_FS
-	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
 	proc = proc_net_fops_create(buf, 0440, &xt_file_ops);
 	if (!proc)
@@ -806,14 +800,14 @@ int xt_proto_init(int af)
 	proc->data = (void *) ((unsigned long) af | (TABLE << 16));
 
 
-	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
 	proc = proc_net_fops_create(buf, 0440, &xt_file_ops);
 	if (!proc)
 		goto out_remove_tables;
 	proc->data = (void *) ((unsigned long) af | (MATCH << 16));
 
-	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
 	proc = proc_net_fops_create(buf, 0440, &xt_file_ops);
 	if (!proc)
@@ -825,12 +819,12 @@ int xt_proto_init(int af)
 
 #ifdef CONFIG_PROC_FS
 out_remove_matches:
-	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
 	proc_net_remove(buf);
 
 out_remove_tables:
-	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
 	proc_net_remove(buf);
 out:
@@ -844,15 +838,15 @@ void xt_proto_fini(int af)
 #ifdef CONFIG_PROC_FS
 	char buf[XT_FUNCTION_MAXNAMELEN];
 
-	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
 	proc_net_remove(buf);
 
-	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
 	proc_net_remove(buf);
 
-	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
 	proc_net_remove(buf);
 #endif /*CONFIG_PROC_FS*/
-- 
1.4.4.2
