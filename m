Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D382CC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3F152080A
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:12:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DJZ3SC6b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbfFRRM3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 13:12:29 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40403 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729209AbfFRRM3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 13:12:29 -0400
Received: by mail-ot1-f65.google.com with SMTP id e8so15005493otl.7
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 10:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=e8dlbgoE74X5GGi/5FXpZZb7GZPkInTUuKy/YgOivNs=;
        b=DJZ3SC6bUSgYC0HUML8zAqxy9oQ6DqokmnuU1LuD9+DmZ/KzvnVHhSaiquvrzqvrH8
         f2NcV0/CCM7F1P7+L3QYuaaihAzdMaZJ//1XAonxhru0tC888quS1nbC4oOciWCcfBdE
         xPl3r73HcQs7htRk7++/OE2JCPg/5iszAGCpfOFibPRd/R+b+j8vYXOejU91mDv7RNdl
         ZG/uum1BoV2ZEEXCnjkI2eMJS2rHBLUDzjNgLqQKNDZj0Ic82WFZ0yaM/z6hSskLIGLj
         JkrLgO/MN6tDlP85xhwV15EXZB4SUcyTQbyxptoemkZmZiv5w1zkdvj/e3CluI4PSdUr
         SRRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=e8dlbgoE74X5GGi/5FXpZZb7GZPkInTUuKy/YgOivNs=;
        b=TADioCawbAmaIKlAVGj4HgjejJBmLTmNs9J8/TT2R7V23gB3/FGsw3FzdTwnhWoQcV
         NcuZnVhi5TcrJC5pFIjn6p8Zen8citombIxrR/fHeaYgfU9tDQW5Uo+K2ihe80vk9Jz7
         eLkxrwlZckQuNbH1me6yM2RilFwMT5lLNqSkcDjLMZcRd6i0pJfJVwx9F4dv52lDapjk
         YNp/zmxfsnH5mrXl6DG6jALHJBKaeSSxKRXSqfe8I1iEPy1cYHhy9joxzzJMqUwwZdV5
         yaIRtazldvgy44jybeySlshXs0Xk0kxL33jWP9WZ2Kyr3hMFPxegNjjsGvL8hRtq3G49
         hEgQ==
X-Gm-Message-State: APjAAAWlWzTm2qLQ7GGC0Cvjd8BsXFn/Lx3avjsOuvtu/lPoGFt2gjca
        shso2IuEpaxNErd6reg0PnNhrY8bcns9iHVDvmc=
X-Google-Smtp-Source: APXvYqy0BlJyYiXw17KQzuLxEgtvzcDfLdDfQfjM03GDoHqwO2WzC8DhX3suYaq+H4E7HumdlLEkfs6SiXdPZ+eOIkg=
X-Received: by 2002:a9d:649a:: with SMTP id g26mr23602385otl.152.1560877948299;
 Tue, 18 Jun 2019 10:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190614143144.10482-1-shekhar250198@gmail.com> <20190618143106.tgpedjytw74octms@egarver.localdomain>
In-Reply-To: <20190618143106.tgpedjytw74octms@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 18 Jun 2019 22:42:17 +0530
Message-ID: <CAN9XX2oH=kDt_fKu5+QvR-0=TUMa6T22g9ZA2dpoM4Cgff25aw@mail.gmail.com>
Subject: Re: [PATCH nft v7 1/2]tests:py: conversion to python3
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 8:01 PM Eric Garver <eric@garver.life> wrote:
>
> On Fri, Jun 14, 2019 at 08:01:44PM +0530, Shekhar Sharma wrote:
> > This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> > The version hystory of this patch is:
> > v1:conversion to py3 by changing the print statements.
> > v2:add the '__future__' package for compatibility with py2 and py3.
> > v3:solves the 'version' problem in argparse by adding a new argument.
> > v4:uses .format() method to make print statements clearer.
> > v5:updated the shebang and corrected the sequence of import statements.
> > v6:resent the same with small changes
> > v7:resent with small changes
>
> "with small changes" is not helpful. In the future please list what was
> actually changed so reviewers know what to focus on.
>
Sorry, will be more specific next time. :-)

> Patch looks good though.
>
> Acked-by: Eric Garver <eric@garver.life>
