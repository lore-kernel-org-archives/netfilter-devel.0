From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 1/2] conntrack: Flush connections with a given mark
Date: Wed, 7 Jan 2015 19:56:53 +0100
Message-ID: <20150107185653.GA3469@salvia>
References: <1419411431-24715-1-git-send-email-kristian.evensen@gmail.com>
 <1419411431-24715-2-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57937 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbbAGSyJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:54:09 -0500
Content-Disposition: inline
In-Reply-To: <1419411431-24715-2-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kristian,

On Wed, Dec 24, 2014 at 09:57:10AM +0100, Kristian Evensen wrote:
> This patch adds support for selective flushing of conntrack mappings. By adding
> CTA_MARK and CTA_MARK_MASK to a delete-message, the mark (and mask) is checked
> before a connection is deleted while flushing.
> 
> Configuring the flush is moved out of ctnetlink_del_conntrack(), and instead of
> calling nf_conntrack_flush_report(), we always call nf_ct_iterate_cleanup().
> This enables us to only make one call from the new ctnetlink_flush_conntrack()
> and makes it easy to add more filter parameters.
> 
> Filtering is done in the ctnetlink_apply_filter()-function, which is also called
> from ctnetlink_dump_table(). ctnetlink_dump_filter has been renamed
> ctnetlink_filter, to indicated that it is no longer only used when dumping
> conntrack entries.

I'm attaching a revisited version of your patch, main changes are:

1) strict type checking in the dump case (for the ctnetlink_filter
object), instead of relying on the genering void * to keep the
ct_iterate happy. It adds a bit more code but I prefer it like this.

2) Explicitly reject mark filters when marks are not supported. This
changes the previous behaviour, but I think this is good to have so
userspace knows that what it is requesting is not support (instead of
silently ignoring it).

3) add helper function to allocate the filter object, so this always
needs explicit release.

Please, have a look a it and let me know if you're fine with it. I'll
pass it to net-next (upcoming 3.20).

Thanks for your patience.

--SLDf9lqlvOQaIe6s
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-conntrack-Flush-connections-with-a-given-m.patch"

>From 2ee5d3941fd06694ddb945e2b96795e8693bfef1 Mon Sep 17 00:00:00 2001
From: Kristian Evensen <kristian.evensen@gmail.com>
Date: Wed, 24 Dec 2014 09:57:10 +0100
Subject: [PATCH] netfilter: conntrack: Flush connections with a given mark

This patch adds support for selective flushing of conntrack mappings.
By adding CTA_MARK and CTA_MARK_MASK to a delete-message, the mark (and
mask) is checked before a connection is deleted while flushing.

Configuring the flush is moved out of ctnetlink_del_conntrack(), and
instead of calling nf_conntrack_flush_report(), we always call
nf_ct_iterate_cleanup().  This enables us to only make one call from the
new ctnetlink_flush_conntrack() and makes it easy to add more filter
parameters.

Filtering is done in the ctnetlink_apply_filter()-function, which is
also called from ctnetlink_dump_table(). ctnetlink_dump_filter has been
renamed ctnetlink_filter, to indicated that it is no longer only used
when dumping conntrack entries.

Moreover, reject mark filters with -EOPNOTSUPP if no ct mark support is
available.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |   90 ++++++++++++++++++++++++----------
 1 file changed, 65 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1bd9ed9..5df801a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -749,13 +749,44 @@ static int ctnetlink_done(struct netlink_callback *cb)
 	return 0;
 }
 
-struct ctnetlink_dump_filter {
+struct ctnetlink_filter {
 	struct {
 		u_int32_t val;
 		u_int32_t mask;
 	} mark;
 };
 
+static struct ctnetlink_filter *
+ctnetlink_alloc_filter(const struct nlattr * const cda[])
+{
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	struct ctnetlink_filter *filter;
+
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+	if (filter == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
+	filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+
+	return filter;
+#endif
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static int ctnetlink_filter(struct nf_conn *i, struct ctnetlink_filter *filter)
+{
+	if (filter == NULL)
+		return 0;
+
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	if ((i->mark & filter->mark.mask) == filter->mark.val)
+		return 0;
+#endif
+
+	return 1;
+}
+
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
@@ -768,10 +799,6 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	int res;
 	spinlock_t *lockp;
 
-#ifdef CONFIG_NF_CONNTRACK_MARK
-	const struct ctnetlink_dump_filter *filter = cb->data;
-#endif
-
 	last = (struct nf_conn *)cb->args[1];
 
 	local_bh_disable();
@@ -798,12 +825,9 @@ restart:
 					continue;
 				cb->args[1] = 0;
 			}
-#ifdef CONFIG_NF_CONNTRACK_MARK
-			if (filter && !((ct->mark & filter->mark.mask) ==
-					filter->mark.val)) {
+			if (ctnetlink_filter(ct, cb->data))
 				continue;
-			}
-#endif
+
 			rcu_read_lock();
 			res =
 			ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
@@ -1001,6 +1025,29 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 };
 
+static int ctnl_flush_filter(struct nf_conn *i, void *data)
+{
+	return ctnetlink_filter(i, data) == 0;
+}
+
+static int ctnetlink_flush_conntrack(struct net *net,
+				     const struct nlattr * const cda[],
+				     u32 portid, int report)
+{
+	struct ctnetlink_filter *filter = NULL;
+
+	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
+		filter = ctnetlink_alloc_filter(cda);
+		if (IS_ERR(filter))
+			return PTR_ERR(filter);
+	}
+
+	nf_ct_iterate_cleanup(net, ctnl_flush_filter, filter, portid, report);
+	kfree(filter);
+
+	return 0;
+}
+
 static int
 ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			const struct nlmsghdr *nlh,
@@ -1024,11 +1071,9 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	else if (cda[CTA_TUPLE_REPLY])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY, u3);
 	else {
-		/* Flush the whole table */
-		nf_conntrack_flush_report(net,
-					 NETLINK_CB(skb).portid,
-					 nlmsg_report(nlh));
-		return 0;
+		return ctnetlink_flush_conntrack(net, cda,
+						 NETLINK_CB(skb).portid,
+						 nlmsg_report(nlh));
 	}
 
 	if (err < 0)
@@ -1076,21 +1121,16 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			.dump = ctnetlink_dump_table,
 			.done = ctnetlink_done,
 		};
-#ifdef CONFIG_NF_CONNTRACK_MARK
+
 		if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
-			struct ctnetlink_dump_filter *filter;
+			struct ctnetlink_filter *filter;
 
-			filter = kzalloc(sizeof(struct ctnetlink_dump_filter),
-					 GFP_ATOMIC);
-			if (filter == NULL)
-				return -ENOMEM;
+			filter = ctnetlink_alloc_filter(cda);
+			if (IS_ERR(filter))
+				return PTR_ERR(filter);
 
-			filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
-			filter->mark.mask =
-				ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
 			c.data = filter;
 		}
-#endif
 		return netlink_dump_start(ctnl, skb, nlh, &c);
 	}
 
-- 
1.7.10.4


--SLDf9lqlvOQaIe6s--
