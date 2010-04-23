From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: register an hook
Date: Fri, 23 Apr 2010 12:50:08 +0200
Message-ID: <i2iede9a9eb1004230350gfa9279bej12902ff2b6522664@mail.gmail.com>
References: <z2uede9a9eb1004230155oe674c584m2ca2d0b4ba3490c0@mail.gmail.com>
	 <alpine.LSU.2.01.1004231227410.30678@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53044 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab0DWKuK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:50:10 -0400
Received: by wwb24 with SMTP id 24so5477956wwb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Apr 2010 03:50:08 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1004231227410.30678@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

what's the difference? what is a target?
I'm analyzing the tarpit patch
(http://enterprise.bih.harvard.edu/pub/tarpit-updates/tarpit-2.6.29.pat=
ch)
and i've found only the registration of that target. and so, how it
works, if there isn't an hook registration?

help me, please :(


On Fri, Apr 23, 2010 at 12:27 PM, Jan Engelhardt <jengelh@medozas.de> w=
rote:
> On Friday 2010-04-23 10:55, Nicola Padovano wrote:
>
>>hi all.
>>i've read how to register an hook in netfilter. and i found two ways.
>>
>>the first uses, this routines:
>>
>>
>> unsigned int my_hook(unsigned int hooknum,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sk_buff *skb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct net_device *=
in,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct net_device *=
out,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int (*okfn)(struct sk_buf=
f *))
>> {
>> }
>>
>>int nf_register_hook(struct nf_hook_ops *reg)
>>int nf_unregister_hook(struct nf_hook_ops *reg)
>>
>>the second instead:
>>
>>static unsigned int xt_tarpit_target(struct sk_buff *skb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0const struct xt_target_param *par)
>>
>>and:
>>xt_register_target(&xt_tarpit_reg);
>>xt_unregister_target(&xt_tarpit_reg);
>>
>>
>>which is the difference?
>
> That a target is not a hook.
>



--=20
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadov.blogspot.com/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
