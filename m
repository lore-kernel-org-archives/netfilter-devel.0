From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5] netfilter: xtables: add quota support for nfacct
Date: Wed, 12 Mar 2014 13:12:04 +0100
Message-ID: <20140312121204.GA5049@localhost>
References: <1392740402-14952-1-git-send-email-mathieu.poirier@linaro.org>
 <20140225175410.GA25784@localhost>
 <CANLsYkw4aMQU4NM=oHdJBuPiHAagUck-eM6MEwaNGNcyoBVgYg@mail.gmail.com>
 <20140310210227.GA23426@localhost>
 <CANLsYkwh+hgqyfH84=Lp+PN0ufV9ug0sPNPvVMfD1iUxkYGsuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47913 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaCLMMO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:12:14 -0400
Content-Disposition: inline
In-Reply-To: <CANLsYkwh+hgqyfH84=Lp+PN0ufV9ug0sPNPvVMfD1iUxkYGsuA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 09:24:33AM -0600, Mathieu Poirier wrote:
> >> >>       __NFACCT_MAX
> >> >>  };
> >> >>  #define NFACCT_MAX (__NFACCT_MAX - 1)
> >> >> diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
> >> >> index 3e19c8a..7c35ce0 100644
> >> >> --- a/include/uapi/linux/netfilter/xt_nfacct.h
> >> >> +++ b/include/uapi/linux/netfilter/xt_nfacct.h
> >> >> @@ -3,11 +3,27 @@
> >> >>
> >> >>  #include <linux/netfilter/nfnetlink_acct.h>
> >> >>
> >> >> +enum xt_quota_flags {
> >> >> +     XT_NFACCT_QUOTA_PKTS    = 1 << 0,
> >> >> +     XT_NFACCT_QUOTA         = 1 << 1,
> >> >> +};
> >> >> +
> >> >>  struct nf_acct;
> >> >> +struct nf_acct_quota;
> >> >>
> >> >>  struct xt_nfacct_match_info {
> >> >>       char            name[NFACCT_NAME_MAX];
> >> >> -     struct nf_acct  *nfacct;
> >> >> +     struct nf_acct  *nfacct __aligned(8);
> >> >>  };
> >> >>
> >> >> +struct xt_nfacct_match_info_v1 {
> >> >> +     char            name[NFACCT_NAME_MAX];
> >> >> +     struct nf_acct  *nfacct __aligned(8);
> >> >
> >> > You have to move at the bottom of the structure, before the new
> >> > nf_acct_quota.
> >> >
> >> > The extension from userspace sets the .userspacesize field, which
> >> > helps iptables to skip internal pointers that are set by the kernel,
> >> > If you don't fix this, iptables -D to delete a rule with nfacct will
> >> > not work.
> >>
> >> Thanks for pointing that out - I've been experiencing problems with
> >> "iptables -D".
> >
> > BTW, don't change the layout of xt_nfacct_match_info, leave it as is.
> > Only use struct nf_acct  *nfacct __aligned(8); in struct
> > xt_nfacct_match_info_v1, OK?
> 
> Ok, but why?  There is obviously a reason and I don't understand it.

If you change it, you're breaking the binary interface, so old
iptables versions will not work anymore.

So the problem is that 32/64 architectures are currently broken
without that alignment, so let's fix that with your new revision 1. The
revision 0 has to stay as is, we can't fix that one, it's too late as
it will break anyone already having an old iptables binary.

[...]
> >> Dealing with the overhead introduced by clearing the "notified" flag
> >> is completely different from the management of "quota" objects.  To do
> >> this the best solution is to introduce a callback to reset the flag
> >> when a "nfacct" object gets reset.  That would be simple and in line
> >> with what is used ubiquitously in the kernel.
> >>
> >> Moving the management of "quota" objects to nfnetlink_acct is a
> >> completely different ball game.  Not only that, it would also mandate
> >> to make changes to nfacct, libnfnl and libnl.  It would also require
> >> to pull a few tricks to make all that extra code compile conditionally
> >> when XT_QUOTA is not selected, unless we want to automatically select
> >> XT_QUOTA when NETLINK_ACCT gets enabled.  And what happens when
> >> another quota type-of-thing comes along?  We keep stuffing "nfacct"
> >> and "nfnetlink_acct.c" with more functionality?
> >
> > This is the most generic thing to make it.
> >
> > How the user will inspect if quota has been already fulfilled? And how
> > will the user reset it in case it needs it? Or simply upgrade the
> > quota without reloading the rule?
> 
> Since quotas are intrinsically linked to nfacct objects, the best way
> to know if a quota has been reached is to look at the statistics for
> the corresponding nfacct object.

OK, let's put the quota on the nfacct object using some variable size
tricks. Please see the (unfinished) patch attached, it's just compile
tested.

The missing chunks are the xt_nfacct.c change and the userspace code
updates.

> > You have to provide a netlink interface if you want to implement
> > this in a nice way.  Otherwise, I bet that someone will come with
> > yet another hackish /proc interface for this, no please. Or worst,
> > people will code perl scripts to parse the iptables -L -n output.
> 
> We could create a sysfs entry for each quota but it doesn't scale well.

/sysfs doesn't make any better than /proc IMO. The standard interface
in netfilter is netlink, let's stick to that.

> > Of course, it's more code to nfnetlink_acct, the libraries and the
> > utility, but this will be pretty generic and we'll provide a nice
> > interface.
> >
> > And again, thinking of nftables, if we implement the quota management
> > code in nfnetlink_acct, adding support for nfacct and quota will just
> > require very little code since we'll reuse most of the common
> > infrastructure.
> >
> > I really think the quota management code belongs nfnetlink_acct, not
> > xt_nfacct.
> 
> I'm not against your idea but the thought of starting over after 1)
> agreeing on a design and 2) investing so much time is disappointing.
> If we end up choosing your way, would you prefer enhancing the nfacct
> tool with quota capabilities or adding something like "nfquota"?
> Personally I would prefer the latter as it scales better.

