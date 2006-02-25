From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/6]: Restore {ipt,ip6t,ebt}_LOG compatibility
Date: Sat, 25 Feb 2006 14:18:48 +0100 (MET)
Message-ID: <20060225131707.7400.26631.sendpatchset@localhost.localdomain>
References: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Restore {ipt,ip6t,ebt}_LOG compatibility

The nfnetlink_log infrastructure changes broke compatiblity of the LOG
targets. They currently use whatever log backend was registered first,
which means that if ipt_ULOG was loaded first, no messages will be printed
to the ring buffer anymore.

Restore compatiblity by using the old log functions by default and only use
the nf_log backend if the user explicitly said so.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c3fbb1dc63d9433a59fcbcbc446564e6619da165
tree c45a4915e64289b3fc656c834456e2d956328605
parent 37fcebcd2adf3cd2124437ff1fb7836be0a9c207
author Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:56:37 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:56:37 +0100

 include/linux/netfilter_bridge/ebt_log.h |    1 +
 include/linux/netfilter_ipv4/ipt_LOG.h   |    3 ++-
 include/linux/netfilter_ipv6/ip6t_LOG.h  |    3 ++-
 net/bridge/netfilter/ebt_log.c           |    7 ++++++-
 net/ipv4/netfilter/ipt_LOG.c             |    7 ++++++-
 net/ipv6/netfilter/ip6t_LOG.c            |    7 ++++++-
 6 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebt_log.h b/include/linux/netfilter_bridge/ebt_log.h
index 358fbc8..96e231a 100644
--- a/include/linux/netfilter_bridge/ebt_log.h
+++ b/include/linux/netfilter_bridge/ebt_log.h
@@ -3,6 +3,7 @@
 
 #define EBT_LOG_IP 0x01 /* if the frame is made by ip, log the ip information */
 #define EBT_LOG_ARP 0x02
+#define EBT_LOG_NFLOG 0x04
 #define EBT_LOG_MASK (EBT_LOG_IP | EBT_LOG_ARP)
 #define EBT_LOG_PREFIX_SIZE 30
 #define EBT_LOG_WATCHER "log"
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
index 22d1617..892f9a3 100644
--- a/include/linux/netfilter_ipv4/ipt_LOG.h
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h
@@ -6,7 +6,8 @@
 #define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
 #define IPT_LOG_IPOPT		0x04	/* Log IP options */
 #define IPT_LOG_UID		0x08	/* Log UID owning local socket */
-#define IPT_LOG_MASK		0x0f
+#define IPT_LOG_NFLOG		0x10	/* Log using nf_log backend */
+#define IPT_LOG_MASK		0x1f
 
 struct ipt_log_info {
 	unsigned char level;
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
index 9008ff5..060c1a1 100644
--- a/include/linux/netfilter_ipv6/ip6t_LOG.h
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h
@@ -6,7 +6,8 @@
 #define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
 #define IP6T_LOG_IPOPT		0x04	/* Log IP options */
 #define IP6T_LOG_UID		0x08	/* Log UID owning local socket */
-#define IP6T_LOG_MASK		0x0f
+#define IP6T_LOG_NFLOG		0x10	/* Log using nf_log backend */
+#define IP6T_LOG_MASK		0x1f
 
 struct ip6t_log_info {
 	unsigned char level;
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 0128fbb..288ff1d 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -166,7 +166,12 @@ static void ebt_log(const struct sk_buff
 	li.u.log.level = info->loglevel;
 	li.u.log.logflags = info->bitmask;
 
-	nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li, info->prefix);
+	if (info->bitmask & EBT_LOG_NFLOG)
+		nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
+		              info->prefix);
+	else
+		ebt_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
+		               info->prefix);
 }
 
 static struct ebt_watcher log =
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 6606ddb..cc27545 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -425,7 +425,12 @@ ipt_log_target(struct sk_buff **pskb,
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	nf_log_packet(PF_INET, hooknum, *pskb, in, out, &li, loginfo->prefix);
+	if (loginfo->logflags & IPT_LOG_NFLOG)
+		nf_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
+		              loginfo->prefix);
+	else
+		ipt_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
+		               loginfo->prefix);
 
 	return IPT_CONTINUE;
 }
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 77c7258..6b930ef 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -436,7 +436,12 @@ ip6t_log_target(struct sk_buff **pskb,
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	nf_log_packet(PF_INET6, hooknum, *pskb, in, out, &li, loginfo->prefix);
+	if (loginfo->logflags & IP6T_LOG_NFLOG)
+		nf_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
+		              loginfo->prefix);
+	else
+		ip6t_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
+		                loginfo->prefix);
 
 	return IP6T_CONTINUE;
 }
