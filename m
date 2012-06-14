From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re[2]:  [RFC] netfilter: xt_TEE: IPv4 Don't Fragmet options
Date: Thu, 14 Jun 2012 23:41:33 +0200 (CEST)
Message-ID: <8oegugq.e04ae989fdea46e26511be6b1a014113@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>,
	"Jan Engelhardt" <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Florian Westphal" <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:36418 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2FNVlh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:41:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Thu, Jun 14, 2012 at 08:17:35AM +0200, Hans Schillstrom wrote:
>> > I  think it is wrong to always force the DF bit in IPv4, it's better
>> > to have an option If an application don't set the DF bit, usually it
>> > doesn't expect to get an icmp back either.  The result is that the
>> > packet will be dropped...
>> > 
>> > To retain backwards compatibility I suggest adding a new option like
>> > 
>> > --ipv4-df-copy  Do not force "Don't Fragment" on the copied packet
>> > just copy the bit.
>> > 
>> > In IPv6 we don't have that option, so nothing has to be done there.
>> > --- a/net/netfilter/xt_TEE.c
>> > +++ b/net/netfilter/xt_TEE.c
>> > @@ -117,7 +117,8 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
>> >          * decreased MTU on the clone route. IPv6 does this too.
>> >          */
>> >         iph = ip_hdr(skb);
>> > -       iph->frag_off |= htons(IP_DF);
>> > +       if (!info->df_copy)
>> > +               iph->frag_off |= htons(IP_DF);
>
>Wouldn't it make more sense to just remove the
>iph->frag_off |= htons(IP_DF);
>line?  I don't think forcing DF is a good idea.

Neither do I,  I think it was a bad idea from the beginning but someone out there might depend upon it 

>
>Or are you dealing with some application that sets DF, but
>then fails to handle the icmp error?

Nope

/Hans

