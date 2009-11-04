From: Jan Engelhardt <jengelh@medozas.de>
Subject: xt_connlimit kernel fix (610)
Date: Wed, 4 Nov 2009 22:42:03 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911042240580.16279@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34509 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701AbZKDVl6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:41:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Just a carbon copy of bugzilla.NF#610, as I do not know whether bz 
notifies you.

parent 1e13cbc53085fc50ddb5f500218af806b8ae9d68 (v2.6.32-rc3-7-g1e13cbc)
commit a7fe7609f6555189e9c743305fce640ae87f7825
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Nov 4 14:27:30 2009 +0100

netfilter: xt_connlimit: fix zero family value

Commit v2.6.28-rc1~717^2~109^2~2 was slightly incomplete; not all
instances of par->match->family were changed to par->family.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_connlimit.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 6809809..38f03f7 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -103,7 +103,7 @@ static int count_them(struct xt_connlimit_data *data,
 		      const struct nf_conntrack_tuple *tuple,
 		      const union nf_inet_addr *addr,
 		      const union nf_inet_addr *mask,
-		      const struct xt_match *match)
+		      u_int8_t family)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct xt_connlimit_conn *conn;
@@ -113,8 +113,7 @@ static int count_them(struct xt_connlimit_data *data,
 	bool addit = true;
 	int matches = 0;
 
-
-	if (match->family == NFPROTO_IPV6)
+	if (family == NFPROTO_IPV6)
 		hash = &data->iphash[connlimit_iphash6(addr, mask)];
 	else
 		hash = &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
@@ -157,8 +156,7 @@ static int count_them(struct xt_connlimit_data *data,
 			continue;
 		}
 
-		if (same_source_net(addr, mask, &conn->tuple.src.u3,
-		    match->family))
+		if (same_source_net(addr, mask, &conn->tuple.src.u3, family))
 			/* same source network -> be counted! */
 			++matches;
 		nf_ct_put(found_ct);
@@ -207,7 +205,7 @@ connlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 
 	spin_lock_bh(&info->data->lock);
 	connections = count_them(info->data, tuple_ptr, &addr,
-	                         &info->mask, par->match);
+	                         &info->mask, par->family);
 	spin_unlock_bh(&info->data->lock);
 
 	if (connections < 0) {
-- 
# Created with git-export-patch
