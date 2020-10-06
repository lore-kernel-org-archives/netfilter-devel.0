Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937EEC4363D
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 12:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41F91206F7
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 12:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilMpTYKD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgJFMmh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 08:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgJFMmg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 08:42:36 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1A4C061755
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 05:42:36 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id o18so5949243ill.2
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2020 05:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R63HIqAfBJUsUowfyAldwo7P9Kjg9LfjPETuOwSpANE=;
        b=ilMpTYKD9w8HVplfNOvuI2kfBKgojF375BnU2S/jFNL6sAZ/Wk/czpscH9AkSl5Fr2
         32qQg86IKenxXPlUhgz7585K67TNP7zZ2eKjUHagelDHOgWN120eL25u/dLursg6qaMT
         AFRzt1mE+ZV8Wee75+ek/DGt8oCverGdQruNrpapBVJNpDdzQGbmPov1+cK4uoj0jXWc
         oeS8Ws4onOJI3StHFZ9ndrHKxi8SoaSxbr7c2tqwai9djagZkjsZpwZxnZR8AbMC0FvW
         Qa+wKh0O3Vh82hVAwPaudsiZrRmk3BIiTjU12FlnEio1rhTLG0y9rE7BcyGw2POMUzjk
         kcKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R63HIqAfBJUsUowfyAldwo7P9Kjg9LfjPETuOwSpANE=;
        b=eHNuyi56gpxleEjeUE+wa9QECChmviJFaDrlqz+d7EXl2N2qJSfm1flLmQvoe0AQop
         vWkgknS7G+PGFaAyTd9wbR+MBsECjCzICN3ZzxKC/iGgLkpPr9WxuwPogiCsLbdB5rpr
         S21EGWtXbktqGJNWgkvHp9mL5s5dkDO1OGVPdB+asr+r75GFkzmoC1pQmeKA2qglk9Yj
         v2jHV4kEfP1NK/0LS4DcjiBitdEvEuUnZXosWWUnYAgu3OXoNTGoFR2gUIitIJNgw7ny
         Lxgxv6fhMUjd56fReWLdEEa3VRlkixrfwrvUfSha00DcSFhfmt6EldfTNzlHGiLlVJAo
         Kl9g==
X-Gm-Message-State: AOAM533B0T/ui3gCY1/3BsOtxaXuABL01YJ2pmUQgbZo0GJpQJmPHfQ6
        l5Bg99lqzAxzLzMDYw98h2a1Cc0/u5Yo0Q9nCIA05CfqfEsx1A==
X-Google-Smtp-Source: ABdhPJyoVcx4Gdr+sm9ha8cbhX+U3YPyiUwzm1HgFwy0m6EJnVMfBDxhPy5WjaUtYrwyYRbyTP3BZqg2EXNhfewL9X4=
X-Received: by 2002:a92:8910:: with SMTP id n16mr3494809ild.239.1601988156193;
 Tue, 06 Oct 2020 05:42:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201003125841.5138-1-gopunop@gmail.com> <2c604efb-39a3-41de-f0a6-a44c703a20df@riseup.net>
In-Reply-To: <2c604efb-39a3-41de-f0a6-a44c703a20df@riseup.net>
From:   Gopal Yadav <gopunop@gmail.com>
Date:   Tue, 6 Oct 2020 18:12:24 +0530
Message-ID: <CAAUOv8iAPJm1mTPjFamEVQAOh1y-ahExN_+4Pk2rPkELwyxBEw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Solves Bug 1462 - `nft -j list set` does not show counters
To:     "Jose M. Guisado" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 6, 2020 at 4:03 PM Jose M. Guisado <guigom@riseup.net> wrote:
>
> Hi Gopal,
>
> On 3/10/20 14:58, Gopal Yadav wrote:
> > +                     tmp = expr->stmt->ops->json(expr->stmt, octx);
>
> You can compact this using stmt_print_json
>
> > +                     json_object_update(root, tmp);
>
> ASAN reports memleaks when using json_object_update. You should use
> json_object_update_new, or maybe json_object_update_missing_new to
> ensure only new keys are created.

Should I always run ASAN before submitting patches as a regular practice?
json_object_update_missing_new() was raising a warning so I have used
json_object_update_missing() in the updated patch.
