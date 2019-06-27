Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E82C48BD7
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 16:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6B8920659
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 16:16:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVRooXgQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfF0QQz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 12:16:55 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42309 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfF0QQz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 12:16:55 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so2846856otn.9
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 09:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=kol9rloBnkpdkqITnCY47YRS9fWBA/XLsERYY8VaED4=;
        b=MVRooXgQMxZ/gtnzyWWGmPMrsppZSelGWOnOULkByEacFoz5O4YPuTQ3Z8aLxzWz8m
         T7IVF86GmIUs47Jqyfpd4uOve0WGPBlIQ9dXpvb0Xat75pZUt2gqG9uJllrpyw+T5nl5
         VEFQ/pAJ320FNSRFNtsaZACIkArFBEE16w88fu1sHlDaz59kQKdbfMiXifoe4WjHyn8b
         hnjy6oxquC1fkwyW2U/7X2nIB53zVErOxpGK6kFsUkbWUx2uE8jfBhznCqbTr2p7AEQ2
         AiLXUt/p7C/AAbNReLwc0w2VjvildlkUEblLgntHGW16+Z0xIMHSXDO6Qbqy7vxwEyTc
         i0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=kol9rloBnkpdkqITnCY47YRS9fWBA/XLsERYY8VaED4=;
        b=REbLOs/L5eag7lqszPsEP4nGUHvDcqsA3/kzqojMIGQTTcqyRIZhpqtAJpFPApjI7X
         9j9dKvUq80v/ZVlr94gyseo3p/z36Y93wFXE1gDbDrrptITdjM5tdJuLeOcY+ryxPq0Z
         6J0PhGUiCXXPBjOkctuPTB5cU4nBdNllJCR9pXZEakRL3lejq9Em9JhUbWNlnhbJo3Eb
         jj7As/6I18NWmSeY9YL06t5Xnb0v4nIxTybfnppSvzx3tevCLcDp43Z/TltxlyKQpMwj
         aeMnFfEEoe0/a9AXUnfwscFUUcPvSE2nsMi3P3TsQGkTxfL1pypy6GbA8Bh91uKLVEqp
         /Dgw==
X-Gm-Message-State: APjAAAXRZHkaq5lZXkY4MHf0xm24ZHh3D2bbBnhFsn9DxWWtQFK64TDG
        LJ1PWgR2zEJoMqbLmUKD7Y/vFYWplx2ZOWW88cc=
X-Google-Smtp-Source: APXvYqwJhLUT9Oy3G4qDqF9bKtteNnee4LrikVSkN/0MdF2dD+5Xo9bAjYolwti2iW/Yb8sgL/3zfpXTXlXvIQ066KU=
X-Received: by 2002:a9d:4f0f:: with SMTP id d15mr4151020otl.52.1561652214279;
 Thu, 27 Jun 2019 09:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190621174053.4087-1-shekhar250198@gmail.com>
 <20190627125210.7lim5znivu3i2oxn@egarver.localdomain> <CAN9XX2qFCNe0=BwbqVymg8S3_uX_0fu67=2TJ3erbGv_MDGL=A@mail.gmail.com>
In-Reply-To: <CAN9XX2qFCNe0=BwbqVymg8S3_uX_0fu67=2TJ3erbGv_MDGL=A@mail.gmail.com>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Thu, 27 Jun 2019 21:46:43 +0530
Message-ID: <CAN9XX2ooDk5F7y7N5ugLUQDqLU2DbPbcEnoabB8K8c2jM5stNQ@mail.gmail.com>
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

On Thu, Jun 27, 2019 at 9:23 PM shekhar sharma <shekhar250198@gmail.com> wrote:
>
> On Thu, Jun 27, 2019 at 6:22 PM Eric Garver <eric@garver.life> wrote:
> >
> > On Fri, Jun 21, 2019 at 11:10:53PM +0530, Shekhar Sharma wrote:
> > > This patch adds the netns feature to the nft-test.py file.
> > >
> > > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > > ---
> > > The global variable 'netns' stores the value of args.netns
> > > which is used as an argument in various functions.
> > >
> > > The version history of the patch is :
> > > v1: add the netns feature
> > > v2: use format() method to simplify print statements.
> > > v3: updated the shebang
> > > v4: resent the same with small changes
> > > v5&v6: resent with small changes
> > > v7: netns commands changed for passing the netns name via netns argument.
> > > v8: correct typo error
> > > v9: use tempfile, replace cmp() and add a global variable 'netns'
> > >     and store the args.netns value in it.
> > >
> >
> > There should be a separator (---) after the revision history and before
> > the actual patch.
> > i.e.
> >
> > ---
> >
> Okay.
>
> > This patch has hunks from your other patch "[PATCH nft v9]tests: py: fix
> > pyhton3". Please keep the changes separate.
>
> Yes i have included the changes for converting to python3  and also
> included the netns
> feature.
> Should i send a patch without any changes for python3 and only changes for the
> netns feature?
>
> Shekhar

For now, i am posting a patch containing the changes for python3 as
well as for netns feature
without changing the cmp() function so that the changes proposed by
eric in his patch
can be applied.
If it is necessary i will post another version without the python3 changes :-).

Regards,
Shekhar
