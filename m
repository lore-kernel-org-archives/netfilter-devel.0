From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [resend2 net-next] socket: added mtinfo with 'transparent' flag
Date: Mon,  8 Jun 2009 14:30:23 +0200
Message-ID: <1244464224-30692-2-git-send-email-panther@balabit.hu>
References: <4A27CD5A.6040303@trash.net>
 <1244464224-30692-1-git-send-email-panther@balabit.hu>
Cc: kaber@trash.net, Laszlo Attila Toth <panther@balabit.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:41207 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753564AbZFHMa1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:30:27 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 815B913A29F
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2009 14:30:27 +0200 (CEST)
In-Reply-To: <1244464224-30692-1-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added new revision of the 'socket' match supporting flags.

If the XT_SOCKET_TRANSPARENT flag is set, enabled 'transparent'
socket option is required for the socket to be matched.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 net/netfilter/xt_socket.c |   63 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 1acc089..f97270c 100644
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
+		.family		= AF_INET,
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

