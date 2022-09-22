Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FCAECAAD8
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Sep 2022 02:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiIVCj6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 22:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIVCj5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 22:39:57 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ECA3C172;
        Wed, 21 Sep 2022 19:39:56 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dv25so17886823ejb.12;
        Wed, 21 Sep 2022 19:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=gsBxAjq+sNnP4QJ7G4N2iIhID6Ufd6zDUzv3gwJB1Bs=;
        b=c2cVjeay+TzCLWc435vo0HYdnFs6Jy2a0UGnv4x1UrT9TdVtUtnPosPnwOyhyfwvR5
         DFJ0o27opBuI1q6whHffLMvsAcNgrc1ms6SxNVNXaYZhUIA2FAsbT6ujVYnbZniSBuQ+
         0hl/WG+bEoUG8Bi6gJxkuJlws36AkJCIV9kYVEYIK+ZghI0mWtlMYdXJbKcnUPp1mZIq
         HfAxuz054qK1/+YJvdW9qVhHdwMA14gg7ca/3anBO2MhFLQaM7AOeznuy8MldJJQyqWm
         yO0gftA/jE/5UdlUuql7MS+geC145bL3ky3b1xNapLmjeoDwW0H7C5CfSJuis0QIOjNc
         vnRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=gsBxAjq+sNnP4QJ7G4N2iIhID6Ufd6zDUzv3gwJB1Bs=;
        b=bxbe14ZBusG7/9qF+u27KU6458JyeSFsGcWD4VuXgRoyFuyVEQf5AFCy3CuWb6tmGo
         rglOzIh/fDPyltfr2yKdSeT88oqGiv5skmMk49zAP5d8po77NNK3DGrqXOrCXlo6xaAg
         tBqd1Oxqw+Pxjhj9r+sidMS7+nDt8ZpuhNJg0aV/vp1qb1NOX3PGneYA915CORgfojqh
         dbUFXy7o69eH4ujhzaEDTk67HdkPmMGLzNemH3f/GkfUO3upQEVCIqxKFnD0a1/Cmg1Z
         hRENxPm+PkH2bTouSOjzRfNkLyyqkdgnrZeePexTWWe8guvYcxYp8rqBUyThIS+UUHx2
         VSQA==
X-Gm-Message-State: ACrzQf2dpiyIFTIkpj/F/QKOh8HZKU7EiTv3SmO8iRDzya4aMDZxgHnO
        8Iir6R1cEcFYae1+Xf+FCESJloGNQG76fZX2qM8=
X-Google-Smtp-Source: AMsMyM4wkVet+roNLlHBLuDvGdKnXazOo9PvLJxjV1NYqg+erHRgIoNRlkc/l82TyO87uxJyP3xoYiyOkoAxYcCklcI=
X-Received: by 2002:a17:907:6e87:b0:782:2d55:f996 with SMTP id
 sh7-20020a1709076e8700b007822d55f996mr966379ejc.502.1663814394452; Wed, 21
 Sep 2022 19:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1663778601.git.lorenzo@kernel.org> <cdede0043c47ed7a357f0a915d16f9ce06a1d589.1663778601.git.lorenzo@kernel.org>
In-Reply-To: <cdede0043c47ed7a357f0a915d16f9ce06a1d589.1663778601.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 21 Sep 2022 19:39:43 -0700
Message-ID: <CAADnVQJY4pibr5PkoTFhpYDj8pBJ1mTPuR9VSeKQXuJqeh6d3Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: Tweak definition of KF_TRUSTED_ARGS
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 21, 2022 at 9:49 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> +               /* These register types have special constraints wrt ref_obj_id
> +                * and offset checks. The rest of trusted args don't.
> +                */
> +               obj_ptr = reg->type == PTR_TO_CTX || reg->type == PTR_TO_BTF_ID ||
> +                         reg2btf_ids[base_type(reg->type)];
> +

..

>                 /* Check if argument must be a referenced pointer, args + i has
>                  * been verified to be a pointer (after skipping modifiers).
> +                * PTR_TO_CTX is ok without having non-zero ref_obj_id.
>                  */

Kumar,

Looking forward to your subsequent patch to split this function.
It's definitely getting unwieldy.

The comment above is double confusing.
1. I think you meant to say "PTR_TO_CTX is ok with zero ref_obj_id",
right? That double negate is not easy to parse.

2.
PTR_TO_CTX cannot have ref_obj_id != 0.
At least I don't think it's possible, but the comment implies
that such a case may exist.

I applied anyway, since big refactoring is coming shortly, right?
