Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58579C001B0
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 20:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjHHUiS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbjHHUiE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 16:38:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6341FEF5
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 13:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691525124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pst9YototNGkE1+XuIwEVyfGzjci8GwPQJOF6uNyO4I=;
        b=Vf2jEpAngqAyqk2JZd9sDuyGd3PKUPcSDLGQ9Guoeixh8yDx4RI3n03g3EG8b/q063zVMb
        tZafurnyj2sG9eIMQC7pPi6Wl5r15Ty/oL4ZrUTug2ldGwo1NIpTijZ8wRgnqQZ619vBXi
        QAdaZmPHcs62kQEVLz263kfX8YSOCLc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-UfARHuwiOGm-UxbmCOJ-AA-1; Tue, 08 Aug 2023 16:05:23 -0400
X-MC-Unique: UfARHuwiOGm-UxbmCOJ-AA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3176f5796ecso409990f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2023 13:05:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691525121; x=1692129921;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pst9YototNGkE1+XuIwEVyfGzjci8GwPQJOF6uNyO4I=;
        b=akown+GL805FWQ//htowU1n2SqyYLxUlXN3ZRj+OcdK0AejH17Duwq0BGh++kaqRV7
         +GAG7PTAem4mUgo51PO6PDqXpHj9HPplwfmPrTZ3WL7CeVFfb2JfHoZj90cd3bew5f4i
         LE53Whrqsr2RukDhWH5G/k75lmeeobrErrMxaQ8KdsyX9vkBYhgW2BTwvUuPMuz2DtBn
         ii6y+qM/Qu51ekvZMP8mKZvvhhdvoOtmdfhgYccTF8kEII4T8/f0QJ/X4u1xzKFNQBew
         UbzuFLSJBFapJ/peDsZKFiNsUqNKMmfZDzgDgc6YTD4kuVWzoaZmiXYxEM33adeXitGM
         7aWw==
X-Gm-Message-State: AOJu0YwqmhR3L+UhiKKz6HeM/LmVmOMaYHeZGpaOj5ujU7Nmmi3V5pyK
        s4WgtRLjiwwXbiIjjXFE5z45dfAejVY1R7UjlkYG+r8WO2Sb5kFxJ69OknsVEeFdFxxg7k3ny2J
        nmdD2ASXG2kotPSnuBzUVIOGiuDZO4dCLHGfL
X-Received: by 2002:adf:e447:0:b0:317:3d36:b2c1 with SMTP id t7-20020adfe447000000b003173d36b2c1mr317046wrm.7.1691525121384;
        Tue, 08 Aug 2023 13:05:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDTgNY2xqyoBCDcIqkorprhHIAChzf5kwJGDYcn59MQ8mtNAseP/6qxEFmC2yYTpBhiKhftQ==
X-Received: by 2002:adf:e447:0:b0:317:3d36:b2c1 with SMTP id t7-20020adfe447000000b003173d36b2c1mr317042wrm.7.1691525121023;
        Tue, 08 Aug 2023 13:05:21 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.180.70])
        by smtp.gmail.com with ESMTPSA id s11-20020adff80b000000b003179d5aee63sm14495114wrp.91.2023.08.08.13.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 13:05:20 -0700 (PDT)
Message-ID: <e095b0fe0c6db0eaafb8072abfa5102a55f9df41.camel@redhat.com>
Subject: Re: [nft PATCH v4 2/6] src: add input flag NFT_CTX_INPUT_NO_DNS to
 avoid blocking
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 08 Aug 2023 22:05:19 +0200
In-Reply-To: <ZNJCFNlZ8bHuJOkl@orbyte.nwl.cc>
References: <20230803193940.1105287-1-thaller@redhat.com>
         <20230803193940.1105287-5-thaller@redhat.com>
         <ZNJCFNlZ8bHuJOkl@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-08-08 at 15:24 +0200, Phil Sutter wrote:
> On Thu, Aug 03, 2023 at 09:35:16PM +0200, Thomas Haller wrote:
> > getaddrinfo() blocks while trying to resolve the name. Blocking the
> > caller of the library is in many cases undesirable. Also, while
> > reconfiguring the firewall, it's not clear that resolving names via
> > the network will work or makes sense.
> >=20
> > Add a new input flag NFT_CTX_INPUT_NO_DNS to opt-out from
> > getaddrinfo()
> > and only accept plain IP addresses.
>=20
> This sounds like user input validation via backend. Another way to
> solve
> the problem at hand is to not insert host names into the rules(et)
> fed
> into libnftables, right?

Right. More generally, ensure not to pass any non-addresses in JSON
that would be resolved.

Which requires that the user application is keenly aware, understands
and validates the input data. For example, there couldn't be a "expert
option" where the admin configures arbitrary JSON.

And that the application doesn't make a mistake with that ([1]).

[1] https://github.com/firewalld/firewalld/commit/4db89e316f2d60f3cf856a702=
5a96a61e40b1e5a

Thomas

