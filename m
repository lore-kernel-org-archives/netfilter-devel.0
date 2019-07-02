Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F94EC06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 19:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21BAA21852
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 19:20:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dkmvTe/y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfGBTUY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:20:24 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46584 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBTUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 15:20:24 -0400
Received: by mail-oi1-f194.google.com with SMTP id 65so14027233oid.13
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Jul 2019 12:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eViRXc4z6UzNKxV14/TI10eXGla7mTGqDiZ/SuZiOPM=;
        b=dkmvTe/yZegPlzQbYOwg0BVaymk3miXl2qW+yR59S+ZXYAi5ms+ga5SlXsbjTRIOcR
         s97/EdJNyHzdjuDjkXFdsyGybYtZllBzaPIVv1NNN57BS+XPuCiQHmYevRNcGt6iOpBy
         w3YxNDlDtTo0sQa6crG6GhYfbFdsb7MX/ujcDnLtR9lZCeIaeaHxkcGBGYWpodk07ux/
         hlGpik9/NWPVSm7jszHd8UIXgxiw+BUDOfTvPJWUX2fOn0EDIlkc65dWzap1I1ObmoJT
         A81zPRKZiti63PopqRuzO0wlKz+x1Se87mJisen9Ejh51otHpiLVfjPYPhPB5a3xnMZ3
         onUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eViRXc4z6UzNKxV14/TI10eXGla7mTGqDiZ/SuZiOPM=;
        b=Eh5KPp65xl3TNFmOb7sBh4icd88CySCcgMovFnNr51+HlMd9b2rn/1elCxosPaFJD8
         iOtxSCHv4x7+tyJfQw5R06HFb5aliCGKpmM7HaO3sCZrIW71HMMU8+WixNtAWpENiH+q
         FllmAmIMCSsjG3XmZHHCdIQ3vODpGAHrr4wZxqNx555HyZQ+hu9ZelmiNlOrq+po/Fbi
         z2zvV40MqAWzy6QtomHq2HL0ZkmOsBZlYxL5L7mm8701vtdDxwiz1JpTIGmobrMJsglY
         rcrpY2CALtbtx0/uzjwOmDU3IvYbmA36L6DcXN+tTktb6WdJFXeh1UN/OFEa6er0Buhw
         6yBg==
X-Gm-Message-State: APjAAAVkZHtr2anL1NBbkAIgZI2xlt97YTKkmp0v3wfpv64Fel1ElpMf
        jQsOr+YMFhJ0pXZMHucTNnaXttl3u6lnL5nm9JzFDyYn
X-Google-Smtp-Source: APXvYqzLhZT2FC2T6RQmQb0J3A0IXBWxs0FDPGxeY32NeOTYds6HdrC2bTY1NmD+e5dxK6D+Qs8rUtG/xwK+aYLgiCM=
X-Received: by 2002:aca:4f4a:: with SMTP id d71mr4315797oib.20.1562095223853;
 Tue, 02 Jul 2019 12:20:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190701190737.8235-1-shekhar250198@gmail.com> <20190701191735.juqj7w76ke7yzhfa@salvia>
In-Reply-To: <20190701191735.juqj7w76ke7yzhfa@salvia>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Wed, 3 Jul 2019 00:50:12 +0530
Message-ID: <CAN9XX2rxQRzu3OqnpVnt9tEaXop4=5jnJffhqUED_jwgu86hPA@mail.gmail.com>
Subject: Re: [PATCH nft v11]tests: py: add netns feature
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 2, 2019 at 12:47 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Jul 02, 2019 at 12:37:37AM +0530, Shekhar Sharma wrote:
> > This adds the netns feature to nft-test.py.
>
> This patch is mixing the python3 patch fix with the netns support.
>
> Please, make sure your patch applies on top of current
> git.netfilter.org HEAD.
>
> Thanks.

Sorry for that. I am posting a new patch as v12.

Thanks,
Shekhar
