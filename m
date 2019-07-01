Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EB7C0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 19:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 986AC20B7C
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 19:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8tfJQ5P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfGATGk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 15:06:40 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37430 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfGATGk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 15:06:40 -0400
Received: by mail-ot1-f68.google.com with SMTP id s20so14608784otp.4
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jul 2019 12:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FTy40ONJC4+Lac60vW0/ODzbXnC5JGuYW34SUNitNJ0=;
        b=g8tfJQ5PBpdVBo0FGdDiinLGZApUqFzqwWH904FwUWMG6guMwUR8+IZbztnOOcZd2P
         zXe9tYC9GIbcqHMIrXr7aWmruArqb+jJcm6xKDASf5di/fJDVZlnRC5/oUhgmxAV4iz1
         RUp1+PoejPJHLnB9E/Gh/wyppMiy8iYfjqi/wDpmZ9+1hmjrc+0W7zF5UBw4z6+dhfbB
         zJd+BqU8uw2H1ljDanj0q1gXlvUNcsdSVOev1Ppns6pezESOp8DiIGDS0OtJdgsQ1Z33
         6TJjSCgS8ytkKaDDigBvkGM2UjScMZpV4GeuaK0xSbC85ZR1qkRYQBs1RKdQvlmiNOJR
         WisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FTy40ONJC4+Lac60vW0/ODzbXnC5JGuYW34SUNitNJ0=;
        b=ZbH4lRf1edyPPOKhsQ2DIqNXeISEDDtA6dK0wFaORubXjudPtyCOZz+1nQ3R+1vQEI
         +Mgu1txyDFHpRk7oJXi1bsrOXZPcOYy9IZEo7daio+UJsWUW47t4jgt39MuX14M1CI/Q
         NAgOAxuKhjfn8vYngD2npc7n6uch7xNix7e5unQ0Baxx48AWwmeiLrhXd6cmeQmmGmOr
         SmUecKl01ZUTrXbcaE0qxdd49mYeD4wnYS6zMEChXKd05SbQ8PUd/NO3fne4feVHLLNB
         oqcRqij+Uu88g+DWOgjH205x2/DCyx3IiF7BVdkvZeFg2RPr80VKXaluwQdAUeaPJrYH
         H8sw==
X-Gm-Message-State: APjAAAUeHlLPevs5xER3f4YH7XmRCZJBONH9bo/uFp3cSZv4mG6Tzau3
        kkCiCNMbq9tgPgydwPaZMewN/Bc7DE09WaKTYY0vYUKn
X-Google-Smtp-Source: APXvYqyAtr2qUt/vQO9GAO2X/LI1o1Ds6ZmgcEG/RW6S5GjcgMzVskx4aWDKiT5wuGX/fsxxOuJ4kfzVzFpZEpJAWIs=
X-Received: by 2002:a9d:2f26:: with SMTP id h35mr21871579otb.183.1562007999429;
 Mon, 01 Jul 2019 12:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190628200229.3217-1-shekhar250198@gmail.com> <20190701184828.2gmlsltcpfyqf42x@salvia>
In-Reply-To: <20190701184828.2gmlsltcpfyqf42x@salvia>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 2 Jul 2019 00:36:28 +0530
Message-ID: <CAN9XX2pLDPZSLHnBbcj=2GqPSi9cPU-=7fZOnREaVY08b_V7AA@mail.gmail.com>
Subject: Re: [PATCH nft v10]tests: py: fix python3
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 2, 2019 at 12:18 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Sat, Jun 29, 2019 at 01:32:29AM +0530, Shekhar Sharma wrote:
> > This converts the nft-test.py file to run on both py2 and py3.
>
> Patch is applied, thanks Shekhar.
>
> Would you follow up with netns support? Thanks.

Yes Pablo, sending the patch as the v11 of 'add netns feature'

Thanks,
Shekhar
