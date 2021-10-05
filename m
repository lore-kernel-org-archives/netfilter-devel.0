Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D8DC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 16:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 018CE61381
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 16:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbhJEQt2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Oct 2021 12:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236667AbhJEQt2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Oct 2021 12:49:28 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BADC061749
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Oct 2021 09:47:37 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id n8so32180450lfk.6
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Oct 2021 09:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eLZ4fUPrQrbt7FIi8eh6e+j83DwiHUC8faRiqF4uPzs=;
        b=Sx/egy7EF/hE71/yLc5iCclMS1KXr0PsI3iiyddcxXDm2B0Fxf8mgNzYhQ2YN7zBBO
         /4+9Kcm3Z11rJyATI53bYBVYHhIMcqzuKTHZLXoJBScRA6Yo3U68Qhd6c/SYBgRtmj6W
         xEbTJ6zX5RaesGntJeEEsVug181hbwk/vJhRE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eLZ4fUPrQrbt7FIi8eh6e+j83DwiHUC8faRiqF4uPzs=;
        b=G6LVXzV8EdUcgQ3/O+NfvxZ8YSBq0s+aKWd78etVT5zX2lmE9LuLsXxV6OJIWKYKuT
         zOjcGkl4ilYRXmNs2VEi959XYlQeHRPP1npdohSRW8rju7bJUH5Ekw83xSs1eRYipJUk
         9eo+G9WysdIwD6XTO+fuzFIkDPu6f4rw4iJZ/H+lJYCbDWHpJDxdNAa2IhAk6jaD7Z1r
         ku7ooc/60lTyDol+0iIRENkFwuy1+7PDtjrmzuz6RQ70AbvU30FgJBe2Z3EaBm7peotY
         zmLr8zecN8wUrkXcingXdNurPuZCMX+Z4Na2dXvdprUyQxdSv7H8oo7uk4LFjRchPSK1
         Y5Nw==
X-Gm-Message-State: AOAM533X035LPDLUXqxlolE4cjzi6BKjfX8tzSKiQsT1xKOZ0r3sXomi
        q0V9l+Gm9VPinn2pjSlL8jG7E0WvlCCoJWQS
X-Google-Smtp-Source: ABdhPJwf9UmdKC1Jac7n9i8njk5+e4cWlLYhBhbzvNfCniuwcytKHvhGb0kkmtkFKGtZ9RjcvCPrHQ==
X-Received: by 2002:ac2:5d23:: with SMTP id i3mr4608276lfb.477.1633452449049;
        Tue, 05 Oct 2021 09:47:29 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id u25sm2009659lfc.176.2021.10.05.09.47.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:47:27 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id b20so89616595lfv.3
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Oct 2021 09:47:26 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:: with SMTP id p4mr4519659lfg.280.1633452446149;
 Tue, 05 Oct 2021 09:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211005094728.203ecef2@gandalf.local.home> <CAHk-=wj0AJAv9o2sW7ReCFRaD+TatSiLMYjK=FzG9-X=q5ZWwA@mail.gmail.com>
 <20211005123729.6adf304b@gandalf.local.home>
In-Reply-To: <20211005123729.6adf304b@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Oct 2021 09:47:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg8duLUhR4duN2fNWRF73oGufZNMyvyF5Twp9FnqXmq+g@mail.gmail.com>
Message-ID: <CAHk-=wg8duLUhR4duN2fNWRF73oGufZNMyvyF5Twp9FnqXmq+g@mail.gmail.com>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 5, 2021 at 9:37 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Oh well, it was a fun exercise. Too bad we failed due to inconsistencies in
> compilers :-(

I'm admittedly surprised that something like this would be a
"different compiler versions" issue. But "typeof()" isn't exactly
standard C, so the fact that some version of gcc did something
slightly different is annoying but I guess not _that_ surprising.

Oh well indeed,

           Linus
