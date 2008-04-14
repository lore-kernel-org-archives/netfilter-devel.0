From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/41]: nf_conntrack_netlink: clean up NAT protocol parsing
Date: Mon, 14 Apr 2008 12:16:45 +0200 (MEST)
Message-ID: <20080414101642.32717.14843.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36292 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYDNKQq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:46 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_netlink: clean up NAT protocol parsing

Move responsibility for setting the IP_NAT_RANGE_PROTO_SPECIFIED flag
to the NAT protocol, properly propagate errors and get rid of ugly
return value convention.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6bc4343f9bea8ef5d8229a98e18f928064fa3f15
tree 1bcdcea2c5992ddbc0391fd2d0c5fb37b6aa042d
parent 89cebbb26f6542cdeb224adc6c871150221dd0c9
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:50 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:50 +0200

 net/ipv4/netfilter/nf_nat_proto_common.c |   18 +++++-------------
 net/netfilter/nf_conntrack_netlink.c     |   15 +++------------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_proto_common.c b/net/ipv4/netfilter/nf_nat_proto_common.c
index ef4dc39..4904b86 100644
--- a/net/ipv4/netfilter/nf_nat_proto_common.c
+++ b/net/ipv4/netfilter/nf_nat_proto_common.c
@@ -105,24 +105,16 @@ EXPORT_SYMBOL_GPL(nf_nat_proto_nlattr_to_range);
 int nf_nat_proto_nlattr_to_range(struct nlattr *tb[],
 				 struct nf_nat_range *range)
 {
-	int ret = 0;
-
-	/* we have to return whether we actually parsed something or not */
-
 	if (tb[CTA_PROTONAT_PORT_MIN]) {
-		ret = 1;
 		range->min.all = nla_get_be16(tb[CTA_PROTONAT_PORT_MIN]);
+		range->max.all = range->min.tcp.port;
+		range->flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 	}
-
-	if (!tb[CTA_PROTONAT_PORT_MAX]) {
-		if (ret)
-			range->max.all = range->min.all;
-	} else {
-		ret = 1;
+	if (tb[CTA_PROTONAT_PORT_MAX]) {
 		range->max.all = nla_get_be16(tb[CTA_PROTONAT_PORT_MAX]);
+		range->flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 	}
-
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_nat_proto_range_to_nlattr);
 #endif
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4a1b42b..79d5ecd 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -705,19 +705,10 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 		return err;
 
 	npt = nf_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
-
-	if (!npt->nlattr_to_range) {
-		nf_nat_proto_put(npt);
-		return 0;
-	}
-
-	/* nlattr_to_range returns 1 if it parsed, 0 if not, neg. on error */
-	if (npt->nlattr_to_range(tb, range) > 0)
-		range->flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
-
+	if (npt->nlattr_to_range)
+		err = npt->nlattr_to_range(tb, range);
 	nf_nat_proto_put(npt);
-
-	return 0;
+	return err;
 }
 
 static const struct nla_policy nat_nla_policy[CTA_NAT_MAX+1] = {
