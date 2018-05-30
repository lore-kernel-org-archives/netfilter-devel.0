From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] netfilter: nfnetlink: Remove VLA usage
Date: Tue, 29 May 2018 17:35:25 -0700
Message-ID: <20180530003525.GA18642@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
allocates the maximum size expected for all possible attrs and adds
a sanity-check to make sure nothing gets out of sync.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/netfilter/nfnetlink.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 03ead8a9e90c..0cb395f9627e 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -28,6 +28,7 @@
 
 #include <net/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
@@ -37,6 +38,11 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
 	rcu_dereference_protected(table[(id)].subsys, \
 				  lockdep_nfnl_is_held((id)))
 
+#define NFTA_MAX_ATTR	max(max(max(NFTA_CHAIN_MAX, NFTA_FLOWTABLE_MAX),\
+				max(NFTA_OBJ_MAX, NFTA_RULE_MAX)),	\
+			    max(NFTA_TABLE_MAX,				\
+				max(NFTA_SET_ELEM_LIST_MAX, NFTA_SET_MAX)))
+
 static struct {
 	struct mutex				mutex;
 	const struct nfnetlink_subsystem __rcu	*subsys;
@@ -185,11 +191,17 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	{
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 		u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
-		struct nlattr *cda[ss->cb[cb_id].attr_count + 1];
+		struct nlattr *cda[NFTA_MAX_ATTR + 1];
 		struct nlattr *attr = (void *)nlh + min_len;
 		int attrlen = nlh->nlmsg_len - min_len;
 		__u8 subsys_id = NFNL_SUBSYS_ID(type);
 
+		/* Sanity-check NFTA_MAX_ATTR */
+		if (ss->cb[cb_id].attr_count > NFTA_MAX_ATTR) {
+			rcu_read_unlock();
+			return -ENOMEM;
+		}
+
 		err = nla_parse(cda, ss->cb[cb_id].attr_count, attr, attrlen,
 				ss->cb[cb_id].policy, extack);
 		if (err < 0) {
@@ -379,10 +391,16 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		{
 			int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 			u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
-			struct nlattr *cda[ss->cb[cb_id].attr_count + 1];
+			struct nlattr *cda[NFTA_MAX_ATTR + 1];
 			struct nlattr *attr = (void *)nlh + min_len;
 			int attrlen = nlh->nlmsg_len - min_len;
 
+			/* Sanity-check NFTA_MAX_ATTR */
+			if (ss->cb[cb_id].attr_count > NFTA_MAX_ATTR) {
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
