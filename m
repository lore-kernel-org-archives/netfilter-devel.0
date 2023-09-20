Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84812CE79DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbjITOs2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbjITOsR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:48:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEB92139
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695221176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j/OPlq1vvrLwFXEfDhbrtMIxuEFcrJHfYr2dqXh20XE=;
        b=eADEYDJdXlZxP/XhVOqAkNGa693hsS/V1FM0lGclvl6M2mTQTm8Guw+Xe9t3mMQ+UspCMS
        QRh248ZfnEVq/hk0K5jK3HjOEZyAEPZ8VbSOsE/60OXIqs9UrGypzRhYJ48RxU2Hc+xzd5
        LXKk2eXIjT2CDP0VxPzLJDY04l1dvEs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-tR9fLvKOP0mjnd-xNjZuCw-1; Wed, 20 Sep 2023 10:46:15 -0400
X-MC-Unique: tR9fLvKOP0mjnd-xNjZuCw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-404fc59b8acso13869515e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:46:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695221174; x=1695825974;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j/OPlq1vvrLwFXEfDhbrtMIxuEFcrJHfYr2dqXh20XE=;
        b=vHKxFqXSrIVRsgUa0g9L+VqC/8UjPiMQ/X2WtoVuLhZSOcWgrgxHw8UGYsL+hJ90OF
         C7yQBNZ8TzlvEkbS5lni3pnfu7bBb/u4T8VMkAG7xv1bO+lHBOfYX4EZP6CaSia2jLc6
         icL33VCPltGFJbSOUR9tdtEhrV0Yb7SUaoGQa0l4zQP7EGbHzenINt8c7nCGTi/VoPGU
         X4k9xJW05uDkGM6AseVSVvokxjTNqDDeQL5gYtIP90HjFUFmJPU+WA/y1KJoot5CajF1
         vDXxzvyEe0FWSuD9P3T2V/jT2wVdI7Gjw+wYOmlR6kuSAilaGZ+V+0eiy2TD4nbBIVRS
         TF5w==
X-Gm-Message-State: AOJu0Yx1CQh3WXL7Tl4CxnWYNWXmD+Yn0Z0yZMr2NeJI+8vNpLt4QLXl
        38VbIs+6oAnWfB1ZVYC4vKY5Ok2YcJOc5/b6eiWGjC3VM9nVWVn3nr6LhYGuNry051V71APdiRw
        55TCY4EsG0Y6aV0awZvEvSSitahpHyGe1JVwR
X-Received: by 2002:a05:600c:3b82:b0:401:c717:ec69 with SMTP id n2-20020a05600c3b8200b00401c717ec69mr2622992wms.4.1695221173765;
        Wed, 20 Sep 2023 07:46:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGanwMFklB3gpKon1hkouuEUiq5lBTIrRcly5FL2t86B7bq3J2OtCQ9KgHpW93Rj2cQlOcuxQ==
X-Received: by 2002:a05:600c:3b82:b0:401:c717:ec69 with SMTP id n2-20020a05600c3b8200b00401c717ec69mr2622972wms.4.1695221173375;
        Wed, 20 Sep 2023 07:46:13 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id m25-20020a7bca59000000b003fefb94ccc9sm2141453wml.11.2023.09.20.07.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 07:46:12 -0700 (PDT)
Message-ID: <9d90f25dd24e76567e784c93b2a1a5493c14e379.camel@redhat.com>
Subject: Re: [PATCH nft 2/4] gmputil: add nft_gmp_free() to free strings
 from mpz_get_str()
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 20 Sep 2023 16:46:12 +0200
In-Reply-To: <ZQr8KsFAXIT0mca9@orbyte.nwl.cc>
References: <20230920131554.204899-1-thaller@redhat.com>
         <20230920131554.204899-3-thaller@redhat.com>
         <ZQr8KsFAXIT0mca9@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-20 at 16:05 +0200, Phil Sutter wrote:
> On Wed, Sep 20, 2023 at 03:13:39PM +0200, Thomas Haller wrote:
> >=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mp_get_memory_functions(NULL=
, NULL, &free_fcn);
>=20
> Do we have to expect the returned pointer to change at run-time?
> Because
> if not, couldn't one make free_fcn static and call
> mp_get_memory_functions() only if it's NULL?

Hi Phil,


no, it's not expected to EVER change. Users must not change
mp_set_memory_functions() after any GMP objects were allocated,
otherwise there would be a mixup of allocators and crashes ahead.

However, I didn't cache the value, because I don't want to use global
data without atomic compare-exchange (or thread-local). Doing it
without regard of thread-safety so would be a code smell (even if
probably not an issue in practice). And getting it with atomic/thread-
local would be cumbersome. It's hard to ensure a code base has no
threading issues, when having lots of places that "most likely are
99.99% fine (but not 100%)". Hence, I want to avoid the global.

I think the call to mp_get_memory_functions() should be cheap.

Note that libnftables no longer calls mp_set_memory_functions() ([1]).
So for the patch to have practical effects, you would need to have
another part of the process call mp_set_memory_functions() and set a
free function incompatible with libc's free(). So the scenario is very
unlikely already. It's more about being clear about using the correct
free for an allocation (even if in practice it all ends up being the
same).

[1] https://git.netfilter.org/nftables/commit/?id=3D96ee78ec4a0707114d2f8ef=
7590d08cfd25080ea


Thomas

