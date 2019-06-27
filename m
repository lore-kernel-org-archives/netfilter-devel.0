Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A64DC48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22AB92063F
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mGfEx1+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0PxS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 11:53:18 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46770 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0PxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 11:53:17 -0400
Received: by mail-ot1-f67.google.com with SMTP id z23so2744290ote.13
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 08:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=N0kSHX8keqiS5IrAQnrOA1f+WhvyL560nrGlDizao4E=;
        b=mGfEx1+PR6FxtsN1/4npVKcKsJvbnnJNVPSqorEOL4XC0R5/B9Lp6c2NA2Lpg4Gbzz
         dwrRfzmgubYtj6r+FEy2YjfPmhJNXsUoIX0pLAh6jCEBVKkWl6UZLTKY5Cfhq9x3eXFW
         TAvjmPk1mzLg9U6jNb0t2+JfH/N2lKBcgkc9Lj4q3iuBDDsLSKyd0fxVZisIhg4w3HP1
         8tI/vFeFx4nLDGfRAxyn5h8+abQUqOenkRqL918aTmTc20hpg1SqDKfkyF3bhzBR8Nkm
         JH7O4YrD/7qJUvDAMiHzetZw71Au4zEAAlJDlGQiuwStEWdxK2Eop/2tsmpMsh6tsZxZ
         SsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=N0kSHX8keqiS5IrAQnrOA1f+WhvyL560nrGlDizao4E=;
        b=NgRBI22UY+tSjtedIYPm9AFjoH4ksBkPd+NTNlKNgaobwhL9euSCYquocP1/WZUn4J
         EbJX87gjYSJn84BGN9/jXOdNNAujxw2G1//EaXA8t9E7+lMB2+WAd4WwkFzO1rhIHpk2
         fJHU/TJUs//h7R72Yom/wRTL3iaf8ANA3MTLIt27/x0NI7BBBPa+SA/EPwr32ZeHy7J+
         aRS/cGqlR6oDonxgzbl4wkyP250fvsbVv+sQaPapfaMxKSQAQxv1yybiUME80ojWsCnw
         QbiG+qxK17w3P0zLCCTeVbn4QkDn0xRW2CUFUNYgX5ozXBU49JgvQdVCdTh8cdyceXGe
         G0pA==
X-Gm-Message-State: APjAAAV1sKAYxsGZ8Kji6LO2IZIIAghWAIvN/tF9Ywu5BcKLAVSFpGca
        CGqHowPG9nTAg8S5t6mdrYdOFS97teblJya+clA=
X-Google-Smtp-Source: APXvYqxdplz4oZqRdh/3WxRG7CF8/VfaLS3as4jECVj7U9JT6CMohlRwV3AKrWcE487vimYlHo2yp7eetMGsWtJiiJE=
X-Received: by 2002:a9d:4599:: with SMTP id x25mr3903538ote.219.1561650796927;
 Thu, 27 Jun 2019 08:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190621174053.4087-1-shekhar250198@gmail.com> <20190627125210.7lim5znivu3i2oxn@egarver.localdomain>
In-Reply-To: <20190627125210.7lim5znivu3i2oxn@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Thu, 27 Jun 2019 21:23:05 +0530
Message-ID: <CAN9XX2qFCNe0=BwbqVymg8S3_uX_0fu67=2TJ3erbGv_MDGL=A@mail.gmail.com>
Subject: Re: [PATCH nft v9] tests: py: add netns feature
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 27, 2019 at 6:22 PM Eric Garver <eric@garver.life> wrote:
>
> On Fri, Jun 21, 2019 at 11:10:53PM +0530, Shekhar Sharma wrote:
> > This patch adds the netns feature to the nft-test.py file.
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> > The global variable 'netns' stores the value of args.netns
> > which is used as an argument in various functions.
> >
> > The version history of the patch is :
> > v1: add the netns feature
> > v2: use format() method to simplify print statements.
> > v3: updated the shebang
> > v4: resent the same with small changes
> > v5&v6: resent with small changes
> > v7: netns commands changed for passing the netns name via netns argument.
> > v8: correct typo error
> > v9: use tempfile, replace cmp() and add a global variable 'netns'
> >     and store the args.netns value in it.
> >
>
> There should be a separator (---) after the revision history and before
> the actual patch.
> i.e.
>
> ---
>
Okay.

> This patch has hunks from your other patch "[PATCH nft v9]tests: py: fix
> pyhton3". Please keep the changes separate.

Yes i have included the changes for converting to python3  and also
included the netns
feature.
Should i send a patch without any changes for python3 and only changes for the
netns feature?

Shekhar
