From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 5/7] nf: ipv4 defragmentation users counter changes in TPROXY
 target
Date: Mon, 05 May 2014 16:56:19 +0400
Message-ID: <53678A73.8040502@parallels.com>
References: <20140503233908.GA6297@localhost> <cover.1399292146.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:18862 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbaEEM5w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 08:57:52 -0400
In-Reply-To: <cover.1399292146.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/netfilter/xt_TPROXY.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index ef8a926..ce99ad4 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -528,14 +528,21 @@ static int tproxy_tg4_check(const struct xt_tgchk_param *par)
 	const struct ipt_ip *i = par->entryinfo;
 
 	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
-	    && !(i->invflags & IPT_INV_PROTO))
+	    && !(i->invflags & IPT_INV_PROTO)) {
+		inc_br_defrag_ipv4_users_count(par->net);
 		return 0;
+	}
 
 	pr_info("Can be used only in combination with "
 		"either -p tcp or -p udp\n");
 	return -EINVAL;
 }
 
+void tproxy_tg4_destroy(const struct xt_tgdtor_param *par)
+{
+	dec_br_defrag_ipv4_users_count(par->net);
+}
+
 static struct xt_target tproxy_tg_reg[] __read_mostly = {
 	{
 		.name		= "TPROXY",
@@ -545,6 +552,7 @@ static struct xt_target tproxy_tg_reg[] __read_mostly = {
 		.revision	= 0,
 		.targetsize	= sizeof(struct xt_tproxy_target_info),
 		.checkentry	= tproxy_tg4_check,
+		.destroy	= tproxy_tg4_destroy,
 		.hooks		= 1 << NF_INET_PRE_ROUTING,
 		.me		= THIS_MODULE,
 	},
@@ -556,6 +564,7 @@ static struct xt_target tproxy_tg_reg[] __read_mostly = {
 		.revision	= 1,
 		.targetsize	= sizeof(struct xt_tproxy_target_info_v1),
 		.checkentry	= tproxy_tg4_check,
+		.destroy	= tproxy_tg4_destroy,
 		.hooks		= 1 << NF_INET_PRE_ROUTING,
 		.me		= THIS_MODULE,
 	},
-- 
1.7.5.4

