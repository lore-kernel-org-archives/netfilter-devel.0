From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2] netfilter: nfnetlink: Remove VLA usage
Date: Wed, 30 May 2018 12:17:56 -0700
Message-ID: <20180530191756.GA39504@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
allocates the maximum size expected for all possible attrs and adds
sanity-checks at both registration and usage to make sure nothing
gets out of sync.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2: Use a static value and add a check in nfnetlink_subsys_register()
---
 net/netfilter/nfnetlink.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 03ead8a9e90c..1a80fdcf008f 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -37,6 +37,8 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
 	rcu_dereference_protected(table[(id)].subsys, \
 				  lockdep_nfnl_is_held((id)))
 
+#define NFNL_MAX_ATTR_COUNT	32
+
 static struct {
 	struct mutex				mutex;
 	const struct nfnetlink_subsystem __rcu	*subsys;
@@ -76,6 +78,13 @@ EXPORT_SYMBOL_GPL(lockdep_nfnl_is_held);
 
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
@@ -185,11 +194,17 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -379,10 +394,16 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
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
2.17.0


-- 
Kees Cook
Pixel Security
