Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25548C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 19:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhLQTtm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 14:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhLQTtm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 14:49:42 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0282C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 11:49:41 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id k23so5045100lje.1
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 11:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ns1.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=taxt8joDR2VHnKy739c08QHLkYMo9CrIn8Ni5B6rhZg=;
        b=P1vcF4s0fw+swJXHIrRm40Ssr0gJ1FGSF37IjY9teF9+6QuZ7SvPp3s/1lz43Ba1MB
         /lvxHKSyqDVbp8CYPg2VTKEhh52752hH5SgVNaLWjfW/EtNpQZg5wgEn0PUD5Q6OM10B
         KukytPeFjqUtEeYGjrYjGp36Twwo4CF9MYrbkC0Po4rgiIDLsHZ0tCrm9tQfNEtUGL3g
         qcoSoS0eDNB17xz1A4Xr5tb2KZgU+pPFbASwtHphNp5mUI9lncVCGCw7tctdfdSMDcui
         q64LUziQQZFGQBMeg9zfCaBE3Vx4Xvdao4gaQkFlbyxigU4Rl1g9qgnyLs/UMQT8D566
         Srxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=taxt8joDR2VHnKy739c08QHLkYMo9CrIn8Ni5B6rhZg=;
        b=TS17k/jMcC+zeT/HShGALRCjJ41r/txapqA+ZEriWQq1Gdt+JIMeGwqdPFIgzqZltj
         1tVwlgDPckUGLXmf0xOdfoo5k4+Mfe5gknoFRSmR8MFM1TBligkKliyvsFyEuuJd4MgM
         Cjp3ykvfzQpnurXtRV9k9m0V9v0g7/cILu/sfKHfUkUEpQ1+Ctqvsgg2EqVD6TxhaRKQ
         BntDVAzN2oA7hzfl7ZjDoWL3VNqvlivTzZLzDqrUC0pIEn3ltmgMFN2yOio5abpRliNp
         MeOl1NXNZfL8WW9QRVKJqzf/CzoKh3CMj4b9XHUeeekLXn4f2S5WI3BDaPSJ3WC02f0G
         Klqg==
X-Gm-Message-State: AOAM533KvPvyIsZiwZcAkwlGEm8RYT07PfclU9UMrNtP089+p9Fz6lUz
        0yyDEiFGGlPZ1LKVbVVx+7bgUaVHmig3Y3HaDtJpthulQbrqIahH
X-Google-Smtp-Source: ABdhPJzpEgY7ThUh4u0RRY749DWZQcsj2KADRsbUydXmNWbILv6Enm8klIIO0F8cytlA7kDZC4mj5XW8VKMHvFdEgf8=
X-Received: by 2002:a05:651c:168a:: with SMTP id bd10mr3894367ljb.115.1639770579998;
 Fri, 17 Dec 2021 11:49:39 -0800 (PST)
MIME-Version: 1.0
References: <20211209163926.25563-1-fw@strlen.de> <CA+PiBLw3aUEd7X3yt5p7D6=-+EdL3EtFxiqSV8FDb5GuuyyxaQ@mail.gmail.com>
 <20211209171152.GA26636@breakpoint.cc> <CA+PiBLzz6Y0_Ok_dKxK-OUneNu5gxOm6_e2049277NroYoWQmA@mail.gmail.com>
 <CA+PiBLze0Qu-AdAeu_0K++HcHaaN+7p383drNyx3y0RdO2FCuA@mail.gmail.com> <20211217190417.GC17681@breakpoint.cc>
In-Reply-To: <20211217190417.GC17681@breakpoint.cc>
From:   Vitaly Zuevsky <vzuevsky@ns1.com>
Date:   Fri, 17 Dec 2021 19:49:29 +0000
Message-ID: <CA+PiBLzQ4HmFDVhxPwDc7fr58jbfQ0j-6GF67rdiVwq7k-A-og@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove expired entries first
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 17, 2021 at 7:04 PM Florian Westphal <fw@strlen.de> wrote:
> Sure.  But the patch is for the kernel.
> I already mentioned that this doesn't handle anything for non-nat case.
>
> > > > Maybe 'conntrack -L unconfirmed' or 'conntrack -L dying' show something?
>
> Still stands.
>
> Also, is there really a discrepancy? Please show output of
>
> conntrack -C
> conntrack -L | wc -l
> conntrack -C
>
> "conntrack -L" reclaims dead/timed-out entries, conntrack -C currently
> does not.

Of course... It is an order of magnitude difference:

# conntrack -L unconfirmed
conntrack v1.4.4 (conntrack-tools): 0 flow entries have been shown.

# conntrack -L dying
conntrack v1.4.4 (conntrack-tools): 0 flow entries have been shown.

# conntrack -C
88064

# conntrack -L | wc -l
conntrack v1.4.4 (conntrack-tools): 7641 flow entries have been shown.
7641

# conntrack -C
87706

# cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.5 LTS"
