From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/20] netfilter: nfnetlink: Remove VLA usage
Date: Sat,  2 Jun 2018 02:22:56 +0200
Message-ID: <20180602002259.4024-18-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Kees Cook <keescook@chromium.org>

In the quest to remove all stack VLA usage from the kernel[1], this
allocates the maximum size expected for all possible attrs and adds
sanity-checks at both registration and usage to make sure nothing
gets out of sync.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 261820627711..4d0da7042aff 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -38,6 +38,8 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
 	rcu_dereference_protected(table[(id)].subsys, \
 				  lockdep_nfnl_is_held((id)))
 
+#define NFNL_MAX_ATTR_COUNT	32
+
 static struct {
 	struct mutex				mutex;
 	const struct nfnetlink_subsystem __rcu	*subsys;
@@ -77,6 +79,13 @@ EXPORT_SYMBOL_GPL(lockdep_nfnl_is_held);
 
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n)
 {
+	u8 cb_id;
+
+	/* Sanity-check attr_count size to avoid stack buffer overflow. */
+	for (cb_id = 0; cb_id < n->cb_count; cb_id++)
+		if (WARN_ON(n->cb[cb_id].attr_count > NFNL_MAX_ATTR_COUNT))
+			return -EINVAL;
+
 	nfnl_lock(n->subsys_id);
 	if (table[n->subsys_id].subsys) {
 		nfnl_unlock(n->subsys_id);
@@ -186,11 +195,17 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	{
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 		u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
-		struct nlattr *cda[ss->cb[cb_id].attr_count + 1];
+		struct nlattr *cda[NFNL_MAX_ATTR_COUNT + 1];
 		struct nlattr *attr = (void *)nlh + min_len;
 		int attrlen = nlh->nlmsg_len - min_len;
 		__u8 subsys_id = NFNL_SUBSYS_ID(type);
 
+		/* Sanity-check NFNL_MAX_ATTR_COUNT */
+		if (ss->cb[cb_id].attr_count > NFNL_MAX_ATTR_COUNT) {
+			rcu_read_unlock();
+			return -ENOMEM;
+		}
+
 		err = nla_parse(cda, ss->cb[cb_id].attr_count, attr, attrlen,
 				ss->cb[cb_id].policy, extack);
 		if (err < 0) {
@@ -387,10 +402,16 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		{
 			int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 			u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
-			struct nlattr *cda[ss->cb[cb_id].attr_count + 1];
+			struct nlattr *cda[NFNL_MAX_ATTR_COUNT + 1];
 			struct nlattr *attr = (void *)nlh + min_len;
 			int attrlen = nlh->nlmsg_len - min_len;
 
+			/* Sanity-check NFTA_MAX_ATTR */
+			if (ss->cb[cb_id].attr_count > NFNL_MAX_ATTR_COUNT) {
+				err = -ENOMEM;
+				goto ack;
+			}
+
 			err = nla_parse(cda, ss->cb[cb_id].attr_count, attr,
 					attrlen, ss->cb[cb_id].policy, NULL);
 			if (err < 0)
-- 
2.11.0
