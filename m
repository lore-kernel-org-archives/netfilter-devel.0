Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0900C47096
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D6061159
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhFBLW5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 07:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbhFBLWz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 07:22:55 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8540AC061761
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 04:21:10 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id q10so1897683qkc.5
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Jun 2021 04:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gchpafLKJ6F6uOATukxao5S0fzx1QuO5gM2w3naYObs=;
        b=RYDTY0QjdOGb7GBWzWXSIgmp3riEMTtlJ6ePjnS+zHZaqHYFqkBg61i+LUjT8vT0yX
         0aFpRQzdhdiMFqLC0g8cGKUzYmQ+6Uvp5324tCxg7MgufCsg5COzkVbUDxigOpidKyj0
         DfE61GhP1X/GTu1+yxXuVjsqsxs+5CW7o4mkpLeONuCCNft/BESAatIMWgCmnsIdnmvl
         aR9+WJswy89YDIvJ/HT1wB296lsOy7zulRpyVy1u04f604IifYk4496HUh8S5UOkGiKq
         VXJ4JzhBsS2k6HdiksLiL0UqPD8JZjTSwUNnY9Td8DpldjOrRbnm7CLOtyewUJAz7VnE
         QFeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gchpafLKJ6F6uOATukxao5S0fzx1QuO5gM2w3naYObs=;
        b=sFIS2bsK1lB4Dhj2KB3O0wPWiL4x2H19aW+E0nsiU96Hj8FQ/oJbWkxk+7v3AeEb2x
         yGL0XMBkA9XzMOsh1ZHoA3yVrWhGy4qFxNIlHtXdyapTlQaBTIALJ6jaV49u7/Zyadsx
         1vZfvmmTYk/1cFqw8sW8Cl+3ACTHctenTU4qy6Iri+pUwYaohhfBDSvySqn1H4EymmzG
         ZsEJnRAKY95WR2JiOVTu12TBdazJHnf3c0oT3ys4SDnxS4YnR4fpdQTlfqtLLyUbdut5
         XHI8C/oSEcOnxt9v7/IGLCKiBC2A+H/cFDODCe9br9MgZC5+Nl4DGDft75hsLwaV9zqN
         U+6Q==
X-Gm-Message-State: AOAM530BW0V0xUs/EKHrAlTPddW3UjjZyfLJEMJpD076DYDXkFSyf7ki
        9xOduLHEOnsEyslcUr0gQqPoOKW/opZoWVYQKEglPg==
X-Google-Smtp-Source: ABdhPJxkQvzCyua+2YCHkeNe+i/7cmwbKWtNkqHYzH1bZ1etsu2/XFklrkSEo8/9k2tD2Ih4LDt8IMgD4M2z0xhIp6w=
X-Received: by 2002:a05:620a:15b:: with SMTP id e27mr19426423qkn.501.1622632869281;
 Wed, 02 Jun 2021 04:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c98d7205ae300144@google.com> <0000000000003e409f05c3c5f190@google.com>
 <YLdo77SkmGLgPUBi@casper.infradead.org>
In-Reply-To: <YLdo77SkmGLgPUBi@casper.infradead.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 2 Jun 2021 13:20:57 +0200
Message-ID: <CACT4Y+YUa41KMCO3n9WSvsbLqXo=F5nxpnoYWyiyB=AFWZ-KVA@mail.gmail.com>
Subject: Re: [syzbot] WARNING in idr_get_next
To:     Matthew Wilcox <willy@infradead.org>
Cc:     syzbot <syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com>,
        anmol.karan123@gmail.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        dsahern@kernel.org, Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Necip Fazil Yildiran <necip@google.com>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 2, 2021 at 1:19 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> #syz fixed qrtr: Convert qrtr_ports from IDR to XArray

This would be:

#syz fix: qrtr: Convert qrtr_ports from IDR to XArray

Thanks for looking up the proper fix.


> On Wed, Jun 02, 2021 at 03:30:06AM -0700, syzbot wrote:
> > syzbot suspects this issue was fixed by commit:
> >
> > commit 43016d02cf6e46edfc4696452251d34bba0c0435
> > Author: Florian Westphal <fw@strlen.de>
> > Date:   Mon May 3 11:51:15 2021 +0000
>
> Your bisect went astray.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/YLdo77SkmGLgPUBi%40casper.infradead.org.
