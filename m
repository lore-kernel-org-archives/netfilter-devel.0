Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6E8C83F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 16:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjH1Qq0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 12:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjH1Qpy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 12:45:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F37132
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 09:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693241105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GnSqoANbLnyyu6igTLH5DbWIg9UnzFoldxifRVS1CeU=;
        b=NMeDbRIICWDjsyMMw7m4qKStQeB5BPg1y3ltQiQ4xNX+rBLoAG9NNGMHcERaH7S77vhQ44
        oYIgP1g7XgOWFYX+TAp01wTPF8M+j1bqI4i4Nk88V1uXKNtfNDHhGKeQg241sh6O1PjkG+
        JF/mALtJLGVbsY3sybi0+/5PAhN3BaE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-TUyXOKepNx6KsmfVsV0Rpg-1; Mon, 28 Aug 2023 12:45:03 -0400
X-MC-Unique: TUyXOKepNx6KsmfVsV0Rpg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fee6743e50so4018765e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 09:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693241102; x=1693845902;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GnSqoANbLnyyu6igTLH5DbWIg9UnzFoldxifRVS1CeU=;
        b=PNhtJBaXhWkRvmpkfGyJ3FAC5WlHNqyjV4hubWCkb3hMShIEXsivtGZCaLYSDQPHKV
         uny4jQXme5Bm541la2mFV6hwsgvUDSye4ixXd6KdlIGPVsBFHC7C7SJZCttNNBDRy3Oi
         TzT4i0EU9OkgMqqmZjGIkZBE0hH5BzS+/oYtETv+ryl57IsQHqYEwT0j16t1RU2YC7ru
         DlSD7yh+wZ5/U3x8yo2TZ8KqMbxRIQlMiG8FjDnacN2ipsyKHqOaJ/xYLgs7Ji/4OzYu
         MtN6uDFYbh1K1GMR0nS+M3V+hu0/BkbGpHqZr86f9XW+N9y/lnjRkEMEWx7qCZO/wBmO
         LzUw==
X-Gm-Message-State: AOJu0Yyn6I0Xr/PBfNhYv+ZlXgyVmSFP8rP2ICaD2YkF5q8OWOewBP2I
        UZUst7pkJTANS+euekbrG6rCAdsekd3Ir2VK5S68Le0R1fPnhEwauG8lN0EZ3G4lklhK/sNcE/i
        b28V4DTR8gtCSx6I3LK4dhRs9/DP9
X-Received: by 2002:adf:f183:0:b0:317:3a23:4855 with SMTP id h3-20020adff183000000b003173a234855mr17707180wro.2.1693241102297;
        Mon, 28 Aug 2023 09:45:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNrPVR4O4JvkLkLBweXwM3fiE16RGk8CQad+Ioo3/otpZ8nljOIuVqzn+rJbj3VY2GnWm0/A==
X-Received: by 2002:adf:f183:0:b0:317:3a23:4855 with SMTP id h3-20020adff183000000b003173a234855mr17707171wro.2.1693241101931;
        Mon, 28 Aug 2023 09:45:01 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d6609000000b0030647449730sm10981356wru.74.2023.08.28.09.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 09:45:01 -0700 (PDT)
Message-ID: <31efcb8e9ceac6f71003abd9517cca981550fc91.camel@redhat.com>
Subject: Re: [PATCH nft 5/8] src: rework SNPRINTF_BUFFER_SIZE() and avoid
 "-Wunused-but-set-variable"
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Mon, 28 Aug 2023 18:45:00 +0200
In-Reply-To: <ZOzFgtwJI6AasAYZ@calendula>
References: <20230828144441.3303222-1-thaller@redhat.com>
         <20230828144441.3303222-6-thaller@redhat.com> <ZOy5nTEQJvu7zdrx@calendula>
         <aa481d83b0320078a17bebf215378992a4f7cb21.camel@redhat.com>
         <ZOzFgtwJI6AasAYZ@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2023-08-28 at 18:04 +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 28, 2023 at 05:49:53PM +0200, Thomas Haller wrote:
> > On Mon, 2023-08-28 at 17:13 +0200, Pablo Neira Ayuso wrote:
>=20
> > SNPRINTF_BUFFER_SIZE() rejects truncation of the string by
> > asserting
> > against it. That behavior is part of the API of that function.
> > Error
> > checking after an assert seems unnecessary.
> >=20
> > The check "if (len =3D=3D NF_LOG_PREFIXLEN)" seems wrong anyway. After
> > truncation, "len" would be zero. The code previously checked
> > whether
> > nothing was appended, but the error string didn't match that
> > situation.
> >=20
> > Maybe SNPRINTF_BUFFER_SIZE() should not assert against truncation?
>=20
> IIRC, the goal for this function was to handle snprintf() and all its
> corner cases. If there is no need for it or a better way to do this,
> this is welcome.
>=20

I think the macro is sensible (at least, after some cleanup).

It makes a choice, that the caller must ensure a priori that the buffer
is long enough (by asserting).

By looking at the callers, it's not clear to me, whether the callers
can always ensure that.  For meta_key_parse(), it seems the maximum
string is limited by meta_templates. But for stmt_evaluate_log_prefix()
it may be possible to craft user-input that triggers the assertion,
isn't it?

Maybe the macro and the callers should anticipate and handle
truncation?


Thomas

