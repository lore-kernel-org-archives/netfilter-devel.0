From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/07]: x_tables: move table->lock initialization
Date: Fri, 21 Apr 2006 03:06:56 +0200 (MEST)
Message-ID: <20060421010656.8466.9273.sendpatchset@localhost.localdomain>
References: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: move table->lock initialization

xt_table->lock should be initialized before xt_replace_table() call, which
uses it. This patch removes strict requirement that table should define
lock before registering.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 81b536eef7989c16a2d59ced319aafaaf9e3ed03
tree f412294f1c7862db8e0b7d457fdfe85036c32c94
parent 1d7a13058df694ded6411b12931f3dd42f8193a4
author Dmitry Mishin <dim@openvz.org> Fri, 21 Apr 2006 01:29:07 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 01:29:07 +0200

 net/netfilter/x_tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
