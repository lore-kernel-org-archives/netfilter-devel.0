Return-Path: <SRS0=owQB=TL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8C2C04AB1
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 May 2019 18:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC86420881
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 May 2019 18:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n4VCh4vf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfEKSzK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 May 2019 14:55:10 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:41744 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfEKSzK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 May 2019 14:55:10 -0400
Received: by mail-vk1-f195.google.com with SMTP id l73so2316212vkl.8
        for <netfilter-devel@vger.kernel.org>; Sat, 11 May 2019 11:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2HtUDG/anaYQG8BSeIxh1/Ee8o4t9gr/W0vIVbKJ68A=;
        b=n4VCh4vfl7hsUCVfXVQ8uv1BUyIlkz0hRbgkQJkPYq9qxRqTCP/arjAWfqExBp+fx8
         Vd5CBlpA3ka+L40KQjCzf4wA9Xeyd53knJPTPlsFI45pWp3XZL6O7ZLJ5+lV2Nu1dQ54
         HMSecA2ZT7XpETFneSajzZisjCJFsXRxnbeG87uuqPT6w/y+ZBWdy/e6ZTrJKZ2CadRj
         OyZNCLbOLrW3pc6BVclJ0EUI+t58DOa4Q7OXi2duNlnRThFYZslljaaLs0xKNVLu9nOX
         sphK1k2Ti0R7bdnY+9FxzlpABw5mGb9blGWPviaCyKKYUWuSee7TgNslLw8JSMrLCxs+
         TYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2HtUDG/anaYQG8BSeIxh1/Ee8o4t9gr/W0vIVbKJ68A=;
        b=uF0dxB2YEIXctL5Zivc/Rc2ntEJyBx8eLjr2l39B6GKOWkaeP9jLhodoNXX/cAXGvg
         pO0Rmv5zwb0ayFzY7mNhwhb7g/qUbB3BnmijyErhpUdTn66SVLSAC0Y/v0m7Vt/Li07W
         Wz+FfWLLV6pDPcI3f8n/0oGEvjuZYl1J0cBJdMvXTx7nShlf/u7IeNK9nP2u4DPCSBEY
         nnHFcfC4uaBwKyGYBiFyUXonxek8JZJT/3JeSaqyhKTexnCef/7ZZW+rJFSTd6MSQVOQ
         aYI5iinyivAWKLf22f/SFQ6eZrclmkh22lT/yRtfkvRXgBXDGdGvZFaWeBrHVr9br8Df
         c+kA==
X-Gm-Message-State: APjAAAXkDtRNVC+7mp7gSic3SEx77Jdlp0j7GBQzOgaJUSs6a0ZnHRHf
        jr/zfwSg/k/N9ZSyBXD9kQKffXniXZgrC5lg5ztV8Q==
X-Google-Smtp-Source: APXvYqwAU66Ng+zr3og0kGMmfoYsxMIJapgRvtPbptfusdg9uhyvK49C3olsBNWYlyr4w7uNjtacsrkGtOJJRtpVNT8=
X-Received: by 2002:a1f:a54f:: with SMTP id o76mr7396944vke.86.1557600908792;
 Sat, 11 May 2019 11:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190505154016.3505-1-sveyret@gmail.com> <20190505225114.pwpwckz2oauskkrf@salvia>
In-Reply-To: <20190505225114.pwpwckz2oauskkrf@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Sat, 11 May 2019 20:54:57 +0200
Message-ID: <CAFs+hh4Cq3kbJPVtn080KknAP5d3w8V5zcx9AGV800EN8d9G=w@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_ct: add ct expectations support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Le lun. 6 mai 2019 =C3=A0 00:51, Pablo Neira Ayuso <pablo@netfilter.org> a =
=C3=A9crit :
> >       NFT_CT_TIMEOUT,
> >       NFT_CT_ID,
> > +     NFT_CT_EXPECT,
>
> You don't this definition, or I don't find where this is used.

As I told previously, I just copied the way timeout is built, and
therefore, it seems that NFT_CT_TIMEOUT is not used too.
But I actually saw today that these values are used in the =C2=AB nftables
=C2=BB project. There is a copy of nf_tables.h there. Not sure it is a good
idea to keep the variables in =C2=AB nftables =C2=BB and not in kernel.
