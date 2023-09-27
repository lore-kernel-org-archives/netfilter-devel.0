Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4D8E82CAE
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 17:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjI0RFy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 13:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjI0RFx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 13:05:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCE191
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 10:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695834302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hlJY7+Pk3sj32EnCIHkzuuNaIK6+Ws9kODZxPkvLDYY=;
        b=Zog2LGB5YiOYOPSimdC/noawjAiMHaMihDLP3ahZn9eL3y3XR+PBLZCe1r8UNydrfW+q4T
        t3oY2oI7tbH+qGd/dUPxo4jF/6vAJODnc5Yj4JWr27XFAwdhKbjbWyAJ/VRLmd1J74Xw6C
        7pfvs5tHMwXVekTaO20PkWT3gf8lJq8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-jli_YGahMamAL9ft2l-GCQ-1; Wed, 27 Sep 2023 13:05:01 -0400
X-MC-Unique: jli_YGahMamAL9ft2l-GCQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9ae5f4ebe7eso245281966b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 10:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695834299; x=1696439099;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hlJY7+Pk3sj32EnCIHkzuuNaIK6+Ws9kODZxPkvLDYY=;
        b=WZMCBchADwRNH6go35pb/ifTQYQkRJV/MFaHrbL3rvTFeAf+w2A7by9LCufFzkKr/w
         K0nYezkgieXaQB3ibIs4RVrKMURWBfsBwVjKBSumcJ9TRjbINqbxOwQ83xyY3xQZhFd1
         NdflNDwck0KL09FsdFcDvKBvGsiCH0Tn7crRKnr8j9hjPy3+d8vR1Kt2wC1pyJrVNaCe
         TrEQCN5Wa+BqxdNnw8TCJbYd7DbBYUdwIjMzhmnXPaWF85E32YSScG59ijNmaEr0JxUn
         we0ga0XGlKyBTqB+BMcGPMXxfLQKYpA/9y4r3kiy0n3hM1nLM4YorLMIxqlttb2DVhbL
         doqg==
X-Gm-Message-State: AOJu0Yx1ZPUuIEocn8iGonUppzLbx/LgXfxZOwupSL9HDH2HPbNgnBLh
        rHRBwN96xxNKgrryW6ZjhKHPsVu2b7jHdfQ1z9nqqpxKMWZA+Qp5GtSDBeo/14UhpgtYYLippaa
        7IKEDKx45vI9KtQ/YM7HNP3GPMT4rTLkx7/Co
X-Received: by 2002:a17:906:51ca:b0:9a6:5340:c337 with SMTP id v10-20020a17090651ca00b009a65340c337mr2271254ejk.2.1695834299172;
        Wed, 27 Sep 2023 10:04:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFE0/5HsItgwbQdRpB/NDr13r1scbwzabZoiQaQE8ZRJ1azMheLSxpRz5p+t9Qmp/NKELYR5g==
X-Received: by 2002:a17:906:51ca:b0:9a6:5340:c337 with SMTP id v10-20020a17090651ca00b009a65340c337mr2271242ejk.2.1695834298852;
        Wed, 27 Sep 2023 10:04:58 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id v6-20020a170906380600b0099c53c4407dsm9507144ejc.78.2023.09.27.10.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 10:04:58 -0700 (PDT)
Message-ID: <07bdaa70fcecb26fe6638e10152d41239068571d.camel@redhat.com>
Subject: Re: [PATCH nft 2/3] nfnl_osf: rework nf_osf_parse_opt() and avoid
 "-Wstrict-overflow" warning
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 27 Sep 2023 19:04:57 +0200
In-Reply-To: <ZRRbgRny2AHfvV5H@calendula>
References: <20230927122744.3434851-1-thaller@redhat.com>
         <20230927122744.3434851-3-thaller@redhat.com> <ZRRbgRny2AHfvV5H@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-27 at 18:42 +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 27, 2023 at 02:23:27PM +0200, Thomas Haller wrote:
> > We almost can compile everything with "-Wstrict-overflow" (which
> > depends
> > on the optimization level). In a quest to make that happen, rework
> > nf_osf_parse_opt(). Previously, gcc-13.2.1-1.fc38.x86_64 warned:
> >=20
> > =C2=A0=C2=A0=C2=A0 $ gcc -Iinclude "-DDEFAULT_INCLUDE_PATH=3D\"/usr/loc=
al/etc\"" -c
> > -o tmp.o src/nfnl_osf.c -Werror -Wstrict-overflow=3D5 -O3
> > =C2=A0=C2=A0=C2=A0 src/nfnl_osf.c: In function =E2=80=98nfnl_osf_load_f=
ingerprints=E2=80=99:
> > =C2=A0=C2=A0=C2=A0 src/nfnl_osf.c:356:5: error: assuming signed overflo=
w does not
> > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > Werror=3Dstrict-overflow]
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 356 | int nfnl_osf_load_fingerprints(str=
uct netlink_ctx *ctx,
> > int del)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=
=A0=C2=A0 ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > =C2=A0=C2=A0=C2=A0 src/nfnl_osf.c:356:5: error: assuming signed overflo=
w does not
> > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > Werror=3Dstrict-overflow]
> > =C2=A0=C2=A0=C2=A0 src/nfnl_osf.c:356:5: error: assuming signed overflo=
w does not
> > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > Werror=3Dstrict-overflow]
> > =C2=A0=C2=A0=C2=A0 src/nfnl_osf.c:356:5: error: assuming signed overflo=
w does not
> > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > Werror=3Dstrict-overflow]
> > =C2=A0=C2=A0=C2=A0 src/nfnl_osf.c:356:5: error: assuming signed overflo=
w does not
> > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > Werror=3Dstrict-overflow]
> > =C2=A0=C2=A0=C2=A0 src/nfnl_osf.c:356:5: error: assuming signed overflo=
w does not
> > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > Werror=3Dstrict-overflow]
> > =C2=A0=C2=A0=C2=A0 cc1: all warnings being treated as errors
> >=20
> > The previous code was needlessly confusing. Keeping track of an
> > index
> > variable "i" and a "ptr" was redundant. The signed "i" variable
> > caused a
> > "-Wstrict-overflow" warning, but it can be dropped completely.
> >=20
> > While at it, there is also almost no need to ever truncate the bits
> > that
> > we parse. Only the callers of the new skip_delim_trunc() required
> > the
> > truncation.
> >=20
> > Also, introduce new skip_delim() and skip_delim_trunc() methods,
> > which
> > point right *after* the delimiter to the next word.=C2=A0 Contrary to
> > nf_osf_strchr(), which leaves the pointer at the end of the
> > previous
> > part.
> >=20
> > Also, the parsing code using strchr() requires that the overall
> > buffer
> > (obuf[olen]) is NUL terminated. And the caller in fact ensured that
> > too.
> > There is no point in having a "olen" parameter, we require the
> > string to
> > be NUL terminated (which already was implicitly required).=C2=A0 Drop
> > the
> > "olen" parameter. On the other hand, it's unclear what ensures that
> > we
> > don't overflow the "opt" output buffer. Pass a "optlen" parameter
> > and
> > ensure we don't overflow the buffer.
>=20
> Nice.
>=20
> IIRC, this code was copied and pasted from iptables. Maybe porting
> this patch there would be also good.

I will do that, after the patch was merged (and the final version
known).

> BTW, did you test this patch with the pf.os file that nftables ships
> in?

Right. I need to point out, that I did not test this. So it might be
horribly broken. My Fedora kernel builds without CONFIG_NFT_OSF, so the
shell tests are skipped.

How can pf.os used?


Thomas



