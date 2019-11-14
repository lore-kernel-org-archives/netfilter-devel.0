Return-Path: <SRS0=/b89=ZG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC470C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 09:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C34782063A
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 09:56:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/R2Da9e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfKNJ4f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:56:35 -0500
Received: from mail-io1-f54.google.com ([209.85.166.54]:45692 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfKNJ4f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 04:56:35 -0500
Received: by mail-io1-f54.google.com with SMTP id v17so6075123iol.12;
        Thu, 14 Nov 2019 01:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ob7fXRHXFaUbt+MZz3Cua9UHZx9YFsTGvrJNqwC5fEM=;
        b=m/R2Da9eXjfpqA5ZZz9gOmdwzp8fxaWmbkKq1Laourv9uUKBIqlZf+fQ4dgBovIy9R
         Kf+lKAsGkKzjqk8By6BxPGQco4i6XJ5VnGhiM8sbfFxfJdTPBHql3w6t7wpKM0AG3Eox
         v/pULEU9HWNAdSc+7KIJGUbUjYDMQtepjkZ7+3Gfc/WkZFRzKPqiS2dXUa+zq1oi8xkU
         +szMcHdUqdDJzkwtze4YYnISsoNdHdF+focCz3H8q2zxUQNBBMjTb3D+FGbj2uDWnHFF
         St4mRuXT5K4xQ83WcLwYigtZV+KpNQj3FChFqauiM7FSooWcGu1Uj/GpfAUf5Jt2bbhA
         GkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ob7fXRHXFaUbt+MZz3Cua9UHZx9YFsTGvrJNqwC5fEM=;
        b=llrEGMqyPLboc9o0ir8u/dRannbWKJvGAxvB97GIDPsg8rVmS5SyzVOAmCONl/chmK
         VBC2CH1UA4N1ekLGMUNWXPDWgVQP8CS/w9e6p8ARmloT9euCoCPyeeqmjkZMVqj7nYZn
         ARpLnLlSUvg0r7RehfofSQClw8iqrULTSpiWQBfNT0SyoFJyyX700weskcSq5KOdVIN/
         S5r3JXsyA/qT7j3phtxXZfRaGAE69BMpxZleDv3xhD5j32xfUct8jcFQO5qRSHliC5CE
         Od4YNPSaQS0xk0nD2TBXRwnwLDMAoNk9alt8gfC2gmTFuFHAvWmc29Kvv1FdGRnVfZ10
         eHAw==
X-Gm-Message-State: APjAAAU5lVQXmhG8XCzc9URc8gmMCAiBOkpPL9buyWkwCaw4c86U/v+v
        ki+Gs8CrYh1PSSfrtpE6PcinMXLhyCJugUDum8eSVw==
X-Google-Smtp-Source: APXvYqwTpjeFtIFaTkUENUrQv5lnquDZScVBao2TFrtYo5TIDji1W9szmsuLHTId6hW6+0RJfC1TyEshWAsG+VcETAw=
X-Received: by 2002:a05:6602:22c3:: with SMTP id e3mr7924011ioe.73.1573725394310;
 Thu, 14 Nov 2019 01:56:34 -0800 (PST)
MIME-Version: 1.0
References: <ba4fb013-93a0-3f63-0fd6-a4ee557893af@lechevalier.se>
In-Reply-To: <ba4fb013-93a0-3f63-0fd6-a4ee557893af@lechevalier.se>
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Thu, 14 Nov 2019 12:56:22 +0300
Message-ID: <CAK6Qs9k7MD++kEHiZ+ZEunz7SyCNGeEqB3r2iZFTh_hZUQT6tQ@mail.gmail.com>
Subject: Re: ipset bitmap:port question
To:     A L <mail@lechevalier.se>
Cc:     "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I'm also wondering why port numbers are not interpreted with protocol
on bitmap:port while hash kind sets are.
I'd would glad to hear from a netfilter developer.
Regards.

--
=C4=B0brahim Ercan

On Thu, Nov 14, 2019 at 4:25 AM A L <mail@lechevalier.se> wrote:
>
> Hello,
>
> I'm trying to understand if ipset "bitmap:port" should support protocol
> or not. Based on the name"bitmap:port" it should only store one value
> per row, and not tuple like "bitmap:ip,mac" does. However the examples
> in the manual suggests it should?
>
>  ...
