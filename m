From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: register an hook
Date: Fri, 23 Apr 2010 10:55:24 +0200
Message-ID: <z2uede9a9eb1004230155oe674c584m2ca2d0b4ba3490c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34457 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0DWIz0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:55:26 -0400
Received: by wyb39 with SMTP id 39so5402002wyb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Apr 2010 01:55:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi all.
i've read how to register an hook in netfilter. and i found two ways.

the first uses, this routines:


 unsigned int my_hook(unsigned int hooknum,
                      struct sk_buff *skb,
                      const struct net_device *in,
                      const struct net_device *out,
                      int (*okfn)(struct sk_buff *))
 {
 }

int nf_register_hook(struct nf_hook_ops *reg)
int nf_unregister_hook(struct nf_hook_ops *reg)

the second instead:

static unsigned int xt_tarpit_target(struct sk_buff *skb,
				     const struct xt_target_param *par)

and:
xt_register_target(&xt_tarpit_reg);
xt_unregister_target(&xt_tarpit_reg);


which is the difference?

thank you!
