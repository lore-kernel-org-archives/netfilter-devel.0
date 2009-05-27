From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: conntrack: add support for DCCP handshake
 sequence to ctnetlink
Date: Wed, 27 May 2009 16:50:09 +0200
Message-ID: <4A1D5321.1010006@netfilter.org>
References: <20090527125242.11366.70215.stgit@Decadence> <20090527125423.11366.64989.stgit@Decadence> <4A1D4A90.6030605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060307060909000901060005"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59590 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZE0P24 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 11:28:56 -0400
In-Reply-To: <4A1D4A90.6030605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060307060909000901060005
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> --- a/net/netfilter/nf_conntrack_proto_dccp.c
>> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
>> @@ -639,6 +639,8 @@ static int dccp_to_nlattr(struct sk_buff *skb,
>> struct nlattr *nla,
>>      NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state);
>>      NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_ROLE,
>>             ct->proto.dccp.role[IP_CT_DIR_ORIGINAL]);
>> +    NLA_PUT_U64(skb, CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
>> +            ct->proto.dccp.handshake_seq);
> 
> This should use big endian byteorder.

dccp_hdr_seq() returns a value in host byte order, which is used to
assign the value to handshake_seq. So, we need to use cpu_to_be64() to
convert the value to network byte order as other attributes in ctnetlink
which are in network byte order, right? :)

Patch attached.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060307060909000901060005
Content-Type: text/x-diff;
 name="ct-dccp-export-seq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ct-dccp-export-seq.patch"

netfilter: conntrack: add support for DCCP handshake sequence to ctnetlink

This patch adds CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ that exposes
the u64 handshake sequence number to user-space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 include/net/netlink.h                         |    9 +++++++++
 net/netfilter/nf_conntrack_proto_dccp.c       |    7 +++++++
 3 files changed, 17 insertions(+), 0 deletions(-)


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
diff --git a/include/net/netlink.h b/include/net/netlink.h
index eddb502..007bdb0 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -940,6 +940,15 @@ static inline u64 nla_get_u64(const struct nlattr *nla)
 }
 
 /**
+ * nla_get_be64 - return payload of __be64 attribute
+ * @nla: __be64 netlink attribute
+ */
+static inline __be64 nla_get_be64(const struct nlattr *nla)
+{
+	return *(__be64 *) nla_data(nla);
+}
+
+/**
  * nla_get_flag - return payload of flag attribute
  * @nla: flag netlink attribute
  */
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index aee0d6b..2952269 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -639,6 +639,8 @@ static int dccp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state);
 	NLA_PUT_U8(skb, CTA_PROTOINFO_DCCP_ROLE,
 		   ct->proto.dccp.role[IP_CT_DIR_ORIGINAL]);
+	NLA_PUT_BE64(skb, CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
+		     cpu_to_be64(ct->proto.dccp.handshake_seq));
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
+		be64_to_cpu(nla_get_be64(tb[CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ]));
+	}
 	write_unlock_bh(&dccp_lock);
 	return 0;
 }

--------------060307060909000901060005--
