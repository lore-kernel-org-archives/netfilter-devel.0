From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH 1/2] socket: Added 'transparent' option
Date: Fri, 24 Apr 2009 15:30:19 +0200
Message-ID: <1240579820-18637-1-git-send-email-panther@balabit.hu>
Cc: Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:60203 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754198AbZDXN7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:59:11 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 8EB6739D332
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2009 15:30:21 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The socket match has an own matchinfo structure, with one boolean field,
transparent, which is true when only transparent sockets can be matched.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 include/linux/netfilter/xt_socket.h |    8 ++++++++
 net/netfilter/xt_socket.c           |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_socket.h

diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
new file mode 100644
index 0000000..2222d63
--- /dev/null
+++ b/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,8 @@
+#ifndef _XT_SOCKET_H_match
+#define _XT_SOCKET_H_match
+
+struct xt_socket_match_info {
+	__u8 transparent:1;
+};
+
+#endif /* _XT_SOCKET_H_match */
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 1acc089..b894a10 100644
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
@@ -94,6 +96,7 @@ socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	__be32 daddr, saddr;
 	__be16 dport, sport;
 	u8 protocol;
+	const struct xt_socket_match_info *info = par->matchinfo;
 #ifdef XT_SOCKET_HAVE_CONNTRACK
 	struct nf_conn const *ct;
 	enum ip_conntrack_info ctinfo;
@@ -142,10 +145,14 @@ socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 				   saddr, daddr, sport, dport, par->in, false);
 	if (sk != NULL) {
 		bool wildcard = (sk->sk_state != TCP_TIME_WAIT && inet_sk(sk)->rcv_saddr == 0);
+		bool transparent = (sk->sk_state != TCP_TIME_WAIT && inet_sk(sk)->transparent) ||
+				   (sk->sk_state == TCP_TIME_WAIT && inet_twsk(sk)->tw_transparent);
 
 		nf_tproxy_put_sock(sk);
 		if (wildcard)
 			sk = NULL;
+		else if (info->transparent && !transparent)
+			sk = NULL;
 	}
 
 	pr_debug("socket match: proto %u %08x:%u -> %08x:%u "
@@ -161,6 +168,7 @@ static struct xt_match socket_mt_reg __read_mostly = {
 	.name		= "socket",
 	.family		= AF_INET,
 	.match		= socket_mt,
+	.matchsize	= sizeof(struct xt_socket_match_info),
 	.hooks		= 1 << NF_INET_PRE_ROUTING,
 	.me		= THIS_MODULE,
 };
-- 
1.6.2.2.404.ge96f3

