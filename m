Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2C1C388F7
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2612A20679
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fieMZXO4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgKJM6k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Nov 2020 07:58:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgKJM6k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:58:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605013119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z+WGCssdGA3YCRbCIXVl6tCa62lOfUTtuf06k0ZXFFU=;
        b=fieMZXO4XUe/9jY0fkJ72rFyqvvmT2wI1sj2ZSWEtYRZNX+Cdju969PSgfs/ct3dQOdTGH
        3q/uLGLM7Zmkl7vWlG2ta2es0UlJ6LlpGCGs+4zsP1jWqZ2XismspmfEwjcYmAc44opwZZ
        cYiU/471vkxAX8JADqKJcUYSbMGu3sM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-shYHSHleMD-yC3L_ogCdCQ-1; Tue, 10 Nov 2020 07:58:37 -0500
X-MC-Unique: shYHSHleMD-yC3L_ogCdCQ-1
Received: by mail-wr1-f70.google.com with SMTP id h8so5693673wrt.9
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:58:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z+WGCssdGA3YCRbCIXVl6tCa62lOfUTtuf06k0ZXFFU=;
        b=izw2TC2fyXp09jMNVwCcDGQsKFzBlu3AIcRcCBAJB+yICFRXzQAZFNeH/eFCgSSy2c
         4DyfFn4s+rX2EoHNk9/Os9iBSMw9C19LD1u2AtCzAPfP8EnqZVJnRttNc4NnQVwLW8Xm
         M9ksOD8uTDjqA5o4Cm2A7lIKlpERYr89fGlvaWfUPt35d1z+i/uk43V/DYgW3Wc/I53c
         FG+5StXsgStgNjO5RUbThvlkH93KidLePqU1abOfnokgizuB8jnExhk60aY2o33wtEOj
         PzzK/9qH1tKznzRq3G/ycdhkaiysdJsqorII0EyQZO+qxUsHdaJYyAf0JyPpyr0TXNjd
         2tNQ==
X-Gm-Message-State: AOAM531dMK/jtHhKN+x5fxXG+lNY8J10XSplPwjb0ZNhi+vmFSv5RL4N
        l9jw0Z0KR1RneCeLwpxA49hLJf3PYABHOkBuVBj+FPVdmYI0iWCtE8/N/NAXBgu2EW7VsSKDNyJ
        dBJwnTtnQDquzQ3Bw8ZbQap9+BP9lLE+Nw+/9eWmB+mO7
X-Received: by 2002:adf:f2c7:: with SMTP id d7mr20288494wrp.142.1605013116310;
        Tue, 10 Nov 2020 04:58:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweC6IjK+j8sEdC2btLJnlZh8JURX/2BOwz0WpCtJjLKFEyNn9FcQYtGZXXMP66pt+rSaE1GwNqxHeCPjfvT9k=
X-Received: by 2002:adf:f2c7:: with SMTP id d7mr20288476wrp.142.1605013116071;
 Tue, 10 Nov 2020 04:58:36 -0800 (PST)
MIME-Version: 1.0
References: <20201109072930.14048-1-nusiddiq@redhat.com> <20201109213557.GE23619@breakpoint.cc>
 <CAH=CPzqTy3yxgBEJ9cVpp3pmGN9u4OsL9GrA+1w6rVum7B8zJw@mail.gmail.com> <20201110122542.GG23619@breakpoint.cc>
In-Reply-To: <20201110122542.GG23619@breakpoint.cc>
From:   Numan Siddique <nusiddiq@redhat.com>
Date:   Tue, 10 Nov 2020 18:28:24 +0530
Message-ID: <CAH=CPzqRKTfQW05UxFQwVpvMSOZ7wNgLeiP3txY8T45jdx_E5Q@mail.gmail.com>
Subject: Re: [net-next] netfiler: conntrack: Add the option to set ct tcp flag
 - BE_LIBERAL per-ct basis.
To:     Florian Westphal <fw@strlen.de>
Cc:     ovs dev <dev@openvswitch.org>, netdev <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 5:55 PM Florian Westphal <fw@strlen.de> wrote:
>
> Numan Siddique <nusiddiq@redhat.com> wrote:
> > On Tue, Nov 10, 2020 at 3:06 AM Florian Westphal <fw@strlen.de> wrote:
> > Thanks for the comments. I actually tried this approach first, but it
> > doesn't seem to work.
> > I noticed that for the committed connections, the ct tcp flag -
> > IP_CT_TCP_FLAG_BE_LIBERAL is
> > not set when nf_conntrack_in() calls resolve_normal_ct().
>
> Yes, it won't be set during nf_conntrack_in, thats why I suggested
> to do it before confirming the connection.

Sorry for the confusion. What I mean is - I tested  your suggestion - i.e called
nf_ct_set_tcp_be_liberal()  before calling nf_conntrack_confirm().

 Once the connection is established, for subsequent packets, openvswitch
 calls nf_conntrack_in() [1] to see if the packet is part of the
existing connection or not (i.e ct.new or ct.est )
and if the packet happens to be out-of-window then skb->_nfct is set
to NULL. And the tcp
be flags set during confirmation are not reflected when
nf_conntrack_in() calls resolve_normal_ct().


>
> > Would you expect that the tcp ct flags should have been preserved once
> > the connection is committed ?
>
> Yes, they are preserved when you set them after nf_conntrack_in(), else
> we would already have trouble with hw flow offloading which needs to
> turn off window checks as well.

Looks they are not preserved for the openvswitch case. Probably
openvswitch is doing something wrong.
I will debug further and see what is going on.

Please let me know if you have any further comments.

Thanks
Numan

>

