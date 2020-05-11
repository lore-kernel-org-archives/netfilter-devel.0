Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43C0C47255
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 21:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C0A206F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 21:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RMKfcOmc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgEKV0R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 17:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEKV0R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 17:26:17 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE524C061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 14:26:16 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id a21so11188699ljj.11
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 14:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=/IR78QIDGwQ3zRPqdOKqneHUqxdauQ750DTgGvQ56MI=;
        b=RMKfcOmcnzPvCSTnfP6vCvrwZ0OnG6wCNbDZ2b+81bAaDxpXS/0OjmGKEHDKs8qQvV
         T0zrig3NwZGUpIL3ww61Xp8KO6B05dnMEnh3sN6uI9y4i13yF5SnTzAVYiOrvpE2Q1sa
         PdkkN5aCAgxoq1lAOqDvn2xx0a9RPusn4aYu04LBqcacQKbApFH0NuoQGlTM1SD1TGjd
         /W/euMrOd+0edYR3Hkx6CtW9dylit6hRdUbzAh1AAzp8E3WaGPPmF+pI75stPP2f0KTk
         iKmpniWeGr0pEXdg7Pb6arGtpdxnMvDQuTM7i69JdXKUhhyRKdSTQxUzB+D7D8mmgMDQ
         FuAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/IR78QIDGwQ3zRPqdOKqneHUqxdauQ750DTgGvQ56MI=;
        b=hSVh3kB+puWLWIs3aWukYCBpGBjamp1B8odNd65fSSm7Sraf6+tkaDLtlDv6+S1B7m
         f8knryq5ENHYWvt9fwca3kVryBxZ5E206msZScAG8pm07gk+T2CtsMQ9jZ/bAIEIPWxf
         +5Y6aq20QnVD+fMQn9Gmb4FdeoLH9xWAXZZKOtQ53Ema4Ma3B3othFQUGmo7etZDv30E
         2TytiQt6Wt6I8nu3BfgCyHIB2bE7F3JR6DBXHBMAQOb2LIWZnlZsMzUkhI04N7OZb6Mq
         V2EqS1wK+ggydmH15tux+xiXxHYhdrcbY/SljJZoYO/gOnn315KhfCYNkUnNZG0k1vge
         utnA==
X-Gm-Message-State: AOAM531eNh2SeJJCuWKS/V/BcQQGezFC2LM27cqRW0nN09NgdNqFVqvr
        8dVQ0vv8odBPz/hQ/rE/YDZdFXWFe/ZSqfOAJO9sbh+0
X-Google-Smtp-Source: ABdhPJx49kzdvc1vcUfwCmIcNdwnLA9iTe0g1P5iuIM9b+iWiUB68MKcTGgLbmWlNYP+cIZBk7yXy/YvrUBuKuZuZVc=
X-Received: by 2002:a2e:8901:: with SMTP id d1mr11701559lji.37.1589232375050;
 Mon, 11 May 2020 14:26:15 -0700 (PDT)
MIME-Version: 1.0
From:   b38911 Zxc <b38911@gmail.com>
Date:   Mon, 11 May 2020 21:26:04 +0000
Message-ID: <CACWCkhBm0yNnm=Jt0Kq+mbO-mOK7nyDfvTi+CEU6s7OVHs0Azw@mail.gmail.com>
Subject: Correct usage of nf_ct_get
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello.

I tried to post this in the User Mailing List, but may be this is a
better place.
I have a doubt on the correct usage of the conntrack func "nf_ct_get".
I'm calling it in this way in my netfilter, to track UDP traffic:

 -----<Code snippet>-----

       ct = nf_ct_get(skb, &ctinfo);
       if (ct == NULL)
       ...

 -----<Code snippet>-----

On some systems it just work. In some others I get the result as NULL
until I do something like

 # iptables -A OUTPUT -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT

I understand that this is due to some module missing.
I did some additional investigations and it looks that what I'm looking
for can be accomplished with the call to

nf_ct_l3proto_try_module_get

But this looks valid only for some 4.x kernel versions. From more
recent versions
it looks this has been removed. Anyone can point me to how to approach
this on newer
kernels?

Thanks you so much for your help!
CC
