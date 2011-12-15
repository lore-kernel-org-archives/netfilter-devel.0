From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Thu, 15 Dec 2011 13:20:27 +0100
Message-ID: <20111215122027.GA14246@1984>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
 <1323860443-7129-2-git-send-email-pablo@netfilter.org>
 <4EE88729.7010507@trash.net>
 <20111214131802.GB2749@1984>
 <4EE8CF4B.9010005@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	jengelh@medozas.de, thomas.jarosch@intra2net.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35702 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab1LOMUu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Dec 2011 07:20:50 -0500
Content-Disposition: inline
In-Reply-To: <4EE8CF4B.9010005@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 14, 2011 at 05:31:07PM +0100, Patrick McHardy wrote:
> On 14.12.2011 14:18, Pablo Neira Ayuso wrote:
> > On Wed, Dec 14, 2011 at 12:23:21PM +0100, Patrick McHardy wrote:
> > [...]
> >>> +nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
> >>> +	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
> >>> +{
> >>> +	int ret;
> >>> +	struct nf_acct *acct, *matching = NULL;
> >>> +	char *acct_name;
> >>> +
> >>> +	if (!tb[NFACCT_NAME])
> >>> +		return -EINVAL;
> >>> +
> >>> +	acct_name = nla_data(tb[NFACCT_NAME]);
> >>> +
> >>> +	rcu_read_lock();
> >>> +	list_for_each_entry(acct,&nfnl_acct_list, head) {
> >>
> >> I don't really get the locking concept. All netlink operations happen under
> >> the nfnl mutex, so using RCU for the lookup shouldn't be necessary
> >> (applied to all netlink operations).
> > 
> > If you add one iptables rule with NFACCT, you have to iterate over the
> > list (without the mutex). Very unlikely, but we may delete one
> > accounting object via nfnetlink at the same time of adding the rule
> > that refers to it.
> 
> Sure. But we don't need it for any of the netlink operations.

Indeed. I have removed all rcu_read_[un]lock in the list iterations of
the netlink operations.

> >>> +        }
> >>> +	rcu_read_unlock();
> >>> +
> >>> +	acct = kzalloc(sizeof(struct nf_acct), GFP_KERNEL);
> >>> +	if (acct == NULL) {
> >>> +		ret = -ENOMEM;
> >>> +		goto err;
> >>> +	}
> >>> +	spin_lock_init(&acct->lock);
> >>> +	strncpy(acct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
> >>> +	if (tb[NFACCT_BYTES])
> >>> +		acct->bytes = be64_to_cpu(nla_get_u64(tb[NFACCT_BYTES]));
> >>> +	if (tb[NFACCT_PKTS])
> >>> +		acct->pkts = be64_to_cpu(nla_get_u64(tb[NFACCT_PKTS]));
> >>> +
> >>> +	atomic_inc(&acct->refcnt);
> >>> +
> >>> +	/* We are protected by nfnl mutex. */
> >>> +	if (matching) {
> >>
> >> This seems to be a replace operation, so I think you should
> >> require NLM_F_REPLACE. Also it seems you could just
> >> reinitialize the existing counter instead of unconditionally
> >> allocating a new one.
> > 
> > I think it's easier to return -EBUSY as you suggested.
> 
> That was for deletion. For addition supporting replace is fine, but
> we should use the correct netlink flags.

This is what I'm doing now in this case:

        if (matching) {
                if (nlh->nlmsg_flags & NLM_F_REPLACE) {
                        /* reset counters if you request a replacement. */
                        atomic64_set(&cur->pkts, 0);
                        atomic64_set(&cur->bytes, 0);
                        return 0;
                }
                        return -EBUSY;
        }

before that code (in the lookup) you have:

                if (nlh->nlmsg_flags & NLM_F_EXCL)
                        return -EEXIST;

So basically, if one object already exists and you try to create it:

1) with NLM_F_EXCL, you hit EEXIST.

1) with MLM_F_REPLACE, it sets counters to zero.

2) without NLM_F_EXCL and NLM_F_REPLACE, you hit EBUSY.
