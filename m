Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D199AEB64DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 10:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjGRKJA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 06:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjGRKIn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 06:08:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6804C130
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 03:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689674878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dqxntuz5AvQQ3092uxYIo+ShVkQoqqHoY0BrtDypkQI=;
        b=GJK8XMQvY6WPTRxXyiL8NIAVYz2u+B9n+ZzfKpJnhcWiveNe6BjIIxOSsr1+sebwyjWvVd
        kNHvKBnuUmPCxpI3+QBia1kFzWKr7AKU875gE0zQYL9lj87OVnZFkg/oRKsFUJRWSsw3H8
        jiZWy2NYSXtc0PhShjZ0+xJ/9AhnjH8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-90tjWWQ6P-2defbVRCnA5A-1; Tue, 18 Jul 2023 06:07:57 -0400
X-MC-Unique: 90tjWWQ6P-2defbVRCnA5A-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b04d5ed394so9510631fa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 03:07:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689674875; x=1690279675;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dqxntuz5AvQQ3092uxYIo+ShVkQoqqHoY0BrtDypkQI=;
        b=MYRKgEnzqjAs/ExmO4Pzt5RMhe2aGmpaSNE4OvUHxMCd39w7sJ65KYRpuz7WkR4MjI
         cZSfwjZeqQPfGTKYqssXcBx+apUCDHlVwkeeAktmxWfYcC/jI5pKOA6EealsvF+IkbIB
         ltkVKa1dl0yBuwFWN0DYYHuIoFIpXUGDMPjY8jtP8Kn10NO184FLNkiwdpipviDGj9A9
         p6sbr14W8RPWRCqSrRfqe1RZ53btB5Vp48tB+7zBBg0gAbnjQyfVzRyrue0qHcPQmKuG
         ZpW4qMkLKd00FlXx34U/CxgVQBHL14djfBj3ONgwkAEIeaV5HOstTlF6xcb1hQeJJ5n6
         RD0g==
X-Gm-Message-State: ABy/qLZTcl2OpCvBGlu93ZvAn9NVHce1m3i0anwZjkfhf+FFbsOz1PFC
        oV5mI9wwWRMcVS/oaSXuqb2ehKAqQZnVPaNbqlope94ExL5pSTJF3BshSg3OMmeja4IcQMwNmUB
        TGC7FPS8CznlRhTOkQZEvG8qKseFxUsmAq3bq
X-Received: by 2002:a05:651c:a06:b0:2b6:9ebc:d8c4 with SMTP id k6-20020a05651c0a0600b002b69ebcd8c4mr7905437ljq.0.1689674875496;
        Tue, 18 Jul 2023 03:07:55 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHhUuBXL8sSKINe7I5zo5rdMGj3yyDTMCRHwNE+TvHsMeSA/CX9j8mp6bEsgFBF7oBgLMHhzQ==
X-Received: by 2002:a05:651c:a06:b0:2b6:9ebc:d8c4 with SMTP id k6-20020a05651c0a0600b002b69ebcd8c4mr7905419ljq.0.1689674875113;
        Tue, 18 Jul 2023 03:07:55 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.189.9])
        by smtp.gmail.com with ESMTPSA id y12-20020a1709064b0c00b009929c39d5c4sm831265eju.36.2023.07.18.03.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 03:07:54 -0700 (PDT)
Message-ID: <69c557292b363e407b7dc1763f541d9f40b612bb.camel@redhat.com>
Subject: Re: [nft v2 PATCH 3/3] py: add input_{set,get}_flags() API to
 helpers
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue, 18 Jul 2023 12:07:54 +0200
In-Reply-To: <ZLEcjSPnc3PoN57E@orbyte.nwl.cc>
References: <ZKxG23yJzlRRPpsO@calendula>
         <20230714084943.1080757-1-thaller@redhat.com>
         <20230714084943.1080757-3-thaller@redhat.com>
         <ZLEcjSPnc3PoN57E@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-07-14 at 11:59 +0200, Phil Sutter wrote:
