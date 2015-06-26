From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nf] netfilter: nfnetlink: keep going batch handling on missing modules
Date: Fri, 26 Jun 2015 10:01:40 +0200
Message-ID: <1435305700-8768-2-git-send-email-pablo@netfilter.org>
References: <1435305700-8768-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44475 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbbFZH4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 03:56:22 -0400
In-Reply-To: <1435305700-8768-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After a fresh boot with no modules in place at all and a large rulesets, the
existing nfnetlink_rcv_batch() funcion can take long time to commit the ruleset
due to the many abort path. This is specifically a problem for the existing
client of this code, ie. nf_tables, since it results in several
synchronize_rcu() call in a row.

This patch changes the policy to keep full batch processing on missing modules
errors so we abort only once.

Reported-by: Eric Leblond <eric@regit.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Tested-by: Eric Leblond <eric@regit.org>
---
 net/netfilter/nfnetlink.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 8b117c9..e87f6c7 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -276,13 +276,16 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	const struct nfnetlink_subsystem *ss;
 	const struct nfnl_callback *nc;
-	bool success = true, done = false;
+	bool success, done, missing_modules;
 	static LIST_HEAD(err_list);
 	int err;
 
 	if (subsys_id >= NFNL_SUBSYS_COUNT)
 		return netlink_ack(skb, nlh, -EINVAL);
 replay:
+	done = missing_modules = false;
+	success = true;
+
 	skb = netlink_skb_clone(oskb, GFP_KERNEL);
 	if (!skb)
 		return netlink_ack(oskb, nlh, -ENOMEM);
@@ -382,11 +385,8 @@ replay:
 			 * original skb.
 			 */
 			if (err == -EAGAIN) {
-				nfnl_err_reset(&err_list);
-				ss->abort(oskb);
-				nfnl_unlock(subsys_id);
-				kfree_skb(skb);
-				goto replay;
+				missing_modules = true;
+				goto next;
 			}
 		}
 ack:
@@ -412,17 +412,24 @@ ack:
 			if (err)
 				success = false;
 		}
-
+next:
 		msglen = NLMSG_ALIGN(nlh->nlmsg_len);
 		if (msglen > skb->len)
 			msglen = skb->len;
 		skb_pull(skb, msglen);
 	}
 done:
-	if (success && done)
+	if (missing_modules) {
+		ss->abort(oskb);
+		nfnl_err_reset(&err_list);
+		nfnl_unlock(subsys_id);
+		kfree_skb(skb);
+		goto replay;
+	} else if (success && done) {
 		ss->commit(oskb);
-	else
+	} else {
 		ss->abort(oskb);
+	}
 
 	nfnl_err_deliver(&err_list, oskb);
 	nfnl_unlock(subsys_id);
-- 
1.7.10.4

