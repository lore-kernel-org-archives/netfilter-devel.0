Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88514C04AB1
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 05:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4949C208C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 05:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUTmnI9S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfEMFcx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 01:32:53 -0400
Received: from mail-vs1-f50.google.com ([209.85.217.50]:40290 "EHLO
        mail-vs1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfEMFcw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 01:32:52 -0400
Received: by mail-vs1-f50.google.com with SMTP id c24so7220445vsp.7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2019 22:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mTO8cUuHWmRrC5LzF4d/RHaFXaj1VBpBn5y5lARy55I=;
        b=JUTmnI9SqvALB1Ndyhu+cs4XJtSnc7pDvVgziStKWp03xwKeMAsNPgQERKi+LVDhCn
         RFCDquGXcIWDiS0YUjR94zBSwd+xEaFigaQic8lWj+P3NdFEJAZHQusq6O8sEEs8LAkP
         XNubfZbFYAcaz6wCyChbK9VxZqenVffyodTiYstByTGnACqqJSjQn6gdKYCHxHDyfkhC
         mSsUtEewFXx6qZnZt8FYvbQPNGV+0jRC192k0syQCaLDYV6gei8vmSpFnN1gYNGYivsg
         9akS7yL8rKMtEpE90euPo0ia0VNxD7y0L6O+pp1ClR+G1XqNU5H2Fd8u2UNMtM2R2Ibv
         I0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mTO8cUuHWmRrC5LzF4d/RHaFXaj1VBpBn5y5lARy55I=;
        b=sgXy/igqiOUnuWZ5PaCWEa+56K6dCMd9KnddXBCRQBDrlz1cWAYs++6Alr0sGbvXnq
         NYyHEYRDCsyoeMF7lhFpzwMvECzSPrUEijOOdL72aiHioenJtgQs02ZOxXl5BAdU5mCe
         Et9dUWNVlxg6x9VQIxQhRXdd+Xs3jJYtPxIC0/LxFu1qv/fMD4YU19PN/PgwN7glMSS1
         X3QO/8nlI8UCnFA3NSsVsLCJHSZ7UbaTew49hRsbk5stG3j8ZHk5vYVB88/rqgCZe7RK
         6cUqOT1DnaBNv51R310Pfvqbh+xyISuLt3pUIDmNqlvrVW0VbIeM1baP7iAaPw30ce6e
         bmNg==
X-Gm-Message-State: APjAAAWNmHMBsrSWsoakb3rRjfQX2/g7fz1AT/CWg6OSnYSeJLRyRrio
        e5hsCUT0vyQjf2gvUbwXa5iB4sqczqQSP3GcbEsxSA==
X-Google-Smtp-Source: APXvYqyUL4ERbBN5scwyxoncIzs6mQ3nUvZPOGc0+pMv3y3lbuJFHqCY0mUNQUjECfuerCyww6h6IVpZQqefuxugRAw=
X-Received: by 2002:a67:f303:: with SMTP id p3mr987342vsf.166.1557725571916;
 Sun, 12 May 2019 22:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAFs+hh4ghFJqE=b+CXiVL9AguKr1MjZntuDvzYyqmDy5aGJPLw@mail.gmail.com>
 <20190512085624.gdzbjeb4htdp7z45@breakpoint.cc> <CAFs+hh7TXHELQr7aTQXJrkko-jN=C8Nx=s6ZhxQNDyB+KECTnA@mail.gmail.com>
 <nycvar.YFH.7.76.1905130059440.21326@n3.vanv.qr>
In-Reply-To: <nycvar.YFH.7.76.1905130059440.21326@n3.vanv.qr>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Mon, 13 May 2019 07:32:40 +0200
Message-ID: <CAFs+hh5Hh6JAz4Pi6Sm3XR6GGjVQcOswFzCbN6WrEabzNr9rJA@mail.gmail.com>
Subject: Re: Undefined reference?
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le lun. 13 mai 2019 =C3=A0 01:00, Jan Engelhardt <jengelh@inai.de> a =C3=A9=
crit :
> This must be
>
> ./configure LIBNFTNL_LIBS=3D"-L$HOME/libnftnl/src/.libs -lnftnl"
>
> like.. since forever.

Thank you, Jan, but I still have the same result.
(the configure seems to take environment variables anyway).
