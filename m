Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BB9C71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 17:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbjH2Rxe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 13:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238166AbjH2RxQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 13:53:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31630FD
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 10:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693331550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mp/+SMcxEHJjPngNkLItZK/TaS7kM1ZCC9hy3yRgScY=;
        b=IranHYdYSF3MsDNXVff/p2WmVLJobb1NPUWi2qALkLgM1Rl1kr0NJZQlQW9ufV40JYuwM0
        F475rV91Xe7DmL/cZ7dARnAyMbuXOLDB4csEtsYksoZU56UqEkZbzNlseQX4y8bfkB2Ueb
        G4FG/oAvYR+GT/PG/5blDOA0Mat2xRY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-vtmV39-xNOCstgvATes-jg-1; Tue, 29 Aug 2023 13:52:29 -0400
X-MC-Unique: vtmV39-xNOCstgvATes-jg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fe12bf2db4so5741255e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 10:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693331547; x=1693936347;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mp/+SMcxEHJjPngNkLItZK/TaS7kM1ZCC9hy3yRgScY=;
        b=PfGEVZhQJATsMdhRBjCY/TMyzUjzkWOuDR0+L8pK/0e7GAVpR/rNgBdVPdggd4JXzL
         nua9x3unIfWVRHDpg+UmoIs0vk1DBLHddcpVMcCAdZZLxPxoidz01WbRxsfTVKXdYSxQ
         aKBFqG77YxwVkK0oNW/UKtg1kaBLNNRNLQgTXvQxw2houSvxeV+lBNjiUUl+9r5VRFay
         ZIAWGKHVVzHWWVa2fQyLLfaTTqhwqbMmIabwRIjbsb+2Oc/qvVWp6BZK1thvv0i7eevY
         Pvejm9prIuJbtIGaxyTkDiMeJY0xWt3wqGl3iIJFWUirzN4zEX4h95xum0UZrPHWfiQD
         yy3g==
X-Gm-Message-State: AOJu0Yy4ra/C4L2ZoklJgrHWi9ddI4JAdcw2HiYJOfv329eCv8ebOozb
        9lE82wqiSzQAGr5s9+y8vOm/Pk6KkV7PE+JGdIru7yW20eboqVbxPOHGMIM5IuKIO1YensDJ5jy
        i48dzLzSS9dgkTgbRAfvyoyPhdHnxFJKPKfh4
X-Received: by 2002:a05:600c:54eb:b0:401:c6a2:3cd5 with SMTP id jb11-20020a05600c54eb00b00401c6a23cd5mr32249wmb.2.1693331547562;
        Tue, 29 Aug 2023 10:52:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEiG638dP9S5Br7olartxseTF4GJITMbe8ScdQkbKZ7IpaawCumnwfNBFbikwWxlCPZS928Q==
X-Received: by 2002:a05:600c:54eb:b0:401:c6a2:3cd5 with SMTP id jb11-20020a05600c54eb00b00401c6a23cd5mr32236wmb.2.1693331547276;
        Tue, 29 Aug 2023 10:52:27 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id n11-20020a05600c294b00b003fee6e170f9sm14438012wmd.45.2023.08.29.10.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 10:52:26 -0700 (PDT)
Message-ID: <213abb9727c74bff3136eea8f38dd554c33f7c16.camel@redhat.com>
Subject: Re: [PATCH nft v2 0/8] fix compiler warnings with clang
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 29 Aug 2023 19:52:25 +0200
In-Reply-To: <ZO4IEwJPaP9FZiqF@calendula>
References: <20230829125809.232318-1-thaller@redhat.com>
         <ZO4IEwJPaP9FZiqF@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-08-29 at 17:00 +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 29, 2023 at 02:53:29PM +0200, Thomas Haller wrote:
> > Building with clang caused some compiler warnings. Fix, suppress or
> > work
> > around them.
>=20
> Series LGTM, applied.


Thank you!!

>=20
> The ugly macro can go away later, once meta_parse_key() is removed
> when bison/flex use start conditions for this, and probably log
> prefix
> is reviewed not to use it anymore. I still think that macro is not
> looking any better after this update but this is not a deal breaker
> for this series.

I don't find that macro that ugly (anymore). But OK.

>=20
> BTW, would you extend tests/build to check for run build tests for
> clang in a follow up patch? That would help a lot to improve
> coverage,
> and reduce chances compilation with clang breaks again in the future
> before a release.

Yes, I have several more patches, that I will send soon.


Thomas

>=20
> Thanks.
>=20
> > Changes to v1:
> > - replace patches
> > =C2=A0=C2=A0=C2=A0 "src: use "%zx" format instead of "%Zx""
> > =C2=A0=C2=A0=C2=A0 "utils: add
> > _NFT_PRAGMA_WARNING_DISABLE()/_NFT_PRAGMA_WARNING_REENABLE helpers"
> > =C2=A0=C2=A0=C2=A0 "datatype: suppress "-Wformat-nonliteral" warning in
> > integer_type_print()"
> > =C2=A0 with
> > =C2=A0=C2=A0=C2=A0 "include: drop "format" attribute from nft_gmp_print=
()"
> > =C2=A0 which is the better solution.
> > - let SNPRINTF_BUFFER_SIZE() not assert against truncation.
> > Instead, the
> > =C2=A0 callers handle it.
> > - add bugfix "evaluate: fix check for truncation in
> > stmt_evaluate_log_prefix()"
> > - add minor patch "evaluate: don't needlessly clear full string
> > buffer in stmt_evaluate_log_prefix()"
> >=20
> > Thomas Haller (8):
> > =C2=A0 netlink: avoid "-Wenum-conversion" warning in
> > dtype_map_from_kernel()
> > =C2=A0 netlink: avoid "-Wenum-conversion" warning in parser_bison.y
> > =C2=A0 datatype: avoid cast-align warning with struct sockaddr result
> > from
> > =C2=A0=C2=A0=C2=A0 getaddrinfo()
> > =C2=A0 evaluate: fix check for truncation in stmt_evaluate_log_prefix()
> > =C2=A0 src: rework SNPRINTF_BUFFER_SIZE() and handle truncation
> > =C2=A0 evaluate: don't needlessly clear full string buffer in
> > =C2=A0=C2=A0=C2=A0 stmt_evaluate_log_prefix()
> > =C2=A0 src: suppress "-Wunused-but-set-variable" warning with
> > =C2=A0=C2=A0=C2=A0 "parser_bison.c"
> > =C2=A0 include: drop "format" attribute from nft_gmp_print()
> >=20
> > =C2=A0include/nftables.h |=C2=A0 3 +--
> > =C2=A0include/utils.h=C2=A0=C2=A0=C2=A0 | 35 ++++++++++++++++++++++++++=
---------
> > =C2=A0src/Makefile.am=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> > =C2=A0src/datatype.c=C2=A0=C2=A0=C2=A0=C2=A0 | 14 +++++++++++---
> > =C2=A0src/evaluate.c=C2=A0=C2=A0=C2=A0=C2=A0 | 15 ++++++++++-----
> > =C2=A0src/meta.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 +=
+++++-----
> > =C2=A0src/netlink.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> > =C2=A0src/parser_bison.y |=C2=A0 4 ++--
> > =C2=A08 files changed, 58 insertions(+), 27 deletions(-)
> >=20
> > --=20
> > 2.41.0
> >=20
>=20

