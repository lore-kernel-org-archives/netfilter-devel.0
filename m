Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21727EE4982
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 17:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347900AbjHRRk5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 13:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379262AbjHRRk0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 13:40:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA8835BD
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 10:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692380376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCsAW3xHnk6he0aF6shLvoZpvJaVzBApd5s0QHfpT5w=;
        b=VhaeqMhugHMQTHE+5paK7vrSUScUxXpxyE401O0lDAi9rZ/pMvNLBdlKLoa4BakC7OHlj7
        wbVW4sgZmU01D27kS9p9Cu3vC90YS1VQpEeX3sujO7QiViis/y6lFgCrrQW3beuyX9CS1C
        iqOb1fA3QxfSFRCx6rKmltZ5XZsw5ek=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-3bgbRaAhM9qAC6wUuo48tA-1; Fri, 18 Aug 2023 13:39:34 -0400
X-MC-Unique: 3bgbRaAhM9qAC6wUuo48tA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fe246ec511so2461225e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 10:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692380373; x=1692985173;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OCsAW3xHnk6he0aF6shLvoZpvJaVzBApd5s0QHfpT5w=;
        b=cWMgDL+NP/7EDa2banriM5pYmlJnfJhW4XzmobIFNHNNCdRCrjPL5KNciPvJ3WJ0CC
         +rg+EE7MHd9pA0HrSXzeqENNuE8+eDCFfgBKjOOLRUAicdcrFs6D+kVEUUI+qFmpoQDH
         kSXmrqgbB9hSWfTk3xOgFjNgwNXCysZDnvPGJKSTzX64dztzfNsXAWc9395A1SABAT6b
         H9QScgRCMMQGcfbuWF0PonVzFlmJTlGyXjHf+MikStckWxHUcjbBF7R1UiKjB0yeYozd
         tJW/uG6lhSMxSZNc8tJCooKObTCN6DRgFWfArGoLoKiSdxFbWecb0ZNRXoxgmfq0uMCr
         Uyzw==
X-Gm-Message-State: AOJu0YxMsFiPxHouhghGo6EIrAjZjS75+BWZmLDmbfhuhW07rhhMu7Im
        LT2HKiopTHw6ItRBbUcmeM1cT2OZi7/nCMzOg3oa8HpC0B6MGCu/WcR6NVNlZHDalc1kR3XR3do
        Bh7HnQtuFsztUhjygFZW7af9HmOTe
X-Received: by 2002:a05:600c:1d1d:b0:3fe:5228:b77d with SMTP id l29-20020a05600c1d1d00b003fe5228b77dmr2635809wms.3.1692380373460;
        Fri, 18 Aug 2023 10:39:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhBBM0wVAwlAYY44H5nIB39JABxBBe42HrS4i5Acad6cKhonopVtzHMEjPq83JGl9E2JdyIg==
X-Received: by 2002:a05:600c:1d1d:b0:3fe:5228:b77d with SMTP id l29-20020a05600c1d1d00b003fe5228b77dmr2635802wms.3.1692380373202;
        Fri, 18 Aug 2023 10:39:33 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id c24-20020a05600c0ad800b003fbdbd0a7desm2489057wmr.27.2023.08.18.10.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 10:39:32 -0700 (PDT)
Message-ID: <bb3935579c7492373e76f8e71f4a739bcb7fcda4.camel@redhat.com>
Subject: Re: [nft PATCH v3 0/3] src: use reentrant
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 18 Aug 2023 19:39:31 +0200
In-Reply-To: <ZN+Yf0rQ/W+zkpI0@calendula>
References: <20230818141124.859037-1-thaller@redhat.com>
         <ZN+Yf0rQ/W+zkpI0@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-08-18 at 18:12 +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 18, 2023 at 04:08:18PM +0200, Thomas Haller wrote:
> > Changes since version 2:
> >=20
> > - split the patch.
> >=20
> > - add and use defines NFT_PROTONAME_MAXSIZE, NFT_SERVNAME_MAXSIZE,
> > =C2=A0 NETDB_BUFSIZE.
> >=20
> > - add new GPL2+ source file as a place for the wrapper functions.
>=20
> Series LGTM. I would just collapse patch 1 and 2, I can do that
> before
> applying if you like. Or you send v4 as you prefer.

Hi Pablo,


if you are OK with applying it (and mangling it first), please go
ahead.

Thank you!!
Thomas

