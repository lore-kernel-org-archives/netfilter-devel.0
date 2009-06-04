From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [resend net-next] socket: Added 'transparent' option
Date: Thu,  4 Jun 2009 15:26:52 +0200
Message-ID: <1244122013-25970-1-git-send-email-panther@balabit.hu>
Cc: kaber@trash.net, jengelh@medozas.de,
	Laszlo Attila Toth <panther@balabit.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:36928 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752422AbZFDN1C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:27:02 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 0DFFD13A25B
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2009 15:27:02 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added new revision of the 'socket' match. If its new option is set,
enabled 'transparent' socket option is required for the socket to be matched.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 include/linux/netfilter/xt_socket.h |    8 +++++
 net/netfilter/xt_socket.c           |   57 +++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/netfilter/xt_socket.h

diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
new file mode 100644
index 0000000..71acb54
--- /dev/null
+++ b/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,8 @@
+#ifndef _XT_SOCKET_H_match
+#define _XT_SOCKET_H_match
+
+struct xt_socket_match_info1 {
+	__u8 transparent;
+};
+
+#endif /* _XT_SOCKET_H_match */
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 1acc089..6a2453d 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -22,6 +22,8 @@
 #include <net/netfilter/nf_tproxy_core.h>
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
 
+#include <linux/netfilter/xt_socket.h>
+
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 #define XT_SOCKET_HAVE_CONNTRACK 1
 #include <net/netfilter/nf_conntrack.h>
@@ -86,7 +88,8 @@ extract_icmp_fields(const struct sk_buff *skb,
 
 
 static bool
-socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
+socket_match(const struct sk_buff *skb, const struct xt_match_param *par,
+	     bool check_transparent)
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	struct udphdr _hdr, *hp = NULL;
@@ -142,10 +145,22 @@ socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 				   saddr, daddr, sport, dport, par->in, false);
 	if (sk != NULL) {
 		bool wildcard = (sk->sk_state != TCP_TIME_WAIT && inet_sk(sk)->rcv_saddr == 0);
+		bool transparent = (sk->sk_state != TCP_TIME_WAIT &&
+					inet_sk(sk)->transparent) ||
+				   (sk->sk_state == TCP_TIME_WAIT &&
+					inet_twsk(sk)->tw_transparent);
+		const struct xt_socket_match_info1 *info = NULL;
+
+		if (check_transparent)
+			info = par->matchinfo;
 
 		nf_tproxy_put_sock(sk);
+
 		if (wildcard)
 			sk = NULL;
+		else if (check_transparent && info->transparent &&
+			 !transparent)
+			sk = NULL;
 	}
 
 	pr_debug("socket match: proto %u %08x:%u -> %08x:%u "
@@ -157,23 +172,47 @@ socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (sk != NULL);
 }
 
-static struct xt_match socket_mt_reg __read_mostly = {
-	.name		= "socket",
-	.family		= AF_INET,
-	.match		= socket_mt,
-	.hooks		= 1 << NF_INET_PRE_ROUTING,
-	.me		= THIS_MODULE,
+static bool
+socket_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
+{
+	return socket_match(skb, par, false);
+}
+
+static bool
+socket_mt_v1(const struct sk_buff *skb, const struct xt_match_param *par)
+{
+	return socket_match(skb, par, true);
+}
+
+static struct xt_match socket_mt_reg[] __read_mostly = {
+	{
+		.name		= "socket",
+		.revision	= 0,
+		.family		= NFPROTO_IPV4,
+		.match		= socket_mt_v0,
+		.hooks		= 1 << NF_INET_PRE_ROUTING,
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "socket",
+		.revision	= 1,
+		.family		= AF_INET,
+		.match		= socket_mt_v1,
+		.matchsize	= sizeof(struct xt_socket_match_info1),
+		.hooks		= 1 << NF_INET_PRE_ROUTING,
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init socket_mt_init(void)
 {
 	nf_defrag_ipv4_enable();
-	return xt_register_match(&socket_mt_reg);
+	return xt_register_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
 }
 
 static void __exit socket_mt_exit(void)
 {
-	xt_unregister_match(&socket_mt_reg);
+	xt_unregister_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
 }
 
 module_init(socket_mt_init);
-- 
1.6.2.2.404.ge96f3

