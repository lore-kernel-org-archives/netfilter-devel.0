From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT
Date: Thu, 23 Feb 2017 18:06:47 +0100
Message-ID: <20170223170647.GA5277@breakpoint.cc>
References: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
 <20170223052015.GE11144@breakpoint.cc>
 <20170223155156.GL18258@madcap2.tricolour.ca>
 <CAHC9VhQwSH-CjWeaPJZhBpK2+vh8YqfG6kVaMCis--WrZCopEQ@mail.gmail.com>
 <20170223170431.GM18258@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paul Moore <paul@paul-moore.com>, Florian Westphal <fw@strlen.de>,
        linux-audit@redhat.com,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43976 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751638AbdBWRIe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 12:08:34 -0500
Content-Disposition: inline
In-Reply-To: <20170223170431.GM18258@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-02-23 11:57, Paul Moore wrote:
> > On Thu, Feb 23, 2017 at 10:51 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2017-02-23 06:20, Florian Westphal wrote:
> > >> Richard Guy Briggs <rgb@redhat.com> wrote:
> > >> > Simplify and eliminate flipping in and out of message fields, relying on nfmark
> > >> > the way we do for audit_key.
> > >> >
> > >> > +struct nfpkt_par {
> > >> > +   int ipv;
> > >> > +   const void *saddr;
> > >> > +   const void *daddr;
> > >> > +   u8 proto;
> > >> > +};
> > >>
> > >> This is problematic, see below for why.
> > >>
> > >> > -static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
> > >> > +static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb, struct nfpkt_par *apar)
> > >> >  {
> > >> >     struct iphdr _iph;
> > >> >     const struct iphdr *ih;
> > >> >
> > >> > +   apar->ipv = 4;
> > >> >     ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> > >> > -   if (!ih) {
> > >> > -           audit_log_format(ab, " truncated=1");
> > >> > +   if (!ih)
> > >> >             return;
> > >>
> > >> Removing this "truncated" has the consequence that this can later log
> > >> "saddr=0.0.0.0 daddr=0.0.0.0" if we return here.
> > >>
> > >> This cannot happen for ip(6)tables because ip stack discards broken l3 headers
> > >> before the netfilter hooks get called, but its possible with NFPROTO_BRIDGE.
> > >>
> > >> Perhaps you will need to change audit_ip4/6 to return "false" when it can't
> > >> get the l3 information now so we only log zero addresses when the packet
> > >> really did contain them.
> > >
> > > Ok, to clarify the implications, are you saying that handing a NULL
> > > pointer to "saddr=%pI4" will print "0.0.0.0" rather than "(none)" or "?"

No, if you pass pointers that would indeed log NULL.

> > My initial reaction is that if the packet is so badly
> > truncated/malformed that we don't have a full IP header than we should
> > just refrain from logging the packet; it's too malformed/garbage to
> > offer any useful information and the normal packet processing should
> > result in the packet being discarded anyway.

True for ip/ipv6, not sure about bridge though.

> Which is why I wanted the ethertype, but that can be coded into the nfmark.

Not following, sorry, are you saying users can/should use -j MARK
somehow?
