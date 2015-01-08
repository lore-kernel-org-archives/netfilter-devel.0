From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 1/2] conntrack: Flush connections with a given mark
Date: Thu, 8 Jan 2015 14:13:26 +0100
Message-ID: <20150108131326.GA13155@salvia>
References: <1419411431-24715-1-git-send-email-kristian.evensen@gmail.com>
 <1419411431-24715-2-git-send-email-kristian.evensen@gmail.com>
 <20150107185653.GA3469@salvia>
 <CAKfDRXjLRxXSG9zb0RLfF+tgZRy-DKy9Um57GdE3bA7DX3bhZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37602 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbbAHNKi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:10:38 -0500
Content-Disposition: inline
In-Reply-To: <CAKfDRXjLRxXSG9zb0RLfF+tgZRy-DKy9Um57GdE3bA7DX3bhZQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 07, 2015 at 09:05:22PM +0100, Kristian Evensen wrote:
> Hi Pablo,
> 
> On Wed, Jan 7, 2015 at 7:56 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 1) strict type checking in the dump case (for the ctnetlink_filter
> > object), instead of relying on the genering void * to keep the
> > ct_iterate happy. It adds a bit more code but I prefer it like this.
> >
> > 2) Explicitly reject mark filters when marks are not supported. This
> > changes the previous behaviour, but I think this is good to have so
> > userspace knows that what it is requesting is not support (instead of
> > silently ignoring it).
> >
> > 3) add helper function to allocate the filter object, so this always
> > needs explicit release.
> >
> > Please, have a look a it and let me know if you're fine with it. I'll
> > pass it to net-next (upcoming 3.20).
> 
> Thank you for making the improvements, the patch looks a lot better
> now! I only have on question/comment. What is the reason behind adding
> the ctnl_flush_filter()? Isn't it enough to have ctnetlink_filter()
> return 1 in case of match and 0 otherwise. At least, the way I think,
> it makes more sense when I read the code that if this function returns
> false, we should ignore conntrack entry due to no match. So the check
> in ctnetlink_dump_table() should read !ctnetlink_filter(). In
> addition, there is a small typo in the commit log. In the last
> paragraph it says ctnetlink_apply_filter(). After your changes, it is
> just called ctnetlink_filter().

I made some changes based on your comments, attached a new version of
your patch.

--OXfL5xGRrasGEqWY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-conntrack-Flush-connections-with-a-given-m.patch"

>From 866476f323465a8afef10b14b48d5136bf5c51fe Mon Sep 17 00:00:00 2001
From: Kristian Evensen <kristian.evensen@gmail.com>
Date: Wed, 24 Dec 2014 09:57:10 +0100
Subject: [PATCH nf-next] netfilter: conntrack: Flush connections with a given
 mark

This patch adds support for selective flushing of conntrack mappings.
By adding CTA_MARK and CTA_MARK_MASK to a delete-message, the mark (and
mask) is checked before a connection is deleted while flushing.

Configuring the flush is moved out of ctnetlink_del_conntrack(), and
instead of calling nf_conntrack_flush_report(), we always call
nf_ct_iterate_cleanup().  This enables us to only make one call from the
new ctnetlink_flush_conntrack() and makes it easy to add more filter
parameters.

Filtering is done in the ctnetlink_filter_match()-function, which is
also called from ctnetlink_dump_table(). ctnetlink_dump_filter has been
renamed ctnetlink_filter, to indicated that it is no longer only used
when dumping conntrack entries.

Moreover, reject mark filters with -EOPNOTSUPP if no ct mark support is
available.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |   89 ++++++++++++++++++++++++----------
 1 file changed, 64 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1bd9ed9..d1c2394 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -749,13 +749,47 @@ static int ctnetlink_done(struct netlink_callback *cb)
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
+#else
+	return ERR_PTR(-EOPNOTSUPP);
+#endif
+}
+
+static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
+{
+	struct ctnetlink_filter *filter = data;
+
+	if (filter == NULL)
+		return 1;
+
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	if ((ct->mark & filter->mark.mask) == filter->mark.val)
+		return 1;
+#endif
+
+	return 0;
+}
+
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
@@ -768,10 +802,6 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	int res;
 	spinlock_t *lockp;
 
-#ifdef CONFIG_NF_CONNTRACK_MARK
-	const struct ctnetlink_dump_filter *filter = cb->data;
-#endif
-
 	last = (struct nf_conn *)cb->args[1];
 
 	local_bh_disable();
@@ -798,12 +828,9 @@ restart:
 					continue;
 				cb->args[1] = 0;
 			}
-#ifdef CONFIG_NF_CONNTRACK_MARK
-			if (filter && !((ct->mark & filter->mark.mask) ==
-					filter->mark.val)) {
+			if (!ctnetlink_filter_match(ct, cb->data))
 				continue;
-			}
-#endif
+
 			rcu_read_lock();
 			res =
 			ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
@@ -1001,6 +1028,25 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 };
 
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
+	nf_ct_iterate_cleanup(net, ctnetlink_filter_match, filter,
+			      portid, report);
+	kfree(filter);
+
+	return 0;
+}
+
 static int
 ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			const struct nlmsghdr *nlh,
@@ -1024,11 +1070,9 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
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
@@ -1076,21 +1120,16 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
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


--OXfL5xGRrasGEqWY--
