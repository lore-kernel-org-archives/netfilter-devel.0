From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/13]: Convert arp_tables targets to centralized error
	checking
Date: Thu, 16 Feb 2006 22:32:16 +0100 (MET)
Message-ID: <20060216213216.6933.12094.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Convert arp_tables targets to centralized error checking

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b5b1850e58154ca2646ec8f759164a967779d42b
tree 968f37b8f9bf4ccc4855135f6c40a2729c75579a
parent 4f172068d4d24e663edc75a7679e887771a2d89e
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:04 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:04 +0100

 net/ipv4/netfilter/arp_tables.c  |    2 ++
 net/ipv4/netfilter/arpt_mangle.c |   12 ++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f68eb67..082b748 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1143,11 +1143,13 @@ void arpt_unregister_table(struct arpt_t
 /* The built-in targets: standard (NULL) and error. */
 static struct arpt_target arpt_standard_target = {
 	.name		= ARPT_STANDARD_TARGET,
+	.targetsize	= sizeof(int),
 };
 
 static struct arpt_target arpt_error_target = {
 	.name		= ARPT_ERROR_TARGET,
 	.target		= arpt_error,
+	.targetsize	= ARPT_FUNCTION_MAXNAMELEN,
 };
 
 static struct nf_sockopt_ops arpt_sockopts = {
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index c97650a..4715cf5 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -80,12 +80,12 @@ checkentry(const char *tablename, const 
 	return 1;
 }
 
-static struct arpt_target arpt_mangle_reg
-= {
-        .name		= "mangle",
-        .target		= target,
-        .checkentry	= checkentry,
-        .me		= THIS_MODULE,
+static struct arpt_target arpt_mangle_reg = {
+	.name		= "mangle",
+	.target		= target,
+	.targetsize	= sizeof(struct arpt_mangle),
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