Enhancing the nfacct tool is good.

Let me know if you find any problem with the patch I sent you. Thanks.

--NzB8fVQJ5HfG6fxh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="nfacct-quota.patch"

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index b2e85e5..5d74dd1 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -9,5 +9,6 @@ struct nf_acct;
 struct nf_acct *nfnl_acct_find_get(const char *filter_name);
 void nfnl_acct_put(struct nf_acct *acct);
 void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
+bool nfnl_acct_overquota(const struct sk_buff *skb, struct nf_acct *nfacct);
 
 #endif /* _NFNL_ACCT_H */
diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 596ddd4..354a7e5 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -20,6 +20,8 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
 	NFNLGRP_NFTABLES,
 #define NFNLGRP_NFTABLES                NFNLGRP_NFTABLES
+	NFNLGRP_ACCT_QUOTA,
+#define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index c7b6269..51404ec 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -10,15 +10,24 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_GET,
 	NFNL_MSG_ACCT_GET_CTRZERO,
 	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_OVERQUOTA,
 	NFNL_MSG_ACCT_MAX
 };
 
+enum nfnl_acct_flags {
+	NFACCT_F_QUOTA_PKTS	= (1 << 0),
+	NFACCT_F_QUOTA_BYTES	= (1 << 1),
+	NFACCT_F_OVERQUOTA	= (1 << 2), /* can't be set from userspace */
+};
+
 enum nfnl_acct_type {
 	NFACCT_UNSPEC,
 	NFACCT_NAME,
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_FLAGS,
+	NFACCT_QUOTA,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c7b6d46..d55e720 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -32,18 +32,24 @@ static LIST_HEAD(nfnl_acct_list);
 struct nf_acct {
 	atomic64_t		pkts;
 	atomic64_t		bytes;
+	unsigned long		flags;
 	struct list_head	head;
 	atomic_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
 	struct rcu_head		rcu_head;
+	char			data[0];
 };
 
+#define NFACCT_F_QUOTA (NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES)
+
 static int
 nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
 {
 	struct nf_acct *nfacct, *matching = NULL;
 	char *acct_name;
+	unsigned int size = 0;
+	u32 flags = 0;
 
 	if (!tb[NFACCT_NAME])
 		return -EINVAL;
@@ -68,15 +74,39 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 			/* reset counters if you request a replacement. */
 			atomic64_set(&matching->pkts, 0);
 			atomic64_set(&matching->bytes, 0);
+			smp_mb__before_clear_bit();
+			/* reset overquota flag if quota is enabled. */
+			if ((matching->flags & NFACCT_F_QUOTA))
+			     clear_bit(NFACCT_F_OVERQUOTA, &matching->flags);
+
 			return 0;
 		}
 		return -EBUSY;
 	}
 
