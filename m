Return-Path: <SRS0=jWs9=AB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F18C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jun 2020 18:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C530024170
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jun 2020 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592677088;
	bh=Pv/MCYWouTTqY8Tzng4DMBloSb1nDNzojh5j+tABf+I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=P71bvtB47LWk9aQsju0NpnP9Tr8bG6GCaNK6E5x8p9UjsKQu7wSfUdtzFAE7mSzEU
	 8AaGOXtnE+VR5rUtaCf5MBNLXhSkWV58y4UGoPUCJM5Oobq8SJYSk4SafWGJlsQlk/
	 i3CZrvQbGMZMNbYOpx3PPAOuW5amwlksxIJy6A14=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgFTSR7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jun 2020 14:17:59 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37913 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgFTSR4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jun 2020 14:17:56 -0400
Received: by mail-lf1-f66.google.com with SMTP id d27so7364021lfq.5
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2020 11:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvNVjKHLtWO1dFhcir+/iDU+Lfgpi6JKmP8lzEdvB4E=;
        b=XZhtEb+0zgTmk7p1FKGgpCykCJGCR4QhBQlCJIvFhX2gO0uR1pqoBoOBIBXk8xm1oo
         nnYsLEAqabKP6xPYAXRe3MXkcyadqTMH+s5IProFdvebzb7pzQ6AkXwlDow2qmIdedzm
         oZw5CZPotJ22BL1wUHzVnLaBOGBVpYDODO31o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvNVjKHLtWO1dFhcir+/iDU+Lfgpi6JKmP8lzEdvB4E=;
        b=A5BML6JhOL0BYAJFVGMYhZZ/VEa0HgH0RkxwccuDoxe4OnisKnZX/CvzE0qsOkrG2a
         o6J7tfDkkNLOpye9Q6m7mRmYwAmd/Ca8DffPH4v6C1MsGmjFCMSlsM14GBtjn8YAr5Pa
         4/qdBDL9du+S21dsXWm3/jFUDUwuz9bQZfLqAlrZirt4zGG4Huj+wW30FXUMw69cb6Kc
         sgWPLwZO5Tjj50c311uvxrNVD5MZJOjkrSbepoU5An1Xbl7zttGOGGymoo3Yj9rFWEJ2
         cehawq7vaueqEvGDTkSFjdK7+P+YrilJDgwGvQUgGb6UwNPZ+3raI5WDTHHvhrVHbGQG
         09lA==
X-Gm-Message-State: AOAM530QJ3LdpdhyBrnebQU+HqbpWkoTWVYsVRUg+y5Lq5440PBOol8x
        fIpi02+7egA96gG/TVevjmjgjctpcFs=
X-Google-Smtp-Source: ABdhPJxXPMSy3yoSIx00yQjl4VOkuQ75KpLLVPNbuFqqigfRM23ej/69CeW7FyoSH+ZLQIBoRlCDlQ==
X-Received: by 2002:ac2:5b85:: with SMTP id o5mr5141879lfn.106.1592677012855;
        Sat, 20 Jun 2020 11:16:52 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id y16sm1795829ljm.19.2020.06.20.11.16.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 11:16:51 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id g139so6569295lfd.10
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2020 11:16:51 -0700 (PDT)
X-Received: by 2002:a19:ae0f:: with SMTP id f15mr5206631lfc.142.1592677011252;
 Sat, 20 Jun 2020 11:16:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200618210645.GB2212102@localhost.localdomain>
 <CAHk-=whz7xz1EBqfyS-C8zTx3_q54R1GuX9tDHdK1-TG91WH-Q@mail.gmail.com> <20200620075732.GA468070@localhost.localdomain>
In-Reply-To: <20200620075732.GA468070@localhost.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 20 Jun 2020 11:16:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjt=mTBqymWuRYeiXQxdEdf6si_it=Yzm7KR62ws0vknw@mail.gmail.com>
Message-ID: <CAHk-=wjt=mTBqymWuRYeiXQxdEdf6si_it=Yzm7KR62ws0vknw@mail.gmail.com>
Subject: Re: [PATCH] linux++, this: rename "struct notifier_block *this"
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jun 20, 2020 at 12:57 AM Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> > If you want to build the kernel with C++, you'd be a lot better off just doing
> >
> >    /* C++ braindamage */
> >    #define this __this
> >    #define new __new
> >
> > and deal with that instead.
>
> Can't do this because of placement new.

Can you explain?

> > Because no, the 'new' renaming will never happen, and while 'this'
> > isn't nearly as common or relevant a name, once you have the same
> > issue with 'new', what's the point of trying to deal with 'this'?
>
> I'm not sending "new".

My point about 'new' is that

 (a) there's a lot more 'new' than 'this'

 (b) without dealing with 'new', dealing with 'this' is pointless

So why bother? Without some kind of pre-processing phase to make our C
code palatable to a C++ parser, it will never work.

And if you _do_ have a pre-processing phase (which might be a #define,
but might also be a completely separate pass with some special tool),
converting 'this' in the kernel sources isn't useful anyway, because
you could just do it in the pre-processing phase instead.

See? THAT is why I'm harping on 'new'. Not because you sent me a patch
to deal with 'new', but because such a patch will never be accepted,
and without that patch the pain from 'this' seems entirely irrelevant.

What's your plan for 'new'? And why doesn't that plan then work for 'this'?

              Linus
