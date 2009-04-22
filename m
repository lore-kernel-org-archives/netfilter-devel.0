From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: conntrack: add missing role attributes for DCCP
Date: Wed, 22 Apr 2009 14:28:07 +0200
Message-ID: <20090422122807.14461.906.stgit@Decadence>
References: <20090422122306.14461.55699.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44577 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZDVM2R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:28:17 -0400
In-Reply-To: <20090422122306.14461.55699.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds missing role attributes to the DCCP type, otherwise
the creation of entries is not of any use.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/nfnetlink_conntrack.h |    2 ++
 net/netfilter/nf_conntrack_proto_dccp.c       |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 29fe9ea..4f967e2 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -100,6 +100,8 @@ enum ctattr_protoinfo_tcp {
 enum ctattr_protoinfo_dccp {
 	CTA_PROTOINFO_DCCP_UNSPEC,
 	CTA_PROTOINFO_DCCP_STATE,
+	CTA_PROTOINFO_DCCP_ROLE_ORIGINAL,
+	CTA_PROTOINFO_DCCP_ROLE_REPLY,
 	__CTA_PROTOINFO_DCCP_MAX,
 };
 #define CTA_PROTOINFO_DCCP_MAX (__CTA_PROTOINFO_DCCP_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 50dac8d..eb851e3 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -633,6 +633,10 @@ static int dccp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	if (!nest_parms)
 		goto nla_put_failure;
 	NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state);
+	NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_ROLE_ORIGINAL,
+		   ct->proto.dccp.role[IP_CT_DIR_ORIGINAL]);
+	NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_ROLE_REPLY,
+		   ct->proto.dccp.role[IP_CT_DIR_REPLY]);
 	nla_nest_end(skb, nest_parms);
 	read_unlock_bh(&dccp_lock);
 	return 0;
@@ -661,11 +665,18 @@ static int nlattr_to_dccp(struct nlattr *cda[], struct nf_conn *ct)
 		return err;
 
 	if (!tb[CTA_PROTOINFO_DCCP_STATE] ||
-	    nla_get_u8(tb[CTA_PROTOINFO_DCCP_STATE]) >= CT_DCCP_IGNORE)
+	    !tb[CTA_PROTOINFO_DCCP_ROLE_ORIGINAL] ||
+	    !tb[CTA_PROTOINFO_DCCP_ROLE_REPLY] ||
+	    nla_get_u8(tb[CTA_PROTOINFO_DCCP_STATE]) >= CT_DCCP_IGNORE) {
 		return -EINVAL;
+	}
 
 	write_lock_bh(&dccp_lock);
 	ct->proto.dccp.state = nla_get_u8(tb[CTA_PROTOINFO_DCCP_STATE]);
+	ct->proto.dccp.role[IP_CT_DIR_ORIGINAL] =
+		nla_get_u8(tb[CTA_PROTOINFO_DCCP_ROLE_ORIGINAL]);
+	ct->proto.dccp.role[IP_CT_DIR_REPLY] =
+		nla_get_u8(tb[CTA_PROTOINFO_DCCP_ROLE_REPLY]);
 	write_unlock_bh(&dccp_lock);
 	return 0;
 }

