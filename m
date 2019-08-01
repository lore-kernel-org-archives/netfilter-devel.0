Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA027C19759
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C493214DA
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:22:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1FBVihI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbfHAOWR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:22:17 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45586 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbfHAOWQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 10:22:16 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so52181635qkj.12
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Aug 2019 07:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fWePW5JJA+pFxXIfzbZhG8CbAPSsaUT6n/VtlrOuLRs=;
        b=L1FBVihIW26LAWZ+uJnf3Kf6HSJ1dc6rueBwIZDo/vEpmr3yGzCx/yvO+EjWWxcDAa
         5KyuLIGlETD+DZETAwqiMF5c06u4K2sEHifw1ZK35iOuqyxBeuBpeIswo7yDfVyVGauw
         en1bmFgdJ6lFxa9eJYKd/Z5Cv6uWt5BZSaPT3/rf+8Qi2w6QYORq2nlQNatGiBJJgz9g
         faq5sQgAfb6bgherbkpgX82Yf5hYFx5Pv6pQsdafJqfUuRrVpBhVE+al58Tm1YCAWTXL
         561MdfEZPlgYG51c8/ZSjkvtQKbFXoRw1z3e1VPmQrztKr2Zzze19lyUJjwKL3QN/QL6
         o29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fWePW5JJA+pFxXIfzbZhG8CbAPSsaUT6n/VtlrOuLRs=;
        b=mioVHSgyFxtBgQR43qlhB85PtEa81bK7RS0zsyJhS95G/BorK/C3qQ/17d2CPnJh4k
         qW7zDy8KqvIHh5s1NI2016re+9L0KeNB80Dek0N2OapJA6W6NRFkdXoER7z/WD7xIYza
         fYUWPYM9B7t87OStZ+6qahsaLs7bLYvAeFKOOAtM8tfRv8IVnEDrASabbEtdQqjZ5iMg
         mNn7/oa1GFF2IhV81fT9kwgv6Zk/2B+1XJbd80GLyO4Qidyg0whVAffxmK36SBEaWsPl
         j2GTmM9ITX+f17gDRIbNdgbdeIcb9wvEsVDbkLjOOdzoYT/vDqY7dQFXfbIBxPxIsPLk
         fQIQ==
X-Gm-Message-State: APjAAAXq/MsQLP6deOUGk7hQSxm3xqo+q7iO/+4iu4p7lgQ2kV0CmbcD
        +C1C0VwKxVWqhF8UoTfRFD5DEPaZfna2W99WUS8=
X-Google-Smtp-Source: APXvYqxDjZNsLKYuZHUDybZ59oURvUjvsYv9IOHBfLq9tdMtDwuUstEtBH78Ru8kQC7dcEev5XjY7QHnMAj61Qc81CU=
X-Received: by 2002:ae9:d606:: with SMTP id r6mr84210808qkk.364.1564669335228;
 Thu, 01 Aug 2019 07:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <CALOK-OeZcoZZCbuCBzp+1c5iXoqVx33UW_+G3_5aUjw=iRMxHw@mail.gmail.com>
 <CAF90-WiSA88hMQSsvDP=vJK=DhLQPzUN4JzX=OR88oFowqJ8gQ@mail.gmail.com>
In-Reply-To: <CAF90-WiSA88hMQSsvDP=vJK=DhLQPzUN4JzX=OR88oFowqJ8gQ@mail.gmail.com>
From:   Fran Fitzpatrick <francis.x.fitzpatrick@gmail.com>
Date:   Thu, 1 Aug 2019 09:22:04 -0500
Message-ID: <CALOK-OdQwvLx8AACr8bKSbS=2Pa4NDwSC0UfcgedgJhc7keA_Q@mail.gmail.com>
Subject: Re: nftables feature request: modify set element timeout
To:     Laura Garcia <nevola@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Laura,

How come we would need an upstream kernel patch?

It seems like this can be done in the packet path, but I want to do it
outside of the packet path. Ref:
https://wiki.nftables.org/wiki-nftables/index.php/Updating_sets_from_the_packet_path

I essentially want to update the timeout of a set element from the
userspace `nft` command.

Fran

On Thu, Jul 25, 2019 at 7:24 AM Laura Garcia <nevola@gmail.com> wrote:
>
> On Tue, Jul 23, 2019 at 1:10 AM Fran Fitzpatrick
> <francis.x.fitzpatrick@gmail.com> wrote:
> >
> > This morning I was using the `timeout` feature of nftables, but came
> > across an apparent limitation where I was not able to update an
> > element in a set's timeout value unless I removed the element from the
> > set.
> >
> > Can it be possible to handle the element timeout value without needed
> > to remove it from a set?
> >
> > [root@fedora29 vagrant]# nft add element inet filter myset {10.0.0.1
> > timeout 1m }
> > [root@fedora29 vagrant]# nft add element inet filter myset {10.0.0.1
> > timeout 10m }
> > [root@fedora29 vagrant]# nft list ruleset
> > table inet filter {
> >         set myset {
> >                 type ipv4_addr
> >                 flags timeout
> >                 elements = { 10.0.0.1 timeout 1m expires 59s542ms }
> >         }
> > }
>
> Hi,
>
> The timeout attribute per element is designed to be created as a
> constant value where the expiration is calculated and reseted to the
> timeout value during an element update. I don't know exactly your use
> case but what you're able to do is something like:
>
> nft add element inet filter myset {10.0.0.1 timeout 10m }
>
> Where the timeout would be the max reachable value, and then update
> the expiration date:
>
> nft add element inet filter myset {10.0.0.1 expires 1m }
>
> For this, you would need an upstream kernel and nftables.
>
> Cheers!
