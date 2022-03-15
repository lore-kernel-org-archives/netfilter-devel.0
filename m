Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA44CC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 13:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348820AbiCONwN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346656AbiCONwN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 09:52:13 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6179B53701
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:51:01 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r10so29114309wrp.3
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b7LM1DXYedFuJOJ24/L5NrLERam0ji6Ap0KjIFG/Crg=;
        b=Sf7ebGl3+BDHJMtYFvQc0qOytkXryq/q9/B42BbBv/16uuBUNpIpS6gLEcv/MgAQXO
         x17odGlHc8vAn3bYlDXKYaOdKXvz9OuNcsiREZKogzCP1txyIopubm5rFQpxCU/3m6zK
         r2c9UlRG0YUpb2YyFAUHKm71YCTF4h7t00/Dg2W30p8DBWs3j8EXjvLnE0dD31OS0fne
         27qFr6LK+M/13vYbLjfE4vFhovPhawEPPgf1j6uP3LFWLnPXmTls9qmzvJ6mi7+sETXh
         hhkdvjP6zlP3eUbpMj8NUJAtBeX8aAo+cCGe6/ALQC/LaJb4VGMAxBtkcD0FJKnMpJnI
         0wNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b7LM1DXYedFuJOJ24/L5NrLERam0ji6Ap0KjIFG/Crg=;
        b=AY9cD+HOwuYemn2fH9C8gGtxeL50JTdWQw/g6sNT+zZudvFZDMJ6s8HIBU1/oyAxTR
         TbMCOvoiTM/IW0UXrjDEN3/dYrljfpJFP4s/jBapgXlxF9xQJV7KiKgTKOWyuCzrIsIR
         3rCZwyI4DTgcCGIGPhOm6DVizM9dl/uWOfZ9HA3TAVn/KRvIfoVU3PouMCTzlG0zwtSb
         pnM2J7uJVMWoze86LS/po2SnqDtwXFK/SQfX3mDvekIsNAFXrZeMRo2Lh+XtyJY9XSy4
         MfMMWCb/v0i/w63Zi4J3UL8raY3j7UN8yHEYY5TyCsvueQybuN0SV6cUshTT+0luhBK5
         CngA==
X-Gm-Message-State: AOAM532At6/3o7FYPcyk/vnglRje4k9X/8EyK5Tqdhlg6naGQ/BD3tTS
        EsoZs2iCCVUv8O6M/3klTv/PUebc82hoxPghnC8=
X-Google-Smtp-Source: ABdhPJzXxBGzw9RRUd6ki5XDnNEWaPnryQQsxMZIkwcl9IwAobfghCxHKQIeGYLTQzLJnQ6yY3zyvpMLQM7P63UjERc=
X-Received: by 2002:a5d:522b:0:b0:203:d9bc:fbe5 with SMTP id
 i11-20020a5d522b000000b00203d9bcfbe5mr1139163wra.68.1647352259897; Tue, 15
 Mar 2022 06:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220315132619.20256-1-phil@nwl.cc> <20220315132619.20256-4-phil@nwl.cc>
In-Reply-To: <20220315132619.20256-4-phil@nwl.cc>
From:   Etienne Champetier <champetier.etienne@gmail.com>
Date:   Tue, 15 Mar 2022 09:50:23 -0400
Message-ID: <CAOdf3godg+_2hbwxdaodjDnR9a4fZ129GnsjQNON6wcDY01uqQ@mail.gmail.com>
Subject: Re: [iptables PATCH 3/5] xtables: Call init_extensions{,a,b}() for
 static builds
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Phil,

Le mar. 15 mars 2022 =C3=A0 09:26, Phil Sutter <phil@nwl.cc> a =C3=A9crit :
>
> From: Etienne <champetier.etienne@gmail.com>

I messed up the git config on the system I generated my patch,
Signed-off-by and From should "Etienne Champetier"

> Add calls to arp- and ebtables-specific extension loaders where missing.
> Also consistently call init_extensions() for them, as some extensions
> (ebtables 'limit' and arptables 'CLASSIFY' and 'MARK') live in libxt_*
> files.
>
> Signed-off-by: Etienne <champetier.etienne@gmail.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since nfbz:
> - rebased onto previous commit
> - avoid mixing declaration and code in xtables_save_main()
> - add a more descriptive commit message
> ---
>  iptables/xtables-arp.c        |  1 +
>  iptables/xtables-eb.c         |  1 +
>  iptables/xtables-monitor.c    |  2 ++
>  iptables/xtables-restore.c    |  5 +++++
>  iptables/xtables-save.c       |  4 ++++
>  iptables/xtables-standalone.c |  5 +++++
>  iptables/xtables-translate.c  | 11 ++++++++---
>  7 files changed, 26 insertions(+), 3 deletions(-)
>
> ...
