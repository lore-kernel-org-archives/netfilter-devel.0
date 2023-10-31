Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE68C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Oct 2023 19:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbjJaTSb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Oct 2023 15:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjJaTSa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Oct 2023 15:18:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55A991
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 12:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698779861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aw6HYI9I8kGenZWRDQuric1pZmmYxkN5SNu/7s7ccLY=;
        b=DWwrxuvoM1+jjwIdD9sER4CTXoSk99qYyNmaGjcst+BbZaTpMeUBtxCQ2sF6w7dg4wgVZc
        0MOSxsRbgP6mVa2lbaUh8G8RS8ysTr3Fz0xxp19UI5I9FZEcnchc/BudZw+Y5d9dIaSndR
        Qj8bvi6d81zKihJbtpSRq0z2zOEfOBo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-DnMyyFeUN32X5WwgBTqCyA-1; Tue, 31 Oct 2023 15:17:28 -0400
X-MC-Unique: DnMyyFeUN32X5WwgBTqCyA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5435b614a0cso279866a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 12:17:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698779846; x=1699384646;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aw6HYI9I8kGenZWRDQuric1pZmmYxkN5SNu/7s7ccLY=;
        b=nbwpp5aCrhtK0wWpsTqhUWIwJV5RVmNjbpoFgLvg8hsR0HYoT4wTuiAfxXPwb7Ybjz
         9VOeFklfuE87RfS6JzYV984Q1pvCRBt4E+gdRP8/XWnFGImvcKu6eK/jxx5RSRGD4P7j
         GqFM0bXAZ5dIBwjFKPoTmCMqfeNgbuHqOIoRbR7bNw/V0G3d3qD7mGC7gLQRHtS9tXqs
         IbZjZU2uLKyMDVl8079VcKyzEs2xXQU8s082KMhQQdqs4kn7JbD420/LxjU/i5etkslA
         RAktDVS4Y2JD1vWv/MgBkK7xRXWt3Ju3kFa/mCpIv0Kd0qTGGgaZOwrmqvvBHlzPHmDL
         GWEQ==
X-Gm-Message-State: AOJu0Yx/Fr+i+30eH/sg2Mi73TCHzWoFgY4kzPN5Wz7oahb8uTage8Ps
        EH4fokSLeLno2I98u4QxOJnYGVT/QGfx43vFMexqZPOUPKKuiSNgjgVl7Bcdo5U07XzZVfXbOBU
        r3Zf+BARwhUtKxpxqNtf+kV3tkjQQIPpDomQXMgWi20Mrlc+6PTSJ04PnGyfYNiyQSqVYpRni1q
        OXRADCxWUb/fI=
X-Received: by 2002:a17:907:6d02:b0:9c4:4b20:44a5 with SMTP id sa2-20020a1709076d0200b009c44b2044a5mr12322905ejc.4.1698779845868;
        Tue, 31 Oct 2023 12:17:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5KMWfoPyG+CLHuCYQ9KIwjAAr6aKB9acEBsZ/d0WSM4sRqPamC50bfhoDY5IAzdtkbvVaEQ==
X-Received: by 2002:a17:907:6d02:b0:9c4:4b20:44a5 with SMTP id sa2-20020a1709076d0200b009c44b2044a5mr12322888ejc.4.1698779845507;
        Tue, 31 Oct 2023 12:17:25 -0700 (PDT)
Received: from [10.0.0.168] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id l12-20020a170906414c00b009a1a653770bsm1410619ejk.87.2023.10.31.12.17.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 12:17:25 -0700 (PDT)
Message-ID: <f9955dba2dba9965ad2a540482cdd66ab674cd83.camel@redhat.com>
Subject: Re: [PATCH nft 0/7] add and check dump files for JSON in tests/shell
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 31 Oct 2023 20:17:24 +0100
In-Reply-To: <20231031185449.1033380-1-thaller@redhat.com>
References: <20231031185449.1033380-1-thaller@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-10-31 at 19:53 +0100, Thomas Haller wrote:
> Like we have .nft dump files to compare the expected result, add
> .json-nft files that compare the JSON output.
>=20
> Thomas Haller (7):
> =C2=A0 json: fix use after free in table_flags_json()
> =C2=A0 json: drop messages "warning: stmt ops chain have no json callback=
"
> =C2=A0 tests/shell: check and generate JSON dump files
> =C2=A0 tests/shell: add JSON dump files
> =C2=A0 tools: simplify error handling in "check-tree.sh" by adding
> =C2=A0=C2=A0=C2=A0 msg_err()/msg_warn()
> =C2=A0 tools: check more strictly for bash shebang in "check-tree.sh"
> =C2=A0 tools: check for consistency of .json-nft dumps in "check-tree.sh"

Hm. Patch 4/7 bounced (too large).

Will see how to resend, after there is some feedback.

The patch is also here:
https://gitlab.freedesktop.org/thaller/nftables/-/commit/6545b31080036e8525=
be5c80c0103a1509e698e4


Thomas