-	nfacct = kzalloc(sizeof(struct nf_acct), GFP_KERNEL);
+	if (tb[NFACCT_FLAGS]) {
+		flags = ntohl(nla_get_be32(tb[NFACCT_FLAGS]));
+		if (flags & ~NFACCT_F_QUOTA)
+			return -EOPNOTSUPP;
+		if ((flags & NFACCT_F_QUOTA) == NFACCT_F_QUOTA)
+			return -EINVAL;
+		if (flags & NFACCT_F_OVERQUOTA)
+			return -EINVAL;
+
+		size += sizeof(u64);
+	}
+
+	nfacct = kzalloc(sizeof(struct nf_acct) + size, GFP_KERNEL);
 	if (nfacct == NULL)
 		return -ENOMEM;
 
+	if (flags & NFACCT_F_QUOTA) {
+		u64 *quota = (u64 *)nfacct->data;
+
+		*quota = be64_to_cpu(nla_get_be64(tb[NFACCT_QUOTA]));
+		nfacct->flags = flags;
+	}
+
 	strncpy(nfacct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
 
 	if (tb[NFACCT_BYTES]) {
@@ -125,7 +155,13 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes)) ||
 	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
 		goto nla_put_failure;
+	if (acct->flags & NFACCT_F_QUOTA) {
+		u64 *quota = (u64 *)acct->data;
 
+		if (nla_put_be32(skb, NFACCT_FLAGS, htonl(acct->flags)) ||
+		    nla_put_be64(skb, NFACCT_QUOTA, cpu_to_be64(*quota)))
+			goto nla_put_failure;
+	}
 	nlmsg_end(skb, nlh);
 	return skb->len;
 
@@ -270,6 +306,8 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
 	[NFACCT_BYTES] = { .type = NLA_U64 },
 	[NFACCT_PKTS] = { .type = NLA_U64 },
+	[NFACCT_FLAGS] = { .type = NLA_U32 },
+	[NFACCT_QUOTA] = { .type = NLA_U64 },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
@@ -336,6 +374,47 @@ void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
 }
 EXPORT_SYMBOL_GPL(nfnl_acct_update);
 
+static void nfnl_overquota_report(struct nf_acct *nfacct)
+{
+	int ret;
+	struct sk_buff *skb;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (skb == NULL)
+		return;
+
+	ret = nfnl_acct_fill_info(skb, 0, 0, NFNL_MSG_ACCT_OVERQUOTA, 0,
+				  nfacct);
+	if (ret <= 0) {
+		kfree_skb(skb);
+		return;
+	}
+	netlink_broadcast(init_net.nfnl, skb, 0, NFNLGRP_ACCT_QUOTA,
+			  GFP_ATOMIC);
+}
+
+bool nfnl_acct_overquota(const struct sk_buff *skb, struct nf_acct *nfacct)
+{
+	u64 *quota;
+	bool ret = false;
+
+	if (nfacct->flags & NFACCT_F_QUOTA_PKTS) {
+		quota = (u64 *)nfacct->data;
+		ret = atomic64_read(&nfacct->pkts) >= *quota &&
+		      !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags);
+	}
+	if (nfacct->flags & NFACCT_F_QUOTA_BYTES) {
+		quota = (u64 *)nfacct->data;
+		ret = atomic64_read(&nfacct->bytes) >= *quota &&
+		      !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags);
+	}
+	if (ret)
+		nfnl_overquota_report(nfacct);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nfnl_acct_overquota);
+
 static int __init nfnl_acct_init(void)
 {
 	int ret;

--NzB8fVQJ5HfG6fxh--
