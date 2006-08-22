From: Thomas Graf <tgraf@suug.ch>
Subject: [NETFILTER]: x_tables: Fix typos after conversion to use mass
	registation helper
Date: Tue, 22 Aug 2006 22:48:17 +0200
Message-ID: <20060822204817.GJ3470@postel.suug.ch>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
	<20060821225233.10288.88842.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <20060821225233.10288.88842.sendpatchset@localhost.localdomain>
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


Signed-off-by: Thomas Graf <tgraf@suug.ch>

Index: net-2.6.19.git/net/netfilter/xt_CONNSECMARK.c
===================================================================
--- net-2.6.19.git.orig/net/netfilter/xt_CONNSECMARK.c
+++ net-2.6.19.git/net/netfilter/xt_CONNSECMARK.c
@@ -130,14 +130,14 @@ static struct xt_target xt_connsecmark_t
 static int __init xt_connsecmark_init(void)
 {
 	need_conntrack();
-	return xt_register_targets(xt_connsecmark_targets,
-				   ARRAY_SIZE(xt_connsecmark_targets));
+	return xt_register_targets(xt_connsecmark_target,
+				   ARRAY_SIZE(xt_connsecmark_target));
 }
 
 static void __exit xt_connsecmark_fini(void)
 {
-	xt_unregister_targets(xt_connsecmark_targets,
-			      ARRAY_SIZE(xt_connsecmark_targets));
+	xt_unregister_targets(xt_connsecmark_target,
+			      ARRAY_SIZE(xt_connsecmark_target));
 }
 
 module_init(xt_connsecmark_init);
Index: net-2.6.19.git/net/netfilter/xt_SECMARK.c
===================================================================
--- net-2.6.19.git.orig/net/netfilter/xt_SECMARK.c
+++ net-2.6.19.git/net/netfilter/xt_SECMARK.c
@@ -111,7 +111,7 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
-static struct xt_target xt_secmark_target = {
+static struct xt_target xt_secmark_target[] = {
 	{
 		.name		= "SECMARK",
 		.family		= AF_INET,
