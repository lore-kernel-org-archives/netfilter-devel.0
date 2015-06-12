From: Harout Hedeshian <harouth@codeaurora.org>
Subject: [PATCH nf-next] netfilter: xt_socket: add XT_SOCKET_MATCHSOCKMARK flag and mark fields
Date: Fri, 12 Jun 2015 16:39:55 -0600
Message-ID: <1434148795-19937-1-git-send-email-harouth@codeaurora.org>
Cc: Lorenzo Colitti <lorenzo@google.com>,
	Harout Hedeshian <harouth@codeaurora.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56406 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbbFLWkW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 18:40:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_socket is useful for matching sockets with IP_TRANSPARENT and
taking some action on the matching packets. However, it lacks the
ability to match only a small subset of transparent sockets.

Suppose there are 2 applications, each with its own set of transparent
sockets. The first application wants all matching packets dropped,
while the second application wants them forwarded somewhere else.

Add the ability to match sockets based on the socket mark.

Now the 2 hypothetical applications can differentiate their sockets
based on a mark value set with SO_MARK.

iptables -t mangle -I PREROUTING -m socket --transparent --mark 10 -J act1
iptables -t mangle -I PREROUTING -m socket --transparent --mark 11 -J act2

The mark field also takes an optional mask and is invertable.

Signed-off-by: Harout Hedeshian <harouth@codeaurora.org>
---
 include/uapi/linux/netfilter/xt_socket.h |  10 +++
 net/netfilter/xt_socket.c                | 108 +++++++++++++++++++++++++++++--
 2 files changed, 112 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_socket.h b/include/uapi/linux/netfilter/xt_socket.h
