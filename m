From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next 1/2] netfilter: persistent aliases for l4 nat protocols
Date: Thu,  6 Oct 2016 19:09:28 +0200
Message-ID: <588ab5926ff8d1da17536f4511bbcaba5f84a3ff.1475773632.git.dcaratti@redhat.com>
References: <cover.1475773632.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942409AbcJFRJs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2016 13:09:48 -0400
In-Reply-To: <cover.1475773632.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

add macro MODULE_ALIAS_NF_NAT_L4PROTO to provide generic and persistent
aliases for those layer-4 transport protocols whose NAT support is not
built-in into nf_nat.ko.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/netfilter/nf_nat_l4proto.h | 3 +++
 net/netfilter/nf_nat_proto_dccp.c      | 1 +
 net/netfilter/nf_nat_proto_sctp.c      | 1 +
 net/netfilter/nf_nat_proto_udplite.c   | 1 +
 4 files changed, 6 insertions(+)

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 12f4cc8..f4f592e 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -69,4 +69,7 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range *range);
 
+#define MODULE_ALIAS_NF_NAT_L4PROTO(l4protocol) \
+	MODULE_ALIAS("nf-nat-l4-" __stringify(l4protocol))
+
 #endif /*_NF_NAT_L4PROTO_H*/
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index 15c47b2..da67e56 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -114,3 +114,4 @@ module_exit(nf_nat_proto_dccp_fini);
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("DCCP NAT protocol helper");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NF_NAT_L4PROTO(33); /* IPPROTO_DCCP */
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index cbc7ade..8e001cc 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -94,3 +94,4 @@ module_exit(nf_nat_proto_sctp_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SCTP NAT protocol helper");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_ALIAS_NF_NAT_L4PROTO(132); /* IPPROTO_SCTP */
diff --git a/net/netfilter/nf_nat_proto_udplite.c b/net/netfilter/nf_nat_proto_udplite.c
index 58340c9..be0fb65 100644
--- a/net/netfilter/nf_nat_proto_udplite.c
+++ b/net/netfilter/nf_nat_proto_udplite.c
@@ -104,3 +104,4 @@ module_exit(nf_nat_proto_udplite_fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("UDP-Lite NAT protocol helper");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_ALIAS_NF_NAT_L4PROTO(136); /* IPPROTO_UDPLITE */
-- 
2.5.5

