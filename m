From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [net-next] socket: added mtinfo with 'transparent' flag
Date: Tue,  9 Jun 2009 15:11:50 +0200
Message-ID: <1244553110-12145-1-git-send-email-panther@balabit.hu>
References: <4A2E5AA2.8020206@trash.net>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:57518 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758482AbZFINLz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:11:55 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 6F36B13A258
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2009 15:11:53 +0200 (CEST)
In-Reply-To: <4A2E5AA2.8020206@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added new revision of the 'socket' match supporting flags.

If the XT_SOCKET_TRANSPARENT flag is set, enabled 'transparent'
socket option is required for the socket to be matched.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 include/linux/netfilter/xt_socket.h |   12 +++++++
 net/netfilter/xt_socket.c           |   63 ++++++++++++++++++++++++++++------
 2 files changed, 64 insertions(+), 11 deletions(-)
 create mode 100644 include/linux/netfilter/xt_socket.h

diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
new file mode 100644
index 0000000..f6ba866
--- /dev/null
+++ b/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,12 @@
+#ifndef _XT_SOCKET_H_match
+#define _XT_SOCKET_H_match
+
+enum {
+	XT_SOCKET_TRANSPARENT = 1 << 0,
+};
+
+struct xt_socket_mtinfo1 {
+	__u8 flags;
+};
+
+#endif /* _XT_SOCKET_H_match */
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 1acc089..ebf00ad 100644
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
+	     const struct xt_socket_mtinfo1 *info)
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	struct udphdr _hdr, *hp = NULL;
@@ -141,10 +144,24 @@ socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	sk = nf_tproxy_get_sock_v4(dev_net(skb->dev), protocol,
 				   saddr, daddr, sport, dport, par->in, false);
 	if (sk != NULL) {
-		bool wildcard = (sk->sk_state != TCP_TIME_WAIT && inet_sk(sk)->rcv_saddr == 0);
+		bool wildcard;
+		bool transparent = true;
+
+		/* Ignore sockets listening on INADDR_ANY */
+		wildcard = (sk->sk_state != TCP_TIME_WAIT &&
+			    inet_sk(sk)->rcv_saddr == 0);
+
+		/* Ignore non-transparent sockets,
+		   if XT_SOCKET_TRANSPARENT is used */
+		if (info && info->flags & XT_SOCKET_TRANSPARENT)
+			transparent = ((sk->sk_state != TCP_TIME_WAIT &&
+					inet_sk(sk)->transparent) ||
+				       (sk->sk_state == TCP_TIME_WAIT &&
+					inet_twsk(sk)->tw_transparent));
 
 		nf_tproxy_put_sock(sk);
-		if (wildcard)
+
+		if (wildcard || !transparent)
 			sk = NULL;
 	}
 
@@ -157,23 +174,47 @@ socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
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
+	return socket_match(skb, par, NULL);
+}
+
+static bool
+socket_mt_v1(const struct sk_buff *skb, const struct xt_match_param *par)
+{
+	return socket_match(skb, par, par->matchinfo);
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
+		.family		= NFPROTO_IPV4,
+		.match		= socket_mt_v1,
+		.matchsize	= sizeof(struct xt_socket_mtinfo1),
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

