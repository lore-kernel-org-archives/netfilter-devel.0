Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D86C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 16:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20575613D5
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 16:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhJEQUT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Oct 2021 12:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbhJEQUT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Oct 2021 12:20:19 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C33C06174E
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Oct 2021 09:18:28 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y23so49166846lfb.0
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Oct 2021 09:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9pR87ZxffODNYHX3y8wIUUlOXsoFep7W3KkITUWQQdA=;
        b=TpNQeD0xD3/3W2Huts2s1yHnNDHO08/TvqGsxKknqz53fnCGeGEUqEVbfpYl1NdwF4
         xJpyZzE3P+DphdGWSaAERkfy6zE0yQxVQJzxFtwf2PG26X4bXpACjDTFkKxp99R+RSkM
         OtWyX3w8eTxmkzyy/0NhGAMfrer3tnjCwq++I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9pR87ZxffODNYHX3y8wIUUlOXsoFep7W3KkITUWQQdA=;
        b=z0/ySIOPO+gWd/RkvgyyAHKlv9PB9Px9kJvQMUtrsqGj1EV9B1urHxfCCLahVH4YMi
         G7CVOyFu69SwmIGK5Bg2QXttWPW2SxGhyu950jt/y6En/2M/1nujAQBdW7JCBKnrF1Jj
         ELVUjPLBkP3lTia1hxZuGPo1R3SiDo9o4mxInoKnncHvpoGOxcrsLQ+LwdEQXWSjOvLS
         sv8aGZEG7gnlCSb1FZG9+WAv9o5G7+f/8Dr+vom3Cgc/CvZ7mYCHs/g61vIGkyfIek3c
         Fa+ZmfY54tUHtp+/ZXt1ZkluLvHSSw55Sdbw7jSfupj3D/zQmQVz9L78tmOK/vRTOzwn
         CWOw==
X-Gm-Message-State: AOAM531VE+rkWONEkiZUGzUHdGDFOcwuujg7L5sVknif30VwQELIRRCH
        W8wHgumoaeIqOENUp+8bN74C6KhDw9/Iw4Sm
X-Google-Smtp-Source: ABdhPJwBxyhHrI8NrWMRRn+JpebEHrCxH5ulSvB3tSNmPgyTVRK9esWJC99PegtyqJfWhdWtGuozow==
X-Received: by 2002:a05:6512:15a9:: with SMTP id bp41mr4422945lfb.479.1633450706038;
        Tue, 05 Oct 2021 09:18:26 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id d1sm1993677lfj.61.2021.10.05.09.18.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:18:23 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id g41so88215261lfv.1
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Oct 2021 09:18:21 -0700 (PDT)
X-Received: by 2002:a05:6512:b8e:: with SMTP id b14mr4429467lfv.655.1633450701008;
 Tue, 05 Oct 2021 09:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211005094728.203ecef2@gandalf.local.home>
In-Reply-To: <20211005094728.203ecef2@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Oct 2021 09:18:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj0AJAv9o2sW7ReCFRaD+TatSiLMYjK=FzG9-X=q5ZWwA@mail.gmail.com>
Message-ID: <CAHk-=wj0AJAv9o2sW7ReCFRaD+TatSiLMYjK=FzG9-X=q5ZWwA@mail.gmail.com>
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

On Tue, Oct 5, 2021 at 6:47 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Also had to update a lot of the function pointer initialization in the
> networking code, as a function address must be passed as an argument in
> RCU_INIT_POINTER() and not just the function name, otherwise the following
> error occurs:

Ugh.

I think this is a sign of why we did it the way we did with that odd
"typeof(*p)*" thing in the first place.

The thing is, in any normal C, the function name should just stand in
for the pointer to the function, so having to add a '&' to get the
function pointer is somehow odd..

So I think you should just expose your type to anybody who uses a pointer to it.

               Linus
