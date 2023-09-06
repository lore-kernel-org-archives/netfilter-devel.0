Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E15EB8FA5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 05:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240898AbjIFFqD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 01:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjIFFqC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 01:46:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9F010C3
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 22:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693979097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CePulaA3b8HjHd0g3NyB6jArjIXrg8OfnYBmh9El8Jc=;
        b=icMTDL5l2XPbhsXWribIazJnKC9rBQmTJlxgNJjevLb+ZTC8tKiPesQ4FaWFqNsNDNP2Ja
        aDd/hM3ZrkR2mXOHKgbmFM/atSA7F1MwOOCYdw3D4K/1mwrphUhaQgsyNfE6HuLKZMlJiG
        sqkbuDhXpzTYnrPf/ePYGGfDh12SzrE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-yKblL5OQP8qSA4TDwivM0g-1; Wed, 06 Sep 2023 01:44:56 -0400
X-MC-Unique: yKblL5OQP8qSA4TDwivM0g-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9a1aaaf6460so69655566b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Sep 2023 22:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693979095; x=1694583895;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CePulaA3b8HjHd0g3NyB6jArjIXrg8OfnYBmh9El8Jc=;
        b=MFbLZkx8xfacLa6OUUxu+1+qOa7vdU1AIamerWMoGbK9HqtK8JhvBB2zK0HwWmq5DE
         HBcvM5hmYynJ7JNomqIyyo+IapC51ayOZobzUv4sRVw4KA5XhxfwIX00gMGEXJB4/Sbb
         qOZzaDnZ4whcN0JM1WHLWC00+HoX1M6AeVuDblKnwqkbvBazu+HGbnVDtWTxf9vkv3Kq
         eX/HJ0qaWNS85+7zYQfYyTY86SopMqCxkJsO+ZA9/njY3W6MHRSoOQdEFavWgRVVYJfs
         1WppXoRKNZIcirYzhPLGVnZgClEZu9NlIH35HAjJ0ETRDJ5hUekzDXbaANdGlx7Wv8cx
         TcAQ==
X-Gm-Message-State: AOJu0Yya5KSIBT5hygJeYlgtAQ5CksgN0p2I2RRHfH+yv2JeYTaapn2D
        Y3YC6vgQI3cgc8LLs7OqKmhAsjCzCAh9CjoIRa+pQl96Bp4xyfX8o5g2DtRhvwAamewNbfhM0ee
        7MFqN7kL5tWBTz57tmJSFzOofbpjI
X-Received: by 2002:a05:6402:50cf:b0:522:e6b0:8056 with SMTP id h15-20020a05640250cf00b00522e6b08056mr10777984edb.4.1693979095360;
        Tue, 05 Sep 2023 22:44:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGN8+ATv8/91rTqcUDEbfWTM0p3T8yuwuiV45/EpNxdAbgmq9FIoeXpibXiJwbEbUgg+cOChg==
X-Received: by 2002:a05:6402:50cf:b0:522:e6b0:8056 with SMTP id h15-20020a05640250cf00b00522e6b08056mr10777978edb.4.1693979095044;
        Tue, 05 Sep 2023 22:44:55 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id f2-20020a056402150200b0052a3b212157sm7862845edw.63.2023.09.05.22.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 22:44:54 -0700 (PDT)
Message-ID: <7731edd7662e606a06b1d4c60fb4cff9096fa758.camel@redhat.com>
Subject: Re: [PATCH RFC] tests: add feature probing
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Date:   Wed, 06 Sep 2023 07:44:53 +0200
In-Reply-To: <20230904085301.GC11802@breakpoint.cc>
References: <20230831135112.30306-1-fw@strlen.de>
         <c322af5a87a7a4b31d4c4897fe5c3059e9735b4e.camel@redhat.com>
         <20230904085301.GC11802@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2023-09-04 at 10:53 +0200, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> >=20
> >=20
> > But why this "nft -f" specific detection? Why not just executable
> > scripts?
>=20
> Because I want it to be simple,

It does not seem "simple[r]" to me. The approach requires extra
infrastructure in run-test.sh, while being less flexible.


> I could do that, but I don't see the need for arbitrary scripts so
> far.

When building without JSON support, various tests fail, but should be
skipped.

Could we detect JSON support via .nft files? Would we drop then a JSON
.nft file and change the check call to `nft --check -j`?).

Or maybe detection of JSON support needs to be a shell script (doing
`ldd "$NFT_REAL" | greq libjansson`)? In that case, we would have
features-as-shell-scripts very soon.
  =20

Thomas

