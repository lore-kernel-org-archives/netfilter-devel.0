Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B53C83F19
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 15:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjH1PeU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 11:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbjH1PeN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 11:34:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BBCCEB
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 08:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693236786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lykktCYVtVELkq+Q+sOCWzpRWUFmqS/aXQNoGBBX2JE=;
        b=M3CwrP/UI0bruQ00KniCs3LAkHiFDclHAjs6zq1Yc1daczWEYFjUuOXy0XGKTv49YbXxwp
        JelP7HZ87N1WqxtFV0cHxJFn2chvNHwLHdXITcRDSBnjGAiCIbxN9kZaT2IRQnUTVSLh4H
        p1KT+Y68ie9ef1saAQgSFigIld4Ree0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-pM9WHUZbNKiefROv_EF7iw-1; Mon, 28 Aug 2023 11:33:05 -0400
X-MC-Unique: pM9WHUZbNKiefROv_EF7iw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fe4f8a557dso11158535e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 08:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693236783; x=1693841583;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lykktCYVtVELkq+Q+sOCWzpRWUFmqS/aXQNoGBBX2JE=;
        b=DlW2G3eJI4fB3zbUWAdnGDhine+431Ij6FrPpkECKVJB41X40BWYJmfvgztE881DUd
         tIhC2TVxKVE7jxZTHLxH9wmG2Rpct9vs3YCPkgsErJqZDxUlMapqXTFT4Vw1xii7WJ4B
         HFkbZDmilxs0M3GakUB1SniTgxY18V5ZLyywZtXGcxd7+48/EgwtQdDItd9UtVFQy+yt
         P/2VTMbWntF70Iv1+6yl9lhg//X5t7+Bn+FmiaMnYsUGqMcC3GoWVZ+S/KFPhtr5dH9r
         HvP/qRPsEv8g1XpPWTXTN0KlWqXojoTS+QPzP2i8DZvwDsKmaF5wvKJ1ZrGmzoAy4cdB
         bLOg==
X-Gm-Message-State: AOJu0YwI6wOhARCr3cgNg13xaHMud3VbHhh25VoAkCKZSi3VrocVW6mf
        j0EsLbIEk+feh9Dn1tUsVlrS2d7bIESLTBEhtO883hyT0b1BQLj8qDpXh4Q0kylw19jIqaIEhf3
        1esP6j5zzAg5BbZ6XxQD3Aa3TWWNRBXOYdncX
X-Received: by 2002:a5d:60d2:0:b0:316:ef5f:7d8f with SMTP id x18-20020a5d60d2000000b00316ef5f7d8fmr18433752wrt.3.1693236783432;
        Mon, 28 Aug 2023 08:33:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWNTN1Z9EwN2+vQce0cCIrBO3xXAIr5lZrkK1hy2ZP5qsuhAp+c0z8YaLfkPR8zY6FGdoNTA==
X-Received: by 2002:a5d:60d2:0:b0:316:ef5f:7d8f with SMTP id x18-20020a5d60d2000000b00316ef5f7d8fmr18433745wrt.3.1693236783126;
        Mon, 28 Aug 2023 08:33:03 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id y6-20020adfd086000000b003179b3fd837sm10884579wrh.33.2023.08.28.08.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 08:33:02 -0700 (PDT)
Message-ID: <dd5bf8c204447fa7dda1b5bfb87a830f07a55c04.camel@redhat.com>
Subject: Re: [PATCH nft 8/8] datatype: suppress "-Wformat-nonliteral"
 warning in integer_type_print()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Mon, 28 Aug 2023 17:33:01 +0200
In-Reply-To: <ZOy4VvjT/vxpR5iR@calendula>
References: <20230828144441.3303222-1-thaller@redhat.com>
         <20230828144441.3303222-9-thaller@redhat.com> <ZOy4VvjT/vxpR5iR@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2023-08-28 at 17:08 +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 28, 2023 at 04:43:58PM +0200, Thomas Haller wrote:
> >=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0_NFT_PRAGMA_WARNING_DISABLE(=
"-Wformat-nonliteral")
>=20
> Maybe simply -Wno-format-nonliteral turn off in Clang so there is no
> need for this PRAGMA in order to simplify things.

"-Wformat-nonliteral" seems a useful warning. I would rather not
disable it at a larger scale.

Gcc also supports "-Wformat-nonliteral" warning, but for some reason it
does not warn here (also not, when I pass "-Wformat=3D2"). I don't
understand why that is.


Thomas

