From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT
Date: Thu, 23 Feb 2017 10:51:56 -0500
Message-ID: <20170223155156.GL18258@madcap2.tricolour.ca>
References: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
 <20170223052015.GE11144@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751202AbdBWPwA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 10:52:00 -0500
Content-Disposition: inline
In-Reply-To: <20170223052015.GE11144@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-02-23 06:20, Florian Westphal wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
> > Simplify and eliminate flipping in and out of message fields, relying on nfmark
> > the way we do for audit_key.
> > 
> > +struct nfpkt_par {
> > +	int ipv;
> > +	const void *saddr;
> > +	const void *daddr;
> > +	u8 proto;
> > +};
> 
> This is problematic, see below for why.
> 
> > -static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
> > +static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb, struct nfpkt_par *apar)
> >  {
> >  	struct iphdr _iph;
> >  	const struct iphdr *ih;
> >  
> > +	apar->ipv = 4;
> >  	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> > -	if (!ih) {
> > -		audit_log_format(ab, " truncated=1");
> > +	if (!ih)
> >  		return;
> 
> Removing this "truncated" has the consequence that this can later log
> "saddr=0.0.0.0 daddr=0.0.0.0" if we return here.
> 
> This cannot happen for ip(6)tables because ip stack discards broken l3 headers
> before the netfilter hooks get called, but its possible with NFPROTO_BRIDGE.
> 
> Perhaps you will need to change audit_ip4/6 to return "false" when it can't
> get the l3 information now so we only log zero addresses when the packet
> really did contain them.

Ok, to clarify the implications, are you saying that handing a NULL
pointer to "saddr=%pI4" will print "0.0.0.0" rather than "(none)" or "?"

> > -	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 ipid=%hu proto=%hhu",
> > -		&ih->saddr, &ih->daddr, ntohs(ih->id), ih->protocol);
> 
> Alternatively, one could keep this around. In fact, why is this (re)moved
> in first place?  This move of audit_log_format() seems to only reason
> why *apar struct is required.
> 
> AFAICS this now does:
>   ab = new()
>   log(ab, mark);
>   audit_ip4(&apar);
>   log(&apar);
> 
> so might as well keep the log() call within the audit_ip4/6 function.

Understood.  The apar parameter was conceived for the previous patch
with 20 fields and made more sense then.

> > -	audit_proto(ab, skb, ih->protocol, ih->ihl * 4);
> > +	apar->saddr = &ih->saddr;
> > +	apar->daddr = &ih->daddr;
> > +	apar->proto = ih->protocol;
> >  }
> 
> Caution.  skb_header_pointer() may copy from non-linear skb part
> into _iph, which is on stack, so apar->saddr may be stale once
> function returns. So if you really want to remove the audit_log_format()
> of the saddr/daddr then you need to copy the ip addresses here.
> 
> (We guarantee its linear for ip stack but not for NFPROTO_BRIDGE and this function
> is also called for the bridge version of the target).

Ok, all the more reason to keep the log call in the protocol family function call.

> >  static unsigned int
> >  audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
> >  {
> > -	const struct xt_audit_info *info = par->targinfo;
> >  	struct audit_buffer *ab;
> > +	struct nfpkt_par apar = {
> > +		-1, NULL, NULL, -1,
> > +	};
> 
> I suggest to use
> 	struct nfpkt_par apar = {
> 		.family = par->family,
> 	};
> 
> if apar is required for some reason.

I did look at this originally, then realized that netfilter doesn't use
the same protocol family identifiers as standard ethernet headers that
are used in the bridge case or IP protocol or IPv6 next header.  If I
were to pick one, I might use the ethernet header conventions for next
protocol (ethertype, except they are 16 bits instead of 8).

> >  	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> >  	if (ab == NULL)
> >  		goto errout;
> >  
> > -	audit_log_format(ab, "action=%hhu hook=%u len=%u inif=%s outif=%s",
> > -			 info->type, par->hooknum, skb->len,
> > -			 par->in ? par->in->name : "?",
> > -			 par->out ? par->out->name : "?");
> > -
> > -	if (skb->mark)
> > -		audit_log_format(ab, " mark=%#x", skb->mark);
> > +	audit_log_format(ab, " mark=%#x", skb->mark ?: -1);
> 
> -1 will be logged as 0xffffffff, no?  whats wrong with
> 	audit_log_format(ab, " mark=%#x", skb->mark); ?

You are correct, this was hasty.

> >  	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
> > -		audit_log_format(ab, " smac=%pM dmac=%pM macproto=0x%04x",
> > -				 eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
> > -				 ntohs(eth_hdr(skb)->h_proto));
> > -
> 
> This ARPHDR_ETHER test is no longer needed after logging
> of ether addresses is removed.

Ok, that helps simplify the first level logic.  I was really hoping to
keep "macproto" to make clear what protocol family was in play, but
that's when I noticed that par->family doesn't use a standard set of
numbers I recognize.  This isn't a problem because this can be indicated
by a small number of bits in the nfmark.


Thanks for your quick review.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
