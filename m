From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/12]: Add helper functions for mass hook
	registration/unregistration
Date: Thu,  6 Apr 2006 12:04:53 +0200 (MEST)
Message-ID: <20060406100453.17409.47998.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Add helper functions for mass hook registration/unregistration

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3bf0d209e539917efcc5286b8f1cab2856ebdd49
tree 4c5840cf32ee69cc6138534d24c4d43a23fad557
parent 32a976a8703b098e898a9a13f9ddcabbf654e7d8
author Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:32:05 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:32:05 +0200

 include/linux/netfilter.h |    2 ++
 net/netfilter/core.c      |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 412e52c..5aa9316 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -110,6 +110,8 @@ struct nf_info
 /* Function to register/unregister hook points. */
 int nf_register_hook(struct nf_hook_ops *reg);
 void nf_unregister_hook(struct nf_hook_ops *reg);
+int nf_register_hooks(struct nf_hook_ops *reg, unsigned int n);
+void nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n);
 
 /* Functions to register get/setsockopt ranges (non-inclusive).  You
    need to check permissions yourself! */
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 1ceb1a6..5c7143e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -63,6 +63,34 @@ void nf_unregister_hook(struct nf_hook_o
 }
 EXPORT_SYMBOL(nf_unregister_hook);
 
+int nf_register_hooks(struct nf_hook_ops *reg, unsigned int n)
+{
+	unsigned int i;
+	int err = 0;
+
+	for (i = 0; i < n; i++) {
+		err = nf_register_hook(&reg[i]);
+		if (err)
+			goto err;
+	}
+	return err;
+
+err:
+	if (i > 0)
+		nf_unregister_hooks(reg, i - i);
+	return err;
+}
+EXPORT_SYMBOL(nf_register_hooks);
+
+void nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++)
+		nf_unregister_hook(&reg[i]);
+}
+EXPORT_SYMBOL(nf_unregister_hooks);
+
 unsigned int nf_iterate(struct list_head *head,
 			struct sk_buff **skb,
 			int hook,
