Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E08FC3DA6F
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 13:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbjHXNUL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 09:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbjHXNTj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 09:19:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99EE19B7
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 06:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692883117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=85gJ17Zng9HVxrU32N97+N7Hsn/7Kk8ejLSG5k/WCOU=;
        b=JKGuzTMbmnRibKI1CcA2+LSTM9TV60PaW2bbHefGGooiF8d3AdWBFxNk7qdO8cT8tzNq0w
        Rc4h2/o56nHozw6OF2BGhxFLGJNFLAALeomgvJj0hI/joqnKEJAYfzP5UpEyD3KocWpfKQ
        4IFLgo1TIsa/lRTLt2ZVMyaYMWCSDpo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-zV2uULuiNYipMnhkK7Vlpg-1; Thu, 24 Aug 2023 09:18:36 -0400
X-MC-Unique: zV2uULuiNYipMnhkK7Vlpg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3175b9a0094so938465f8f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 06:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692883115; x=1693487915;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=85gJ17Zng9HVxrU32N97+N7Hsn/7Kk8ejLSG5k/WCOU=;
        b=MD3jdlndWYjLnbww/gwsb2o4hRBB1oycgp0NW9drHn1tEKquQiJ1lDv/oLFumXSdh9
         mIdqR2VcP0vp4B/aZJLshwmt/zf91K4nmcvD4EGJwn3t6Alkzca4FFFWOEvU9dgn9Di+
         SufHTD9Ud8UxEY2xqSNGWFieC0KEvLi7AZA50ynKwC/gYrDkksVzZl2VkXNjYaPx9Sbn
         4cxWsg7THa6FKWY8m46yCuU7Qq0K0gb6YNsLII72LoekoEdaCBxxAdD3utmYij1Nmk2T
         3aXJvSZhWDBnwNaZhHo5O9M2Cf0i1/UT+1wOM3JjQL4rs6UXhevJvGCaw388MbfbsvQz
         GIdg==
X-Gm-Message-State: AOJu0YyBPeT22N7mR/gu9vLZ5DgDfqwll7tuOdKYyBun4roR/tQVvF6W
        5p4F7VRgrQw07Gy1zZtXVCtqdpNdlbZhU81ViY+HcR2bI626ccZTuoGRxxBwpM0BXcWT3sAtezD
        Zrnxz4H2jTk9C4dE45vrfJDZ95xOLuZfjYgCD
X-Received: by 2002:a5d:6949:0:b0:319:7624:4c88 with SMTP id r9-20020a5d6949000000b0031976244c88mr11669738wrw.0.1692883115004;
        Thu, 24 Aug 2023 06:18:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBm6HPDDORzN8B30qz/j8KhLnrGRHP9rOu1fsaGQ3ejBckgLJ2iL2s9ABAXEwF3TizW2iayw==
X-Received: by 2002:a5d:6949:0:b0:319:7624:4c88 with SMTP id r9-20020a5d6949000000b0031976244c88mr11669731wrw.0.1692883114751;
        Thu, 24 Aug 2023 06:18:34 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id 13-20020a05600c228d00b003fefd46df47sm2635893wmf.29.2023.08.24.06.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 06:18:34 -0700 (PDT)
Message-ID: <3969057145140cfcd67d0277b11089548b22c504.camel@redhat.com>
Subject: Re: [PATCH nft 0/6] cleanup base includes and add <nftdefault.h>
 header
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 24 Aug 2023 15:18:33 +0200
In-Reply-To: <ZOdS6DOQLYPkthoX@calendula>
References: <20230824111456.2005125-1-thaller@redhat.com>
         <ZOdS6DOQLYPkthoX@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-08-24 at 14:54 +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 24, 2023 at 01:13:28PM +0200, Thomas Haller wrote:
> > - cleanup _GNU_SOURCE/_XOPEN_SOURCE handling
> > - ensure <config.h> is included as first (via <nftdefault.h>
> > header)
> > - add <nftdefault.h> to provide a base header that is included
> > =C2=A0 everywhere.
>=20
> Could you use include/nft.h instead?

ACK. I will rename for v2.

Thomas

