Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD33C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 19:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CB1E61371
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 19:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhJETsz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Oct 2021 15:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbhJETsx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Oct 2021 15:48:53 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B2EC061749
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Oct 2021 12:47:02 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id y26so473857lfa.11
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Oct 2021 12:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ugWGt9Pg5upI+OifuSoHCXw7NKwxQ1vrKgVTrc521LA=;
        b=T7PyJHg80nfkPUQJ7wSKYwTRhSmMLdv+QAUUhPStrfcNo/FY2KObTGqH8VI91mm2de
         in0tGoxNF7Pfx7awFKAakx9kDhOZoB9oYhggSaw/Q0JWtGGgV/+n3HELHjYLUkWJV3N/
         5K95Wh43Bw4IeM9lQCzUeqH0Sb/e/rUuWf6Eo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ugWGt9Pg5upI+OifuSoHCXw7NKwxQ1vrKgVTrc521LA=;
        b=0jXQQqlPXovHLzU9E4QdlnVAvu+SafR1CzofnpHynu+zSObw5CD1A1zeC7DfMs1W7D
         eLFdghGdsGouif5T8dFvG12pBXI+YVOGVLj9EG/kbVqRXG4i+1qjbRcMXcHrZYe2PcZ6
         gwv7rthoRJOpJ1Lo0rqFr0f+bPuBg67fAZxZarhNuQmJdQv2jUBGCKVoijytLjDOmFI4
         SJDlQdpvoQfGFeyyOZOhOtDWMBPBSwidX1GSB9PjVNrHOcaf10CMQ/x1qhowJxqScifD
         dpCpshFbfWrMPy9vkxfetXhbqjlBa7X02jHrONVB+IDZOmlmwQ6jgES/2LwYdJLABMem
         Qaxw==
X-Gm-Message-State: AOAM532Utx+HV28Rc5JWi+1LnllkAc0h4YLxt+Yr90PRukOJCy9hz90f
        zgjIgDtG4fzEsOWPpQkmaWFgcHJkMOYhTDK14z4=
X-Google-Smtp-Source: ABdhPJyDzS53eSpErewHX4joeEdHAGb8NDSqB8V+cfzRptL6hOwfC4t8/6KIBkHSKkhqmpmgVLnAwg==
X-Received: by 2002:a05:651c:a12:: with SMTP id k18mr21830936ljq.449.1633463220618;
        Tue, 05 Oct 2021 12:47:00 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id l23sm2216279ljg.99.2021.10.05.12.47.00
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 12:47:00 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id i4so624727lfv.4
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Oct 2021 12:47:00 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:: with SMTP id p4mr5337511lfg.280.1633463219864;
 Tue, 05 Oct 2021 12:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211005094728.203ecef2@gandalf.local.home> <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
 <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
 <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr> <20211005144002.34008ea0@gandalf.local.home>
 <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr> <20211005154029.46f9c596@gandalf.local.home>
In-Reply-To: <20211005154029.46f9c596@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Oct 2021 12:46:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiL+wyCOTedh48Oz0cNOKJq2GNwtxg6423hf-1FuGrv_A@mail.gmail.com>
Message-ID: <CAHk-=wiL+wyCOTedh48Oz0cNOKJq2GNwtxg6423hf-1FuGrv_A@mail.gmail.com>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 5, 2021 at 12:40 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I may try it, because exposing the structure I want to hide, is pulling out
> a lot of other crap with it :-p

One option is just "don't do rcu_access of a pointer that you're not
supposed to touch in a file that isn't supposed to touch it".

IOW, why are you doing that

     pid_list = rcu_dereference_sched(tr->function_pids);

in a place that isn't supposed to look at the pid_list in the first place?

Yeah, yeah, I see how you just pass it to trace_ignore_this_task() as
an argument, but maybe the real fix is to just pass that trace_array
pointer instead?

IOW, if you want to keep that structure private, maybe you really just
shouldn't have non-private users of it randomly doing RCU lookups of
it?

                  Linus
