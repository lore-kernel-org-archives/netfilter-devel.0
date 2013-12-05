From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] netfilter: nft: add queue module
Date: Thu, 5 Dec 2013 18:09:55 +0100
Message-ID: <20131205170955.GA8663@localhost>
References: <20131130122657.GG2067@breakpoint.cc>
 <1385824444-4506-1-git-send-email-eric@regit.org>
 <20131204110021.GA11380@localhost>
 <1386161263.9597.23.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44327 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab3LERKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:10:04 -0500
Content-Disposition: inline
In-Reply-To: <1386161263.9597.23.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Wed, Dec 04, 2013 at 01:47:43PM +0100, Eric Leblond wrote:
[...]
> > > +static u32
> > > +nfqueue_hash(const struct nft_pktinfo *pkt, const struct nft_queue *priv)
> > > +{
> > > +	u32 queue = priv->queuenum;
> > > +
> > > +	if (priv->family == AF_INET)
> > > +		queue += ((u64) hash_v4(pkt->skb) * priv->queues_total) >> 32;
> > > +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> > > +	else if (priv->family == AF_INET6)
> > > +		queue += ((u64) hash_v6(pkt->skb) * priv->queues_total) >> 32;
> > > +#endif
> > > +
> > > +	return queue;
> > > +}
> > 
> > to there, it looks very similar to NFQUEUE. You can move these
> > functions to net/netfilter/nf_queue.h. You'll have to inline them and
> > add the jhash_initval parameter. You'll need an initial patch to
> > prepare this change and adapt xt_NFQUEUE.c
> 
> I'm ok with the two hash functions but the nfqueue_hash the second
> argument is different. Do you want me to introduce a new common
> structure for xt_NFQUEUE and nft_queue ?

My suggestion is to add something like:

static inline u32 nfqueue_hash(const struct sk_buff *skb, u16 queuenum,
                               u16 queues_total, u8 family)

that can be used by both, it will also be defined in
net/netfilter/nf_queue.h
