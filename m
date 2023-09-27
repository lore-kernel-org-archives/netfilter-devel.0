Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B47E82CBB
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 17:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjI0RvW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 13:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI0RvV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 13:51:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B16CEB
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 10:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695837032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDVtvwCPUYXn+UBxhg2qmIlGeGaP+myEivvlsr8NFuM=;
        b=GjJXJL2hCOg06SpF7ra/QYXUK2xIQlNR3aHmsyulUbB0/2yggdp+4ZHj9fDOIvHiP5LrmB
        A+E3j2dIHwEGG2qGmdh3UaFvJiwlL9J1BdNGdzQbdEEZMybdyBVAfQ+AuntdOU/udzkHNA
        Ds4POszn4cfiG4nWniwqH+kmLHfMBKw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-LCqTP_2JNPSCWY8-MSUoAA-1; Wed, 27 Sep 2023 13:50:31 -0400
X-MC-Unique: LCqTP_2JNPSCWY8-MSUoAA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-51e535b143fso1701953a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 10:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695837029; x=1696441829;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NDVtvwCPUYXn+UBxhg2qmIlGeGaP+myEivvlsr8NFuM=;
        b=gUWlmDMBALF6NKkcmlp7vgjGyK4Gw6HYG8YqE/I6P83l/5ST4BJCqwq7msddOTcGmK
         j427Sbz+eugcuFEx1gJWMmmn0Zj/yrJ6rL1pZRSBK0YDBlPQJhTvJcYojShRXijPTo81
         ysZYlgjaxyOex+j4MIDtGIEGi5BMhHl3vxQTRRFTQHAzgGZLBc88P0DpEPMyfOt10aBl
         GGueEzuU9iLLh7s6554xotf86gXv2whYaNPRVXMBfqBaZTqOQrunNfdJrQSzXmmMlMo6
         uqUesFo21QgOoVO8p5QKXfmGGIY9RnFEMG+MXfUI5DG6s44ZlxDSWiiZLEVshO3e5S6Y
         7kLw==
X-Gm-Message-State: AOJu0YzeKLvKFKPiYON6mQFi79VD+5+MMD76GN08zvhgnd0746qc0N/C
        lqFOpNk7UFWzUnbYjC1KrSSnNqMJLdcIjFIX1/ha6Si4pnh9lnneH1Yt/cgJ43Nq3Zb0XqxKS9n
        Cwqo32FDSpwNuAkAB21ahjaCyn3O7loeMjZhS
X-Received: by 2002:a05:6402:518a:b0:530:4cf8:8162 with SMTP id q10-20020a056402518a00b005304cf88162mr2431939edd.2.1695837029514;
        Wed, 27 Sep 2023 10:50:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGs7C/bIxp8tLOcXHQyqpwZmBRCiSlvOCWkfiGP6IJNDkQr3eYPivAbQqGUC4ijjYf1GIYBFg==
X-Received: by 2002:a05:6402:518a:b0:530:4cf8:8162 with SMTP id q10-20020a056402518a00b005304cf88162mr2431927edd.2.1695837029229;
        Wed, 27 Sep 2023 10:50:29 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id v10-20020aa7dbca000000b005330b2d1904sm8397463edt.71.2023.09.27.10.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 10:50:28 -0700 (PDT)
Message-ID: <c746f59f24efcc610a883795c834728bfb86d651.camel@redhat.com>
Subject: Re: [PATCH nft 2/3] nfnl_osf: rework nf_osf_parse_opt() and avoid
 "-Wstrict-overflow" warning
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 27 Sep 2023 19:50:27 +0200
In-Reply-To: <ZRRiK70d4FJUJgsP@calendula>
References: <20230927122744.3434851-1-thaller@redhat.com>
         <20230927122744.3434851-3-thaller@redhat.com> <ZRRbgRny2AHfvV5H@calendula>
         <07bdaa70fcecb26fe6638e10152d41239068571d.camel@redhat.com>
         <ZRRiK70d4FJUJgsP@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-27 at 19:11 +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 27, 2023 at 07:04:57PM +0200, Thomas Haller wrote:
> >=20
> > How can pf.os used?
>=20
> According to code, pf.os file with signatures needs to be placed
> here:
>=20
> #define OS_SIGNATURES DEFAULT_INCLUDE_PATH "/nftables/osf/pf.os"
>=20
> then, you can start matching on OS type, see 'osf' expression in
> manpage. Note there is a "unknown" OS type when it does not guess the
> OS.


Sorry, I don't follow. Testing this seems very cumbersome.

I suspect, the tests "tests/shell/testcases/sets/typeof_{sets,maps}_0"
might hit the code. But that test requires kernel support.

IMO the netfilter projects should require contributors to provide tests
(as sensible). That is, tests that are simply invoked via `make check`
and don't require to build special features in the kernel
(CONFIG_NFT_OSF).

Anyway. Let's hold this patch [2/3] back for now.=C2=A0And patch [1/3] is
obsolete too.

I have patches that would add unit tests to the project (merely as a
place where more unit tests could be added). I will add a test there.
But that is based on top of "no recursive make", and I'd like to get
that changed first.


Thomas

