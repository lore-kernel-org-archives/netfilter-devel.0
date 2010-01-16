From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] xt_connlimit: netns support
Date: Sat, 16 Jan 2010 17:50:19 +0200
Message-ID: <20100116155019.GA4086@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:58451 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab0APPu0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:50:26 -0500
Received: by fxm25 with SMTP id 25so1032769fxm.21
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2010 07:50:25 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/xt_connlimit.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -99,7 +99,8 @@ same_source_net(const union nf_inet_addr *addr,
 	}
 }
 
-static int count_them(struct xt_connlimit_data *data,
+static int count_them(struct net *net,
+		      struct xt_connlimit_data *data,
 		      const struct nf_conntrack_tuple *tuple,
 		      const union nf_inet_addr *addr,
 		      const union nf_inet_addr *mask,
@@ -122,7 +123,7 @@ static int count_them(struct xt_connlimit_data *data,
 
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, tmp, hash, list) {
-		found    = nf_conntrack_find_get(&init_net, &conn->tuple);
+		found    = nf_conntrack_find_get(net, &conn->tuple);
 		found_ct = NULL;
 
 		if (found != NULL)
@@ -180,6 +181,7 @@ static int count_them(struct xt_connlimit_data *data,
 static bool
 connlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
+	struct net *net = dev_net(par->in ? par->in : par->out);
 	const struct xt_connlimit_info *info = par->matchinfo;
 	union nf_inet_addr addr;
 	struct nf_conntrack_tuple tuple;
@@ -204,7 +206,7 @@ connlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	}
 
 	spin_lock_bh(&info->data->lock);
-	connections = count_them(info->data, tuple_ptr, &addr,
+	connections = count_them(net, info->data, tuple_ptr, &addr,
 	                         &info->mask, par->family);
 	spin_unlock_bh(&info->data->lock);
 
