Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C88C07E96
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Jul 2021 07:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D87361351
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Jul 2021 07:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhGKHPl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Jul 2021 03:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKHPl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Jul 2021 03:15:41 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32481C0613DD
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jul 2021 00:12:55 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d12so13116372pfj.2
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jul 2021 00:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8he8vJwyRIYpjg+FkaaXNzfmOPnNBINkdbbzLbKRzzg=;
        b=sxnUsd3fjdQ/5x4X8b/r38ZvUiUN7iorNSUcaJuODR7Q6I/Omwkixt6zcusCXfcxWu
         W5t2OI3de5x7CJKBegGYa1U/EZT5vV5CG/JlldHS7fK4IyLCo81q6IgUtL6qNUQpMdgf
         VY9ph8K/LoUlHL5SoVI0YvIzH+Rm9jLIcUw+605cyJwHFyfcP2Y4Kz0K6HdueNLY2jtb
         9XbMiFRATyiWxbvhiK+26dDyiLvZ9mLWl2NExt1L/rURYAhnJEUL0s1AoSxYpyIqXzM+
         zuapTLkKLQZDygI8v7DwhQEJgepNCHdfrkL7oESMB9piHdb4+NssWPHs0APg25VR5st3
         15eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8he8vJwyRIYpjg+FkaaXNzfmOPnNBINkdbbzLbKRzzg=;
        b=BaHxYnVlDYuToFJWH0vmJfFbXRdokxHa7KV7cXXMtKvawA7FwGTE3ggCkWIA1JKwoj
         hB0wlOvIPwQQUDqyzO2O8mEClst/AGcW4ZR+kzMuGlvTPl6Y67JzPEQiD6dKu07nGhE2
         DZVW82wJ1kUX77BxDvPr38w9Zpw2CWUQoVSUn6PP6mHynqEmjx34mkMHtAL2Rt/Mskma
         r2N6zR18/R23AtS9SWTFnrPgA88Ous+YKc+1UReCIhc9phMYqjoaNVUzPXn1q/9BfRIG
         sm8xDispNjUAa7iyPUZA6jGqv+t8mIxQ3QRVsvPIfxjnHet9PkV7ALNALXvf/EEsnN/7
         XvTg==
X-Gm-Message-State: AOAM530vJXeKigGVq98tr9pVDGaEEUT0UiP0ZkDZiGFZs3v06DP8UnQp
        YR66gz9VzT39U1mzd/V0kpc=
X-Google-Smtp-Source: ABdhPJwXijSUm35mwM3OOu1JCL1L8F8vu+3sCNqdlZYSp+6cmekI9Zs0/Mxbw8xzHjSGxr0s0dkPGQ==
X-Received: by 2002:aa7:87c2:0:b029:320:d13:d8a7 with SMTP id i2-20020aa787c20000b02903200d13d8a7mr35749047pfo.44.1625987574629;
        Sun, 11 Jul 2021 00:12:54 -0700 (PDT)
Received: from smtpclient.apple (softbank126168110019.bbtec.net. [126.168.110.19])
        by smtp.gmail.com with ESMTPSA id z12sm9844494pjd.39.2021.07.11.00.12.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Jul 2021 00:12:54 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated flows
From:   Ryoga Saito <proelbtn@gmail.com>
In-Reply-To: <20210709204851.90b847c71760aa40668a0971@uniroma2.it>
Date:   Sun, 11 Jul 2021 16:12:48 +0900
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FEF1CBA8-62EC-483A-B7CA-50973020F27B@gmail.com>
References: <20210706052548.5440-1-proelbtn@gmail.com>
 <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
 <20210708133859.GA6745@salvia>
 <20210708183239.824f8e1ed569b0240c38c7a8@uniroma2.it>
 <CALPAGbJt_rb_r3M2AEJ_6VRsG+zXrEOza0U-6SxFGsERGipT4w@mail.gmail.com>
 <8EFE7482-6E0E-4589-A9BE-F7BC96C7876E@gmail.com>
 <20210709204851.90b847c71760aa40668a0971@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks for your reply.

>> I considered srv6 Behaviors (e.g. T.Encaps) to be the same as the =
encapsulation
>> in other tunneling protocols, and srv6local Behaviors (e.g. End, =
End.DT4,
>> End.DT6, ...) to be the same as the decapsulation in other tunneling =
protocols
>> even if decapsulation isn't happened.=20
>=20
> This is the point: SRv6 End, End.T, End.X with their flavors are *not* =
encap/
> decap operations. As SRv6 is not a protocol meant only for =
encap/decap, we
> cannot apply to this the same logic found in other protocols that =
perform
> encap/decap operations.

Okay, I understood.

>> I think it works correctly on your situation with the following rule:
>>=20
>> ip6tables -A INPUT --dst fc01::2 -j ACCEPT
>>=20
>> To say more generally, SRv6 locator blocks should be allowed with =
ip6tables if
>> you want to change default policy of INPUT chain to DROP/REJECT.
>>=20
>=20
> No, this is a way to fix the problem that you introduce by changing =
the current
> srv6local forwarding model. If you have 100 End SIDs should you add =
100 accept
> rules? The root problem is that SRv6 (srv6local) traffic should not go =
through
> the INPUT path.

No, you only need to add single rule for accepting these SIDs. Here is =
the
quote of RFC 8986.

---
This document defines an SRv6 SID as consisting of LOC:FUNCT:ARG, where
a locator (LOC) is encoded in the L most significant bits of the SID,
followed by F bits of function (FUNCT) and A bits of arguments (ARG). L,
the locator length, is flexible, and an operator is free to use the =
locator
length of their choice. F and A may be any value as long as L+F+A <=3D =
128.
When L+F+A is less than 128, then the remaining bits of the SID MUST be
zero.

A locator may be represented as B:N where B is the SRv6 SID block (IPv6
prefix allocated for SRv6 SIDs by the operator) and N is the identifier =
of
the parent node instantiating the SID.

When the LOC part of the SRv6 SIDs is routable, it leads to the node, =
which
instantiates the SID.
---

If there are 100 SIDs, but these SIDs are for the same node, the =
locators
of these SIDs also should be same. so, you can allow SRv6 flows by =
adding
only single rule.

> Have you set the traffic to flow through INPUT to confirm a connection =
(for
> conntrack)? If this is the only reason, before changing the srv6local
> processing model in such a disruptive way, you can investigate =
different ways
> to do connection confirmation without going directly through nfhook =
with INPUT.
> I can help with some hints if you are interested.

You stated this patch isn't acceptable because NF_HOOK is called even =
when
End behavior is processing, aren't you? So, do you think it=E2=80=99s =
natural that
NF_HOOK is called *only* when SRv6 behavior is encap/decap operation. =
The
problem I stated first is that netfilter couldn't track inner flows of
SRv6-encapsulated packets regardless of the status of IPv6 conntrack. If
yes, I will fix and resubmit patch.

Ryoga=
