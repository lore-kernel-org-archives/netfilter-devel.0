Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 445CBC04ABA
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 17:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjITRtL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 13:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjITRtK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 13:49:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6671ADD
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 10:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695232106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B4eHUbkpCsLxM8JhYgm+U+yEOsuhOr0x3DibmuFMRRc=;
        b=a9zDc1wpexmjAcvoyMmT9M0osv9lWB8xskDyvaf7olr7dzU6LUPtkU/ySJEnnATQySr1CH
        6o43JC7vmf35altTuulieUAAICzbDLbCJiuGQDODPK1sY10jcUH31t4xI3LlnRXoBZIJrZ
        WvmjseFhuNqFktuOnX+ug43tk8uMBHE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-7SdsKP4GO2uXVHX0rz46Dg-1; Wed, 20 Sep 2023 13:48:25 -0400
X-MC-Unique: 7SdsKP4GO2uXVHX0rz46Dg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-404fc59b8acso270655e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 10:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695232103; x=1695836903;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B4eHUbkpCsLxM8JhYgm+U+yEOsuhOr0x3DibmuFMRRc=;
        b=KFSOYttOBfSiLDAh/h2dgqXDgJkJSmTuITHhfrAAercFnr5aV4jwZEzCmrYasP/c9S
         82Pad+qbrKnnDkR/cix3c/u0tXXpXjTConoDaPYzbKhCjCdXSglnlO/0R+zR+/Jau1j4
         EaOrWQs4bv8j6qBjCUQl1T3g9UurNX6VK9Q3BAniEkogwSTMnI9+mgN5n/lYNI3nIC4G
         U7nglTWbKZf0JTfd3sHI55e/ID8S8qGE+eDXP3WynA/id7WdR4LZ02Gw+uteTPCzeb32
         5ZXUhIYIphnMvymEY+JdZIXNTOFxb0W1S7f1msBNQZOSLIk6ebuGspdbrmd/wPtRKAFG
         9iaQ==
X-Gm-Message-State: AOJu0YyqoLl6v46Jz0qQyd/DTVswEvb42s3ec86XnCFUe+hO6n92xHb6
        NSCapGAt0sTOkErH2HZzrqPAYAGkqUsVfEtu9A16cZXiDcGQwgcikNV8RZM1Xw2RHXgGypmeLqM
        +q2K1RUD/o7l4lOBbfVhv8IWdtvyMDZWhnATu
X-Received: by 2002:adf:f688:0:b0:319:7624:4ca2 with SMTP id v8-20020adff688000000b0031976244ca2mr2706493wrp.0.1695232103797;
        Wed, 20 Sep 2023 10:48:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcgFWtw6O/iyDh5BZo2yOkinBbBcDmILgHehC6qyx0yjwvfMz96O7313T2rZ/zbMeI1UvLzw==
X-Received: by 2002:adf:f688:0:b0:319:7624:4ca2 with SMTP id v8-20020adff688000000b0031976244ca2mr2706481wrp.0.1695232103463;
        Wed, 20 Sep 2023 10:48:23 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id y14-20020a5d4ace000000b0031c5dda3aedsm19334238wrs.95.2023.09.20.10.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 10:48:22 -0700 (PDT)
Message-ID: <d8bbc221d973199e2f4cd8b13d3165db9f4c0668.camel@redhat.com>
Subject: Re: [PATCH nft 8/9] datatype: use __attribute__((packed)) instead
 of enum bitfields
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 20 Sep 2023 19:48:22 +0200
In-Reply-To: <ZQsXoASbR1+aimMt@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
         <20230920142958.566615-9-thaller@redhat.com> <ZQsXoASbR1+aimMt@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-20 at 18:02 +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 20, 2023 at 04:26:09PM +0200, Thomas Haller wrote:
>=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0enum ops=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0op;
>=20
> This is saving _a lot of space_ for us, we currently have a problem
> with memory consumption, this is going in the opposite direction.
>=20
> I prefer to ditch this patch.

The packed enums are only one uint8_t large. The memory-saving compared
to a :8 bitfield is exactly the same.

Thomas

