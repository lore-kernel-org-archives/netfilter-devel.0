Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E026CC48BD5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 15:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B40A1208E3
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 15:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BW6U36xw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732468AbfFYPpM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 11:45:12 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41202 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731960AbfFYPpM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 11:45:12 -0400
Received: by mail-io1-f65.google.com with SMTP id w25so571147ioc.8
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 08:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dWwYrPVRlYC+hWRtVzZy3YcTqNYCEUXAedDbd23FqPw=;
        b=BW6U36xwO2NR98Ra3G23IPP/Vsn1NCplxV3bfdqOsbE3ZKWRPeV3SYkjR/tr0wpAkt
         apKLbCV2ESxtKgwS6qIUhyek/7q+uJKqPuOjxj6xd5LhhUzovMvIxWTD3NEkrGDUNWoA
         l1Ekw/GtdVRxIWcYFFiDINIb4lzSU6+dmleRtXOQo88oyBo0ixbuyLdFc7JD/vcmmyzO
         8G7C9ybrJK/OPClg5sl+cmZ6WIAt6CB2ximzZq65D8ycMxybqEwOvZ6TTik+2jBtcY0h
         NK1BJpkYcCZ7dp6VzXCg+szUGcBHw6TIUZTjmQCXKXezTwQWLvzCDixKAL2KjN4Tyw7T
         D4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dWwYrPVRlYC+hWRtVzZy3YcTqNYCEUXAedDbd23FqPw=;
        b=s0YO3xLyiF172eNIjH0O0SWazQ0eWzOdKzguLxi1LB/3frWM7Y0ZOOFXYQvVevYQkv
         ccCwCcyLYkdfhCd+pqdPSq700rJ6KXgrL19BCi5Hc7ZbgR/GPJ6n5WYkB8wSuD9sTdXW
         K3r+o54QUFoaAMAQwyokXxUwC2YSYyYrwM1eQ9LRK60EkfN2XOX8ivS4uOHWIa/DqOfc
         K+p7Zi9Of/0CjjyGKj9GcDFqJX+zPDpCDuJlsGNVfXAGz8IqeEA8koazwmuObI2n22ax
         39lkIygSll8wQ7PMVni9Cecw6ZaLA9l0/aJPAqJYMp4ruzeAs/HthOQFrGccVtmz2mSE
         HqXw==
X-Gm-Message-State: APjAAAUcvLk76J1wd96YfzdSTLoqfKcCqDOeZ+1/HfLl1sAkcngPk81O
        fIM91f5bjYGK5Zb96ZEtaZHS/U+7bUUr+xUbqHk=
X-Google-Smtp-Source: APXvYqyGSQ2w2+6ro7fsvFDxKZ+cTYz7v1d1M7+xczEjyWSaiGGAG3zswk3nUlqlLtIBUJ5ELBmHJ7yRH4kgKD8POqg=
X-Received: by 2002:a6b:7606:: with SMTP id g6mr7443390iom.288.1561477511727;
 Tue, 25 Jun 2019 08:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190513095630.32443-1-pablo@netfilter.org> <20190513095630.32443-9-pablo@netfilter.org>
 <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca> <20190624235816.vw6ahepdgvxhvdej@salvia>
 <4367f30f-4602-a4b6-a96e-35d879cc7758@kaechele.ca> <20190625080853.d6f523cimgg2u44v@salvia>
 <0904a616-106c-91de-ed55-97973aa5c330@kaechele.ca> <CAKfDRXjun=cVovtn70jxwTc9pa0hhDHUSdZjLHJC1Xw2AMG+rA@mail.gmail.com>
 <04ab8f2d-2b50-8d99-2fa1-837b7acaf417@kaechele.ca>
In-Reply-To: <04ab8f2d-2b50-8d99-2fa1-837b7acaf417@kaechele.ca>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Tue, 25 Jun 2019 17:45:00 +0200
Message-ID: <CAKfDRXhbbGdg33-ozvt5fODT5-ka9jYo2kHLyiKWsx8JEPu1KA@mail.gmail.com>
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

Hi Felix,

On Tue, Jun 25, 2019 at 4:45 PM Felix Kaechele <felix@kaechele.ca> wrote:
> So here's what my understanding is of what is happening:
>
> Let's go back to that line of code:
>
> u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
>
> Just to make sure I understand this correctly: If the version is set to
> 0 the address family (l3proto) will be set to AF_UNSPEC regardless of
> what the actual l3proto was set to by the user of the API.
> It is only set to the value chosen by the if the version is set to a
> non-null value.
> We assume that all clients that require the old behaviour set their
> version to 0, since that's the only valid value to set it to at this
> point anyway.

Yes, your understanding is correct and I think I now see what has gone
wrong. The change in the patch we are discussing here should only be
applied to the flush-path. What happened was that when fixing up the
support for flushing,  we (well, I) forgot about delete. Until my
original patch got merged, u3 was never used when flushing. However,
the value was used when deleting. By changing the value assigned to
u3, we unfortunately broke delete. By moving the "u3 = nfmsg->version
...." line to the else-clause (like Pablo did in his patch) and
passing nfmsg->nfgen_family (like Nicolas suggests) to the
parse_tuple-calls, the old behavior for delete should be restored and
filter still support flushing by L3-protocol.

BR,
Kristian
