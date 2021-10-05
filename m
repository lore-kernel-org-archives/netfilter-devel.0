Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E69FC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 21:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6877C61159
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 21:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbhJEVaE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Oct 2021 17:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236719AbhJEVaB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Oct 2021 17:30:01 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64DCC061749
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Oct 2021 14:28:09 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id u18so1468331lfd.12
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Oct 2021 14:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K7jQ1mmWi2XBmpgAPcJ8NJOBcFNqeNIIIqJq69SJlXI=;
        b=aqmi0VcnQ1JDOG+62KHNkPCW9psm3Gc6I0WmwAmeqOHaqPxliahcaOEbptUWdB27P7
         TVvOUr1XDPRcbTiUrvwEYTrrA6U7YHnWyjQWHv9VYsTcw+eKDp1YRbSzqXp42CGdFQm/
         dlspqoxgRfSifvqYNBCP8cB8iMfjHRGMisfOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K7jQ1mmWi2XBmpgAPcJ8NJOBcFNqeNIIIqJq69SJlXI=;
        b=MZdcwPFg5uC2O8EuUSmiBcQS2VcrWVB8vmLHCxFqaxZarpgtJEiF6XQoc95gjWNOKP
         GGiNvW6f3O8QnnVieVQWdEkBoq9E6SnaqHcYIRiSN/eq9HtCazdf+aGPpB0/cRi/j+QM
         5eXBC3u4mZxBsryd8aZTgtVW0dxYt2ZbsYaTe/pfK8/MEj4DfMSOSX6zeRZALCcs8Yab
         7BG5iVl4WuzG9laUd9AJttpPSZTbHhyGfYMupxRjmnFTeXhX8RnGr30h3UcVO3O9/feg
         fSn/DQFJjM9VCXuJ5THJDnlctxwtPHYW4nLEGjJbxyAA0U4nhChM6S/stI5FewJfIkgm
         T6zA==
X-Gm-Message-State: AOAM533R4NIKygquLEhwJVVS34jVuBkkWhvB/XpniX7XZW8hZsyUq6Vb
        bYcLjdOwchGK7xxTMW/8akgVCkNOeJxOAvqVCuk=
X-Google-Smtp-Source: ABdhPJz55Csm2Hmb6+8aoajgxc7savW5WIQIYQfdMmCi7bMhZzvc90S7eFBGt/8VfDiC85tP7Jv31Q==
X-Received: by 2002:a2e:5cc6:: with SMTP id q189mr23812246ljb.82.1633469287728;
        Tue, 05 Oct 2021 14:28:07 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id d19sm2078341lfv.74.2021.10.05.14.28.06
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 14:28:07 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id n8so1577097lfk.6
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Oct 2021 14:28:06 -0700 (PDT)
X-Received: by 2002:a2e:5815:: with SMTP id m21mr24761572ljb.95.1633469286442;
 Tue, 05 Oct 2021 14:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211005094728.203ecef2@gandalf.local.home> <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
 <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
 <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr> <20211005144002.34008ea0@gandalf.local.home>
 <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr> <20211005154029.46f9c596@gandalf.local.home>
 <20211005163754.66552fb3@gandalf.local.home> <pn2qp6r2-238q-rs8n-p8n0-9s37sr614123@vanv.qr>
In-Reply-To: <pn2qp6r2-238q-rs8n-p8n0-9s37sr614123@vanv.qr>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Oct 2021 14:27:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whFhTofNk5G6dYFoFJC10EKzGdZVQdQygXHXWm_jodwBQ@mail.gmail.com>
Message-ID: <CAHk-=whFhTofNk5G6dYFoFJC10EKzGdZVQdQygXHXWm_jodwBQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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

On Tue, Oct 5, 2021 at 2:09 PM Jan Engelhardt <jengelh@inai.de> wrote:
>
> Illegal.
> https://en.cppreference.com/w/c/language/conversion
> subsection "Pointer conversion"
> "No other guarantees are offered"

Well, we happily end up casting pointers to 'unsigned long' and back,
and doing bit games on the low bits of a pointer value.

So it's not like the kernel deeply cares about theoretical portability.

But I do discourage casting when not required, just because as much
static type checking we can possibly have is good when we can do it.

              Linus
