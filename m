From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3 v2] netfilter: nf_tables: export rule-set
 generation ID
Date: Thu, 11 Sep 2014 18:25:21 +0200
Message-ID: <20140911162521.GC5824@salvia>
References: <1410448819-6694-1-git-send-email-pablo@netfilter.org>
 <1410448819-6694-3-git-send-email-pablo@netfilter.org>
 <CAOkSjBhc65FVRK5CZSVuGnWz9sN0J1Ot9LOwGat_xKPuO83p_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58625 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaIKQY1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:24:27 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhc65FVRK5CZSVuGnWz9sN0J1Ot9LOwGat_xKPuO83p_g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 11, 2014 at 05:46:57PM +0200, Arturo Borrero Gonzalez wrote:
> On 11 September 2014 17:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +
> > +static int nf_tables_gen_notify(struct net *net, struct sk_buff *skb, int event)
> > +{
> > +       struct nlmsghdr *nlh = nlmsg_hdr(skb);
> > +       struct sk_buff *skb2;
> > +       int err;
> > +
> > +       if (nlmsg_report(nlh) &&
> > +           !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
> > +               return 0;
> > +
> 
> The above logic is different from the other functions.
> 
> I don't know if that was deliberate.

We don't have nft_ctx at that point. nlmsg_report(nlh) is basically
what ctx->report usually constains.

Unless I'm overlooking something obvious, this looks correct to me.

> > +       err = -ENOBUFS;
> > +       skb2 = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> > +       if (skb2 == NULL)
> > +               goto err;
> > +
> > +       err = nf_tables_fill_gen_info(skb2, net, NETLINK_CB(skb).portid,
> > +                                     nlh->nlmsg_seq);
> > +       if (err < 0) {
> > +               kfree_skb(skb2);
> > +               goto err;
> > +       }
> > +
> > +       err = nfnetlink_send(skb2, net, NETLINK_CB(skb).portid,
> > +                            NFNLGRP_NFTABLES, nlmsg_report(nlh), GFP_KERNEL);
> > +err:
> > +       if (err < 0) {
> > +               nfnetlink_set_err(net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
> > +                                 err);
> > +       }
> > +       return err;
> > +}
> > +
> 
> All the xx_notify() functions looks very similar. Do you think it
> worth to factorize the code?

I prefer if we focus on adding missing features, fixing bugs and so
on. We'll have the time to revisit things later on.
