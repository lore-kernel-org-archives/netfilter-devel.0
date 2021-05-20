Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E184C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 May 2021 18:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A51C6105A
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 May 2021 18:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhETSC0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 May 2021 14:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbhETSCZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 May 2021 14:02:25 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6B0C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2021 11:01:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d16so12925241pfn.12
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2021 11:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4/z/5D4Z02DQ8Gw0+VtvIfn0alzeV3eYS5uCJ2DfWik=;
        b=bB9otXIntCd96sMnuCuHdPZ8RoIjZpvqYmlcCv8KGejnGHP8lkN3zjjGPr34mO2fvq
         D+nmAjr5W0+wBo0WYSNfJeUhzZlppMkkoyAgHJZWRC0S9jHYBMltyEAWUyl4ne0dWC0h
         6UACqANMl+bsc4/JiFr+XpDdqwnzf4geEWaq2WwDaxbyfT6oGdpeZyNS2tK0zuiWB5lS
         Bo/Oa2rawlwfYIW1SDSTE8Og3S8KVyJ7qhrtQveMNPxrGhRW1BcI2YjCpMDnBPMAgSGu
         I+sLwQn4LHWHQ6FRDSEog3SbtDHnURt35j9NUOqIYgaa+qOFNbttqz0AsY4La4eP3+tF
         DCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4/z/5D4Z02DQ8Gw0+VtvIfn0alzeV3eYS5uCJ2DfWik=;
        b=FXK2UfvQ/ZhRWeN2rY58IBidDCWXEbChivga4U6gwqqkPLP70BiS3yjy7PoHhRdeVw
         1jhbbzIS5jHk4yNYEhrhehTLTD5ehnb6lsNevPtqtv0aksbJ0ACZLWbNqe4lFoD03Bd3
         +78kqA7W/VQqardoWkoIXcg9WTr0bk5NOT8mVXBgGBDVecsL6QjUwNgxL9T1LAqDNN/s
         mM0qJpEFiU0c12yI7LFuWnDv8+dE4zeaKR8fdTACNnNw1ix/uGLJd/OlzfI7Cjv+Xr7+
         vQVeOo3eUm0EtNOxawOy1+RZbFiDHFQWcA2vAeBSMatXLGRKw4EoMH0vzda8Sz/p+ed3
         S9/Q==
X-Gm-Message-State: AOAM5337GKrXvejW910IodSay1NliLy6IYcI1MWfjz4zaxdvpmHdmdcg
        ZAsr68FjVkm9maPtSf9VjBGifC6hrPILaXox8MMLwi7ZteU=
X-Google-Smtp-Source: ABdhPJyN+xAiY9flf0/oVNeDNLeDksWI9oOxIA+WQQzJ0d1nmRIlhf+uqH54glXE2WdPaxp1Vr3XZEitlQC6tItXBX4=
X-Received: by 2002:a62:d083:0:b029:2e3:c8be:14b1 with SMTP id
 p125-20020a62d0830000b02902e3c8be14b1mr2236377pfg.41.1621533663812; Thu, 20
 May 2021 11:01:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210518152426.GA23687@salvia>
In-Reply-To: <20210518152426.GA23687@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Thu, 20 May 2021 20:00:53 +0200
Message-ID: <CAFs+hh5+8EmjQn6ahFnujOVwEHJv48Lj+=yum+dL_rG9gY9xbA@mail.gmail.com>
Subject: Re: warning splat in nftables ct expect
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

HI,

> I can fix this by adding the nf_ct_is_confirmed() check, but then you
> can only create an expectation from the first packet. I guess this is
> fine for your usecase, right?

Well, I must say that I=E2=80=AFactually never used the expectations, and
probably will not use it before long. So, of course, you can add the
check.

Thank you.

--=20
Bien cordialement, / Plej kore,

St=C3=A9phane Veyret
