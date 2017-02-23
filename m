From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT
Date: Thu, 23 Feb 2017 12:14:51 -0500
Message-ID: <CAHC9VhSUKTQ+mx4ha7_LRM7SaSbnK9sP5Sz7C+aFn26sB0riBQ@mail.gmail.com>
References: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
 <20170223052015.GE11144@breakpoint.cc> <20170223155156.GL18258@madcap2.tricolour.ca>
 <CAHC9VhQwSH-CjWeaPJZhBpK2+vh8YqfG6kVaMCis--WrZCopEQ@mail.gmail.com>
 <20170223170431.GM18258@madcap2.tricolour.ca> <CAHC9VhSm+=9HB=+rVeOMDY12sC5fNS1Cz1pygSBT14YuGVsd=A@mail.gmail.com>
 <20170223171324.GN18258@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>, linux-audit@redhat.com,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:32816 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdBWROw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 12:14:52 -0500
Received: by mail-vk0-f53.google.com with SMTP id k127so23633304vke.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 09:14:52 -0800 (PST)
In-Reply-To: <20170223171324.GN18258@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 23, 2017 at 12:13 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-02-23 12:06, Paul Moore wrote:
>> On Thu, Feb 23, 2017 at 12:04 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > On 2017-02-23 11:57, Paul Moore wrote:
>> >> On Thu, Feb 23, 2017 at 10:51 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> > On 2017-02-23 06:20, Florian Westphal wrote:
>> >> >> Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> >> > Simplify and eliminate flipping in and out of message fields, relying on nfmark
>> >> >> > the way we do for audit_key.
>> >> >> >
>> >> >> > +struct nfpkt_par {
>> >> >> > +   int ipv;
>> >> >> > +   const void *saddr;
>> >> >> > +   const void *daddr;
>> >> >> > +   u8 proto;
>> >> >> > +};
>> >> >>
>> >> >> This is problematic, see below for why.
>> >> >>
>> >> >> > -static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
>> >> >> > +static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb, struct nfpkt_par *apar)
>> >> >> >  {
>> >> >> >     struct iphdr _iph;
>> >> >> >     const struct iphdr *ih;
>> >> >> >
>> >> >> > +   apar->ipv = 4;
>> >> >> >     ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
>> >> >> > -   if (!ih) {
>> >> >> > -           audit_log_format(ab, " truncated=1");
>> >> >> > +   if (!ih)
>> >> >> >             return;
>> >> >>
>> >> >> Removing this "truncated" has the consequence that this can later log
>> >> >> "saddr=0.0.0.0 daddr=0.0.0.0" if we return here.
>> >> >>
>> >> >> This cannot happen for ip(6)tables because ip stack discards broken l3 headers
>> >> >> before the netfilter hooks get called, but its possible with NFPROTO_BRIDGE.
>> >> >>
>> >> >> Perhaps you will need to change audit_ip4/6 to return "false" when it can't
>> >> >> get the l3 information now so we only log zero addresses when the packet
>> >> >> really did contain them.
>> >> >
>> >> > Ok, to clarify the implications, are you saying that handing a NULL
>> >> > pointer to "saddr=%pI4" will print "0.0.0.0" rather than "(none)" or "?"
>> >>
>> >> My initial reaction is that if the packet is so badly
>> >> truncated/malformed that we don't have a full IP header than we should
>> >> just refrain from logging the packet; it's too malformed/garbage to
>> >> offer any useful information and the normal packet processing should
>> >> result in the packet being discarded anyway.
>> >
>> > Which is why I wanted the ethertype, but that can be coded into the nfmark.
>>
>> If the packet is garbage (garbage without any payload in this case),
>> what does it matter?  It's noise.
>
> It could be an indicator that either the logging rules or the filter
> rules need honing, or even that there is a bug in the network code.

Elaborate on this please, I still don't see how logging the ethertype
is helpful for a malformed packet.

-- 
paul moore
www.paul-moore.com
