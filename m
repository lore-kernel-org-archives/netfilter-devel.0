From: Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: [PATCH]: Fix ipt_REJECT problem with nf_bridge
Date: Wed, 11 Mar 2009 11:29:01 +0200
Message-ID: <9b2db90b0903110229k14d0622flb7c4bfeecb02ca1a@mail.gmail.com>
References: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>
	 <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>
	 <49B5FE06.1010204@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, jengelh@medozas.de
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:46219 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZCKJ3D convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:29:03 -0400
Received: by ey-out-2122.google.com with SMTP id 25so494881eya.37
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2009 02:29:01 -0700 (PDT)
In-Reply-To: <49B5FE06.1010204@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

Thanks for your reply.

On Tue, Mar 10, 2009 at 7:43 AM, Philip Craig <philipc@snapgear.com> wr=
ote:
> Nir Tzachar wrote:
>>> The problem arises from the following code
>>> (net/ipv4/netfilter/ipt_REJECT.c line 221:)
>>>
>>> =A0 =A0 =A0 =A0if (hook !=3D NF_INET_FORWARD
>>> #ifdef CONFIG_BRIDGE_NETFILTER
>>> =A0 =A0 =A0 =A0 =A0 =A0|| (nskb->nf_bridge && nskb->nf_bridge->mask=
 & BRNF_BRIDGED)
>>> #endif
>>> =A0 =A0 =A0 =A0 =A0 )
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addr_type =3D RTN_LOCAL;
>>>
>>> but, as nskb was newly allocated just a few line back, the
>>> oldskb->nf_bridge was never copied, so nskb->nf_bridge is always NU=
LL.
>
> Is there a reason you need to copy it into nskb, rather
> than just changing the test to check oldskb?
>
> I don't think ipv4 netfilter should be setting this field
> for new packets. =A0The bridging code will do that if needed
> when it receives the packet.

I agree. However, when I tried it (before setting the bridge argument
on the new skb), the kernel crashes. I do not exactly remember where,
but I think route_me_harder tries to dereference the nf_bridge
pointer. I may be entirely wrong, so I'll give it another check.

Cheers.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
