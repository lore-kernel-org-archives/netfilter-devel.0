Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2782DC001E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Oct 2023 13:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjJUN0H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Oct 2023 09:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjJUN0F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Oct 2023 09:26:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC4DD67
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Oct 2023 06:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697894649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sAJJoylF1cW1oW2mCcwy+DSGsa9dllVFEwoULjFHt7U=;
        b=bavzUNnJWFisWT60X4K6nCXnzfZeiMBQpSuOzflL9KYThC9ogtneKFS6foFLEfyb/2DmPI
        9Om0M68ZmsV7S4klCWWyGEFwhNzcs2SczuMretQlVcF5wfM9TGDoygqitGyKHW+zAwcgbs
        h9+8PQxoLQJs99WFA164zDWLbcCaXhg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-6Axf9W80OOCFSbIY_5p7ig-1; Sat, 21 Oct 2023 09:24:08 -0400
X-MC-Unique: 6Axf9W80OOCFSbIY_5p7ig-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-53ffd4937d6so368218a12.3
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Oct 2023 06:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697894647; x=1698499447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sAJJoylF1cW1oW2mCcwy+DSGsa9dllVFEwoULjFHt7U=;
        b=AUiJr9ypQExZAEfyMphR8j7org3c1obskya1YzEFhQfQKw7FXImWdTgqjWKnUCOZni
         vlNxgKQTYB7P3UaYm8KLh5Z+5/nhL55T2URQxkwaZZq2uCz+LTqKiWgv8LHePf0xjNVN
         jHlzpn3joi+cF0aMWQ4FEmRLdwOft9IeCGiV1IAg4b5GSgXeGNA6lAD/ECeR0dxafYkN
         B4PZ76D5GEnHenzIdx0Mps7NLUY7dc4jEDglJucFvATOzS4iTqdz+RTcuh1dspGMlxnf
         lSuiC8Qv1BwWccY1/EeslCWOZaY15hynemFdYrlot+RBNedt4bHBmn49LvyKPPMTM2uc
         imOg==
X-Gm-Message-State: AOJu0YxklXU3Hu487Qm9FGeAHVzJrH+YF/ZDzUWGyk1SlBb/7JjoXCP2
        yOWnM2bwSDFB3+N1AlFgxLzRu4byFBEximcfpNZaxTQwzfU/rgFMSv7LL5qkiI1z+KRESVawigZ
        l3JGfzqthWOWrCK8HmErsSfhUmD5pQTvScHnEax+dHqeT
X-Received: by 2002:a50:aacf:0:b0:53e:1388:cb2e with SMTP id r15-20020a50aacf000000b0053e1388cb2emr3332771edc.35.1697894647035;
        Sat, 21 Oct 2023 06:24:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyy9uSFCMUqfgN2rj17ch/G/jvq1QTWJGPAXTF5FtC6Qouo5v3kERhMpzgMczbfZXe5FR3mAcf/aFuBhBAvjs=
X-Received: by 2002:a50:aacf:0:b0:53e:1388:cb2e with SMTP id
 r15-20020a50aacf000000b0053e1388cb2emr3332740edc.35.1697894646692; Sat, 21
 Oct 2023 06:24:06 -0700 (PDT)
MIME-Version: 1.0
References: <143690ecc1102c0f67fa7faec437ec7b02bb2304.1697885975.git.lukas@wunner.de>
In-Reply-To: <143690ecc1102c0f67fa7faec437ec7b02bb2304.1697885975.git.lukas@wunner.de>
From:   Richard Fontana <rfontana@redhat.com>
Date:   Sat, 21 Oct 2023 09:23:55 -0400
Message-ID: <CAC1cPGx-cb+YZ9KgEFvSjtf+fp9Dhcn4sm9qHmFFDRDxb=7fHg@mail.gmail.com>
Subject: Re: [PATCH] treewide: Add SPDX identifier to IETF ASN.1 modules
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-spdx@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Oct 21, 2023 at 7:25=E2=80=AFAM Lukas Wunner <lukas@wunner.de> wrot=
e:
>
> Per section 4.c. of the IETF Trust Legal Provisions, "Code Components"
> in IETF Documents are licensed on the terms of the BSD-3-Clause license:
>
> https://trustee.ietf.org/documents/trust-legal-provisions/tlp-5/
>
> The term "Code Components" specifically includes ASN.1 modules:
>
> https://trustee.ietf.org/documents/trust-legal-provisions/code-components=
-list-3/

Sorry if this seems super-pedantic but I am pretty sure the license
text in the IETF Trust Legal Provisions does not actually match SPDX
`BSD-3-Clause` because of one additional word in clause 3 ("specific"
before "contributors"), so IMO you should get SPDX to modify its
definition of `BSD-3-Clause` prior to applying this patch (or get IETF
to change its version of the license, but I imagine that would be more
difficult). This issue of a multitude of nonsubstantively different,
non-matching versions of clause 3 is a common issue that has been
coming up in the Fedora project's adoption of SPDX identifiers for
license metadata.

Richard

