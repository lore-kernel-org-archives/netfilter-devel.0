From: Dmitry Mishin <dim@openvz.org>
Subject: [PATCH] table->lock initialization move
Date: Mon, 17 Apr 2006 15:14:01 +0400
Message-ID: <200604171514.02014.dim@openvz.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6h3QEUxtX0L2Q2U"
Cc: dev@openvz.org, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--Boundary-00=_6h3QEUxtX0L2Q2U
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

xt_table->lock should be initialized before xt_replace_table() call, which 
uses it. This patch removes strict requirement, that table should define lock 
before registering.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>

-- 
Thanks,
Dmitry.

--Boundary-00=_6h3QEUxtX0L2Q2U
Content-Type: text/plain; charset="us-ascii";
	name="diff-net-netfilter-xt-lock-20060417"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="diff-net-netfilter-xt-lock-20060417"

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 00cf0a4..17abf60 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -529,6 +529,7 @@ int xt_register_table(struct xt_table *t
 
 	/* Simplifies replace_table code. */
 	table->private = bootstrap;
+	rwlock_init(&table->lock);
 	if (!xt_replace_table(table, 0, newinfo, &ret))
 		goto unlock;
 
@@ -538,7 +539,6 @@ int xt_register_table(struct xt_table *t
 	/* save number of initial entries */
 	private->initial_entries = private->number;
 
-	rwlock_init(&table->lock);
 	list_prepend(&xt[table->af].tables, table);
 
 	ret = 0;

--Boundary-00=_6h3QEUxtX0L2Q2U--