> Hi Thomas,
>=20
> On Fri, Jul 14, 2023 at 10:48:53AM +0200, Thomas Haller wrote:
> > Note that the corresponding API for output flags does not expose
> > the
> > plain numeric flags. Instead, it exposes the underlying, flag-based
> > C
> > API more directly.
> >=20
> > Reasons:
> >=20
> > - a flags property has the benefits that adding new flags is very
> > light
> > =C2=A0 weight. Otherwise, every addition of a flag requires new API.
> > That new
> > =C2=A0 API increases the documentation and what the user needs to
> > understand.
> > =C2=A0 With a flag API, we just need new documentation what the new fla=
g
> > is.
> > =C2=A0 It's already clear how to use it.
> >=20
> > - opinionated, also the usage of "many getter/setter API" is not
> > have
> > =C2=A0 better usability. Its convenient when we can do similar things
> > (setting
> > =C2=A0 a boolean flag) depending on an argument of a function, instead
> > of
> > =C2=A0 having different functions.
> >=20
> > =C2=A0 Compare
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0 ctx.set_reversedns_output(True)
> > =C2=A0=C2=A0=C2=A0=C2=A0 ctx.set_handle_output(True)
> >=20
> > =C2=A0 with
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0 ctx.ouput_set_flags(NFT_CTX_OUTPUT_REVERSEDNS =
|
> > NFT_CTX_OUTPUT_HANDLE)
> >=20
> > =C2=A0 Note that the vast majority of users of this API will just creat=
e
> > one
> > =C2=A0 nft_ctx instance and set the flags once. Each user application
> > =C2=A0 probably has only one place where they call the setter once. So
> > =C2=A0 while I think flags have better usability, it doesn't matter muc=
h
> > =C2=A0 either way.
> >=20
> > - if individual properties are preferable over flags, then the C
> > API
> > =C2=A0 should also do that. In other words, the Python API should be
> > similar
> > =C2=A0 to the underlying C API.
> >=20
> > - I don't understand how to do this best. Is Nftables.output_flags
> > =C2=A0 public API? It appears to be, as it has no underscore. Why does
> > this
> > =C2=A0 additional mapping from function (get_reversedns_output()) to
> > name
> > =C2=A0 ("reversedns") to number (1<<0) exist?
>=20
> I don't recall why I chose to add setters/getters for individual
> output
> flags instead of expecting users to do bit-fiddling. Maybe the latter
> is
> not as common among Python users. :)
>=20
> On the other hand, things are a bit inconsistent already, see
> set_debug() method.=20
>=20
> Maybe we could turn __{get,set}_output_flag() public and make them
> accept an array of strings or numbers just like set_debug()? If you
> then adjust your input flag API accordingly, things become consistent
> (enough?), without breaking existing users.
>=20
> FWIW, I find
>=20
> > ctx.set_output_flags(["reversedns", "stateless"])
>=20
> nicer than
>=20
> > ctx.set_output_flags(REVERSEDNS | STATELESS)
>=20
> at least with a Python hat on. WDYT?

Hi Phil,


I see set_debug().

So we can do:

   nft.set_debug("netlink")

or

   nft.set_debug(("netlink", "scanner"))

but to me, that is not an improvement over plain

   nft.output_set_debug(nftables.NFT_DEBUG_NETLINK | nftables.NFT_DEBUG_SCA=
NNER)

(which would be a thin layer over the underlying, documented C API).


I like set_debug() better than the __set_output_flag() approach,
because the flags are an argument of one function, instead of multiple
set-flag-xyz() functions. I don't like very much that

  - the "set_debug()" name does not resemble the underlying=C2=A0
    nft_ctx_output_set_debug() name.
  - it encourages using string literals as arguments (instead of=C2=A0
    Python=C2=A0constants which I can grep for and find with ctags).
  - it requires extra some code to translate from one domain=C2=A0
    (the list of names/ints)) to another (plain integer flags), when=C2=A0
    the user could just as well use the=C2=A0flags directly.

Anyway. I don't really mind either way. I will do whatever we agree
upon.


Thanks,
Thomas

