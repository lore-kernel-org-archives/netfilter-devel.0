From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/18]: x_tables: add helpers for mass match/target
	registration
Date: Tue, 22 Aug 2006 00:52:32 +0200 (MEST)
Message-ID: <20060821225232.10288.34148.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: add helpers for mass match/target registration

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 15e38196fbab0fbedc31889f45440b9fe6fdf257
tree 13de7a026236dacc50d6db347169b1132d30caff
parent c3e06d8b091765def127afcc148835736d64fad5
author Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 19:01:17 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 19:01:17 +0200

 include/linux/netfilter/x_tables.h |    5 +++
 net/netfilter/x_tables.c           |   60 ++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 48cc32d..9a99124 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -290,8 +290,13 @@ struct xt_table_info
 
 extern int xt_register_target(struct xt_target *target);
 extern void xt_unregister_target(struct xt_target *target);
+extern int xt_register_targets(struct xt_target *target, unsigned int n);
+extern void xt_unregister_targets(struct xt_target *target, unsigned int n);
+
 extern int xt_register_match(struct xt_match *target);
 extern void xt_unregister_match(struct xt_match *target);
+extern int xt_register_matches(struct xt_match *match, unsigned int n);
+extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
 
 extern int xt_check_match(const struct xt_match *match, unsigned short family,
 			  unsigned int size, const char *table, unsigned int hook,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 174e8f9..8037ba6 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -87,6 +87,36 @@ xt_unregister_target(struct xt_target *t
 EXPORT_SYMBOL(xt_unregister_target);
 
 int
+xt_register_targets(struct xt_target *target, unsigned int n)
+{
+	unsigned int i;
+	int err = 0;
+
+	for (i = 0; i < n; i++) {
+		err = xt_register_target(&target[i]);
+		if (err)
+			goto err;
+	}
+	return err;
+
+err:
+	if (i > 0)
+		xt_unregister_targets(target, i);
+	return err;
+}
+EXPORT_SYMBOL(xt_register_targets);
+
+void
+xt_unregister_targets(struct xt_target *target, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++)
+		xt_unregister_target(&target[i]);
+}
+EXPORT_SYMBOL(xt_unregister_targets);
+
+int
 xt_register_match(struct xt_match *match)
 {
 	int ret, af = match->family;
@@ -113,6 +143,36 @@ xt_unregister_match(struct xt_match *mat
 }
 EXPORT_SYMBOL(xt_unregister_match);
 
+int
+xt_register_matches(struct xt_match *match, unsigned int n)
+{
+	unsigned int i;
+	int err = 0;
+
+	for (i = 0; i < n; i++) {
+		err = xt_register_match(&match[i]);
+		if (err)
+			goto err;
+	}
+	return err;
+
+err:
+	if (i > 0)
+		xt_unregister_matches(match, i);
+	return err;
+}
+EXPORT_SYMBOL(xt_register_matches);
+
+void
+xt_unregister_matches(struct xt_match *match, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++)
+		xt_unregister_match(&match[i]);
+}
+EXPORT_SYMBOL(xt_unregister_matches);
+
 
 /*
  * These are weird, but module loading must not be done with mutex
