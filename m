Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82C8C433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 22:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EB4061178
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 22:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhDBWvI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 18:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhDBWvH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 18:51:07 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDADC0613E6
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Apr 2021 15:51:05 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id u29so3358459vsi.12
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Apr 2021 15:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GUO6eNuNOaxH9KjFmDuRE0Nu3fXuEsSQBh73oLOU+dw=;
        b=iaEKmsDp2u04ZP56vPNQAoGm98HAIy5ZLKrsW6xMbzryUO7HCd3JeVjU4+BU+Vdvy1
         atKVARlLmckk76x+fKg2EF+8tB0dqG4gKH0Pnxbr9BCWyKFJMQTsK6ZNdHF9/HyVrCo0
         3yGJOk2qgAnnILFCQXImYc59M9d9AQ0CQEAgv3YBrzhp3hB1uhOAa208c4+3amvOavt9
         ooDW4pwLC1a2gVf9B8h9ECpl/KzjxuUKjPQISIPaJhAJbdGiDjMVGp4B3BqJ/KaKKPfe
         E4XfqyzdV8/QMMWrBlsIfEnvvwSJi99ckzyXL6hCTj2OvGqjGAYF9UZTUdN4BpF+nJLu
         wXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GUO6eNuNOaxH9KjFmDuRE0Nu3fXuEsSQBh73oLOU+dw=;
        b=b8Z72oXftPKjhsGeXNPC7n526tJlIBX8vIe4TjSvUwjFsC3NdVFRd5cfII/RNfu57M
         FzpsdE7PfgkXm/VkIBxoMHfkROwmdhhcn1gCJ0q5a2mvdOKkoY4KvK9IPcGEzp0RSt9Y
         DX982/4bbaoFre61z91wU4c3k1MyWduBqwBLjhlXlrOPpcOs7xizb0XhnHrw5R+Xa6cu
         ujswxXoPO0U3VqojbrAnwf21he5494fUFOYAtqff7EoJux1P84SpKCGZd59ovfyhRQtT
         asw2RmIi0UAJKDRr+G+Jku9+9EEkE2bI+06ynKSG6Zi95yMehAVeeigWLbH4Gfkx0vko
         cIQA==
X-Gm-Message-State: AOAM530vdfq3FFPc9AZVUwYTNvjNCkESzKzjPMlgGCMf+iHxlq1q50kn
        CmMLiYjO22hPpatm8iJocq5gph1gj6gkYoNbrYME8DHCr+A=
X-Google-Smtp-Source: ABdhPJwcA/lo/UwwGMwuW3K4Uho/14c6H+v26M+FHUmGqEgVkc/BKAnToW+M+WsAhRBjg+mkIgdTVuau29DgPzA8DeI=
X-Received: by 2002:a67:7282:: with SMTP id n124mr10271737vsc.39.1617403864187;
 Fri, 02 Apr 2021 15:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210402201156.2789453-1-zenczykowski@gmail.com> <20210402214049.GL13699@breakpoint.cc>
In-Reply-To: <20210402214049.GL13699@breakpoint.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 2 Apr 2021 15:50:52 -0700
Message-ID: <CANP3RGcB4SvNFjsHEhH20dP+hNTQ6GE9ZgpWVyPeFv7fgbJHog@mail.gmail.com>
Subject: Re: [PATCH netfilter] netfilter: xt_IDLETIMER: fix
 idletimer_tg_helper non-kosher casts
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> > The code is relying on the identical layout of the beginning
> > of the v0 and v1 structs, but this can easily lead to code bugs
> > if one were to try to extend this further...
>
> What is the concern?  These structs are part of ABI, they
> cannot be changed.

That is a reasonable point, but there should have at *least* been
a solid comment about why this sort of cast is safe.
