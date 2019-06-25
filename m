Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CC2C48BD5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 15:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B34D2133F
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 15:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7RyxFry"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfFYPId (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 11:08:33 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41500 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730607AbfFYPIc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 11:08:32 -0400
Received: by mail-io1-f66.google.com with SMTP id w25so281736ioc.8
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 08:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1u9GbFenI40WvHOt5Op+hEtf9WHs0fNmxVcCGEEfgY=;
        b=b7RyxFryJCXbofNtJn/QO58OQscdQbnAEA6nyolHcmeP4YQZZ68MOGqQXbocs6MEPi
         z9EYfE5Of7Qw6xb+Om509lomdJzdu+2jHJ+f8kxz/3gZIyFMSVp6ti6Tnsr32JUdFaQ+
         o8s0va5F+3dvDzcbY38w1x3D4u5hHFtdx7QoIe9hqCGEMEP86Fxy1RrBaljzf0Q3a9Fu
         TS0lYKbq5gMuCS1PLNz57cu5w6WxODQb7c+o0+3nmW4QxX36+Bnv3txoFuhKEQ8/+9a1
         80+eb9cbbqcgIPdShsp4UdaVT/Lxb1zto/cwIZ9IdOcsBdW5aB4yqFy0RY+w5kc4Gj+C
         ziJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G1u9GbFenI40WvHOt5Op+hEtf9WHs0fNmxVcCGEEfgY=;
        b=eEUrus9XiY5f/YCGrcJ4/7xT7G09A8VXDij/HjS3IvaL60at38wqHYJFhhuALAg11O
         kXY4aWutlVzaSdlphH1fOjgdCwf+qoOls8m4XZtGqbIYiKTQl2mmULT4hll2u3px60EQ
         kqVmZ134rE0EgE89C/Sy4MU4xsEIXIROReqUXPqonGOCBHEWcWqax4NtrVHgtPI0hPU5
         uq36KkyphPDKhrffqG81ySJPZEGXAuiMBq9UIRql+pxU+hRrlfLuUYDUQiLRuyCw7vBw
         NJ6izFAH8qdSBYssQ7ziZ9HUHP81Fn1AYOMz8f+9Zp2aCM+O0wI1RwCscq4itW56HvTb
         hzrw==
X-Gm-Message-State: APjAAAUdfJJ+4ZB0Txr/r39AZ62CzeBJhCy5AYTk58scmrO5BidaNQpe
        LSFmLLTgv0nU2NoD7H/8V+bjq+Y6g9keSyqtfRo=
X-Google-Smtp-Source: APXvYqxo/D8Uu2PTVrSaG+/W8+GBZNT0azti79RlFcAKdQOSFv7nyKMzc6JWOtorqEKj9zuYNiwdcRuv8zhbOGFhRmE=
X-Received: by 2002:a5d:94d0:: with SMTP id y16mr17774692ior.123.1561475312091;
 Tue, 25 Jun 2019 08:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190513095630.32443-1-pablo@netfilter.org> <20190513095630.32443-9-pablo@netfilter.org>
 <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca> <20190624235816.vw6ahepdgvxhvdej@salvia>
 <4367f30f-4602-a4b6-a96e-35d879cc7758@kaechele.ca> <20190625080853.d6f523cimgg2u44v@salvia>
 <0904a616-106c-91de-ed55-97973aa5c330@kaechele.ca> <CAKfDRXjun=cVovtn70jxwTc9pa0hhDHUSdZjLHJC1Xw2AMG+rA@mail.gmail.com>
 <04ab8f2d-2b50-8d99-2fa1-837b7acaf417@kaechele.ca>
In-Reply-To: <04ab8f2d-2b50-8d99-2fa1-837b7acaf417@kaechele.ca>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Tue, 25 Jun 2019 17:08:20 +0200
Message-ID: <CAKfDRXiwRs5kkZi3AQd4nwqvWtukbrviihH+5s4iHkDfnuW93g@mail.gmail.com>
Subject: Re: [PATCH 08/13] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
To:     Felix Kaechele <felix@kaechele.ca>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Jun 25, 2019 at 4:45 PM Felix Kaechele <felix@kaechele.ca> wrote:
> No worries. I appreciate you taking the time helping me out.
>
> >> this patch is giving me some trouble as it breaks deletion of conntrack
> >> entries in software that doesn't set the version flag to anything else
> >> but 0.
> >
> > I might be a bit slow, but I have some trouble understanding this
> > sentence. Is what you are saying that software that sets version to
> > anything but 0 breaks?
>
> Yeah, definitely not my best work of prose ;-)
> What I was trying to say is: Any software that remains with the version
> set to 0 will not work. By association, since libnetfilter_conntrack
> explicitly sets the version to 0, anything that uses
> libnetfilter_conntrack will be unable to delete a specific entry in the
> conntrack table.

Thanks, now I follow. I now see that you are talking about the
deleting and not flushing. Unless anyone beats me to it, I will try to
take a closer look at the problem later today. Pablos patch implements
the first thing that I wanted to try (only read and use version/family
when flushing), and I see that Nicolas has made some suggestions. If
you could first try Pablo's patch with Nicolas' changes, that would be
great as the change should revert behavior of delete back to how it
was before my change.

BR,
Kristian
