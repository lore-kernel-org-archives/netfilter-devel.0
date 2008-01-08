From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 19/27] xt_policy: use the new unoin nf_inet_addr
Date: Tue, 8 Jan 2008 17:42:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801081740040.3032@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022130340.14900@fbirervta.pbzchgretzou.qr>
 <47839B45.30005@trash.net> <Pine.LNX.4.64.0801081653560.3032@fbirervta.pbzchgretzou.qr>
 <47839CA2.5040303@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55111 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYAHQme (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:42:34 -0500
In-Reply-To: <47839CA2.5040303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 8 2008 16:54, Patrick McHardy wrote:
>> > >
>> > > +#ifdef __KERNEL__
>> > > +		struct {
>> > > +			union nf_inet_addr saddr;
>> > > +			union nf_inet_addr smask;
>> > > +			union nf_inet_addr daddr;
>> > > +			union nf_inet_addr dmask;
>> > > +		};
>> > > +#else
>> > > +		struct {
>> > > +			union xt_policy_addr saddr;
>> > > +			union xt_policy_addr smask;
>> > > +			union xt_policy_addr daddr;
>> > > +			union xt_policy_addr dmask;
>> > > +		};
>> > > +#endif
>> >
>> > I really dislike this uglyness, but I've applied it since
>> > there it also doesn't make much sense to leave single files
>> > using their own address definition.
>> >
>> 
>> <CES>It will all go away in a few years time</CES>
>> 
>> Ehrm, how will userspace actually deal with it?
>
>
> I don't understand what you mean with this question.
>
>
When will iptables start using the union nf_inet_addr saddr; variant?

I already figured it out myself, so don't bother. :-)
