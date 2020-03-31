Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906ABC2D0F0
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 21:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B63206DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 21:21:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rVzdMzpr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbgCaVVN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 17:21:13 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35895 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbgCaVVN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 17:21:13 -0400
Received: by mail-lj1-f193.google.com with SMTP id b1so3005956ljp.3;
        Tue, 31 Mar 2020 14:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CeJAWmi8pyj2Cqo4Z3FIPSvkbNhWN+ArB8lDqJPB0hk=;
        b=rVzdMzprwCkwuY1yCfod517jm+YgEye9vCggJEu6l+znT4lZw9YR+Smox+DKqXlphn
         5ZSpctjJMoefuIzzBZ/mOGYF5hhgWJQH59+fgAvRRgD9xwsL3u30uRIRJPUvNbrQ+lIN
         IO/riXxZ1SzhElkWTVfLHGfmfcfGkvIaKz8f3BlW6DC61uWXl9AcAV1VN2/OcuLJny/t
         MW76+ptfcRK9hQunQ9nKbkmI9sYq4gqTLyL1cblkyLIx7fvaLK/LC8JjbKpD/APGpHHe
         fMC+ocx5qLnDdLWtU3IQZ5+R27aFFVHVsbJoV5dq9IuIcjxsIaAEBTSDG8Uvn5vCI9c8
         eESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CeJAWmi8pyj2Cqo4Z3FIPSvkbNhWN+ArB8lDqJPB0hk=;
        b=fj2LNosBMYUnfVBfu0AUbmQ4hZM8y06vQ+Dly1o/lQ3EqQulb7q8WmtCh+kYLF1J7C
         yRFF/thTW/S3zF4EUGXQRGbXnnAmBksdkAWLs0s0KfbNq2JNLLCWTGjqzQ0SUGJcGWYM
         bL8yDCPgjCku9aF2HgDvxFeztFhWKH971VX2WBLyiEBmbkZ7fyf2tI8wdXyUL5XzhIMr
         Agmsh0P3PLdyA08QofLV/ALzXS7hNQngM6fED/DPZM5Zhc8aWWulrPbv9yFmEu3lQOrT
         tbRxL3xZb8JJegBpNi7DfwbRZlOWvcm6XLNDZUxMve7Vi5L00v/JvI2JnLvLV9ZD7YnQ
         dzcA==
X-Gm-Message-State: AGi0PuYQQptYyvK+77val2UZBh3bo6r0D0uJLqZsq2f3U0Akv25O+oh+
        28j5ygt2XZAPxvfZpX+0uNi+67a85jW+uFXxBIg=
X-Google-Smtp-Source: APiQypIUhYwGchIZDdDuPTTze9YkwtXeMQxvGpmTlOXCS0dbo7aO9GLfhCJ06OomtWL+YX3Qh3xMQthRJdFZO20wLBs=
X-Received: by 2002:a2e:a495:: with SMTP id h21mr11322000lji.123.1585689671599;
 Tue, 31 Mar 2020 14:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200331163559.132240-1-zenczykowski@gmail.com>
 <nycvar.YFH.7.76.2003312012340.6572@n3.vanv.qr> <20200331181641.anvsbczqh6ymyrrl@salvia>
In-Reply-To: <20200331181641.anvsbczqh6ymyrrl@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 31 Mar 2020 14:21:00 -0700
Message-ID: <CAHo-Ooy-5CxfWhHuhWHO5M_wm8mO_ZMZT81qNSSNTyN5OAoJww@mail.gmail.com>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Right, this is not in 5.6 as it's only in net-next atm as it was only
merged very recently.
I mentioned this in the commit message.

I'm not sure what you mean by code that uses this.
You can checkout aosp source and look there...
There's the kernel code (that's effectively already linked from the
commit message), and the iptables userspace changes (
https://android.googlesource.com/platform/external/iptables/+/refs/heads/ma=
ster/extensions/libxt_IDLETIMER.c#39
), and the netd C++/Java layer that uses iptables -j IDLETIMER
--send_nl_msg 1 (
https://android.googlesource.com/platform/system/netd/+/refs/heads/master/s=
erver/IdletimerController.cpp#151
) and the resulting notifications parsing (can't easily find it atm).

If you mean by code that uses this patch... that's impossible as this
patch doesn't implement a usable feature.
It just moves the offset.

Could you clarify what you're asking for?

On Tue, Mar 31, 2020 at 11:16 AM Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
>
> On Tue, Mar 31, 2020 at 08:14:17PM +0200, Jan Engelhardt wrote:
> >
> > On Tuesday 2020-03-31 18:35, Maciej =C5=BBenczykowski wrote:
> > >Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> > >---
> > > include/uapi/linux/netfilter/xt_IDLETIMER.h | 1 +
> > > 1 file changed, 1 insertion(+)
> > >
> > >diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uap=
i/linux/netfilter/xt_IDLETIMER.h
> > >index 434e6506abaa..49ddcdc61c09 100644
> > >--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
> > >+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
> > >@@ -48,6 +48,7 @@ struct idletimer_tg_info_v1 {
> > >
> > >     char label[MAX_IDLETIMER_LABEL_SIZE];
> > >
> > >+    __u8 send_nl_msg;   /* unused: for compatibility with Android */
> > >     __u8 timer_type;
> > >
> > >     /* for kernel module internal use only */
> > >--
> >
> > This breaks the ABI for law-abiding Linux users (i.e. the GNU/Linux
> > subgroup of it), which is equally terrible.
> >
> > You will have to introduce a IDLETIMER v2.
>
> IIRC, IDLETIMER v1 is in net-next, scheduled for 5.7-rc, there is no
> release for this code yet.
