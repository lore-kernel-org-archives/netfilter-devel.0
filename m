From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: register an hook
Date: Fri, 23 Apr 2010 12:27:48 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004231227410.30678@obet.zrqbmnf.qr>
References: <z2uede9a9eb1004230155oe674c584m2ca2d0b4ba3490c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42763 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0DWK1u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:27:50 -0400
In-Reply-To: <z2uede9a9eb1004230155oe674c584m2ca2d0b4ba3490c0@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-04-23 10:55, Nicola Padovano wrote:

>hi all.
>i've read how to register an hook in netfilter. and i found two ways.
>
>the first uses, this routines:
>
>
> unsigned int my_hook(unsigned int hooknum,
>                      struct sk_buff *skb,
>                      const struct net_device *in,
>                      const struct net_device *out,
>                      int (*okfn)(struct sk_buff *))
> {
> }
>
>int nf_register_hook(struct nf_hook_ops *reg)
>int nf_unregister_hook(struct nf_hook_ops *reg)
>
>the second instead:
>
>static unsigned int xt_tarpit_target(struct sk_buff *skb,
>				     const struct xt_target_param *par)
>
>and:
>xt_register_target(&xt_tarpit_reg);
>xt_unregister_target(&xt_tarpit_reg);
>
>
>which is the difference?

That a target is not a hook.
