Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8F5C48BD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 11:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2755820644
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 11:52:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K79vh7za"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731313AbfFYLwq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 07:52:46 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40301 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfFYLwp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 07:52:45 -0400
Received: by mail-io1-f68.google.com with SMTP id n5so177925ioc.7
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 04:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t9Jw4cNBs88Ry5n0p2Od1/ynKVMlAzGCyLAizjC/b8A=;
        b=K79vh7za7zh434gFbiqMQZDT5iF0RcwLzrWLfSRnFqE4+NF85qEl9S3QsH+a3KmIcc
         /uF23D7WJpPWUcYKqHV/V7mRFkaFi/88UgJOV8W08NiGXmE/R+iB8m4rNh3MMP4H6FR3
         ttpSbCkmriA0M6K2HD4e7EZOAnFXgO/YW3ENg008ZtJ7EF+Xhsh1Fji/6Tdj99OCQ7+U
         Gi0zOR79cMItztf1BP3rceWWZekcQHD3TdBtCqa3Oh+VtjvTGJUUXXZ4aJ15r2u0W72s
         zq/O6nh+wGE+JMLx4BmlIePNycr+NFV07wC8S/BaQkPq6yOuL3yIk/BOk/Qy6pEwNKX/
         QAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t9Jw4cNBs88Ry5n0p2Od1/ynKVMlAzGCyLAizjC/b8A=;
        b=nBVBYVnNGVBN4XiUvjyzUQDcE2E2zW2aJSgeazD1A/RXuazS36j0h3X0aDnT8cx1mh
         9IbBbfWv21Gqdyv/462OvcOx0OEePQMHbXM6zgGtsPTt0ZQXHJU4oRdPiUHZyo9bYW92
         H3GPvS0QwP0xtoWNwSYVL3sK3MnpMCdRnOPVqDCoQZ1UVsvl8ByVZFRcp1hfS0IU4MGv
         K4HK7D9dNBgvdxXQqDxIJ5E+MSbGXB006tnspapjgFrPqV79ogw7QXgCR2qPC6yTmemE
         tyTz7jGszIGDNia71qX3sBMRyTbMCj16TRaAAtipOaVIbmfu+J/RoU66Favzw/aduoIA
         Fp/g==
X-Gm-Message-State: APjAAAXOz7jI+6dw22exG9KKiqP4m5/wlDA7b47iRb7i7d96HGNSmwTc
        Y53EYhydWake+LwALPQ5QuowmHXFhsVT2s/L2OkRyQR75F3Hhw==
X-Google-Smtp-Source: APXvYqxfsEbDCLHj65BV6OSLdOE9GYBz9dGTzDVvYHGHo6+FVxhgtWiHJSLeGs1o7wkqSyZD0w8BsuzAjC3Zf3bB3Ck=
X-Received: by 2002:a02:9991:: with SMTP id a17mr4681495jal.1.1561463564818;
 Tue, 25 Jun 2019 04:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190513095630.32443-1-pablo@netfilter.org> <20190513095630.32443-9-pablo@netfilter.org>
 <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca> <20190624235816.vw6ahepdgvxhvdej@salvia>
 <4367f30f-4602-a4b6-a96e-35d879cc7758@kaechele.ca> <20190625080853.d6f523cimgg2u44v@salvia>
 <0904a616-106c-91de-ed55-97973aa5c330@kaechele.ca>
In-Reply-To: <0904a616-106c-91de-ed55-97973aa5c330@kaechele.ca>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Tue, 25 Jun 2019 13:52:32 +0200
Message-ID: <CAKfDRXjun=cVovtn70jxwTc9pa0hhDHUSdZjLHJC1Xw2AMG+rA@mail.gmail.com>
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

I am sorry for the trouble that my change has caused. I do not know
what the correct action would be, but I am just trying to figure out
what is going on. In your first email, you wrote:

> this patch is giving me some trouble as it breaks deletion of conntrack
> entries in software that doesn't set the version flag to anything else
> but 0.

I might be a bit slow, but I have some trouble understanding this
sentence. Is what you are saying that software that sets version to
anything but 0 breaks? According to the discussion triggered by the
patch adding the feature that we fix here (see the thread [PATCH
07/31] netfilter: ctnetlink: Support L3 protocol-filter on flush),
using the version field is the correct solution. Pablo wrote:

> The version field was meant to deal with this case.
>
> It has been not unused so far because we had no good reason.

So I guess Nicholas worry was correct, that there are applications
that leave version uninitialized and they trigger the regression. I
will let others decide if not setting version counts as a regression
or incorrect API usage. If an uninitialized version counts as a
regression, I am fine with reverting and will try to come up with
another approach. However, I guess we now might have users that depend
on the new behavior of flush as well.

BR,
Kristian
