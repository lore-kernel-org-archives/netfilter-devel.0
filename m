From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 6/7] nf: ipv4 defragmentation users counter changes in xt_socket
 match
Date: Mon, 05 May 2014 16:56:28 +0400
Message-ID: <53678A7C.9030701@parallels.com>
References: <20140503233908.GA6297@localhost> <cover.1399292146.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:47495 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611AbaEEM6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 08:58:01 -0400
In-Reply-To: <cover.1399292146.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/netfilter/xt_socket.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 1ba6793..982bd58 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -388,6 +388,12 @@ socket_mt6_v1_v2(const struct sk_buff *skb, struct xt_action_param *par)
 }
 #endif
 
+static int socket_mt4_v0_check(const struct xt_mtchk_param *par)
+{
+	inc_br_defrag_ipv4_users_count(par->net);
+	return 0;
+}
+
 static int socket_mt_v1_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
@@ -396,6 +402,8 @@ static int socket_mt_v1_check(const struct xt_mtchk_param *par)
 		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V1);
 		return -EINVAL;
 	}
+	if (par->family == NFPROTO_IPV4)
+		inc_br_defrag_ipv4_users_count(par->net);
 	return 0;
 }
 
@@ -407,15 +415,24 @@ static int socket_mt_v2_check(const struct xt_mtchk_param *par)
 		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V2);
 		return -EINVAL;
 	}
+	if (par->family == NFPROTO_IPV4)
+		inc_br_defrag_ipv4_users_count(par->net);
 	return 0;
 }
 
+static void socket_mt4_destroy(const struct xt_mtdtor_param *par)
+{
+	dec_br_defrag_ipv4_users_count(par->net);
+}
+
 static struct xt_match socket_mt_reg[] __read_mostly = {
 	{
 		.name		= "socket",
 		.revision	= 0,
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt4_v0,
+		.checkentry	= socket_mt4_v0_check,
+		.destroy	= socket_mt4_destroy,
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
 		.me		= THIS_MODULE,
@@ -426,6 +443,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt4_v1_v2,
 		.checkentry	= socket_mt_v1_check,
+		.destroy	= socket_mt4_destroy,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
@@ -450,6 +468,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt4_v1_v2,
 		.checkentry	= socket_mt_v2_check,
+		.destroy	= socket_mt4_destroy,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
-- 
1.7.5.4

