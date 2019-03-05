Return-Path: <SRS0=Q+IM=RI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02028C43381
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Mar 2019 08:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3CCD206DD
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Mar 2019 08:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vHJfps1y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfCEIXm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:23:42 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:52577 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfCEIXm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 03:23:42 -0500
Received: by mail-it1-f193.google.com with SMTP id g17so2937283ita.2
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Mar 2019 00:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G0YBZ24VUDqnzCInxvNY/uc8SPKs0E0RDSq5IkaIrSo=;
        b=vHJfps1yeLi2OAzGJp2JbWLnOj1SQFcYOZPdAVKVJM5M9lq2k91PQB0tqH622C/Xwy
         s21DhURFzIkm0eutxmXR/tYXCOou47w3AgdiIxT1IhH+1joHuLAFzZTDhlQ0itIZzHQw
         jUjIilPs0E7sCN/b2EXqSqA8EFriHfO1PapUiKQjrOJLWTnTGveMegaaG/azI6b9ulZp
         yUkz2K3a9VcDvka49ew/wBNEZbpatGKiM0qGdCnpLFYGjDaOG5maZx9Qrq+jd6y2PtmK
         SjZ1OGvtzu0ILgoJFEf2BJGfNw3xOre6dW09ijC31mAVzZQrGJxr1CJcT+BK/xpuYpmJ
         OK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G0YBZ24VUDqnzCInxvNY/uc8SPKs0E0RDSq5IkaIrSo=;
        b=Vk1fCXcdaw1hVfYID+N/UNYGpD0AYEZt8FRU6WSmlj8AyTtZrpubKVg7GA+flqksq5
         zWl6spSdcFM0xidvTCICAokJDIQ2F+gI/g5XPEVXXW6dHMJvag2b0FFg80B6GTFSZFhX
         YC9CxQ7kcu+KVJHkV4h3pxzv3nUpbJGHwksiZ3SXKCE+tYjsimf2xVZcOSOfw4aiTA9g
         MfyInvNyAOO4OZacO5NgbcyOohr7bpAkM2KpfVlBv/Byu4/xhsY71VP+mq+rwpt3vR5L
         IFAyezWaZl6orT+b4+7pzvbgpdaFyiEqa98sy92XWHqcZKkOJiSXZGsSOL5+FDL/65Hc
         mcpA==
X-Gm-Message-State: APjAAAXTV/FWvbsuvGKtMvkZKi4FlLZraP9AtrC8H5P3cSlshUi45Gj9
        fdZw5OrTsyA44Xr03KIdwzUVT3tLoVW49iGcElhQ2pA1
X-Google-Smtp-Source: APXvYqyQyd1bqzq3T5Kc9JDsjjwFMOCxZUqP/RH9KPPHYKATVhG7/4gbt6PzOt6QAuo1cJt219vjechNTnFAC+iJyC4=
X-Received: by 2002:a24:ee8c:: with SMTP id b134mr1884128iti.7.1551774221002;
 Tue, 05 Mar 2019 00:23:41 -0800 (PST)
MIME-Version: 1.0
References: <20190301104331.GA26805@nebula> <20190301110000.ofmenn5hjxf4nvb4@breakpoint.cc>
In-Reply-To: <20190301110000.ofmenn5hjxf4nvb4@breakpoint.cc>
From:   Karuna Grewal <karunagrewal98@gmail.com>
Date:   Tue, 5 Mar 2019 13:53:29 +0530
Message-ID: <CAHRz_yZ4esKR2TJ=9AqtYbc5awDaNKHW6iuLXVLFZcuFAWLW1Q@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_meta: Extend support for NFT_META_TSTAMP_NS
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 1, 2019 at 4:30 PM Florian Westphal <fw@strlen.de> wrote:
>
> Karuna Grewal <karunagrewal98@gmail.com> wrote:
> > Meta evaluation function is extended to suport NFT_META_TSTAMP_NS option
> > by exposing the 64 bit timestamp of the packet to two 32 bit registers.

> Other than this, this patch looks good.  Please consider sending v3 once
> you have nftables patches ready as well.
I've a doubt in the nftables implementation for implementing the `-m
time` support. I'm unable to get a proper idea of where the start and
stop time comparison with the dest register's value takes place.
From my understanding of implementation, I've noticed that after
parsing the rule and the meta expression is allocated, expression's
primary evaluation function is invoked.
Meanwhile, the kernel has the nft_meta_get_eval  function setting the
register with the relevant field and in nf_tables_core.h  the
registering of different nft_expr_types is accomplished.
Could someone please give me some pointers about where this processing
of the data set in the meta registers takes place?
Thanks
Karuna
