Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0589CC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 18:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhLIS1h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhLIS1h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 13:27:37 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E38EC061746
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 10:24:03 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id u22so10294752lju.7
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Dec 2021 10:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ns1.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nqd2gdLJ2gSUA6o0Aa2qfmoqL+cD9IQr0/jlPWQWgx8=;
        b=AW707ikv6nO9udA1muiq+CwLbmHMhm+AnSBansoy0f9spgUVUY914xmkbaS5frtwbD
         Z0zsaaO/ZOJkl2ELiDzyBO4g9IyA2Tb32FvJVlpYkPYPgYKsOSp44+ZuXRR+T37SOyw+
         xyljadEhfJ/Q6YceZLRLp4X/3YAndk3vwdcAmfc7Zozsur4OYUo+sE2cw1RWLoML/yNF
         vmvH5mRerJsNyI+FLdo82OExciSE1vj4YiJj7sxCJRjn7PwzzP13kNvsGnlIPcHaus/t
         Yc3VNCnnNK9YVX9+9C1401IDPox/PxCf5nugIhGmxiayC/DJ+P/SDYsFk3+S/6Xf+V7F
         uhqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nqd2gdLJ2gSUA6o0Aa2qfmoqL+cD9IQr0/jlPWQWgx8=;
        b=gv5ccF0VcASId2/2XI+2jBrlVlZuBpmHmr0QahKJt1rHxxUup5Ryx9xJZaQbjkQeaj
         p38WROvkjGJIYxZ5J4t+ZcpqaNBO9atDq+KSVojuwS57iYEHdhMhNu99ex0qn4Kk2E29
         wSXYAxHdz/HO97Zp/7LxyF4K6Nsks2gEaLtqX6TmpvpqSPBOW9vvfhhJjfbT3LTf7svo
         vgaIw/rTjb0Kq2aTa8nna9lDPHyZTMaFhw20tq/Q9Cgf2r0Yg6k7l1HFQFaUEjGo/aHE
         +goutgzjDrchcIxnzgORdK5ejBwrThcnHP0hfcuYVEJIG6nZD8CRBO3V/yx3FQUi+5Rg
         zxcw==
X-Gm-Message-State: AOAM530nnv9FziWSifp4WRJqNNSDycfQLQifFMAv/C+v9kR5txImIbkY
        k2IyEFj3eEOEZ7wi4UcZZau/6zkcfMciUp1qS8KQdukUq55h5Q==
X-Google-Smtp-Source: ABdhPJx3393iPFJZ8Hv+cbzOUNjt2tlOJIqcAKFegavM7vP9q7/8lPdY4OGEXBxuEcb3JcIORLwTzkYOJU19B7x6fpQ=
X-Received: by 2002:a2e:5d7:: with SMTP id 206mr8050794ljf.133.1639074241597;
 Thu, 09 Dec 2021 10:24:01 -0800 (PST)
MIME-Version: 1.0
References: <20211209163926.25563-1-fw@strlen.de> <CA+PiBLw3aUEd7X3yt5p7D6=-+EdL3EtFxiqSV8FDb5GuuyyxaQ@mail.gmail.com>
 <20211209171152.GA26636@breakpoint.cc>
In-Reply-To: <20211209171152.GA26636@breakpoint.cc>
From:   Vitaly Zuevsky <vzuevsky@ns1.com>
Date:   Thu, 9 Dec 2021 18:23:50 +0000
Message-ID: <CA+PiBLzz6Y0_Ok_dKxK-OUneNu5gxOm6_e2049277NroYoWQmA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove expired entries first
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 9, 2021 at 5:11 PM Florian Westphal <fw@strlen.de> wrote:
> > > --
> > > 2.32.0
> > >
> >
> > Florian, thanks for prompt turnaround on this. Seeing
> > conntrack -C
> > 107530
> > mandates the check what flows consume this many entries. I cannot do
> > this if conntrack -L skips anything while kernel defaults to not
> > exposing conntrack table via /proc. This server is not supposed to NAT
> > anything by the way.
>
> Then this patch doesn't change anything.
>
> Maybe 'conntrack -L unconfirmed' or 'conntrack -L dying' show something?

Are you saying that was a patch? v2.32.0? Mind sharing a link for
downloading the source and/or packaged release?
I would like to test it just in case, and if no luck, what do i do to
file it as a bug?
