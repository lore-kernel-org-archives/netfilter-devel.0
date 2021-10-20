Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A51C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 13:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A3D260E74
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 13:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhJTNjh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 09:39:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229570AbhJTNjh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 09:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634737042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oke3YO10lsd4gHi583/wBPyeD31fc7NpCX/cJCf2FLg=;
        b=dlq9A0vEQI8jWUNPuGUqchp4hIbujk6pJzmsVQDlb+OTsxm6mdx7mvMH6MllEs6pUT/E8p
        e+v1SLyjfnj3a6eplp1bRS36eAbN7Xn0o7p76mWDeisvvG2FdNVOIe5EVVwKmQVlgqESVh
        aCg0UMBdCOK7GMzF7194drxd0Wx68EA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-191GAMYtMiyJFkXE34yJwQ-1; Wed, 20 Oct 2021 09:37:21 -0400
X-MC-Unique: 191GAMYtMiyJFkXE34yJwQ-1
Received: by mail-wm1-f70.google.com with SMTP id g4-20020a1c9d04000000b0030dd4dd6659so402742wme.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 06:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=oke3YO10lsd4gHi583/wBPyeD31fc7NpCX/cJCf2FLg=;
        b=Kdn2GL7fj1ifrTlZbPZN6xK9f/2CNpRndmolhCtvHiDNVvHa0MRBks+/vAmE4EaitW
         ZqwHCheE/5tENfMFvqc+OABvhz5TO/pLpfXt2Qw7ly/kqqSVmmVXeEm3QC3S2IhH4JhO
         YO+LgA1KVHT2W/wUHtj2zqTmBg01QiTU1lg9usbJUAzmggwf+7gs1M92lRUTKsW60Xbj
         uibdHn4iqNfEcqf7lB6FFr414kx+0jrQu/UOlnI85vZdtmTDpAgOO2GRC6YEFl5Yl41f
         qkW0Vp3lftf1LPRGnn12J1rUIeKFZchroReChBwO8dlppl7oZsHvuuRl30KDNdWZyuk8
         czqw==
X-Gm-Message-State: AOAM531KJeMARdN6FZjv/3BDbrpt2hLymAyhpZ83WUBEhZmRwdXb0cJ2
        UpTQVqgEYV1Vq31+7gQdH0/zLe3itTdk3rvIC4D+QnbFDcckJCfy0xkoHeUPykNMpPDhV2SjVZK
        yWQalKeMyFyB2L0v2NMcRHmqZOcX0
X-Received: by 2002:adf:bb82:: with SMTP id q2mr52190331wrg.170.1634737039703;
        Wed, 20 Oct 2021 06:37:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTHw47MraFzsrwwbsQ+zUteuElMMaW1dHrh0GDfWnbKcqrPDZOKob/LGBPz9AsiZ9rJjDdhw==
X-Received: by 2002:adf:bb82:: with SMTP id q2mr52190301wrg.170.1634737039525;
        Wed, 20 Oct 2021 06:37:19 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id u16sm4383141wmc.21.2021.10.20.06.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 06:37:18 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: cover baecd1cf2685 ("segtree: Fix segfault
 when restoring a huge interval set")
In-Reply-To: <20211020131354.GH1668@orbyte.nwl.cc>
References: <20211020124220.489260-1-snemec@redhat.com>
 <20211020131354.GH1668@orbyte.nwl.cc>
User-Agent: Notmuch/0.33.2 (https://notmuchmail.org) Emacs/29.0.50
 (x86_64-pc-linux-gnu)
Date:   Wed, 20 Oct 2021 15:38:01 +0200
Message-ID: <20211020153801+0200.908737-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 20 Oct 2021 15:13:54 +0200
Phil Sutter wrote:

> Thanks for the patch, just one remark:
>
> [...]
>> +cat >>"$ruleset_file" <<\EOF
>                           ~~~
> Is this backslash a typo or intentional?

It instructs the shell not to perform expansion on the heredoc lines
(which would include interpreting '$big_set' as a shell variable).

https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#t=
ag_18_07_04

--=20
=C5=A0t=C4=9Bp=C3=A1n

