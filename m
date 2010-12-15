From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: xt_conntrack: support matching on port ranges
Date: Wed, 15 Dec 2010 09:46:26 +0100
Message-ID: <4D088062.3000805@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080508010209020205050705"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46771 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab0LOIq2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:46:28 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by stinky.trash.net (Postfix) with ESMTP id 43A62B2C5C
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2010 09:46:26 +0100 (MET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080508010209020205050705
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Add support for matching on port ranges to the conntrack match.
iptables patch will follow soon.


--------------080508010209020205050705
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x"

commit d9f56e82963575ec3275874e1529ec36683a082c
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Dec 15 08:07:19 2010 +0100

    netfilter: xt_conntrack: support matching on port ranges
    
    Add a new revision 3 that contains port ranges for all of origsrc,
    origdst, replsrc and repldst. The high ports are appended to the
    original v2 data structure to allow sharing most of the code with
    v1 and v2. Use of the revision specific port matching function is
    made dependant on par->match->revision.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 54f47a2..74b904d 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -58,4 +58,19 @@ struct xt_conntrack_mtinfo2 {
 	__u16 state_mask, status_mask;
 };
 
+struct xt_conntrack_mtinfo3 {
+	union nf_inet_addr origsrc_addr, origsrc_mask;
+	union nf_inet_addr origdst_addr, origdst_mask;
+	union nf_inet_addr replsrc_addr, replsrc_mask;
+	union nf_inet_addr repldst_addr, repldst_mask;
+	__u32 expires_min, expires_max;
+	__u16 l4proto;
+	__u16 origsrc_port, origdst_port;
+	__u16 replsrc_port, repldst_port;
+	__u16 match_flags, invert_flags;
+	__u16 state_mask, status_mask;
+	__u16 origsrc_port_high, origdst_port_high;
+	__u16 replsrc_port_high, repldst_port_high;
+};
+
 #endif /*_XT_CONNTRACK_H*/
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index e536710..4ef1b63 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -112,6 +112,54 @@ ct_proto_port_check(const struct xt_conntrack_mtinfo2 *info,
 	return true;
 }
 
+static inline bool
+port_match(u16 min, u16 max, u16 port, bool invert)
+{
+	return (port >= min && port <= max) ^ invert;
+}
+
+static inline bool
+ct_proto_port_check_v3(const struct xt_conntrack_mtinfo3 *info,
+		       const struct nf_conn *ct)
+{
+	const struct nf_conntrack_tuple *tuple;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	if ((info->match_flags & XT_CONNTRACK_PROTO) &&
+	    (nf_ct_protonum(ct) == info->l4proto) ^
+	    !(info->invert_flags & XT_CONNTRACK_PROTO))
+		return false;
+
+	/* Shortcut to match all recognized protocols by using ->src.all. */
+	if ((info->match_flags & XT_CONNTRACK_ORIGSRC_PORT) &&
+	    !port_match(info->origsrc_port, info->origsrc_port_high,
+			ntohs(tuple->src.u.all),
+			info->invert_flags & XT_CONNTRACK_ORIGSRC_PORT))
+		return false;
+
+	if ((info->match_flags & XT_CONNTRACK_ORIGDST_PORT) &&
+	    !port_match(info->origdst_port, info->origdst_port_high,
+			ntohs(tuple->dst.u.all),
+			info->invert_flags & XT_CONNTRACK_ORIGDST_PORT))
+		return false;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	if ((info->match_flags & XT_CONNTRACK_REPLSRC_PORT) &&
+	    !port_match(info->replsrc_port, info->replsrc_port_high,
+			ntohs(tuple->src.u.all),
+			info->invert_flags & XT_CONNTRACK_REPLSRC_PORT))
+		return false;
+
+	if ((info->match_flags & XT_CONNTRACK_REPLDST_PORT) &&
+	    !port_match(info->repldst_port, info->repldst_port_high,
+			ntohs(tuple->dst.u.all),
+			info->invert_flags & XT_CONNTRACK_REPLDST_PORT))
+		return false;
+
+	return true;
+}
+
 static bool
 conntrack_mt(const struct sk_buff *skb, struct xt_action_param *par,
              u16 state_mask, u16 status_mask)
@@ -170,8 +218,13 @@ conntrack_mt(const struct sk_buff *skb, struct xt_action_param *par,
 		    !(info->invert_flags & XT_CONNTRACK_REPLDST))
 			return false;
 
-	if (!ct_proto_port_check(info, ct))
-		return false;
+	if (par->match->revision != 3) {
+		if (!ct_proto_port_check(info, ct))
+			return false;
+	} else {
+		if (!ct_proto_port_check_v3(par->matchinfo, ct))
+			return false;
+	}
 
 	if ((info->match_flags & XT_CONNTRACK_STATUS) &&
 	    (!!(status_mask & ct->status) ^
@@ -207,6 +260,14 @@ conntrack_mt_v2(const struct sk_buff *skb, struct xt_action_param *par)
 	return conntrack_mt(skb, par, info->state_mask, info->status_mask);
 }
 
+static bool
+conntrack_mt_v3(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_conntrack_mtinfo3 *info = par->matchinfo;
+
+	return conntrack_mt(skb, par, info->state_mask, info->status_mask);
+}
+
 static int conntrack_mt_check(const struct xt_mtchk_param *par)
 {
 	int ret;
@@ -244,6 +305,16 @@ static struct xt_match conntrack_mt_reg[] __read_mostly = {
 		.destroy    = conntrack_mt_destroy,
 		.me         = THIS_MODULE,
 	},
+	{
+		.name       = "conntrack",
+		.revision   = 3,
+		.family     = NFPROTO_UNSPEC,
+		.matchsize  = sizeof(struct xt_conntrack_mtinfo3),
+		.match      = conntrack_mt_v3,
+		.checkentry = conntrack_mt_check,
+		.destroy    = conntrack_mt_destroy,
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init conntrack_mt_init(void)

--------------080508010209020205050705--
