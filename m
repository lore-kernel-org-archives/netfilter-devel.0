From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH V4 1/2] netfilter: xt_AUDIT: use consistent ipv4 network offset
Date: Thu, 23 Mar 2017 14:44:01 -0400
Message-ID: <CAHC9VhRmcV8LhRpFg1Mp8pKKKeKaD6qKNgJc9kDhyxpOQXG77A@mail.gmail.com>
References: <d2ef98ddd4884276879107d4cd4521330e709578.1490165887.git.rgb@redhat.com>
 <20170322111151.GA2766@salvia> <20170322114318.GC9021@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, linux-audit@redhat.com,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35492 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965740AbdCWSoD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2017 14:44:03 -0400
Received: by mail-ua0-f195.google.com with SMTP id u30so13573823uau.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2017 11:44:02 -0700 (PDT)
In-Reply-To: <20170322114318.GC9021@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 7:43 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-03-22 12:11, Pablo Neira Ayuso wrote:
>> On Wed, Mar 22, 2017 at 03:05:36AM -0400, Richard Guy Briggs wrote:
>> > Even though the skb->data pointer has been moved from the link layer
>> > header to the network layer header, use the same method to calculate the
>> > offset in ipv4 and ipv6 routines.
>> >
>> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>> > ---
>> >  net/netfilter/xt_AUDIT.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
>> > index 4973cbd..cdb7cee 100644
>> > --- a/net/netfilter/xt_AUDIT.c
>> > +++ b/net/netfilter/xt_AUDIT.c
>> > @@ -76,7 +76,7 @@ static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
>> >     struct iphdr _iph;
>> >     const struct iphdr *ih;
>> >
>> > -   ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
>> > +   ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
>>
>> This update is completely pointless.
>
> Its point is to be consistent with audit_ip6() and to prevent further
> time consumed by confusion and head-scratching.  I know it is slightly
> slower with an identical result.

Agree with Richard, merged to audit/next.

-- 
paul moore
www.paul-moore.com
