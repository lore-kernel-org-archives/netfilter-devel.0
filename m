Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0E8C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 21:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60CA020707
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 21:02:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvZK95bv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgAaVCU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 16:02:20 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38915 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgAaVCU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 16:02:20 -0500
Received: by mail-ot1-f65.google.com with SMTP id 77so7925758oty.6;
        Fri, 31 Jan 2020 13:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W5IX6woZlGDJVR1SzsriysOif0VIvM9E0SCLAW1t70g=;
        b=lvZK95bvo/rP6CnnKdF4aGiWlHlc4EP492vPZoIlmjuUbtYeJ8HJAsAwL0ajTOFUpR
         4LVmfJI+QAEJvPA24yFzmbNoVbAaqohtlFgqIQLW/cP+Yg3UEjcMq+HzRLqjBe/xG+Y0
         ZaI6mJeocjlzZIbOJx/qTF3Gd+DuMU77EVytmbmwvKlBDf2KybY3oFuBCeqFlHugOJsK
         G4/9Lbh01BfqTNjruwmabigkN4znSw4xaGTmmNzn+Q6hTjuH+TqKYj06UikZE/67I52M
         ObcKWEiIHUAG/yfJDd22LzDSlZgx8nJBXc5z8mrA9jlEim56ZBlHFAoyMr0KaRjQO3+I
         uHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W5IX6woZlGDJVR1SzsriysOif0VIvM9E0SCLAW1t70g=;
        b=R/i9HTO5vtxWsos1HA6viXv9BlmnuYDnZkKirniRpEUFVl/NTTfaWFDvP8rP5Kk3UG
         r5f3EnOP63mTk1gXPbqBQ7KmeBQclDb6QilSUkqijH39pj8Fm42MmsQm0pz7WaoXPwco
         soLVi8xanw4g2qoZ/hz3LLc3gsRTKOLxbvG3AGLlJ1Bttrmbeij+/rOQ1AmRljeRbtMk
         8N76Qebq9ygcLAo6eaStGIDOwGarU6qr11+JFrMQRoCs2wXzKfXsryQcsSYH9UWRJFl1
         ySlUnCqViu+HO/1QNRld0VwIRYSMG/7zj6VmSK251YeKa6ezK2i+vaODw0to8MigqdtW
         8i0A==
X-Gm-Message-State: APjAAAW/8PWa+IGOGNYrbvkvVD4i8YVwj6iRgCUBWY1HFAhC3yhaSAV7
        i9FxyXZjnsLFHR83swrRFWQMsEPDgVZjvGO6WBc=
X-Google-Smtp-Source: APXvYqz5Y4nx4sGmhnWRBLc+TR0bFDCTm0JvasI+XmWXRta7GdkUM/ARq2AoWwq1Aw8Y5O9M3gjtydLmglM2zJJPGes=
X-Received: by 2002:a05:6830:1e64:: with SMTP id m4mr9510166otr.244.1580504539863;
 Fri, 31 Jan 2020 13:02:19 -0800 (PST)
MIME-Version: 1.0
References: <000000000000dd68d0059c74a1db@google.com> <000000000000ed3a48059d17277e@google.com>
 <CAHk-=wgNo-3FuNWSj+pRqJEG3phVnpcEi+NNq7f_VMWeTugFDA@mail.gmail.com>
In-Reply-To: <CAHk-=wgNo-3FuNWSj+pRqJEG3phVnpcEi+NNq7f_VMWeTugFDA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 31 Jan 2020 13:02:08 -0800
Message-ID: <CAM_iQpUO2s2j0gbjYp8J3Q7J-peLChxL71+tzR0d6SphMZ7Aiw@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_add
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>,
        Marco Elver <elver@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        jeremy@azazel.net, Kate Stewart <kstewart@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 31, 2020 at 12:58 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Jan 26, 2020 at 8:01 PM syzbot
> <syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has bisected this bug to:
>
> Ok, the bisection is obviously bogus - it just points to where the
> KASAN support was added to _notice_ the problem.
>
> But is somebody looking at the actual KASAN report itself?

It is supposed to be fixed by:

commit 32c72165dbd0e246e69d16a3ad348a4851afd415
Author: Kadlecsik J=C3=B3zsef <kadlec@blackhole.kfki.hu>
Date:   Sun Jan 19 22:06:49 2020 +0100

    netfilter: ipset: use bitmap infrastructure completely

Thanks.
