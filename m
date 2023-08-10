Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2A8C001DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 08:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbjHJIo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 04:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbjHJIoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 04:44:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461AC10C7
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 01:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691657023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVBu0xRPGmQCiVwmL1q6SlMJtYqVQ4U0woGw6YF8R5Q=;
        b=gR6NOZK2jKFimVAXH6aLn2CAQW/SI25eFgmiomWUNuPHQ7MARA+MWXwW2EIR7cKljAVqJW
        MangonFI24K/xs/VJ0XXkNWCVSy8LpXpSN2PT9ctlrJAvfTdeBHqqbpk3Q6nsk2/7qfHXX
        clUmxUL7PiDHMQIM/EAmdImFugzDVh0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-iwPz5WyhPnWlljsIidT8wA-1; Thu, 10 Aug 2023 04:43:41 -0400
X-MC-Unique: iwPz5WyhPnWlljsIidT8wA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-31749c6bfa6so104649f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 01:43:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691657020; x=1692261820;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OVBu0xRPGmQCiVwmL1q6SlMJtYqVQ4U0woGw6YF8R5Q=;
        b=WeeJZcuYUwNaWp2yECur5Ja7dybMoYv0g8hE/jxWJDKujTa2MO+YCFAxE9InUL7yxg
         bRVUX70YSoSHDNT4kr5WzFNqIuLaLM19zQVKvbGwcwJTVvWalohlGfE5PEjQ/rntwfFb
         igL7BIpEVuxAlOTiWegJ4icBroz7ceYSYd5bpeJl2k+meDcfAAahQq2BqeFVc4QSq/c3
         4MArxmSspcpzoIa+1sAaSatjYVpU80Qdh0TO/j9gLkuggkxC4NZS6zrsRrRJaqshhAI9
         Uw6/k0FzDGArrUeFX6Y7Lfy77Ext0BBrqc6h1rTbU4AGVj1ey8U/0A1pX4FQlObgJA3E
         6zGw==
X-Gm-Message-State: AOJu0YyXMzv87IJh6nvSxpP2RLz7M2QI79I7jM1GIdx1LCHK7rOpeM2z
        +wpkpcmacmZERtTgI5vC5tXhKi46gscuOazfqz9JOy8XrWKAgpUWOJ2HaiZTd460YrFQrWF2fP+
        8bggvixIkiHJhmbcU/amPFaggsbHW1zYFpe2f
X-Received: by 2002:adf:d087:0:b0:317:630d:1e8e with SMTP id y7-20020adfd087000000b00317630d1e8emr1437794wrh.2.1691657020482;
        Thu, 10 Aug 2023 01:43:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGE0zJtsVetjP1X3Z9adM1g5DqZ8/KijQR0AAOix+vkprRb2yphFvTPWJDurBbWQxiwN0dPXg==
X-Received: by 2002:adf:d087:0:b0:317:630d:1e8e with SMTP id y7-20020adfd087000000b00317630d1e8emr1437785wrh.2.1691657020065;
        Thu, 10 Aug 2023 01:43:40 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.180.70])
        by smtp.gmail.com with ESMTPSA id v2-20020a5d6102000000b003141e629cb6sm1371553wrt.101.2023.08.10.01.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 01:43:39 -0700 (PDT)
Message-ID: <7f3848f6d52a2521df8bd1ee01b2fdb0af9b57a1.camel@redhat.com>
Subject: Re: [nft PATCH v4 2/6] src: add input flag NFT_CTX_INPUT_NO_DNS to
 avoid blocking
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 10 Aug 2023 10:43:38 +0200
In-Reply-To: <ZNSVo9Um6T0fgqXA@orbyte.nwl.cc>
References: <20230803193940.1105287-1-thaller@redhat.com>
         <20230803193940.1105287-5-thaller@redhat.com>
         <ZNJCFNlZ8bHuJOkl@orbyte.nwl.cc>
         <e095b0fe0c6db0eaafb8072abfa5102a55f9df41.camel@redhat.com>
         <ZNNoUHB/i7rxPXS1@orbyte.nwl.cc>
         <b1829e8f312b2e626dc4efefdc1d666044405552.camel@redhat.com>
         <ZNSVo9Um6T0fgqXA@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, 2023-08-10 at 09:45 +0200, Phil Sutter wrote:
> On Wed, Aug 09, 2023 at 09:17:36PM +0200, Thomas Haller wrote:
>=20
>=20
> >=20
> > It seems prudent that libnftables provides a mode of operation so
> > that
> > it doesn't block the calling application. Otherwise, it is a
> > problem
> > for applications that care about that.
>=20
> Hmm. In that case, one might also have to take care of calls to
> getprotobyname() and maybe others (getaddrinfo()?). Depending on
> nsswitch.conf it may block, too, right?

getaddrinfo() is avoided by NFT_CTX_INPUT_NO_DNS.

... except at one place in `inet_service_type_parse()`, where
getaddrinfo() is used to parse the service. I don't think that has any
reason to block(*), has it?.

getprotobyname() also should not block(*)  as it merely reads
/etc/protocols (in musl it's even hard-coded).


(*) reading from /etc or talking netlink to kernel is sufficiently fast
so I consider it "non-blocking".


In the first version, the flag was called NFT_CTX_NO_BLOCK. It had the
goal to avoid any significant blocking. The flag got renamed to
NFT_CTX_INPUT_NO_DNS, which on the surface has the different goal to
only accept plain IP addresses.

If there are other places that still can block, they should be
identified and addressed. But that's then separate from NO_DNS flag.


>=20
> > > > And that the application doesn't make a mistake with that
> > > > ([1]).
> > > >=20
> > > > [1]
> > > > https://github.com/firewalld/firewalld/commit/4db89e316f2d60f3cf856=
a7025a96a61e40b1e5a
> > >=20
> > > This is just a bug in firewall-cmd, missing to convert ranges
> > > into
> > > JSON
> > > format. I don't see the benefit for users which no longer may use
> > > host
> > > names in that spot.
> >=20
> > Which spot do you mean? /sbin/nft is not affected, unless it opts-
> > in to
> > the new flag. firewalld never supported hostnames at that spot
> > anyway
> > (or does it?).
>=20
> I'm pretty sure it does, albeit maybe not officially.

That would be important to verify. I will check, thank you.



Thomas

