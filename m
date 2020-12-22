Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C30C433E6
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Dec 2020 22:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47E6220855
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Dec 2020 22:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgLVWa5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 17:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgLVWa4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 17:30:56 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1BFC0613D3
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2020 14:30:16 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id o19so35685523lfo.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2020 14:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vjYFPjk7rgVuqAwGx+B/otvJ3LuNwvpN2FEt46eyObc=;
        b=amvUI7K4WAcLJ9tnS+LAQ/n1NuF8P0UHe7+AYMNPMZnlv7fJUTNx6E64RbgvlZ8Owe
         TJ2z8GKkZYGOSNicckNAcD9zOIvW/TqKNSMHTQvnPxXGufSRr4imYMXgwJdUYT5XGD2N
         NiKRNsdPVxPuEYBGxfX557J2zseQwqgqzGg3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vjYFPjk7rgVuqAwGx+B/otvJ3LuNwvpN2FEt46eyObc=;
        b=jnLSS+t7wlfR03mAkET43AvCEIAWDUUwyvmMWsLNc5bqehUTNgN28bk8tFMbSsZDER
         lRIUf3tMy9yBSLNX7rtHsdtLqYeLaVXvAXUnv3M5QelQxBkQGlzEnxWGt0bFUbbvnxMr
         bQq4pJqIcb3nKKvycTLJHtLDsXU4Enk9it8GA1/EwFNFO6Ygka0tFHl+5NVIhvP6xPIQ
         o4O3d2vTExkVRE3/bet5+gV0ylzOEnnDFsBNOe/w52u889EWb+55eEeomdpvhKKNN5Bv
         6iWhE+yTdUJKtqsEChJMr1aO90Keb02GACwrbJawKwD9EgNamF3iOm2PO5B91jxBbK16
         Rhbw==
X-Gm-Message-State: AOAM532mAJKPjq1sv7Dw3lyuaPQAIBy4INwzv0sStHHbyN0R7fBWH51Q
        Wk5x4ww6yPgg6JXWoZUc7eJm14y3+/10Vg==
X-Google-Smtp-Source: ABdhPJx2NA/SNgQr4UNtMzkbsrE7cLPwiACSD10oKp2FpZmrFhQQwcwoI/ot033PRF5lgkc3XeLJgw==
X-Received: by 2002:a2e:b4ab:: with SMTP id q11mr10267440ljm.129.1608676214513;
        Tue, 22 Dec 2020 14:30:14 -0800 (PST)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id i25sm1881549lfl.157.2020.12.22.14.30.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 14:30:13 -0800 (PST)
Received: by mail-lf1-f47.google.com with SMTP id a12so35623214lfl.6
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2020 14:30:13 -0800 (PST)
X-Received: by 2002:a05:6512:789:: with SMTP id x9mr9144963lfr.487.1608676213222;
 Tue, 22 Dec 2020 14:30:13 -0800 (PST)
MIME-Version: 1.0
References: <000000000000fcbe0705b70e9bd9@google.com> <20201222222356.22645-1-fw@strlen.de>
In-Reply-To: <20201222222356.22645-1-fw@strlen.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Dec 2020 14:29:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjB83CZvzp88Axc278L+uSKEdztA9OO7kjx64R7Y9n31A@mail.gmail.com>
Message-ID: <CAHk-=wjB83CZvzp88Axc278L+uSKEdztA9OO7kjx64R7Y9n31A@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: xt_RATEEST: reject non-null terminated
 string from userspace
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 22, 2020 at 2:24 PM Florian Westphal <fw@strlen.de> wrote:
>
> strlcpy assumes src is a c-string. Check info->name before its used.

If strlcpy is the only problem, then the fix is to use strscpy(),
which doesn't have the design mistake that strlcpy has.

Of course, if the size limit of the source and the destination differ
(ie if you really want to limit the source to one thing, and the
destination to another - there are in theory valid cases where that
happens), then there are no useful helper functions for that.

                Linus
