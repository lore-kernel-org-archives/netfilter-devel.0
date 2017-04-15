From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2 nf-next] netfilter: nft_ct: allow to set ctnetlink
 event types of a connection
Date: Sat, 15 Apr 2017 21:21:19 +0800
Message-ID: <CAML_gOcrkR6SOqcWrEk=+=QhVb+YZuLg1n6duXk=UsSV0zaAMg@mail.gmail.com>
References: <20170415102604.29236-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:35783 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753441AbdDONVV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 09:21:21 -0400
Received: by mail-ua0-f181.google.com with SMTP id f10so36016599uaa.2
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 06:21:20 -0700 (PDT)
In-Reply-To: <20170415102604.29236-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

2017-04-15 18:26 GMT+08:00 Florian Westphal <fw@strlen.de>:
[...]
> +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> +       case NFT_CT_EVENTMASK: {
> +               struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
> +               u16 ctmask = nft_reg_load16(&regs->data[priv->sreg]);

Hmm, I find that in nft utility, this ctmask is defined as a 32 bit value.
So using nft_reg_load16 maybe wrong. In order to avoid ambiguity,
I think it's better to convert it to "u32 ctmask = regs->data[priv->sreg];".

Referring to http://patchwork.ozlabs.org/patch/751013/:
+static const struct datatype ct_event_type = {
+ .type = TYPE_CT_EVENTBIT,
+ .name = "ct_event",
+ .desc = "conntrack event bits",
+ .byteorder = BYTEORDER_HOST_ENDIAN,
+ .size = 4 * BITS_PER_BYTE,
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> +
> +               if (e) {
> +                       if (e->ctmask != ctmask)
> +                               e->ctmask = ctmask;
> +                       break;
> +               }
> +
> +               if (ctmask && !nf_ct_is_confirmed(ct))
> +                       nf_ct_ecache_ext_add(ct, ctmask, 0, GFP_ATOMIC);
> +               break;
> +       }
