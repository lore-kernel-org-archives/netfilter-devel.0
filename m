Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86D4C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Apr 2022 03:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbiDKDqp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Apr 2022 23:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243967AbiDKDql (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Apr 2022 23:46:41 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657C91CD
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Apr 2022 20:44:28 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u19so4228504lff.4
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Apr 2022 20:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=7gPGBjBRj/6MkRvreHilhwceVSIhf690rJ9qycmoDDA=;
        b=cRwXEkFAkPcLqmMG0IZgELaSjTay0cydhcBWouoFwUsMUcgiWG9o2OvoGxquzBfZS7
         UjFTWsnWmCmbJL8gLokTqd7q0XaauSKdkVKAhy3709ff8cKgKSE9Zqsk/EbNNOIIXCBQ
         3yhD2ff/Cb6taJEXF23CC/fUeeTEgi4/dJAIs/r5VmD6U/QHsvmvcNITgJADF6z/Op7L
         L72hRPA1rECih3yahr/Pwrg2tacAgWdU4XPd2oWBbgmrdD+KfFv/jMYZZKQgZY5Xen/g
         NVO/NZX8KmEevt4rJIAabFUtZOY5cNXnyT2yVkBvgdiWYwCSpAv3aL9UeuOoqIlKyfAK
         PkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=7gPGBjBRj/6MkRvreHilhwceVSIhf690rJ9qycmoDDA=;
        b=XyxGi047nFxhxY2tOH4Snw3d7vgXvH/GNrYDK1v4bIQ/QDvNJEqLN8t6TbHnYK7wfG
         8jCjJD4EvDibmwoOa4+IRiDMTAJrLO2x0FcJIhUogUiUu6hHUgN2Dz9CX+VsZvkyTU26
         YZCfn1A5oVipEucJekPFGNLXhuFsEntccMg+RYP8HapHOqsE7l0kxor+p6Exb82dQvnb
         kHW22UERtOIFoCxmnFvQtWhYEjYCytp67HGvK9DRKygBwBl9JfuVFHZVNQ9xbgCqDwP/
         LNtu1jgv0b9SZy+sun7gCTCBMJwp1mtNZClbStg0IY2MlYpsnq/cZIDz3kPKhsr5NHiL
         t0ag==
X-Gm-Message-State: AOAM530Sn54jflf9iUa2VbejQj1QV47eHHs3FssuvymfRnqUm6x8N6rw
        NbKAt6d+rYtVcVgLDNCPzeXeKkYXXOlZXFKJcLLSUmyZKqg=
X-Google-Smtp-Source: ABdhPJw/5Vqq0ZZfJmhTmSGFzMCX3l55xtuRh/o7KYku7uIb/MAKFGwYhjJY6NgLRnzEmNugYTw+OFMHRT+giUCdcyg=
X-Received: by 2002:ac2:521b:0:b0:46b:82a9:b888 with SMTP id
 a27-20020ac2521b000000b0046b82a9b888mr10039676lfl.578.1649648666543; Sun, 10
 Apr 2022 20:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <6251829e.xNu4VrF13GQsRBbt%martin.gignac@gmail.com> <YlL1yuSN6cFbK3SN@salvia>
In-Reply-To: <YlL1yuSN6cFbK3SN@salvia>
From:   Martin Gignac <martin.gignac@gmail.com>
Date:   Sun, 10 Apr 2022 23:43:50 -0400
Message-ID: <CANf9dFOZSwFyoT+LfoRf5sf4kCjg6-G9L+t=Dmov9O8Fpbf7fA@mail.gmail.com>
Subject: Re: [PATCH nft] tests: py: Add meta time tests without 'meta' keyword
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> I extended it to cover the json codebase too (./nft-test -j).

I had originally included a similar JSON diff in the patch as well,
but then noticed that it made no difference to the output of the test
whether it was there or not, so I mistakenly concluded that it didn't
matter. The README didn't mention the '-j' flag, and I didn't search
in the Python code long enough to understand the relevance of
including the JSON diff. Thanks for adding it.
