Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070D7ECE58F
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 21:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D897220663
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 21:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbfJOVWH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 17:22:07 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46094 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfJOVWG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 17:22:06 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iKUGa-0006pA-SE; Tue, 15 Oct 2019 23:22:04 +0200
Date:   Tue, 15 Oct 2019 23:22:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: don't dump ct extensions
 of unconfirmed conntracks
Message-ID: <20191015212204.GR25052@breakpoint.cc>
References: <20191014194141.17626-1-fw@strlen.de>
 <20191015210647.GA16877@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015210647.GA16877@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> On 2019-10-14, at 21:41:41 +0200, Florian Westphal wrote:
> > When dumping the unconfirmed lists, the cpu that is processing the ct
> > entry can realloc ct->ext at any time.
> >
> > Accessing extensions from another CPU is ok provided rcu read lock is
> > held.
> >
> > Once extension space will be reallocated with plain krealloc this
> > isn't used anymore.
> >
> > Dumping the extension area for confirmed or dying conntracks is fine:
> > no reallocations are allowed and list iteration holds appropriate
> > locks that prevent ct (and thus ct->ext) from getting free'd.
> >
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/netfilter/nf_conntrack_netlink.c | 77 ++++++++++++++++++----------
> >  1 file changed, 51 insertions(+), 26 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index e2d13cd18875..db04e1bfb04d 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -506,9 +506,44 @@ static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
> >  	return -1;
> >  }
> >
> > +/* all these functions access ct->ext. Caller must either hold a reference
> > + * on ct or prevent its deletion by holding either the bucket spinlock or
> > + * pcpu dying list lock.
> > + */
> > +static int ctnetlink_dump_extinfo(struct sk_buff *skb,
> > +				  const struct nf_conn *ct, u32 type)
> > +{
> > +	if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
> > +	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
> > +	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
> > +	    ctnetlink_dump_labels(skb, ct) < 0 ||
> > +	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0 ||
> > +	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
> > +		return -1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
> > +{
> > +	if (ctnetlink_dump_status(skb, ct) < 0 ||
> > +	    ctnetlink_dump_mark(skb, ct) < 0 ||
> > +	    ctnetlink_dump_secctx(skb, ct) < 0 ||
> > +	    ctnetlink_dump_id(skb, ct) < 0 ||
> > +	    ctnetlink_dump_use(skb, ct) < 0 ||
> > +	    ctnetlink_dump_master(skb, ct) < 0)
> > +		return -1;
> > +
> > +	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
> > +	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
> > +	     ctnetlink_dump_protoinfo(skb, ct) < 0))
> > +
> > +	return 0;
> > +}
> > +
> >  static int
> >  ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
> > -		    struct nf_conn *ct)
> > +		    struct nf_conn *ct, bool extinfo)

[..]

> > +
> > +			/* We can't dump extension info for the unconfirmed
> > +			 * list because unconfirmed conntracks can have ct->ext
> > +			 * reallocated (and thus freed).
> > +			 *
> > +			 * In the dying list case ct->ext can't be altered during
> > +			 * list walk anymore, and free can only occur after ct
> > +			 * has been unlinked from the dying list (which can't
> > +			 * happen until after we drop pcpu->lock).
> > +			 */
> >  			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
> >  						  cb->nlh->nlmsg_seq,
> >  						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
> > -						  ct);
> > -			rcu_read_unlock();
> > +						  ct, dying ? true : false);
> 
> s/dying ? true : false/dying/

Yes, but it found it misleading since the last argument isn't about
'dying' or not, it tells that we can safely access ct->ext.
