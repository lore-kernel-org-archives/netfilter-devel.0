Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B437DC83F16
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 02:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbjHaC1U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 22:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbjHaC1U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 22:27:20 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8193DCE7
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 19:27:12 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-d7bae413275so1605141276.0
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 19:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1693448831; x=1694053631; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxPIrfMOSgJoCJ0abPoHMU83KuuFZMtAqB1RmHO2mPk=;
        b=db0YC9HssVJLqQFszT20UMSdq79Wek8Vms/ZjSF+0/kGNfE3TpMxI7UEWCilloLrGV
         w7pJ8Jv1JJuFDdEdial2FJ3OxdEugX9qj88m3YJevMeoBoahtpgdwBrVOWvseTF74UFY
         e5Ck92oCmRLNweIAnYvyk6RL1+lK+usp+jRkmpwDTXhyFZ+oI5COhX0oUkMG6QR8/VUq
         DNUPakUbGT0jaW6kvs+na9e7D5l62XdPssC7/fIrRvaqJo18Uwa8S5YRgGJhw6ajX1jy
         sVBWY01sTe/wFP0ilYoadv21Wt452p4H3rU+5iJfF/cRPAz5wMuGbjUePwy222nlutEE
         80+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693448831; x=1694053631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UxPIrfMOSgJoCJ0abPoHMU83KuuFZMtAqB1RmHO2mPk=;
        b=i5iTHEdb3ve7z1c+f3rYbfOh29zWUvEO2OR8isxCCgKTG3eFYanHWKA1F/evPB6LCB
         HnEE9qK2yIUiViQ+cBmTjL2/aZFmDgvvpy8sR1Wma124EdgGhpDHTVazvbOJZHvrro1n
         0/7ZbrBQq9Mk0Jt74lLhlZeiSY+AjuxVFjNTtjziLhOPj3xR6fAi8yzVmedvAGm6fTUP
         qghK318fHuDoPYzD1z5AbJHH3HLzaCeaKsa0VjERVtQDQYloD3/yKa57YTk+IKFzm0gZ
         9tCBAwBHulNuramKHYL3JymJLrx/egqg1Zsr+sK41jptTEGkclLT/GPXR7pQc/D4bTF0
         hf0Q==
X-Gm-Message-State: AOJu0YylOP6VZdSW2mZGJgMB4UUvadyrtZHOyqUUQZR4ipfLRLOIuBv6
        IxO1jjJMw7Ap92T5BzWrZ7U6UeiOFMMW+RsDND9I
X-Google-Smtp-Source: AGHT+IGFBWfHD3oP8mUz0d73L6lvJ9J4UgM6Xhhr2BsahXYXIcJCnWEaHwUQIoSgHhkng/j4tXkRAiU49y5Cbd/KUb8=
X-Received: by 2002:a81:8547:0:b0:56c:e480:2b2b with SMTP id
 v68-20020a818547000000b0056ce4802b2bmr1364155ywf.12.1693448831752; Wed, 30
 Aug 2023 19:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230829175158.20202-1-phil@nwl.cc> <20230829175158.20202-2-phil@nwl.cc>
In-Reply-To: <20230829175158.20202-2-phil@nwl.cc>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 30 Aug 2023 22:27:01 -0400
Message-ID: <CAHC9VhTMMp6Xsc2phTqx9T4h9VQ-ZK4mfa_+RTmOBN-8CBgnng@mail.gmail.com>
Subject: Re: [nf PATCH 2/2] netfilter: nf_tables: Audit log rule reset
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 29, 2023 at 2:24=E2=80=AFPM Phil Sutter <phil@nwl.cc> wrote:
>
> Resetting rules' stateful data happens outside of the transaction logic,
> so 'get' and 'dump' handlers have to emit audit log entries themselves.
>
> Cc: Richard Guy Briggs <rgb@redhat.com>
> Fixes: 8daa8fde3fc3f ("netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RE=
SET")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/linux/audit.h         |  1 +
>  kernel/auditsc.c              |  1 +
>  net/netfilter/nf_tables_api.c | 18 ++++++++++++++++++
>  3 files changed, 20 insertions(+)

See my comments in patch 1/2.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
