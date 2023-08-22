Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66607EE4996
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 15:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbjHVPQL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbjHVPQL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 11:16:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D0CD2
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 08:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692717319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XaWvCljYeSrofr5/PbOGKe4C6yPU6STnRM4+E9CkTLQ=;
        b=hteq0REm+q9DvEouWPTgT9KWGnGYJVMMSDfcUbTCMNDf5sMMdaRNZwmw5+TXwttDozcxOX
        JQeW4V2OaDMlA+J1+0J2nf8bk4QfdJU+zcgbN76tUntxnvXVTJnYyRxvziyj04qmKE7c3H
        aKBKkJpbb1uPsNuRK9UjXThLMzG36kc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-If9CsEtxN6q-qdZym_p8KA-1; Tue, 22 Aug 2023 11:15:18 -0400
X-MC-Unique: If9CsEtxN6q-qdZym_p8KA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fef7a0509bso2084005e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 08:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692717316; x=1693322116;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XaWvCljYeSrofr5/PbOGKe4C6yPU6STnRM4+E9CkTLQ=;
        b=jIOTOjS7yJ3tFS+3TBNou1wsYGmytNWVsx/IiYH5eshHe5xAiyRH8EjrT6DDmhtmtJ
         +88/Bewjx3lL6njik8DbZvQtgYayYoFyEwMHMIFKYPaxDIj7XtPU7VL+oBdws3LQBbHh
         pa2yhxHKqr0tXQMrQTu1c6F4BJVhQP/u5emhHR/R4FR3ODYTnqEXP6xHaNuI89HSRuZJ
         ZQJnp50izL8jy2Rk9UV3l7VzVcMGihGva5Tb2tVLv08DkySkIPVCNizqT12Z01KKna+s
         hZkXZ2IdA8cXfifTnFKTL9Nt+Gzf4UfWjKuzCmjhyOQnZ7h+sB69OSTIjwDoUnWQ5CjZ
         Au3g==
X-Gm-Message-State: AOJu0YwB8IXmmqv3c+muyPvXtkuqaV1rEmtxEPPGXgAY3fKy/NPkz7PB
        MIw9ICRDyy/Vh56qaJbrYhYZq8ljRdB4OLmk/M9NULMNa4OkG9+EUqZVL9M36ZcgWR6pY0Yi8Pk
        xfLLbg53EQuNjclFCNV1bsvKSx60ihTliWndA
X-Received: by 2002:a05:600c:8516:b0:3fe:5228:b77d with SMTP id gw22-20020a05600c851600b003fe5228b77dmr7839399wmb.3.1692717316562;
        Tue, 22 Aug 2023 08:15:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdvw1ZUEb+l7+SkxAJuLuRTK8e0qTh2XRQnEGl0L5NHp7A/rr5GLW40kWGLvAn78TUL6N82w==
X-Received: by 2002:a05:600c:8516:b0:3fe:5228:b77d with SMTP id gw22-20020a05600c851600b003fe5228b77dmr7839391wmb.3.1692717316210;
        Tue, 22 Aug 2023 08:15:16 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id c1-20020a7bc001000000b003fee567235bsm12004149wmb.1.2023.08.22.08.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 08:15:15 -0700 (PDT)
Message-ID: <ba3ff8dcecbd37a3e59c30dc26fd4e8fc6734352.camel@redhat.com>
Subject: Re: [nft PATCH 2/2] meta: use reentrant localtime_r()/gmtime_r()
 functions
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 22 Aug 2023 17:15:14 +0200
In-Reply-To: <f5680cd01051242a87f768f5770b062c199971b1.camel@redhat.com>
References: <20230822081318.1370371-1-thaller@redhat.com>
         <20230822081318.1370371-2-thaller@redhat.com> <ZOR3za+Z+1X0VnIo@calendula>
         <f5680cd01051242a87f768f5770b062c199971b1.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-08-22 at 13:39 +0200, Thomas Haller wrote:
> On Tue, 2023-08-22 at 10:54 +0200, Pablo Neira Ayuso wrote:
>=20
>=20
> nftables calls localtime_r() from print/parse functions. Presumably,
> we
> will print/parse several timestamps during a larger operation, it
> would
> be odd to change/reload the timezone in between or to meaningfully
> support that.
>=20
>=20
> I think it is all good, nothing to change. Just to be aware of.
>=20

Thinking some more, the "problem" is that when we parse a larger data,
then multiple subfields are parsed. Thereby we call "time()" and
"localtime()" multiple times. The time() keeps ticking, and time and tz
can be reset at any moment -- so we see different time/tz, in the
middle of parsing the larger set of data.

What IMO should happen, is that for one parse operation, we call such
operations at most once, and cache them in `struct netlink_parse_ctx`.


Is that considered a problem to be solved? Seems simple. Would you
accept a patch for that?


Thomas

