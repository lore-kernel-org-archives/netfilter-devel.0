From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH] conntrack: Flush connections with given work
Date: Fri, 19 Dec 2014 11:18:25 +0100
Message-ID: <1418984305-18857-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42096 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaLSKSe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Dec 2014 05:18:34 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so882662wgh.30
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Dec 2014 02:18:33 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for selective flushing of conntrack mappings. By adding
CTA_MARK and CTA_MARK_MASK to a delete-message, the mark is checked before a
connection is deleted while flushing.

One use-case for this feature is on multihomed systems using policy routing
(based on marks). If say for example the next-hop's internet connection goes
down, it is desirable to be able to "reset" all connections using that
interface. However, since the device might be communicating with other devices
on the local network, it is not desitable to set the interface as down.

An iptables-rules can then be used to match not NEW connections without a mark.
generating for example a TCP RST.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1bd9ed9..9626b8f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1001,6 +1001,18 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 };
 
+#ifdef CONFIG_NF_CONNTRACK_MARK
+static int ctnetlink_filter_mark(struct nf_conn *i, void *data)
+{
+	struct ctnetlink_dump_filter *filter = data;
+
+	if ((i->mark & filter->mark.mask) == filter->mark.val)
+		return 1;
+	else
+		return 0;
+}
+#endif
+
 static int
 ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			const struct nlmsghdr *nlh,
@@ -1023,6 +1035,18 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG, u3);
 	else if (cda[CTA_TUPLE_REPLY])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY, u3);
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	else if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
+		struct ctnetlink_dump_filter filter = {
+			.mark.val = ntohl(nla_get_be32(cda[CTA_MARK])),
+			.mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]))
+		};
+
+		nf_ct_iterate_cleanup(net, ctnetlink_filter_mark, &filter,
+				      NETLINK_CB(skb).portid,
+				      nlmsg_report(nlh));
+	}
+#endif
 	else {
 		/* Flush the whole table */
 		nf_conntrack_flush_report(net,
-- 
2.1.0

