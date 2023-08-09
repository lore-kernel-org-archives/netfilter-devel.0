Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AFCC04FE0
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 19:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbjHITSs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 15:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjHITSs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 15:18:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B74E2D5B
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Aug 2023 12:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691608662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hN4QoHp0Ty1xNt3x1UdCqzRwk6mg3iCwpL0p8tFJMPw=;
        b=D7OArMD6nvEh1Bwr1RsK75zmtxghfghik4thTBsdbMXd7fLvnHI69y0RgyXu+EL8bj68yC
        D9MsusGlEuWAevev8SHo0X/na5NjuedTSdaOMCLEFl4OfScU/VZWFe6UL1eXaIBs1XXgXl
        fvG9BhBYlq0WJZjmGKhEnNe2oB3ONAE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-CSDrD79uN6ej4bzYx1G_HQ-1; Wed, 09 Aug 2023 15:17:40 -0400
X-MC-Unique: CSDrD79uN6ej4bzYx1G_HQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-317cc34e897so28218f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Aug 2023 12:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691608659; x=1692213459;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hN4QoHp0Ty1xNt3x1UdCqzRwk6mg3iCwpL0p8tFJMPw=;
        b=Krc1jG5kBafZ5o5oOFr0BUyNBzXHKqVlPQQle2HPKc2jxZQYjKYB25qdmX0Q7Qq32j
         lzN2lL1HAxPwcG4lCIZioFaN6MLl4dkWzlwV4JWGt8bE1qvaxoX7eGOSaie2tbom+IWB
         Nd3KDeqMxHEqmxI/jdawNMbeY/qimdFNKT3qVD57plzhdi6N29RrRLNMdGGpo5Kj8pGr
         uTbjK3307l6q7dzOtHlxMI21IFzABwOBDHvoBO55F1oGv3cqpRzO0HqFd9RtEZHQ8N+/
         +c2IIC8wSDH3IqaQwUJbb6lP/tAO1WaMH7PLZFeqvNiz0mLrWPWHfOYZdi7um7fglUll
         Dm5w==
X-Gm-Message-State: AOJu0Yz+DBesN+44Bh8w5dA4jZE8MkzmGBVyZ6L1rrnRUdyFgpVSl/gS
        oMDdg8zeZ66sCjQRGf8loO87Uxo3qqpZIXTeFpoUCClaMXs+AyWNmc6qpp0yTMtvipXfumAXyEF
        iSZDuyEcXnV22ERriWPvWGoVTZLUJSFKv1NZN
X-Received: by 2002:a5d:558d:0:b0:316:f32c:b156 with SMTP id i13-20020a5d558d000000b00316f32cb156mr200036wrv.6.1691608658999;
        Wed, 09 Aug 2023 12:17:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1crOLi/g0YNh7PYlgWAg57iHIxrqDcieI+b0Gie+PNF1G2MpHfo0jmgVQLCIQ3jpUPqbfHg==
X-Received: by 2002:a5d:558d:0:b0:316:f32c:b156 with SMTP id i13-20020a5d558d000000b00316f32cb156mr200024wrv.6.1691608658689;
        Wed, 09 Aug 2023 12:17:38 -0700 (PDT)
Received: from [10.0.0.168] ([37.186.180.70])
        by smtp.gmail.com with ESMTPSA id r5-20020a056000014500b00317dd7b96e7sm13688300wrx.23.2023.08.09.12.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 12:17:38 -0700 (PDT)
Message-ID: <b1829e8f312b2e626dc4efefdc1d666044405552.camel@redhat.com>
Subject: Re: [nft PATCH v4 2/6] src: add input flag NFT_CTX_INPUT_NO_DNS to
 avoid blocking
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 09 Aug 2023 21:17:36 +0200
In-Reply-To: <ZNNoUHB/i7rxPXS1@orbyte.nwl.cc>
References: <20230803193940.1105287-1-thaller@redhat.com>
         <20230803193940.1105287-5-thaller@redhat.com>
         <ZNJCFNlZ8bHuJOkl@orbyte.nwl.cc>
         <e095b0fe0c6db0eaafb8072abfa5102a55f9df41.camel@redhat.com>
         <ZNNoUHB/i7rxPXS1@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, 2023-08-09 at 12:20 +0200, Phil Sutter wrote:
> On Tue, Aug 08, 2023 at 10:05:19PM +0200, Thomas Haller wrote:
> > On Tue, 2023-08-08 at 15:24 +0200, Phil Sutter wrote:
> > > On Thu, Aug 03, 2023 at 09:35:16PM +0200, Thomas Haller wrote:
> > > > getaddrinfo() blocks while trying to resolve the name. Blocking
> > > > the
> > > > caller of the library is in many cases undesirable. Also, while
> > > > reconfiguring the firewall, it's not clear that resolving names
> > > > via
> > > > the network will work or makes sense.
> > > >=20
> > > > Add a new input flag NFT_CTX_INPUT_NO_DNS to opt-out from
> > > > getaddrinfo()
> > > > and only accept plain IP addresses.
> > >=20
> > > This sounds like user input validation via backend. Another way
> > > to
> > > solve
> > > the problem at hand is to not insert host names into the
> > > rules(et)
> > > fed
> > > into libnftables, right?
> >=20
> > Right. More generally, ensure not to pass any non-addresses in JSON
> > that would be resolved.
>=20
> Well, detecting if a string constitutes a valid IP address is rather
> trivial. In Python, there's even 'ipaddress' module for that job.

firewalld messed it up, showing that it can happen.

>=20
> > Which requires that the user application is keenly aware,
> > understands
> > and validates the input data. For example, there couldn't be a
> > "expert
> > option" where the admin configures arbitrary JSON.
>=20
> Why is host resolution a problem in such scenario? The fact that
> using
> host names instead of IP addresses may result in significant delays
> due
> to the required DNS queries is pretty common knowledge among system
> administrators.


It seems prudent that libnftables provides a mode of operation so that
it doesn't block the calling application. Otherwise, it is a problem
for applications that care about that.


>=20
> > And that the application doesn't make a mistake with that ([1]).
> >=20
> > [1]
> > https://github.com/firewalld/firewalld/commit/4db89e316f2d60f3cf856a702=
5a96a61e40b1e5a
>=20
> This is just a bug in firewall-cmd, missing to convert ranges into
> JSON
> format. I don't see the benefit for users which no longer may use
> host
> names in that spot.

Which spot do you mean? /sbin/nft is not affected, unless it opts-in to
the new flag. firewalld never supported hostnames at that spot anyway
(or does it?).


Thomas

