From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix missmatch in big-endian system
Date: Thu, 9 Mar 2017 11:36:07 +0100
Message-ID: <CAOkSjBhyOiSw1ucabBrsrjdpmBLgbej6=_9NUuKsfri5YmZUqw@mail.gmail.com>
References: <1488984858-29290-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36312 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932181AbdCIKof (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 05:44:35 -0500
Received: by mail-io0-f173.google.com with SMTP id l7so25567591ioe.3
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Mar 2017 02:44:01 -0800 (PST)
Received: from mail-it0-f41.google.com (mail-it0-f41.google.com. [209.85.214.41])
        by smtp.gmail.com with ESMTPSA id y124sm8984723itd.19.2017.03.09.02.36.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Mar 2017 02:36:28 -0800 (PST)
Received: by mail-it0-f41.google.com with SMTP id g138so63938400itb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Mar 2017 02:36:28 -0800 (PST)
In-Reply-To: <1488984858-29290-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 8 March 2017 at 15:54, Liping Zhang <zlpnobody@163.com> wrote:
>
> +/* Store/load an u16 or u8 integer to/from the u32 data register.
> + *
> + * Note, when using concatenations, register allocation happens at 32-bit
> + * level. So for store instruction, pad the rest part with zero to avoid
> + * garbage values.
> + */
> +
> +static inline void nft_reg_store16(u32 *dreg, u16 val)
> +{
> +       *dreg = 0;
> +       *(u16 *)dreg = val;
> +}
> +
> +static inline void nft_reg_store8(u32 *dreg, u8 val)
> +{
> +       *dreg = 0;
> +       *(u8 *)dreg = val;
> +}
> +

Any chance the compiler detects the double assignment and removes the first one?
