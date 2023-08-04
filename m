Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1531C001DB
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 19:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjHDT06 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 15:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjHDT05 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 15:26:57 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CD41BE
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Aug 2023 12:26:57 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-40a47e8e38dso45341cf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Aug 2023 12:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691177216; x=1691782016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ea5NvBV7OKnrCcP1bbWGFK6biV4K5ybbKkapW1FOcr4=;
        b=pk8VWj/fD+goY4szKOJWOcGgV8M79kFXXVN+adcFpGjC1rCxU6jbN3dVMtiOZ8sZjT
         wt6b2bTSKgV+vlgTr+F3xQKKWFG3/ugq/8bEoEXqijCYTktb3UYKtW4V8MqVMh0LqtEN
         advNboQYJ3/wsJv4Y9FIUyyeSiQWY9juIa7+Qe8YFKg1JNDUeF1wEi9R0WwihElP0fTs
         oQ7bZaK/sQsa3qrKDlwjSLUozvDakwWkNILCZckx4bTjRmCOcjGm+dx1rKZb7ly46c5M
         aLCGlw8B4iKXuQjejHHwTJ6fIIWJ4zdSGyH0S+2f0cK4yugwkU8RBDTaeg9qe0MTOHLS
         sgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691177216; x=1691782016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ea5NvBV7OKnrCcP1bbWGFK6biV4K5ybbKkapW1FOcr4=;
        b=U1h5/v+jFgYHqVcyISV7SzB8n04lNlTcLgFEm3m1KMyfBog2VFPjcJvdKiaBJaC/0+
         V8yVCrpTjhxAZNxY4hJE5Tayz5in0/wi/Co6HbF9caLoV/8rETTDBrZ0PUZzBE+y2UkI
         C5B2gnx87Wx5JYgjYgOFpM2AoZlzjSXGqaPgOym7+8UPikEU3XGT55T/f/KtLGLz12So
         iJPBWlopU4RWlpHupaHAxd15p+bUEQ+pcIZhpkV9IBcKpFXoHFLdzxLxMjLjCrrLJ3Qm
         TBJMgMPv8ZT/Ua2g48NCrjjtewpjR7wUlHrHdJs5tJSPvBLoUnLI2+ymZIksTVOkDx/M
         44og==
X-Gm-Message-State: AOJu0Yxf4pEvrFfoTFVfdvXy5xcPrHUCRv/sDGC/HRF42+ltnvVlVonA
        48RvqP4ooipKwzW3swUuNhfvRmIPbDUfBUElZpTY9A==
X-Google-Smtp-Source: AGHT+IFcvJyUqd+aWkgQqR5TtAb0EX8PIqNhzjqJR5ruFEIfiTeJcrEy97+bA+ZIBIqodarkiOjPtuhJriWYVQBdTNQ=
X-Received: by 2002:ac8:5c16:0:b0:403:b3ab:393e with SMTP id
 i22-20020ac85c16000000b00403b3ab393emr63337qti.18.1691177216019; Fri, 04 Aug
 2023 12:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230725085443.2102634-1-maze@google.com> <20230727135825.GF2963@breakpoint.cc>
In-Reply-To: <20230727135825.GF2963@breakpoint.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 4 Aug 2023 21:26:43 +0200
Message-ID: <CANP3RGfL1k6g8XCi50iEMEYwOfsMmr-y-KB=0N=jGV8hzcoSeA@mail.gmail.com>
Subject: Re: [PATCH netfilter] netfilter: nfnetlink_log: always add a timestamp
To:     Florian Westphal <fw@strlen.de>, coreteam@netfilter.org,
        kadlec@netfilter.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 27, 2023 at 3:58=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Maciej =C5=BBenczykowski <maze@google.com> wrote:
> > Compared to all the other work we're already doing to deliver
> > an skb to userspace this is very cheap - at worse an extra
> > call to ktime_get_real() - and very useful.
>
> Reviewed-by: Florian Westphal <fw@strlen.de>

I'm not sure if there's anything else that needs to happen for this to
get merged.
Maybe it fell through the cracks...?  Maybe I didn't add the right CC's...

Thanks,
Maciej
