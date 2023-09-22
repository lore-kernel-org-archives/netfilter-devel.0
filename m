Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E82CD4F33
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 08:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjIVIzp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 04:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjIVIzo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 04:55:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CA799
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 01:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695372896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rp6lMmd0tNx2tgr00NveVWwiNIbIIaCqj72QLMb3vNk=;
        b=eMIad6UhjfjQQn+asucPETvEiq+g+xea8cyl1AIt+ruWxkKlHS+Gp1aqEOk9XXgRAMyZ9E
        fJlugNmCcB6Q/uTjvrn/jJG6arW5yUQs9t0S2ge3rDOudRlH4zFnewHViWbi4JWz6avBtV
        1Px8K6/CcC62Ffjy4JXGpqLxBwDKi5M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-zFAL4buWNvuj6GpnhGapgA-1; Fri, 22 Sep 2023 04:54:55 -0400
X-MC-Unique: zFAL4buWNvuj6GpnhGapgA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-53347126bf0so209594a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 01:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695372893; x=1695977693;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rp6lMmd0tNx2tgr00NveVWwiNIbIIaCqj72QLMb3vNk=;
        b=OjUqdqYpTrd7YpYLyVhOEgOQjKJKHaJItzdFqaFv50G7MBgVOcOm9wCBDdBBJ8yLGW
         d6clPjbAyOQFRQgEplmAHdaUPqsKyYYCFURdVNNfDLobmKwRod61LhPCvlprBgnj8LWu
         fWKSoLZerVLnTdYTM+GDMeO/ujmGWLzdeO4YFJEhvbd/pvUb1GGQikyd721+WDRwU4L/
         /gbbe8Bb5GBVC6CoRYQPDwXXWEflkNdT7+qgYk78AWnVRFG+74doglDTZpUYR8rYv69v
         mEqKrMZoxqd+HF2HS5rciampnu0icUsUjMNupXPDXw8NXt2jXD8ZwIY8EwumcYAJ7e3R
         gfEg==
X-Gm-Message-State: AOJu0YyeUNlDGsxqh+nIyvGySkmeYCEwCA+DSP2G+s/0LwRBm1BoXZrP
        1ZHoKtzH7W+CegzGXGIE78gvjwAmQlYhZ3fTjThuc1dwJGZSPfWOaH3p0CtncNSEA/VLB0VUP93
        Ei/k/o735iDpAJYgqFtjSMyMKXe/K5nDnSdpw
X-Received: by 2002:a05:6402:26d3:b0:522:e6b0:8056 with SMTP id x19-20020a05640226d300b00522e6b08056mr6398909edd.4.1695372893605;
        Fri, 22 Sep 2023 01:54:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZd3oaNrxw3T/Kz8HXuwwhR73cjTdeJcZM6bFxDRoI4JENK0n7nsUphFmvug6vWsX7Por2SQ==
X-Received: by 2002:a05:6402:26d3:b0:522:e6b0:8056 with SMTP id x19-20020a05640226d300b00522e6b08056mr6398899edd.4.1695372893349;
        Fri, 22 Sep 2023 01:54:53 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id h6-20020a50ed86000000b00530df581407sm1975730edr.35.2023.09.22.01.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 01:54:52 -0700 (PDT)
Message-ID: <988c6c1bc2a2fff3d0ab65bdd5c7bdb9e09499a1.camel@redhat.com>
Subject: Re: [PATCH nft 7/9] expression: cleanup expr_ops_by_type() and
 handle u32 input
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 22 Sep 2023 10:54:52 +0200
In-Reply-To: <ZQxQ2bDCBBZGGfAR@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
         <20230920142958.566615-8-thaller@redhat.com> <ZQs2Pmq6J5ZdXDQb@calendula>
         <47d61eebc85999dbd2f5b7a038b00723dea70cae.camel@redhat.com>
         <ZQxQ2bDCBBZGGfAR@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-09-21 at 16:19 +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 20, 2023 at 09:28:29PM +0200, Thomas Haller wrote:
>=20
>=20
> > The check "if (value > (uint32_t) EXPR_MAX)" is only here to ensure
> > that nothing is lost while casting the uint32_t "value" to the enum
> > expr_types.
>=20
> Is this cast really required? This is to handle the hypothetical case
> where EXPR_MAX ever gets a negative value?
>=20

EXPR_MAX is never negative.

If EXPR_MAX is treated as a signed integer, then it will be implicitly
cast to unsigned when comparing with the uint32_t. The behavior will be
correct without a cast.

But won't the compiler warn about comparing integers of different
signedness?

The cast is probably not needed. But it doesn't hurt.


Thomas

