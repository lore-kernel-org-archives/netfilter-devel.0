Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CD5EB8FD7
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 11:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239825AbjIHLvn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 07:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjIHLvm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 07:51:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756B519BC
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 04:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694173851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PFxAp5/ON7wxJQP/f0Vbk0+z4iPD48ZiLfZ/hHivOsQ=;
        b=AQ5of+8q0do7ORgyl6WdtzD3z28QBELMzOaYipTNzWXJ7ME9ZLcEgwL4u+2mesxsbEYkpg
        4w3G7jcN0SHElRoyzz6fen74LYWzSCJiynTi2jBPMfSholV2FPhIAvRFSRnsipizSZn2wM
        Js8e2jlEplt7f6j39CKf/K8xB1KLZS4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-GpFwBykKPTWCiGvBiFgjtg-1; Fri, 08 Sep 2023 07:50:50 -0400
X-MC-Unique: GpFwBykKPTWCiGvBiFgjtg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4020114f05bso5544795e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Sep 2023 04:50:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694173848; x=1694778648;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PFxAp5/ON7wxJQP/f0Vbk0+z4iPD48ZiLfZ/hHivOsQ=;
        b=UHEa/OMx88UMIOsr0/cWT4+dmT1LTzWSZAIzF3T4QOUDGw9tFpCz1f1OCdadNS1yLe
         7U9os4nyg4o3c5DwpRSjmigjOnr/E4JUq+TeTYYs/7beTrPbxAl1LSMB3RG75Htk0e50
         79PMheG1SIhDSC0vE+NtL770h80bRHUiucaDNmTQwOzf4BKcHpNG3bdLtxjsfQPWCML6
         GKHR178RN+zhtFLA1d/r1ZTJ9CMTjzcZr8TiE9JJWxlqnscp0kw8nVsElFHqJvjUcypI
         +6pasz3BeCnyVecdwpoLVRnb3A0j0dhTACQ0n+PJrrz/jUxLNNnnuf054X1FCmoy78TW
         E9Zw==
X-Gm-Message-State: AOJu0YwxzeUqnHiYwv/Q+HlmwBe9Y10WMXbf5UGP+gmegZV53IG1rXCk
        J6XFILVF2fYIqzbET6xFc9NmkyWkRZ+96M+gibIo/MQOVaSoD8a5jmecUS43q8wzZj1NlzpPJ1x
        Z/3msSvhcoO2WpjA1s5l/uT1LE7ZMLaocdh/0
X-Received: by 2002:a05:600c:1c20:b0:3fe:21a6:a18 with SMTP id j32-20020a05600c1c2000b003fe21a60a18mr2005404wms.3.1694173848632;
        Fri, 08 Sep 2023 04:50:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDsOF6VbUmsO8Xbm6i9w3sa9VB85mH/aoKqAVuAdrI5tBNighd5hPijZaU43KEpxidX9m+5w==
X-Received: by 2002:a05:600c:1c20:b0:3fe:21a6:a18 with SMTP id j32-20020a05600c1c2000b003fe21a60a18mr2005388wms.3.1694173848335;
        Fri, 08 Sep 2023 04:50:48 -0700 (PDT)
Received: from [10.0.0.168] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id c26-20020a7bc01a000000b003feeb082a9fsm1823190wmb.3.2023.09.08.04.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Sep 2023 04:50:47 -0700 (PDT)
Message-ID: <abf258a4f449cd7f4e98fe7094bc46104351f9ac.camel@redhat.com>
Subject: Re: [PATCH nft 5/6] build: drop recursive make for
 "examples/Makefile.am"
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 08 Sep 2023 13:50:47 +0200
In-Reply-To: <ZPsA1x32YIAMAlR8@orbyte.nwl.cc>
References: <20230825113042.2607496-1-thaller@redhat.com>
         <20230825113042.2607496-6-thaller@redhat.com>
         <ZPsA1x32YIAMAlR8@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-09-08 at 13:09 +0200, Phil Sutter wrote:
> On Fri, Aug 25, 2023 at 01:27:37PM +0200, Thomas Haller wrote:
> [...]
> > +check_PROGRAMS +=3D examples/nft-buffer
> > +
> > +examples_nft_buffer_AM_CPPFLAGS =3D -I$(srcdir)/include
> > +examples_nft_buffer_LDADD =3D src/libnftables.la
> > +
> > +check_PROGRAMS +=3D examples/nft-json-file
> > +
> > +examples_nft_json_file_AM_CPPFLAGS =3D -I$(srcdir)/include
> > +examples_nft_json_file_LDADD =3D src/libnftables.la
>=20
> Does this replace or extend AM_CPPFLAGS/LDADD for the example
> programs?
> IOW, do the global AM_CPPFLAGS added in the previous patch leak into
> the
> example program compile calls or not?
>=20
> Cheers, Phil
>=20


Replace.


Described here:
https://www.gnu.org/software/automake/manual/html_node/Flag-Variables-Order=
ing.html

Basically, if you explicitly define CFLAGS,CPPFLAGS,LDFLAGS,etc for a
target like

inst_LTLIBRARIES =3D /path/to/libtarget.la
path_to_libtarget_CPPFLAGS =3D -ABC

then this gets build with $(path_to_libtarget_CPPFLAGS) $(CPPFLAGS).

Otherwise, it gets $(AM_CPPFLAGS) $(CPPFLAGS)



Thomas

