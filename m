Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BCEC0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 14:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECB5A21850
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 14:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RK++vLRY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfGCOcT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 10:32:19 -0400
Received: from mail-vk1-f182.google.com ([209.85.221.182]:32938 "EHLO
        mail-vk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfGCOcT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 10:32:19 -0400
Received: by mail-vk1-f182.google.com with SMTP id y130so2461vkc.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2019 07:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9GcNJ4hPNQaUjG+v4TxmlhDj9863RHQiJEZBuag6GdQ=;
        b=RK++vLRY5A/px3X0TGEC+/s9lJJpXaVeOonBJabF52QbR3/QsPRBFrXhmPLzo3DlhT
         pFYsSCYXQwkN+YVrTaYxiQEt1K7YfKr9yAoyx4EJPm4WmsG1q/Vkq2ZwxIhW7ymXH22c
         n0O524G96ti+hTYWgHnryPXXSOhCUs2kaolZTJ4TpLhomXBFAQWalfIQz457Gl5/Dw0M
         YC3PXmbX8qtA+S1kPI2bJs+jiE72Z1PRPppv5DbCh79pri8wVahXXc0FrCKvW51t9IB1
         geFGUyBjqTymplM6uLdSkIe7IX9pnUazyBNSdqNjorQyaVd7nlQKS3qx9Abb+DWoiEt0
         +koQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9GcNJ4hPNQaUjG+v4TxmlhDj9863RHQiJEZBuag6GdQ=;
        b=laMWy5e9e5rc7qTM14NJNWPT77Egm8ZYqavnRAt5X60B/bOcoq0wZ+lfsvxPCNGXMN
         0u9uiG97EDYdWb/qK0RMv46aRrEsmPnQArgX8WT95by2y7KqKhb4br32iLA1AAJk8TMG
         Ds829jhwIEV70qzF+iDys9Uv2MtKn83w0NlJMRuPQoFMMSXwI+wfdMqT5jGA+IjGd6Uq
         Ksj6UMjRBKkloJiDRBBR/GH9kjYIio4DJqkBzQ10pJbaP32QUPJlygxkA8jsuYw4JnTh
         TiOVqd4R18U1qrQwr1JYtz1GEhN9oudxNkxjW8US6L+AFx0zgavje89nHLc0sK1j5deK
         fzcw==
X-Gm-Message-State: APjAAAVWqXi6ugDT72msMcph7hzWU/zohvw2MdIdcjzYUrGz8R8rFkti
        0g13GqIWaB2SODHFAdzeHvp8rYvyGbfkwyTE9dT96g==
X-Google-Smtp-Source: APXvYqyouZ2SQuRJHMJVgGyTmUyLEVyVlSui91ZUnc/jvtTt5EBpGUhEiTj8SMEXqMVNfG+x39T/dMKEpCBBAvpdZcs=
X-Received: by 2002:a1f:7c8e:: with SMTP id x136mr268210vkc.27.1562164338210;
 Wed, 03 Jul 2019 07:32:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190605092818.13844-1-sveyret@gmail.com> <20190605092818.13844-2-sveyret@gmail.com>
 <20190702231247.qoqcq5lynsb4xs5h@salvia>
In-Reply-To: <20190702231247.qoqcq5lynsb4xs5h@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Wed, 3 Jul 2019 16:32:06 +0200
Message-ID: <CAFs+hh7s0Xr9gRz9_thHY-XCuXbijqF6n4Xkd5cD745wsbmy6w@mail.gmail.com>
Subject: Re: [PATCH nftables v4 1/1] add ct expectations support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> json compilation breaks:

Thank you for warning me.

> Would you fix this and revamp?

Sure! :-)

--=20
Bien cordialement, / Plej kore,

St=C3=A9phane Veyret
