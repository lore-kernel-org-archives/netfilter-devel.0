Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E120EC07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 10:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbjJXKQ2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbjJXKQ1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 06:16:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6442210C8
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698142536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J32RkMzKjSZhUQ5a/74JcTQ1nWCrfcnvaTj8VULQnB8=;
        b=P2/5fYYMzCActG9LaHzYtip1s53oretmewHHYHyIV5ID6A3r7ccYs1MwH4HjA4tNRDQK+u
        NBENl4plCPjTCfqFjiSXHOJOWe5hUk39vK+n+vmK8Osl99V05uEDsbTOKerffRFTXlgXC2
        Ny862qUuUHmfwann36gzgUlVy8oMeYg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-TX21-5iwP8SUtdELEm7Z-Q-1; Tue, 24 Oct 2023 06:15:25 -0400
X-MC-Unique: TX21-5iwP8SUtdELEm7Z-Q-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5401de6ce9eso537461a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698142524; x=1698747324;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J32RkMzKjSZhUQ5a/74JcTQ1nWCrfcnvaTj8VULQnB8=;
        b=vGnzmlp7820CjU/Btt3iOGeoyzXxCpJ41iGi22l0YLXo/u8EmfGIFBvEhfsCg/87gQ
         LArWEgHHVwRxkoubG4g67Uf25XaDwWeMDfrvuZYeO1pSRX9JVaRlGn+XJE5taDN1fsy5
         +6Z+h/G78kfvcfKFpGlQkwL8zkkH4ehHKg1Fd9i3NUpR1jYlSOZA6yIJUXRZOmme8cQP
         9HtLhDgiKbS/vmUcsET+ZrX7C9vbMdWrjBlp1KKkHtnZWoYRrhcXcP9BxGC64zzJ4Tcr
         MqGm/ImAW58nONmVaLJG3rMDBvOMJO4hKGPSD4//u9v+VuY4vI33LriMUR5KHlZOzbXU
         ebAQ==
X-Gm-Message-State: AOJu0Yzpi1boPCT01MsIxWz4jwySV00NpUUa5gmrwkEb0J26BJ5tAcf8
        opPIwvsnUyvK3/N2gLorqZ+3Ie7jiz3we73PYAnHg6o80Hcq1pBUTto2pA+TKv/ilmQ1qdbiGyw
        NiWLW8u14yhqkHVAcr30puWuyrezX0uM1YMJM
X-Received: by 2002:a50:d4d4:0:b0:53f:9242:d24f with SMTP id e20-20020a50d4d4000000b0053f9242d24fmr8143105edj.0.1698142523774;
        Tue, 24 Oct 2023 03:15:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzLA8XjkRUzBLRB3iZ9ueoiw0qYZcaNXwZ/qXPJjWcrLFFHvciXh7WgpJzuEJKmhsnHZz00g==
X-Received: by 2002:a50:d4d4:0:b0:53f:9242:d24f with SMTP id e20-20020a50d4d4000000b0053f9242d24fmr8143099edj.0.1698142523484;
        Tue, 24 Oct 2023 03:15:23 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id i7-20020a50fc07000000b00534e791296bsm7631279edr.37.2023.10.24.03.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 03:15:23 -0700 (PDT)
Message-ID: <24637db2fe827e321ea152b5b24cfa3a29d3660d.camel@redhat.com>
Subject: Re: [PATCH nft 1/3] tests/shell: add
 "bogons/nft-f/zero_length_devicename2_assert"
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 24 Oct 2023 12:15:22 +0200
In-Reply-To: <ZTeVIzWLhSWn4wsA@calendula>
References: <20231023170058.919275-1-thaller@redhat.com>
         <ZTeVIzWLhSWn4wsA@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-10-24 at 11:57 +0200, Pablo Neira Ayuso wrote:
> Series aplied, thanks.

Thank you.

>=20
> After all these updates I see this failure:
>=20
> W: [FAILED]=C2=A0=C2=A0=C2=A0=C2=A0 1/1 testcases/sets/elem_opts_compat_0
>=20
> I: results: [OK] 0 [SKIPPED] 0 [FAILED] 1 [TOTAL] 1
>=20
> when running tests.
>=20

Hm. I don't get such failure (Kernel 6.5.6-200.fc38.x86_64).
But regardless of that, I don't think that my patches had anything to
do with that test, do they?


Can you provide more information? Can you bisect the failure?

Could you share:

  make && ./tests/shell/run-tests.sh ./tests/shell/testcases/sets/elem_opts=
_compat_0 -x -k
  grep -R ^ /tmp/nft-test.latest.*/


Thomas

