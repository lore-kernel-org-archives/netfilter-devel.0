From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: conntrack: add support for DCCP handshake
	sequence to ctnetlink
Date: Wed, 27 May 2009 14:54:23 +0200
Message-ID: <20090527125423.11366.64989.stgit@Decadence>
References: <20090527125242.11366.70215.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51221 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762735AbZE0Ngb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 09:36:31 -0400
In-Reply-To: <20090527125242.11366.70215.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ that exposes
the u64 handshake sequence number to user-space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 net/netfilter/nf_conntrack_proto_dccp.c       |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 1a865e4..ed4ef8d 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -101,6 +101,7 @@ enum ctattr_protoinfo_dccp {
 	CTA_PROTOINFO_DCCP_UNSPEC,
 	CTA_PROTOINFO_DCCP_STATE,
 	CTA_PROTOINFO_DCCP_ROLE,
+	CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
 	__CTA_PROTOINFO_DCCP_MAX,
 };
 #define CTA_PROTOINFO_DCCP_MAX (__CTA_PROTOINFO_DCCP_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index aee0d6b..0831b5e 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -639,6 +639,8 @@ static int dccp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state);
 	NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_ROLE,
 		   ct->proto.dccp.role[IP_CT_DIR_ORIGINAL]);
+	NLA_PUT_U64(skb, CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
+		    ct->proto.dccp.handshake_seq);
 	nla_nest_end(skb, nest_parms);
 	read_unlock_bh(&dccp_lock);
 	return 0;
@@ -651,6 +653,7 @@ nla_put_failure:
 static const struct nla_policy dccp_nla_policy[CTA_PROTOINFO_DCCP_MAX + 1] = {
 	[CTA_PROTOINFO_DCCP_STATE]	= { .type = NLA_U8 },
 	[CTA_PROTOINFO_DCCP_ROLE]	= { .type = NLA_U8 },
+	[CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ] = { .type = NLA_U64 },
 };
 
 static int nlattr_to_dccp(struct nlattr *cda[], struct nf_conn *ct)
@@ -683,6 +686,10 @@ static int nlattr_to_dccp(struct nlattr *cda[], struct nf_conn *ct)
 		ct->proto.dccp.role[IP_CT_DIR_ORIGINAL] = CT_DCCP_ROLE_SERVER;
 		ct->proto.dccp.role[IP_CT_DIR_REPLY] = CT_DCCP_ROLE_CLIENT;
 	}
+	if (tb[CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ]) {
+		ct->proto.dccp.handshake_seq =
+			nla_get_u64(tb[CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ]);
+	}
 	write_unlock_bh(&dccp_lock);
 	return 0;
 }

