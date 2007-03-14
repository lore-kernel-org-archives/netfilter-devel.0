From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/22]: x_tables: remove duplicate of xt_prefix
Date: Wed, 14 Mar 2007 09:50:03 +0100 (MET)
Message-ID: <20070314084948.15282.18927.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: remove duplicate of xt_prefix

Remove xt_proto_prefix array which duplicates xt_prefix and change all
users of xt_proto_prefix to xt_prefix.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c9e0a6db3a45a0b71c5e81d4915c9734719ad998
tree d9d9db95b2b6cb407802db9d55dba496854741d4
parent 384510bca7c96113e5dca3bcc7f84a2934d707f1
author Tobias Klauser <tklauser@distanz.ch> Thu, 08 Mar 2007 18:22:29 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 13 Mar 2007 17:01:59 +0100

 net/netfilter/x_tables.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ec607a4..0eb2504 100644
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
 
@@ -651,12 +651,6 @@ void *xt_unregister_table(struct xt_tabl
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
@@ -798,7 +792,7 @@ #endif
 
 
 #ifdef CONFIG_PROC_FS
-	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
 	proc = proc_net_fops_create(buf, 0440, &xt_file_ops);
 	if (!proc)
@@ -806,14 +800,14 @@ #ifdef CONFIG_PROC_FS
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
@@ -825,12 +819,12 @@ #endif
 
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
