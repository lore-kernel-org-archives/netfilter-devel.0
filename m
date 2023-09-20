Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3748C04FF1
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 19:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjITT3r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 15:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjITT3e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 15:29:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB556E9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 12:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695238114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OZSu3npffy82iPdnYaLnJVJKL9U+ggrZ+Gmit+wZa5I=;
        b=UX5RCtu6/j6VFtemLIEXfC0yeRKN8NjIeQQthvsskiIJccwkzp74J3YduxKqf4r9v1laJO
        q6NuLdPa5QO23st9tUHTGnA2CgcfloMJ3DdpH56i/5ZxdjAdLwNavJYA033MxyBkVuoehN
        UdtOwPomiqU2oUUwXCmES8jjZ5WMJRI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-qxWb5g59NQeL3T4TiJuIrQ-1; Wed, 20 Sep 2023 15:28:32 -0400
X-MC-Unique: qxWb5g59NQeL3T4TiJuIrQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-404daa4f5a7so531085e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 12:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695238110; x=1695842910;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OZSu3npffy82iPdnYaLnJVJKL9U+ggrZ+Gmit+wZa5I=;
        b=rBT8IQzJUJbfx3ZX44U9CLplwp/Cg8nTMcyTVrm8Yq80iftE9SfdPptqA4C6dnNhpi
         niT3FiDSOI0M758h4DLPjf4MYRc7UIv2o1tlNm6nA7Z7P8xIzRFR64zlGyijAEZ1Rfgu
         iA8guQNpn96iT3TMMA3J76drvAXDaVDF4ZQyaf0butdRIvOtM/Fb5W5Z0oGclzHaSDhC
         GCx+z0KARaMThpJALL3fxr46SB8zFxRgDK1lKlfy7U/hVbmwZdvydHm6nwb90ysARoVV
         JgnzDxGNkIx1M0lMgZ2911lmfkEPOkyntcjrIPG0g3+gPzdP6Zgy2kp2BLq0eqsiwoVd
         W9Ag==
X-Gm-Message-State: AOJu0YxQa0dczvGvYmByg9OsFx88wlkLjW005Klezk6rvfO39UpXasvd
        BfMVKvvSHZfj5SqB4sJqFwFeBJK8xfJ6ziVld3/wmluL3aMWpuSIdkhi1UFQDHIiMzC6w0sdF3a
        1T8JNR/WI7X3QKG4vNim6r044PeHe9JHC34//
X-Received: by 2002:a05:600c:3b82:b0:401:c717:ec69 with SMTP id n2-20020a05600c3b8200b00401c717ec69mr3259464wms.4.1695238110723;
        Wed, 20 Sep 2023 12:28:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHC/3eRSn3QzZSw6ZL/D6Q3u0rAJYv/l0qZZNRF7wGLumezCHJEenLyGXXp5lx4r3rns5pBuA==
X-Received: by 2002:a05:600c:3b82:b0:401:c717:ec69 with SMTP id n2-20020a05600c3b8200b00401c717ec69mr3259447wms.4.1695238110442;
        Wed, 20 Sep 2023 12:28:30 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id w26-20020a17090633da00b00988be3c1d87sm9668882eja.116.2023.09.20.12.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 12:28:29 -0700 (PDT)
Message-ID: <47d61eebc85999dbd2f5b7a038b00723dea70cae.camel@redhat.com>
Subject: Re: [PATCH nft 7/9] expression: cleanup expr_ops_by_type() and
 handle u32 input
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 20 Sep 2023 21:28:29 +0200
In-Reply-To: <ZQs2Pmq6J5ZdXDQb@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
         <20230920142958.566615-8-thaller@redhat.com> <ZQs2Pmq6J5ZdXDQb@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-20 at 20:13 +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 20, 2023 at 04:26:08PM +0200, Thomas Haller wrote:
> >=20
> > -const struct expr_ops *expr_ops_by_type(enum expr_types value)
> > +const struct expr_ops *expr_ops_by_type_u32(uint32_t value)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* value might come from unr=
eliable source, such as "udata"
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * annotation of set keys.=
=C2=A0 Avoid BUG() assertion.
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (value =3D=3D EXPR_INVALI=
D || value > EXPR_MAX)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (value > (uint32_t) EXPR_=
MAX)
>=20
> I think this still allows a third party to set EXPR_INVALID in the
> netlink userdata attribute, right?
>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return NULL;
> > -
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return __expr_ops_by_ty=
pe(value);
> > =C2=A0}

Yes, it still allows that. It's handled by the following
__expr_ops_by_type(), which returns NULL for invalid types (like
EXPR_INVALID).

The check "if (value > (uint32_t) EXPR_MAX)" is only here to ensure
that nothing is lost while casting the uint32_t "value" to the enum
expr_types.


Thomas

