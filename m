From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 08/11] netfilter: add a private member to nf_hook_ops
Date: Fri, 16 Nov 2012 02:23:42 +0100
Message-ID: <1353029025-31635-9-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45179 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2KPBX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:57 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will be used to store a pointer to the base chain to be invoked
on a specific hook.

(This patch is early in the series, so as to reduce recompilations
during stgit-like commit editing.)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/linux/netfilter.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index ee14284..3813e84c 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -48,15 +48,25 @@ typedef unsigned int nf_hookfn(unsigned int hooknum,
 			       const struct net_device *out,
 			       int (*okfn)(struct sk_buff *));
 
+/**
+ * @list:	List anchor for parent (nf_hooks[pf][hooknum])
+ *
+ * To be filled in by user:
+ * @hook:	Function to call
+ * @owner:	Owning module
+ * @priv:	Private data, free for use by op owner
+ * @pf:		Netfilter protocol/subsystem this hook is for (%NFPROTO_*)
+ * @hooknum:	Hook this op is on (%NF_INET_*)
+ * @priority:	Hooks are ordered in ascending priority.
+ */
 struct nf_hook_ops {
 	struct list_head list;
 
-	/* User fills in from here down. */
 	nf_hookfn *hook;
 	struct module *owner;
+	void *priv;
 	u_int8_t pf;
 	unsigned int hooknum;
-	/* Hooks are ordered in ascending priority. */
 	int priority;
 };
 
-- 
1.7.10.4

