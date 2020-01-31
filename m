Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02624C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 20:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCA53214D8
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 20:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580504269;
	bh=xSaADny3VeFeTtHG/1htvc3v34drLqjFKsbK6AuXjHk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Z5MaeB+zoO0bhpp6ogyXJ2k/YK6PK766kafhyHvIdvhkDg3e1gLzbJWmc28z1yqtI
	 UF8KvjHweTIkuS7OA7rA6PKhjjEOgXsk5NCbyG2ePpNQ4jEGuz2zSteiuZkCfcy+R4
	 LrxWa6omVleQAJ3d8EcgZZvHj/vlpN7br+8U7xgA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgAaU5t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 15:57:49 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37120 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgAaU5o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 15:57:44 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so5831680lfc.4
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 12:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yIy8jX/bIqNLPn135lJfh03fB0J5DTm/sQQubpuwpIc=;
        b=T9YJkCW9JbP3I/VrV8Kj+Sqgh32TFui6J89dvvzFWNF4uNBBlwLYLIiloGbloeGdEn
         +WhsCFna2qbBsj24mHwTYrLs7jNN597VW/cYfZ14T/ucXOrbAuhgBHDPx8ZibV3JpYUn
         SIOsaSvx7SY3ycO1LVDx3/u1kmOYO3RuQI1m4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yIy8jX/bIqNLPn135lJfh03fB0J5DTm/sQQubpuwpIc=;
        b=SlSft/Li7rZix+Husw3azYZjo1JGOzYbeov4n6kAUAMsVJiBIDoqRwXyKt+dNQw9pe
         ag5YkWfAjDU6Ze4oymlrbW9yZJXDvyOb37dweZU8x+1gtbrkTBKkhpQ0ZLwh7ca6pFhn
         WxwlYDeTBVGyFpydz/gUIrAG79q9rCWq/fgNFHrkK9BZDCcMFXtf12TrxPwbMQtykMjg
         g6hwDihKwceTs90neGPFa3+CJ0QeVOfVhMeM5jJaXTSr/VhsTSm8NdyYKf3WaWnaroP0
         TuVYaMfGqXPfNzMPzyYklIIChGswsQk2v8uyNPglrQEL3o3LMQDSIZk6T4GMZTOZ7agW
         Yzwg==
X-Gm-Message-State: APjAAAUCMjnpz+6loDLQdLIEdIom24CtRCG43OCHfn0Lc9Jv+khYIoQh
        qIioyBEimpCIgWXVBUcccL5r95kV4+Q=
X-Google-Smtp-Source: APXvYqy6lcoZwBGnhR0RYBawuXVs8Z9+NxAtU0L7uEhnO2SJIQ+GR5uKowpV2hD72SoRIYjYqsCycQ==
X-Received: by 2002:ac2:5626:: with SMTP id b6mr6469760lff.134.1580504260781;
        Fri, 31 Jan 2020 12:57:40 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id z1sm5139382lfh.35.2020.01.31.12.57.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 12:57:39 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id o15so2958184ljg.6
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 12:57:39 -0800 (PST)
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr7089308ljk.201.1580504259100;
 Fri, 31 Jan 2020 12:57:39 -0800 (PST)
MIME-Version: 1.0
References: <000000000000dd68d0059c74a1db@google.com> <000000000000ed3a48059d17277e@google.com>
In-Reply-To: <000000000000ed3a48059d17277e@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 31 Jan 2020 12:57:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgNo-3FuNWSj+pRqJEG3phVnpcEi+NNq7f_VMWeTugFDA@mail.gmail.com>
Message-ID: <CAHk-=wgNo-3FuNWSj+pRqJEG3phVnpcEi+NNq7f_VMWeTugFDA@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_add
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Marco Elver <elver@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        jeremy@azazel.net, Kate Stewart <kstewart@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 26, 2020 at 8:01 PM syzbot
<syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:

Ok, the bisection is obviously bogus - it just points to where the
KASAN support was added to _notice_ the problem.

But is somebody looking at the actual KASAN report itself?

  https://syzkaller.appspot.com/bug?extid=f3e96783d74ee8ea9aa3

It does look like nfnetlink_rcv_msg() ends up looking at a bit:

 bitmap_ip_do_add net/netfilter/ipset/ip_set_bitmap_ip.c:83 [inline]
 bitmap_ip_add+0xef/0xe60 net/netfilter/ipset/ip_set_bitmap_gen.h:136
 bitmap_ip_uadt+0x73e/0xa10 net/netfilter/ipset/ip_set_bitmap_ip.c:186
 call_ad+0x1a0/0x5a0 net/netfilter/ipset/ip_set_core.c:1716
 ip_set_ad.isra.0+0x572/0xb20 net/netfilter/ipset/ip_set_core.c:1804
 ip_set_uadd+0x37/0x50 net/netfilter/ipset/ip_set_core.c:1829
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229

that is past the allocation:

 ip_set_alloc+0x38/0x5e net/netfilter/ipset/ip_set_core.c:255
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x6ec/0xc20 net/netfilter/ipset/ip_set_bitmap_ip.c:327
 ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229

Maybe this has already been fixed, but I'm just trying to follow-up on
the syzbot report..

           Linus
