From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/18]: x_tables: add data member to struct xt_match
Date: Tue, 22 Aug 2006 00:52:40 +0200 (MEST)
Message-ID: <20060821225240.10288.33283.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: add data member to struct xt_match

Shared match functions can use this to make runtime decisions basen on the
used match.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0da4cda5f20c851bf4a7da543d6eb91cad7810aa
tree 4f6bc6de8304515ddcfd03d99e876f13d7299190
parent 9c8627cc82b512bf2c7d07f0a9afd9a6afc9e7ec
author Patrick McHardy <kaber@trash.net> Fri, 18 Aug 2006 06:06:17 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 18 Aug 2006 06:06:17 +0200

 include/linux/netfilter/x_tables.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9d97102..03d1027 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -185,6 +185,9 @@ struct xt_match
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
+	/* Free to use by each match */
+	unsigned long data;
+
 	char *table;
 	unsigned int matchsize;
 	unsigned int hooks;
