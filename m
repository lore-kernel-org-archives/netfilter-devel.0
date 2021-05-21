Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD88C04FF3
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 20:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3143661164
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 20:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhEUUVU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 16:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhEUUVJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 16:21:09 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE83C06134D
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 13:19:34 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h16so24653178edr.6
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 13:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sSrJSQySUjx6FPqWl2/q5eAJB4T53E7fGvZWzpBPOis=;
        b=MjlAT5npheGS9uTNSbjiOXadoRxl/8jmvEI8G9aDhy7xqJUrdNYvGpkA8Xm60gTQkp
         K1BTWZE6r1FxeohLoTpdGsCICxR7jyT3hPcrIezLSGjSPrEyfdMzPjpvhdY5crrXj9PC
         ZASC00zQwWpR4VeG7cqgBg0ZjGjrhYqZy+27ZMUEx5VwUPTIk/A9DOkA6TZyuDrRvWl+
         FEk48QpMRPHZOZbfa8x1807awJmoQeWYH3h1c4zRDqv5HtJkTwnMWrPLROjBgOSyO482
         tVpmtr+pj2RPNNlrZekE6tP+JfVVvamRFyz3wtLUMNYKGfz4Z1EciHFs1ZXFoefUOE0h
         1/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sSrJSQySUjx6FPqWl2/q5eAJB4T53E7fGvZWzpBPOis=;
        b=lhSNGth7Zmt/a6rr1EaFFRxJonJeX9GoislZA0DHJWQtZT4mVYIKjGHK8OZtyHdupV
         oE1NPi59hKC6BzGn+/gOAS3CBd2yVEusfdRP67JuzAas5rL1DujMZ/WoYVF+89ZckF38
         GNDIk7tXnpuKZhH9YPqLFodBFSOiRk95nno8md0coag/s9Ra8IaOtTccoYP75S6CSiz6
         Rm++op4KibaJh9p1BGxiMqdeSwgnw7z3UQzbxY23cerOHd98Toy7aND3DCyELTsHs6uI
         fOWsFnCGGq2McGgOD703SPFjVxuzbZltvFvN1v05JzJu5Bq7PdXzeWQLERVHAqOCfH+F
         RoQQ==
X-Gm-Message-State: AOAM533Ft19uT33+eqqQ8LzTfduRUyZGT+3OqhSSJpH0tOrw2V/c2zv1
        ghEfu0/zFUbHjq4KQfYKKS7edTNq1iN6xiu2ZI1D
X-Google-Smtp-Source: ABdhPJz6+FmIEqBgSBEqq6zFfzmDtBhxn7muf+nqqkYrZjNmBPvdA78mgrLy76fm/YjN7a+/ZdDseuAERhUF84zi9CQ=
X-Received: by 2002:aa7:cb48:: with SMTP id w8mr13109201edt.12.1621628373077;
 Fri, 21 May 2021 13:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210513200807.15910-1-casey@schaufler-ca.com> <20210513200807.15910-19-casey@schaufler-ca.com>
In-Reply-To: <20210513200807.15910-19-casey@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 21 May 2021 16:19:21 -0400
Message-ID: <CAHC9VhR6uQwh5utg1qUrs2U3-OdwavzVNmcWG9Lmmqj3-Nbzsg@mail.gmail.com>
Subject: Re: [PATCH v26 18/25] LSM: security_secid_to_secctx in netlink netfilter
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 13, 2021 at 4:28 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Change netlink netfilter interfaces to use lsmcontext
> pointers, and remove scaffolding.
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: John Johansen <john.johansen@canonical.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org
> Cc: netfilter-devel@vger.kernel.org
> ---
>  net/netfilter/nfnetlink_queue.c | 37 +++++++++++++--------------------
>  1 file changed, 14 insertions(+), 23 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>


--
paul moore
www.paul-moore.com
