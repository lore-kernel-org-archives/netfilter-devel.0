From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] fix format specifier for netfilter log targets
Date: Mon, 15 May 2006 18:56:00 +1000
Message-ID: <44684220.9050107@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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

The prefix argument for nf_log_packet is a format specifier,
so don't pass the user defined string directly to it.

Signed-off-by: Philip Craig <philipc@snapgear.com>

Index: linux-2.6.x/net/ipv4/netfilter/ipt_LOG.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/ipv4/netfilter/ipt_LOG.c,v
retrieving revision 1.1.1.16
diff -u -p -r1.1.1.16 ipt_LOG.c
--- linux-2.6.x/net/ipv4/netfilter/ipt_LOG.c	21 Mar 2006 01:35:40 -0000	1.1.1.16
+++ linux-2.6.x/net/ipv4/netfilter/ipt_LOG.c	15 May 2006 08:44:39 -0000
@@ -427,7 +427,7 @@ ipt_log_target(struct sk_buff **pskb,

 	if (loginfo->logflags & IPT_LOG_NFLOG)
 		nf_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
-		              loginfo->prefix);
+		              "%s", loginfo->prefix);
 	else
 		ipt_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
 		               loginfo->prefix);
Index: linux-2.6.x/net/ipv6/netfilter/ip6t_LOG.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/ipv6/netfilter/ip6t_LOG.c,v
retrieving revision 1.1.1.14
diff -u -p -r1.1.1.14 ip6t_LOG.c
--- linux-2.6.x/net/ipv6/netfilter/ip6t_LOG.c	21 Mar 2006 01:35:41 -0000	1.1.1.14
+++ linux-2.6.x/net/ipv6/netfilter/ip6t_LOG.c	15 May 2006 08:44:39 -0000
@@ -438,7 +438,7 @@ ip6t_log_target(struct sk_buff **pskb,

 	if (loginfo->logflags & IP6T_LOG_NFLOG)
 		nf_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
-		              loginfo->prefix);
+		              "%s", loginfo->prefix);
 	else
 		ip6t_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
 		                loginfo->prefix);
Index: linux-2.6.x/net/bridge/netfilter/ebt_log.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/bridge/netfilter/ebt_log.c,v
retrieving revision 1.1.1.9
diff -u -p -r1.1.1.9 ebt_log.c
--- linux-2.6.x/net/bridge/netfilter/ebt_log.c	21 Mar 2006 01:35:39 -0000	1.1.1.9
+++ linux-2.6.x/net/bridge/netfilter/ebt_log.c	15 May 2006 08:44:39 -0000
@@ -168,7 +168,7 @@ static void ebt_log(const struct sk_buff

 	if (info->bitmask & EBT_LOG_NFLOG)
 		nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
-		              info->prefix);
+		              "%s", info->prefix);
 	else
 		ebt_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
 		               info->prefix);
