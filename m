From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH] [connlimit] connlimit-above early loop termination
Date: Fri, 11 Feb 2011 11:22:15 -0500
Message-ID: <1297441335.25407.9.camel@d941e-10>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:44228 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab1BKQWS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Feb 2011 11:22:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch below introduces an early termination of the loop that is
counting matches. It terminates once the counter has exceeded the
threshold provided by the user. There's no point in continuing the loop
afterwards and looking at other entries.

It plays together with the following code further below:

return (connections > info->limit) ^ info->inverse;

where connections is the result of the counted connection, which in turn
is the matches variable in the loop. So once 

        -> matches = info->limit + 1    
alias   -> matches > info->limit
alias   -> matches > threshold 

we can terminate the loop.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com> 


diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 5c5b6b9..f3ced9c 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -97,7 +97,8 @@ static int count_them(struct net *net,
 		      const struct nf_conntrack_tuple *tuple,
 		      const union nf_inet_addr *addr,
 		      const union nf_inet_addr *mask,
-		      u_int8_t family)
+		      u_int8_t family,
+		      unsigned int threshold)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct xt_connlimit_conn *conn;
@@ -151,9 +152,14 @@ static int count_them(struct net *net,
 			continue;
 		}

-		if (same_source_net(addr, mask, &conn->tuple.src.u3, family))
+		if (same_source_net(addr, mask, &conn->tuple.src.u3, family)) {
 			/* same source network -> be counted! */
 			++matches;
+			if (matches > threshold) {
+				nf_ct_put(found_ct);
+				break;
+			}
+		}
 		nf_ct_put(found_ct);
 	}

@@ -201,7 +207,8 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)

 	spin_lock_bh(&info->data->lock);
 	connections = count_them(net, info->data, tuple_ptr, &addr,
-	                         &info->mask, par->family);
+	                         &info->mask, par->family,
+	                         info->limit);
 	spin_unlock_bh(&info->data->lock);

 	if (connections < 0) {



