Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A119C64E7C
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0DE3221FB
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgLBWfd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 17:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgLBWfd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 17:35:33 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B6FC0617A6
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 14:34:53 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id o4so180209pgj.0
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Dec 2020 14:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yj9uJKclERcz+3dgssLnxEsO561b5XP4e0V1kaqzzHU=;
        b=DeLWj512JCeqOATOifyLs3tV6W2ShtE1ozKCsCMSU6b/dQCrePNDDDeloHg6HKDTOn
         1tXXfhZpOM/qfpu/4uKGDZMdpt5+G1ACRIweOcs/IRUi1XkMbPofQLszlPUQOXU20LIa
         Mx+8bJ0ThXdxQoCDmjayo7oGrdsQBjuo4jxBM5pE5LAc9xLqX+4aelFrlcETUey4cPYf
         hmyloKX82XTEqwlYl+6VSFyn/0LCFwvTILiXeQeA3DO6PpzpRTalSglVTGDaojWaoh6w
         +nrj9HgM0DemgHvCXLIJZAWbPpx3SFiT199P0bSAaXdge0N4Jj5mWI0x97sLV553ptbE
         h3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yj9uJKclERcz+3dgssLnxEsO561b5XP4e0V1kaqzzHU=;
        b=q+rPzD2136m3Fsr1pd9u4IxnSWsuiUBtLfEQrF6mcSzU0ym5eZfewOoiL2Bheip814
         K2+Uq35xg1qcsXhccaDWnq9cB9BJ/RrllgbEyND6E2eiNvwD3uvW5jFxnUI3J5MkhnDS
         Cul6+LhNLeoEBkxF2XZTgDCOy/36lcfIAJ2uGf8UyZKq1uG2U7vGpbU9QV0a90ccp/wy
         8/sH8DBrnMJ6GvUDw/xqFdQqa5XKQ9ep9L7VzBBi8NC6dkjit5L9+YT7qZxS8/m4s86r
         WsAiGSAbYP6+NbYtSdAYI+8GZGd0mwkTRTM5rN3zz0fs6rZ4PkW830knCIouCTWZCJe4
         P3vw==
X-Gm-Message-State: AOAM533rxoWTgF9YhejGcL1U5p/q2Msw7/QEhdSz1fh4aPlqtbwYd0HV
        J/7ULUwA5h3wLUXgCVXkj8fB9+taxiP3kUcXn7oP1w==
X-Google-Smtp-Source: ABdhPJwk9EgW3Fj29T0FZY+jliaMst7k9i/OfQ+jUCLl2350gsCT+2SSH1KV/nTldfxvpeHL5TQcjXv3gozBbabP5u4=
X-Received: by 2002:a63:3247:: with SMTP id y68mr437000pgy.10.1606948492350;
 Wed, 02 Dec 2020 14:34:52 -0800 (PST)
MIME-Version: 1.0
References: <20201107075550.2244055-1-ndesaulniers@google.com>
 <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
 <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com> <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
In-Reply-To: <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 2 Dec 2020 14:34:40 -0800
Message-ID: <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
To:     Joe Perches <joe@perches.com>, Tom Rix <trix@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
>
> > Yeah, we could go through and remove %h and %hh to solve this, too, right?
>
> Yup.
>
> I think one of the checkpatch improvement mentees is adding
> some suggestion and I hope an automated fix mechanism for that.
>
> https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/

+ Tom, who's been looking at leveraging clang-tidy to automate such
treewide mechanical changes.
ex. https://reviews.llvm.org/D91789

See also commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging
use of unnecessary %h[xudi] and %hh[xudi]") for a concise summary of
related context.
-- 
Thanks,
~Nick Desaulniers
