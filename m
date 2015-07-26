From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] netfilter: xtables: Add helper macro for xt_match boilerplate
Date: Sun, 26 Jul 2015 17:27:37 +0530
Message-ID: <20150726115737.GA14070@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

For simple modules that contain a single xt_match without any
additional setup code then ends up being a block of duplicated
boilerplate. This patch adds a new macro, module_xt_match(),
which replaces the module_init()/module_exit() registrations with
template functions.

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 include/linux/netfilter/x_tables.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 286098a..4ebf66b 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -142,6 +142,16 @@ struct xt_match {
 	unsigned short family;
 };
 
+/**
+ * module_xt_match() - Helper macro for registering a netfilter driver
+ * @__xt_match: xt_match struct
+ * Helper macro for netfilter drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_xt_match(__xt_match) \
+	module_driver(__xt_match, xt_register_match, xt_unregister_match)
+
 /* Registration hooks for targets. */
 struct xt_target {
 	struct list_head list;
-- 
1.9.1