index 6315e2a..3a7304e 100644
--- a/include/uapi/linux/netfilter/xt_socket.h
+++ b/include/uapi/linux/netfilter/xt_socket.h
@@ -6,6 +6,7 @@
 enum {
 	XT_SOCKET_TRANSPARENT = 1 << 0,
 	XT_SOCKET_NOWILDCARD = 1 << 1,
+	XT_SOCKET_MATCHSOCKMARK = 1 << 2,
 };
 
 struct xt_socket_mtinfo1 {
@@ -18,4 +19,13 @@ struct xt_socket_mtinfo2 {
 };
 #define XT_SOCKET_FLAGS_V2 (XT_SOCKET_TRANSPARENT | XT_SOCKET_NOWILDCARD)
 
+struct xt_socket_mtinfo3 {
+	__u8 flags;
+	__u32 mark, mask;
+	__u8 invert_mark;
+};
+#define XT_SOCKET_FLAGS_V3 (XT_SOCKET_TRANSPARENT \
+			   | XT_SOCKET_NOWILDCARD \
+			   | XT_SOCKET_MATCHSOCKMARK)
+
 #endif /* _XT_SOCKET_H */
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index e092cb0..abbba03 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -203,7 +203,7 @@ static struct sock *xt_socket_lookup_slow_v4(const struct sk_buff *skb,
 
 static bool
 socket_match(const struct sk_buff *skb, struct xt_action_param *par,
-	     const struct xt_socket_mtinfo1 *info)
+	     const struct xt_socket_mtinfo3 *info)
 {
 	struct sock *sk = skb->sk;
 
@@ -212,6 +212,7 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 	if (sk) {
 		bool wildcard;
 		bool transparent = true;
+		bool markmatch = true;
 
 		/* Ignore sockets listening on INADDR_ANY,
 		 * unless XT_SOCKET_NOWILDCARD is set
@@ -226,10 +227,17 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 		if (info->flags & XT_SOCKET_TRANSPARENT)
 			transparent = xt_socket_sk_is_transparent(sk);
 
+		/* Ignore sockets which are not marked a certain value
+		 * if XT_SOCKET_MATCHSOCKMARK is set
+		 */
+		if (info->flags & XT_SOCKET_MATCHSOCKMARK)
+			markmatch = ((sk->sk_mark & info->mask) == info->mark)
+				    ^ info->invert_mark;
+
 		if (sk != skb->sk)
 			sock_gen_put(sk);
 
-		if (wildcard || !transparent)
+		if (wildcard || !transparent || !markmatch)
 			sk = NULL;
 	}
 
@@ -239,8 +247,11 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 static bool
 socket_mt4_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
-	static struct xt_socket_mtinfo1 xt_info_v0 = {
+	static struct xt_socket_mtinfo3 xt_info_v0 = {
 		.flags = 0,
+		.mark = 0,
+		.mask = 0,
+		.invert_mark = 0,
 	};
 
 	return socket_match(skb, par, &xt_info_v0);
@@ -249,6 +260,22 @@ socket_mt4_v0(const struct sk_buff *skb, struct xt_action_param *par)
 static bool
 socket_mt4_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 {
+	struct xt_socket_mtinfo1 *xt_info  =
+				     (struct xt_socket_mtinfo1 *)par->matchinfo;
+	static struct xt_socket_mtinfo3 xt_info_v1 = {
+		.flags = 0,
+		.mark = 0,
+		.mask = 0,
+		.invert_mark = 0,
+	};
+	xt_info_v1.flags = xt_info->flags;
+
+	return socket_match(skb, par, &xt_info_v1);
+}
+
+static bool
+socket_mt4_v3(const struct sk_buff *skb, struct xt_action_param *par)
+{
 	return socket_match(skb, par, par->matchinfo);
 }
 
@@ -371,9 +398,10 @@ static struct sock *xt_socket_lookup_slow_v6(const struct sk_buff *skb,
 }
 
 static bool
-socket_mt6_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
+socket_match6(const struct sk_buff *skb,
+	      struct xt_action_param *par,
+	      const struct xt_socket_mtinfo3 *info)
 {
-	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
 	struct sock *sk = skb->sk;
 
 	if (!sk)
@@ -381,6 +409,7 @@ socket_mt6_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 	if (sk) {
 		bool wildcard;
 		bool transparent = true;
+		bool markmatch = true;
 
 		/* Ignore sockets listening on INADDR_ANY
 		 * unless XT_SOCKET_NOWILDCARD is set
@@ -395,15 +424,44 @@ socket_mt6_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 		if (info->flags & XT_SOCKET_TRANSPARENT)
 			transparent = xt_socket_sk_is_transparent(sk);
 
+		/* Ignore sockets which are not marked a certain value
+		 *  if XT_SOCKET_MATCHSOCKMARK is set
+		 */
+		if (info->flags & XT_SOCKET_MATCHSOCKMARK)
+			markmatch = ((sk->sk_mark & info->mask) == info->mark)
+				    ^ info->invert_mark;
+
 		if (sk != skb->sk)
 			sock_gen_put(sk);
 
-		if (wildcard || !transparent)
+		if (wildcard || !transparent || !markmatch)
 			sk = NULL;
 	}
 
 	return sk != NULL;
 }
+
+static bool
+socket_mt6_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	struct xt_socket_mtinfo1 *xt_info  =
+				     (struct xt_socket_mtinfo1 *)par->matchinfo;
+	static struct xt_socket_mtinfo3 xt_info_v1 = {
+		.flags = 0,
+		.mark = 0,
+		.mask = 0,
+		.invert_mark = 0,
+	};
+	xt_info_v1.flags = xt_info->flags;
+
+	return socket_match6(skb, par, &xt_info_v1);
+}
+
+static bool
+socket_mt6_v3(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	return socket_match6(skb, par, par->matchinfo);
+}
 #endif
 
 static int socket_mt_v1_check(const struct xt_mtchk_param *par)
@@ -428,6 +486,20 @@ static int socket_mt_v2_check(const struct xt_mtchk_param *par)
 	return 0;
 }
 
+static int socket_mt_v3_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_socket_mtinfo3 *info =
+				    (struct xt_socket_mtinfo3 *)par->matchinfo;
+
+	if (info->flags & ~XT_SOCKET_FLAGS_V3) {
+		pr_info("unknown flags 0x%x\n",
+			info->flags & ~XT_SOCKET_FLAGS_V3);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static struct xt_match socket_mt_reg[] __read_mostly = {
 	{
 		.name		= "socket",
@@ -486,6 +558,30 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.me		= THIS_MODULE,
 	},
 #endif
+	{
+		.name		= "socket",
+		.revision	= 3,
+		.family		= NFPROTO_IPV4,
+		.match		= socket_mt4_v3,
+		.checkentry	= socket_mt_v3_check,
+		.matchsize	= sizeof(struct xt_socket_mtinfo3),
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN),
+		.me		= THIS_MODULE,
+	},
+#ifdef XT_SOCKET_HAVE_IPV6
+	{
+		.name		= "socket",
+		.revision	= 3,
+		.family		= NFPROTO_IPV6,
+		.match		= socket_mt6_v3,
+		.checkentry	= socket_mt_v3_check,
+		.matchsize	= sizeof(struct xt_socket_mtinfo3),
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN),
+		.me		= THIS_MODULE,
+	},
+#endif
 };
 
 static int __init socket_mt_init(void)
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

