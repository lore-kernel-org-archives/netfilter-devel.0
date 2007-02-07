From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/15]: x_tables: fix return values for LOG/ULOG
Date: Wed,  7 Feb 2007 09:22:57 +0100 (MET)
Message-ID: <20070207082256.27478.61098.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: fix return values for LOG/ULOG

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ed4ff97f3d8c948c5ef177b80c1432e739fa0c94
tree b5f9939908568ea4785ef722e0289ef627e55541
parent 7ef8c3390c8e383f7bf590b11623aed2cf493dfa
author Jan Engelhardt <jengelh@gmx.de> Tue, 06 Feb 2007 07:37:01 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:53:11 +0100

 net/ipv4/netfilter/ipt_LOG.c  |    7 +++++--
 net/ipv4/netfilter/ipt_ULOG.c |    7 ++++---
 net/ipv6/netfilter/ip6t_LOG.c |    7 +++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index c96de16..37778c7 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -471,8 +471,11 @@ static struct nf_logger ipt_log_logger =
 
 static int __init ipt_log_init(void)
 {
-	if (ipt_register_target(&ipt_log_reg))
-		return -EINVAL;
+	int ret;
+
+	ret = ipt_register_target(&ipt_log_reg);
+	if (ret < 0)
+		return ret;
 	if (nf_log_register(PF_INET, &ipt_log_logger) < 0) {
 		printk(KERN_WARNING "ipt_LOG: not logging via system console "
 		       "since somebody else already registered for PF_INET\n");
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index dbd3478..a47e279 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -379,7 +379,7 @@ static struct nf_logger ipt_ulog_logger 
 
 static int __init ipt_ulog_init(void)
 {
-	int i;
+	int ret, i;
 
 	DEBUGP("ipt_ULOG: init module\n");
 
@@ -400,9 +400,10 @@ static int __init ipt_ulog_init(void)
 	if (!nflognl)
 		return -ENOMEM;
 
-	if (ipt_register_target(&ipt_ulog_reg) != 0) {
+	ret = ipt_register_target(&ipt_ulog_reg);
+	if (ret < 0) {
 		sock_release(nflognl->sk_socket);
-		return -EINVAL;
+		return ret;
 	}
 	if (nflog)
 		nf_log_register(PF_INET, &ipt_ulog_logger);
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 33b1faa..9fe0816 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -482,8 +482,11 @@ static struct nf_logger ip6t_logger = {
 
 static int __init ip6t_log_init(void)
 {
-	if (ip6t_register_target(&ip6t_log_reg))
-		return -EINVAL;
+	int ret;
+
+	ret = ip6t_register_target(&ip6t_log_reg);
+	if (ret < 0)
+		return ret;
 	if (nf_log_register(PF_INET6, &ip6t_logger) < 0) {
 		printk(KERN_WARNING "ip6t_LOG: not logging via system console "
 		       "since somebody else already registered for PF_INET6\n");
