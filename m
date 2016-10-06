From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next 2/2] xt_nat: probe module for non-builtin L4 protocols
Date: Thu,  6 Oct 2016 19:09:29 +0200
Message-ID: <06167f035d50086571206d0f211c4b7196cd810f.1475773632.git.dcaratti@redhat.com>
References: <cover.1475773632.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942409AbcJFRJu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2016 13:09:50 -0400
In-Reply-To: <cover.1475773632.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

autoload nf_nat_proto_{dccp,sctp,udplite}.ko on invocation of checkentry()
callback, if rule matches DCCP, SCTP or UDPLITE protocols. This avoids
situations where, after a SNAT/DNAT rule with specified sport/dport is
created, no port translation is done unless the user manually loads
nf_nat_proto_{dccp,udplite,sctp}.ko with insmod/modprobe commands.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/netfilter/xt_nat.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index bea7464..b78023d 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -13,6 +13,44 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_l4proto.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+static void xt_nat_probe_proto(const struct xt_tgchk_param *par)
+{
+	const struct ip6t_ip6 *i6;
+	const struct ipt_ip *i;
+	u8 proto, l4proto;
+
+	switch (par->family) {
+	case NFPROTO_IPV4:
+		i = (const struct ipt_ip *)par->entryinfo;
+		if (i->invflags & IPT_INV_PROTO)
+			return;
+		proto = i->proto;
+		break;
+	case NFPROTO_IPV6:
+		i6 = (const struct ip6t_ip6 *)par->entryinfo;
+		if (i6->invflags & IP6T_INV_PROTO)
+			return;
+		proto = i6->proto;
+		break;
+	default:
+		return;
+	}
+
+	switch (proto) {
+	case IPPROTO_UDPLITE:
+	case IPPROTO_SCTP:
+	case IPPROTO_DCCP:
+		rcu_read_lock();
+		l4proto = __nf_nat_l4proto_find(par->family, proto)->l4proto;
+		rcu_read_unlock();
+		if (!l4proto)
+			request_module("nf-nat-l4-%u", proto);
+	}
+}
 
 static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
 {
@@ -23,6 +61,13 @@ static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
 			par->target->name);
 		return -EINVAL;
 	}
+	xt_nat_probe_proto(par);
+	return 0;
+}
+
+static int xt_nat_checkentry_v1(const struct xt_tgchk_param *par)
+{
+	xt_nat_probe_proto(par);
 	return 0;
 }
 
@@ -129,6 +174,7 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 	{
 		.name		= "SNAT",
 		.revision	= 1,
+		.checkentry     = xt_nat_checkentry_v1,
 		.target		= xt_snat_target_v1,
 		.targetsize	= sizeof(struct nf_nat_range),
 		.table		= "nat",
@@ -139,6 +185,7 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 	{
 		.name		= "DNAT",
 		.revision	= 1,
+		.checkentry     = xt_nat_checkentry_v1,
 		.target		= xt_dnat_target_v1,
 		.targetsize	= sizeof(struct nf_nat_range),
 		.table		= "nat",
-- 
2.5.5

