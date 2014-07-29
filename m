From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nfnetlink_acct: use flag to reset counters
Date: Tue, 29 Jul 2014 18:32:09 +0200
Message-ID: <20140729163208.GA3739@salvia>
References: <20140725160123.GA20548@salvia>
 <1406570272-3704-2-git-send-email-a.perevalov@samsung.com>
 <20140728215325.GA4093@salvia>
 <53D78978.5090408@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kyungmin.park@samsung.com, hs81.go@samsung.com,
	netfilter-devel@vger.kernel.org, alexey.perevalov@hotmail.com,
	mathieu.poirier@linaro.org
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59371 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbaG2QcH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:32:07 -0400
Content-Disposition: inline
In-Reply-To: <53D78978.5090408@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 29, 2014 at 03:46:00PM +0400, Alexey Perevalov wrote:
[...]
> >>@@ -143,7 +157,9 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
> >>  	if (nla_put_string(skb, NFACCT_NAME, acct->name))
> >>  		goto nla_put_failure;
> >>-	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
> >>+	if (type == NFNL_MSG_ACCT_GET_CTRZERO &&
> >>+		(!nfacct_flags || is_counters_reset(nfacct_flags, acct->flags) ||
> >>+		is_quotas_reset(nfacct_flags, acct->flags))) {
> >Replacing this:
> >
> >                 acct->flags & nfacct_flags == nfacct_flags
> >
> >I think it should be enough.
> >
> Yes, agree, but how to be with just counters without a quota,
> at first look it should be
> #define NFACCT_F_COUNTER ~(NFACCT_F_QUOTA_PKTS |
> NFACCT_F_QUOTA_BYTES | NFACCT_F_OVERQUOTA)

Right. I get the problem, what I proposed is not enough.

We can extend this in a more flexible way to allow better filtering
from userspace, eg.

NFACCT_FLAGS_FILTER (nest)
 NFACCT_VALUE (u32)
 NFACCT_MASK (u32)

The use the value and the mask to perform:

value & filter->mask == filter->data

Where filter comes from netlink cb->data.

Please, see this thread:

http://www.spinics.net/lists/netfilter-devel/msg32173.html

The idea is very similar. We should only have one single key after
your patch to filter by flags.

Is this OK for your needs?

> Also I decided to put such condition not into nfnl_acct_fill_info,
> but directly into nfnl_acct_dump, it will make this feature more
> general,
> client will get ability to filter it not only for reset command, but
> also for list command, also nfnl_acct_fill_info is using in many
> places, e.g.
> just get command or nfnl_overquota_report.

Right, the filtering should be generic for both list and reset
commands.

> And finally, I found strange approach for working with
> NFACCT_F_OVERQUOTA (value 1 << 2, 4), in nfnl_acct_overquota the
> test_and_set_bit function is used, which wants
> Nth bit, and that Nth bit is 4, but not 2. Clearing is fine
> clear_bit accept Nth bit as well,
> but nfnl_acct_new gets from netlink attribute NFACCT_F_OVERQUOTA not
> as offset value.

That's a bug. Would you also send a separated patch for that, please?

> I took a look at it because of:
> 1. It's not convenient to keep combined bit set for
> NFACCT_F_COUNTER, because NFACCT_F_OVERQUOTA not what we have in
> acct->flags. Of course if you not against such bit set.
> 2. nlnf_overquata_report sends to user space _forth_ activated bit,
> but not _second_ for NFACCT_F_OVERQUOTA, but
> NFACCT_F_QUOTA_[BYTES|PKTS] was being sent as is. Output of the
> nfacct, after overquota event occurred, not so clear, in case of
> bytes quota it's just changing to package. It's not a big deal to
> fix it to print "overquoted", but I feel it's better to use some
> unified method to set bits.

That's inconsistent and this of course needs a fix. Patch? Thanks.
