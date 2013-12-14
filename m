From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH RFC nf_conntrack_tcp] Export ip_ct_tcp_state variables to userspace
Date: Sat, 14 Dec 2013 17:46:11 +0100
Message-ID: <1387039571-6110-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57087 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3LNQqW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Dec 2013 11:46:22 -0500
Received: by mail-lb0-f182.google.com with SMTP id l4so260354lbv.13
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Dec 2013 08:46:21 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

Several of the TCP state variables tracked by conntrack are interesting for
userspace applications. This patch adds additional netlink attributes and
exports the rest of the variables contained in the ip_ct_tcp_state-struct, as
well as retrans from struct ip_ct_tcp. The size of the netlink message
increases, but as protoinfo is only called on get/dump, I don't think the
increased buffer requirement should be a problem.

One example of a use case for these variables is to make monitoring of TCP
connections on middleboxes easier and more efficient.  Applications would no
longer have to detect and keep track of TCP connections them self, they could
rather rely on the information provided by conntrack. By monitoring the
development of the sequence numbers and the window size, and using snapshots of
retrans, one could for example detect the type of tcp flow (thin/thick) and say
something about the quality of the link.

Would this functionality be useful or is the cost of a bigger message is too
large? If it is useful, what would be the best way to implement this
functionality? Now that all of ip_ct_tcp_state is contained in the message,
would it better to export the whole struct (similar to how it is done with
tcp_info and inet_diag)?

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |  9 +++++++++
 net/netfilter/nf_conntrack_proto_tcp.c             | 20 +++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index acad6c5..f27fa5f 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -106,6 +106,15 @@ enum ctattr_protoinfo_tcp {
 	CTA_PROTOINFO_TCP_WSCALE_REPLY,
 	CTA_PROTOINFO_TCP_FLAGS_ORIGINAL,
 	CTA_PROTOINFO_TCP_FLAGS_REPLY,
+	CTA_PROTOINFO_TCP_END_ORIGINAL,
+	CTA_PROTOINFO_TCP_END_REPLY,
+	CTA_PROTOINFO_TCP_MAXEND_ORIGINAL,
+	CTA_PROTOINFO_TCP_MAXEND_REPLY,
+	CTA_PROTOINFO_TCP_MAXWIN_ORIGINAL,
+	CTA_PROTOINFO_TCP_MAXWIN_REPLY,
+	CTA_PROTOINFO_TCP_MAXACK_ORIGINAL,
+	CTA_PROTOINFO_TCP_MAXACK_REPLY,
+	CTA_PROTOINFO_TCP_RETRANS,
 	__CTA_PROTOINFO_TCP_MAX
 };
 #define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 44d1ea3..17e85e5 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1166,7 +1166,25 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	    nla_put_u8(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
 		       ct->proto.tcp.seen[0].td_scale) ||
 	    nla_put_u8(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY,
-		       ct->proto.tcp.seen[1].td_scale))
+		       ct->proto.tcp.seen[1].td_scale) ||
+	    nla_put_u32(skb, CTA_PROTOINFO_TCP_END_ORIGINAL,
+		       ct->proto.tcp.seen[0].td_end) ||
+	    nla_put_u32(skb, CTA_PROTOINFO_TCP_END_REPLY,
+		       ct->proto.tcp.seen[1].td_end) ||
+	    nla_put_u32(skb, CTA_PROTOINFO_TCP_MAXEND_ORIGINAL,
+		       ct->proto.tcp.seen[0].td_maxend) ||
+	    nla_put_u32(skb, CTA_PROTOINFO_TCP_MAXEND_REPLY,
+		       ct->proto.tcp.seen[1].td_maxend) ||
+	    nla_put_u32(skb, CTA_PROTOINFO_TCP_MAXWIN_ORIGINAL,
+		       ct->proto.tcp.seen[0].td_maxwin) ||
+	    nla_put_u32(skb, CTA_PROTOINFO_TCP_MAXWIN_REPLY,
+		       ct->proto.tcp.seen[1].td_maxwin) ||
+	    nla_put_u32(skb, CTA_PROTOINFO_TCP_MAXACK_ORIGINAL,
+		       ct->proto.tcp.seen[0].td_maxack) ||
+	    nla_put_u32(skb, CTA_PROTOINFO_TCP_MAXACK_REPLY,
+		       ct->proto.tcp.seen[1].td_maxack) ||
+	    nla_put_u8(skb, CTA_PROTOINFO_TCP_RETRANS,
+		       ct->proto.tcp.retrans))
 		goto nla_put_failure;
 
 	tmp.flags = ct->proto.tcp.seen[0].flags;
-- 
1.8.3.2

