Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4175C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 20:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiBVUHo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 15:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbiBVUHn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 15:07:43 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0869B54D6
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 12:07:17 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j2so43751769ybu.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 12:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AjnaX+96lqe7LijU9Rl3ogEW4Pg0WWxDUtU2eg0y22Q=;
        b=QuoRQZ9xGDd3kLv1UUcnSJ9VydU7KPF/+yLCDpnbT/rhn9N5skeK0Uwk/vTAPcHOF6
         dggaAIrCWnQ+DQNgV/C0wa1ceLRh7yja3OlPfN2nFrH0aO9CoZh004ZvMl02D02FNWOx
         BQa7fX3eh+iN7b4FB+vR3WV8O91Shcs/uUeTws3cwD0GajmB7X9SBLxxVJMe33vwC2kS
         I9FMIr67qG4hJjpCnnk4V/YL6rb0sPZgceIt4EQdY7FQfV4fOlBsQu8B+d2CE6XHPIsn
         YKR9VGOaNlmQPb5V4m9O57OavxUaYnY9A8fQo4OpAO2jDVQhTrv8Eg/9sPuMCjKrNuMc
         E2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AjnaX+96lqe7LijU9Rl3ogEW4Pg0WWxDUtU2eg0y22Q=;
        b=yi93fW0FjkPS16q1DkCPAF8v5o/ZoLi4tXRqqWdzoYYoag/BHFWEomNDU2qvOh6NZz
         5AIw6zHvHzFqikK3T6ur3jSwMNcZXlu4le32W0FPBPyiPcvbRZmDXWxku68auFEmBrIz
         7eJWSDwqT2p8qEL9AjN3L4SU4cBmuq3CxhN6qbRtclOTFfXWGWh/J+GCa1g0uoHhq+w8
         G6iAWJF3leQqPuFCIQQU0/B+7xaPBbn8615HT7ocrQ9AUl3bWndU2TRR710LBUYlby1G
         ssXCqGIE1obUjV6jDfx/T7BmqWFaj/oAgVxBxNcmCP46jFMtfsOSzuutBCS/L+cvzMBD
         8afg==
X-Gm-Message-State: AOAM533+hI6TJDmG3HaPLmNLMrrfjPLB1yvevd/i4fCYG/XTZqEfRpmt
        +ec+oFUGtYyRx5wStna2r5JMsldL3t+eegpTrb9GLGxqdUb2msp6q+I=
X-Google-Smtp-Source: ABdhPJwMkyFR0SUCG3KBZfZtk+rrGhU5lYfT5M5/nEf1SdaEERKaPV5W4dz9u31w/k5niv2/ZjHpFspIWGGLvAfupWs=
X-Received: by 2002:a25:f441:0:b0:611:4f60:aab1 with SMTP id
 p1-20020a25f441000000b006114f60aab1mr25228544ybe.598.1645560436619; Tue, 22
 Feb 2022 12:07:16 -0800 (PST)
MIME-Version: 1.0
References: <20220222181331.811085-1-eric.dumazet@gmail.com> <20220222194605.GA28705@breakpoint.cc>
In-Reply-To: <20220222194605.GA28705@breakpoint.cc>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Feb 2022 12:07:05 -0800
Message-ID: <CANn89iLz4yML_RktHUadAkU966h9QCRJQ=cMPVzUDU7dHXg0sw@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant
To:     Florian Westphal <fw@strlen.de>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 11:46 AM Florian Westphal <fw@strlen.de> wrote:
>
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > While kfree_rcu(ptr) _is_ supported, it has some limitations.
> >
> > Given that 99.99% of kfree_rcu() users [1] use the legacy
> > two parameters variant, and @catchall objects do have an rcu head,
> > simply use it.
> >
> > Choice of kfree_rcu(ptr) variant was probably not intentional.
>
> In case someone wondered, this causes expensive
> sycnhronize_rcu + kfree for each removal operation.

This fallback to synchronize_rcu() only happens if kvfree_call_rcu() has been
unable to allocate a new block of memory.

But yes, I guess I would add a Fixes: tag, because we can easily avoid
this potential issue.

Pablo, if not too late:

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")

>
> Reviewed-by: Florian Westphal <fw@strlen.de>
>
